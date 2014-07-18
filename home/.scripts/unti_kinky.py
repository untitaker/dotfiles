#!/usr/bin/env python3
import sys
import time
import datetime
import os
sys.path.append('/home/untitaker/projects/kinky')
from kinky import Item, StatusBar, shell, is_running

title_color = '#666'
separator_color = '#333'
blue_color = '#3465A4'

bar = StatusBar()
bar.between = '^fg({sep}) | ^fg()'.format(sep=separator_color)
bar.error_value = '^fg({#FF0000)broken^fg()'


class DatetimeItem(Item):
    def run(self):
        while True:
            self.text = datetime.datetime.now().strftime(
                '%H^fg({sep}):^fg()%M{between}%Y^fg({sep})/'
                '^fg()%m^fg({sep})/^fg()%d'
                .format(sep=separator_color, between=self.bar.between)
            )
            time.sleep(30)


class VolumeItem(Item):
    def run(self):
        while True:
            state = shell('amixer get Master | grep "Mono: Playback"') \
                .strip().split()
            if not state:
                continue
            vol = state[3].replace('[', '').replace(']', '')
            mute = state[5]
            text = '^fg({title})VOL: '.format(title=title_color)
            text += (
                '^fg(#FF0000)'
                if mute == '[off]' else
                '^fg({blu})'.format(blu=blue_color)
            )
            text += vol + '^fg()'
            self.text = text
            time.sleep(.5)


class MpdItem(Item):
    def run(self):
        while True:
            if is_running('ncmpcpp'):
                self.text = '^fg({title})MPD: ^fg({blu}){song}^fg()'.format(
                    title=title_color,
                    blu=blue_color,
                    song=shell('mpc | head -1 | cut -c-50')
                )
            else:
                self.text = None

            time.sleep(0.3)


class MaildirItem(Item):
    maildir = None
    _prev_new = 0

    def _mail_status(self):
        new = len(os.listdir(os.path.join(self.maildir, 'new')))
        read = len(os.listdir(os.path.join(self.maildir, 'cur')))

        if self._prev_new < new:
            self._send_notification(new)

        self._prev_new = new
        return (
            '^fg(#FF0000){new}^fg()'if new
            else '{read}' if read
            else '^fg({title}){read}^fg({title})'
        ).format(new=new, read=read, title='{title}')

    def _send_notification(self, amount):
        shell('notify-send "You have {} new mails!"'.format(amount))

    def run(self):
        while True:
            self.text = ('^fg({title})MAIL: ^fg()' + self._mail_status()) \
                .format(title=title_color)
            shell('inotifywait -t 5 -r ' + self.maildir + ' &> /dev/null')


class CputempItem(Item):
    def run(self):
        while True:
            cores = [
                line for line in shell('sensors').split('\n')
                if line.startswith('Core ')
            ]
            core_temps = [
                '^fg({title}){temp}^fg()'.format(
                    temp=float(core.split()[2].replace('°C', '')),
                    title=title_color
                )
                for core in cores
            ]
            self.text = self.bar.between.join(core_temps)
            time.sleep(5)


class BatteryItem(Item):
    def run(self):
        while True:
            rv = shell('upower -i '
                       '/org/freedesktop/UPower/devices/battery_BAT0')
            if not rv:
                break

            rv = rv.split('\n')
            data = {}
            for l in rv:
                if ':' not in l:
                    continue
                k, v = l.split(':', 1)
                k = k.strip()
                v = v.strip()
                data[k] = v

            if 'state' not in data:  # no battery in this device
                break
            state = data['state']
            percentage = data['percentage']

            if state == 'charging':
                _time = data.get('time to full', None)
            else:
                _time = data.get('time to empty', None)

            if _time:
                self.text = '{} ({}); {}'.format(state, _time, percentage)
            else:
                self.text = '{}; {}'.format(state, percentage)
            time.sleep(1)


class NetctlItem(Item):
    def run(self):
        if shell('which netctl-auto') is None:
            return

        while True:
            rv = shell('sudo netctl-auto current').strip()
            self.text = rv or '^fg(#FF0000)disconnected^fg()'
            time.sleep(10)


mail_item = MaildirItem()
mail_item.maildir = '/home/untitaker/.mail/markus/INBOX'

bar.items = [
    mail_item,
    MpdItem(),
    CputempItem(),
    BatteryItem(),
    NetctlItem(),
    VolumeItem(),
    DatetimeItem()
]

if __name__ == '__main__':
    bar.run()
