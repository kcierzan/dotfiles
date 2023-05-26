#!/usr/bin/env python
import argparse
import subprocess


PRESETS = [
    {"temp": 1500, "gamma": [1.0, 0.5, 0.0]},
    {"temp": 2000, "gamma": [1.0, 0.5, 0.2]},
    {"temp": 2500, "gamma": [1.0, 0.6, 0.4]},
    {"temp": 3500, "gamma": [1.0, 0.7, 0.5]},
    {"temp": 4000, "gamma": [1.0, 0.8, 0.6]},
    {"temp": 5000, "gamma": [1.0, 0.8, 0.8]},
    {"temp": 6000, "gamma": [1.0, 1.0, 0.9]},
    {"temp": 6500, "gamma": [1.0, 1.0, 1.0]},
]

MAX_TEMP = PRESETS[-1]["temp"]
MIN_TEMP = PRESETS[0]["temp"]

class Display():
    def __init__(self):
        self.display = self._get_display()
        self.brightness = self._get_brightness()
        self.gamma = self._get_gamma()
        self.temperature = self.lookup_temp_by_gamma()

    def _shell_with_output(self, command):
        return subprocess.getoutput(command)

    def _get_display(self):
        return self._shell_with_output(
            "xrandr | grep -w connected | cut -f1 -d ' '")

    def _get_brightness(self):
        brightness = self._shell_with_output(
            "xrandr --verbose | " \
            f"grep -w {self.display} -A8 | " \
            " grep Brightness | " \
            " cut -f2 -d ' '")
        return float(brightness)

    def _get_gamma(self):
        gamma = self._shell_with_output(
            "xrandr --verbose | " \
            f"grep -w {self.display} -A8 | " \
            "grep Gamma | cut -f2- -d: | tr -d ' '")
        if gamma:
            return [round(1 / float(value), 1)
                      # don't try to divide by zero...
                      if float(value) != 0.0 else 0.0
                    for value in gamma.split(":")]
        else:
            print("Gamma not found: {}".format(gamma))

    def lookup_temp_by_gamma(self):
        for preset in PRESETS:
            if preset["gamma"] == self.gamma:
                return preset["temp"]

    def change_brightness(self, operation):
        if operation == "+":
            if self.brightness + 0.1 > 1.0:
                new = 1.0
            else:
                new = round(self.brightness + 0.1, 1)
        elif operation == "-":
            if self.brightness - 0.1 < 0.0:
                new = 0.0
            else:
                new = round(self.brightness - 0.1, 1)
        cmd = f"redshift -P -O {self.temperature} -b {new}:{new} 2> /dev/null"
        self._shell_with_output(cmd)
        return new

    def change_temp(self, operation):
        for i, preset in enumerate(PRESETS):
            if preset["gamma"] == self.gamma:
                if operation == "+":
                    if i >= len(PRESETS) - 1:
                        new_temp = MAX_TEMP
                    else:
                        new_temp = PRESETS[i + 1]["temp"]
                    break
                elif operation == "-":
                    if i <= 1:
                        new_temp = MIN_TEMP
                    else:
                        new_temp = PRESETS[i - 1]["temp"]
                    break
        cmd = f"redshift -P -O {new_temp} -b {self.brightness}:{self.brightness}"
        self._shell_with_output(cmd)
        return new_temp


def parse_arguments():
    features = ["display", "brightness", "temperature"]
    parser = argparse.ArgumentParser(
        description="Adjust brightness and temperature")
    parser.add_argument("action",
                        type=str,
                        nargs=1,
                        metavar="ACTION",
                        choices=["info", "+", "-"])
    parser.add_argument("target",
                        type=str,
                        nargs=1,
                        metavar="FEATURE",
                        choices=features,
                        help="feature")
    return parser.parse_args()


def main():
    args = parse_arguments()
    display = Display()

    args.target = args.target[0]
    args.action = args.action[0]

    if args.action == "info":
        if args.target == "brightness":
            print(display.brightness)
        elif args.target == "temperature":
            print(display.temperature)
        return

    if args.action != "info" and args.target == "display":
        print("Invalid option!")
        return
    if args.target == "temperature":
        out = display.change_temp(args.action)
        print(out)
        return
    out = display.change_brightness(args.action)
    print(out)


if __name__ == "__main__":
    main()
