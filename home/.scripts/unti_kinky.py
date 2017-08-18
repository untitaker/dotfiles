#!/usr/bin/env python3
import sys
import time
import datetime
import os

sys.path.append('/home/untitaker/projects/kinky')
from kinky import Item, StatusBar, shell, is_running, shell_stream

normal_color = '^fg()^bg()'
selected_color = '^fg(#3465A4)'
urgent_color = '^fg(#FF0000)^bg()'
urgent2_color = '^fg(#000)^bg(#FF0000)'
grey_color = '^fg(#333)'
title_color = '^fg(#888888)'

bar = StatusBar()
bar.between = ' {}| {}'.format(grey_color, normal_color)
bar.error_value = '{}broken{}'.format(urgent_color, normal_color)


def watch_dir(p):
    shell('inotifywait -rq -e create -e delete -e move ' + p)


class DatetimeItem(Item):
    def run(self):
        while True:
            self.text = datetime.datetime.now().strftime(
                '%H:%M{between}%Y/%m/%d'
                .format(between=self.bar.between)
            )
            time.sleep(10)


class VolumeItem(Item):
    def run(self):
        self._set_vol()
        for line in shell_stream('pactl subscribe'):
            if "'change' on sink" not in line:
                continue
            self._set_vol()

    def _set_vol(self):
        state = shell('amixer get Master | grep "Left: Playback" | head -1') \
            .strip().split()
        if not state:
            return
        vol = state[-2].replace('[', '').replace(']', '')
        mute = state[-1]
        text = '{}VOL: '.format(title_color)
        text += urgent_color if mute == '[off]' else selected_color
        text += vol
        self.text = text


class MpdItem(Item):
    def run(self):
        while True:
            if is_running('ncmpcpp'):
                self.text = 'MPD: {select}{song}'.format(
                    select=selected_color,
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
            '{urgent}{new}' if new
            else '{normal}{read}'
        ).format(urgent=urgent_color, normal=normal_color, new=new, read=read)

    def _send_notification(self, amount):
        shell('notify-send "You have {} new mails!"'.format(amount))

    def run(self):
        while True:
            self.text = (title_color + 'MAIL: ' + self._mail_status())
            watch_dir(self.maildir)


class CputempItem(Item):
    def run(self):
        while True:
            cores = [
                line for line in shell('sensors').split('\n')
                if line.startswith('Core ')
            ]
            core_temps = [
                title_color + repr(float(core.split()[2].replace('°C', '')))
                for core in cores
            ]
            self.text = self.bar.between.join(core_temps)
            time.sleep(5)


class BatteryItem(Item):
    _color = ''
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
            percentage = int(data['percentage'].strip('%'))
            battery_empty = percentage < 10
            if battery_empty and (not self._color or state == 'charging'):
                self._color = urgent2_color
            else:
                self._color = ''

            if state == 'charging':
                _time = data.get('time to full', None)
            else:
                _time = data.get('time to empty', None)

            if _time:
                self.text = '{}{} ({}); {}%'.format(
                    self._color, state, _time, percentage)
            else:
                self.text = '{}{}; {}%'.format(
                    self._color, state, percentage)
            time.sleep(1 if self._color or battery_empty else 20)


class NetctlItem(Item):
    def run(self):
        if shell('which netctl-auto') is None:
            return

        while True:
            rv = shell('SUDO_ASKPASS=/bin/false '
                       'sudo -A netctl-auto list').splitlines()
            for x in rv:
                if x.startswith('*'):
                    self.text = x[1:].strip()
                    break
            else:
                self.text = '{}disconnected {}'.format(urgent_color,
                                                       normal_color)
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
