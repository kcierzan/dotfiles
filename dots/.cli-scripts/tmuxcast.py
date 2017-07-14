#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""A shit script to fetch weather info"""
import re
import subprocess
import shlex
from sys import stdout as output

import requests


def call_subprocess(cmd):
    """parse arg strings and call shell commands"""
    proc = subprocess.Popen(shlex.split(cmd), stdout=subprocess.PIPE)
    out, _ = proc.communicate()
    return out


def get_location():
    """Fetch ip from some hardcoded site like a genius"""
    location_data = requests.get('http://ipinfo.io/json')
    try:
        location = location_data.json()
    except ValueError:
        output.write(location_data.status_code)
        return
    city = location.get('city', 'Chalfont')
    region = location.get('region', 'Pennsylvania')
    return '{}, {}'.format(city, region)


def get_weather(location):
    """Check for an environment variable set by this script"""
    weather = call_subprocess('ansiweather -a false -p false -w flase'
                              ' -d false -h false -u imperial -l "{}"'.format(
                                  location))
    match = re.findall(r'\d+\s..\w\s.*', str(weather))
    return ''.join(match)


def main():
    """Entry point to the script"""
    weather = get_weather(get_location())
    output.write('{}'.format(weather))


if __name__ == '__main__':
    main()
