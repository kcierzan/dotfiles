#!/usr/bin/env python

import subprocess

display_info_cmd =  """xrandr --verbose | grep -w "$1" -A8 | grep "$2" | cut -f2- -d: | tr -d ' ' """


GAMMA_VALUES = {
    "1000": {
        "red": 1.0,
        "green": 0.18172716,
        "blue": 0.0,
    },
    "1200": {
        "red": 1.0,
        "green": 0.30942099,
        "blue": 0.0,
    },
    "1500": {
        "red": 1.0,
        "green": 0.08679949,
        "blue": 0.0,
    },
    "2000": {
        "red": 1.0,
        "green": 0.54360078,
        "blue": 0.08679949,
    },
    "2500": {
        "red": 1.0,
        "green": 0.64373109,
        "blue": 0.28819679,
    },
    "3000": {
        "red": 1.0,
        "green": 0.71976951,
        "blue": 0.42860152,
    },
    "3500": {
        "red": 1.0,
        "green": 0.77987699,
        "blue": 0.54642268,
    },
    "4000": {
        "red": 1.0,
        "green": 0.82854786,
        "blue": 0.64816570,
    },
    "5000": {
        "red": 1.0,
        "green": 0.90198230,
        "blue": 0.81465502,
    },
    "6000": {
        "red": 1.0,
        "green": 0.97107439,
        "blue": 0.94305985,
    },
    "6500": {
        "red": 1.0,
        "green": 1.0,
        "blue": 1.0,
    },
}

def shell_with_output(command):
    return subprocess.getoutput(command)


def get_connected_displays():
    return shell_with_output("xrandr | grep -w connected | cut -f1 -d ' '")

def get_display_info():
    display = get_connected_displays()
    xrandr = f"xrandr --verbose | grep -w {display} -A8"
    return shell_with_output(xrandr)

info = get_display_info()


def get_brightness():
    brightness = shell_with_output("echo '" + info + "' | grep Brightness | cut -f2 -d ' '")
    print(brightness)
    return float(brightness)


def get_gamma():
    gamma = shell_with_output("echo '" + info + "' | grep Gamma | cut -f2- -d: | tr -d ' '")
    floats = [float(value) for value in gamma.split(":")]
    return dict(zip(["red", "green", "blue"], floats))


if __name__ == "__main__":
    print("display info")

    print("brightness")
    get_brightness()

    print("gamma")
    get_gamma()
