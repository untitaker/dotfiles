#!/usr/bin/env python3
import sys
import logging
#logging.basicConfig(level=logging.DEBUG)
import time
import datetime
import os
sys.path.append('/home/untitaker/projects/kinky')
from kinky import Item, StatusBar, shell, is_running

title_color = '#888'
separator_color = '#333'
blue_color = '#3465A4'

bar = StatusBar()
bar.between = '^fg({sep}) | ^fg()'.format(sep=separator_color)

class DatetimeItem(Item):
    def run(self):
        while self.running:
            self.text = datetime.datetime.now().strftime(
                 '%H^fg({sep}):^fg()%M{between}%Y^fg({sep})/^fg()%m^fg({sep})/^fg()%d'
                    .format(sep=separator_color ,between=self.bar.between)
            )
            time.sleep(30)

class VolumeItem(Item):
    def run(self):
        while self.running:
            state = shell('amixer get Master | grep "Mono: Playback"').strip().split()
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
        while self.running:
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
            else '^fg(#666){read}^fg()'
        ).format(new=new, read=read)

    def _send_notification(self, amount):
        shell('notify-send "You have {} new mails!"'.format(amount))

    def run(self):
        while self.running:
            self.text = '^fg({title})MAIL: ^fg()'.format(title=title_color) + \
                    self._mail_status()
            shell('inotifywait -r ' + self.maildir + ' &> /dev/null')

class CputempItem(Item):
    def run(self):
        while self.running:
            cores = [
                line for line in shell('sensors').split('\n')
                if line.startswith('Core ')
            ]
            core_temps = [
                '^fg(#666)' + \
                str(float(core.split()[2].replace('°C', ''))) + \
                '^fg()'
                for core in cores
            ]
            self.text = self.bar.between.join(core_temps)
            time.sleep(5)

class CpuUsageItem(Item):
    def run(self):
        while self.running:
            rv = shell('mpstat -P ON').split('\n')
            for line in rv:
                line = line.split()
                cpu = line[2]


class BatteryItem(Item):
    def run(self):
        while self.running:
            rv = shell('upower -i /org/freedesktop/UPower/devices/battery_BAT0'
                       '| grep -E "state|to\ full|percentage"').split('\n')

            data = {}
            for l in rv:
                if ':' not in l:
                    continue
                k, v = l.split(':')
                k = k.strip()
                v = v.strip()
                data[k] = v

            self.text = data['state'] + '; ' + data['percentage']
            time.sleep(1)


mail_item = MaildirItem()
mail_item.maildir = '/home/untitaker/.mail/markus/INBOX'

bar.items = [
    mail_item,
    MpdItem(),
    CputempItem(),
    BatteryItem(),
    VolumeItem(),
    DatetimeItem()
]

if __name__ == '__main__':
    bar.run()