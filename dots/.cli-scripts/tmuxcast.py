#!/usr/bin/env python
# -*- coding: utf-8 -*-

# TODO:
# pass args through to ansiweather
# split output from ansiweather and reformat
# add english explanation dict
# add forecastio
# add multi day forcast

"""A shit script to fetch weather info"""
import os
import re
import subprocess
import shlex

import requests


def call_subprocess(cmd):
    """parse arg strings and call shell commands"""
    proc = subprocess.Popen(shlex.split(cmd), stdout=subprocess.PIPE)
    out, _ = proc.communicate()
    return out


def get_ip():
    """Resolve current public IP"""
    ip = call_subprocess('dig +short myip.opendns.com'
                         ' @resolver1.opendns.com')
    return ip.strip()


def get_location(ip):
    """Fetch ip from some hardcoded site like a genius"""
    location_data = requests.get('http://ipinfo.io/{}'.format(ip))
    location = location_data.json()
    os.environ['CITY'] = location.get('city')
    return location.get('city', 'Chalfont')


def get_weather(city):
    """Check for an environment variable set by this script"""
    weather = call_subprocess('ansiweather -a false -p false -w flase -h false'
                              ' -u imperial -l {}'.format(city))
    match = re.findall(r'\d+\s..\w\s.*', weather)
    return ''.join(match)


def main():
    """Entry point to the script"""
    city = os.getenv('CITY', get_location(get_ip()))
    print(get_weather(city))


if __name__ == '__main__':
    main()
