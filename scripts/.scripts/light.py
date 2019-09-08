#!/usr/bin/env python
import copy
import argparse
import subprocess

ROUNDING_FACTOR = 1

GAMMA_VALUES = [
    {
        "red": 1.0,
        "green": 0.2,
        "blue": 0.1,
        "temp": 1000
    },
    {
        "red": 1.0,
        "green": 0.3,
        "blue": 0.1,
        "temp": 1200
    },
    {
        "red": 1.0,
        "green": 0.4,
        "blue": 0.1,
        "temp": 1500
    },
    {
        "red": 1.0,
        "green": 0.5,
        "blue": 0.1,
        "temp": 2000
    },
    {
        "red": 1.0,
        "green": 0.6,
        "blue":  0.3,
        "temp": 2500
    },
    {
        "red": 1.0,
        "green": 0.7,
        "blue":  0.4,
        "temp": 3000
    },
    {
        "red": 1.0,
        "green": 0.8,
        "blue": 0.5,
        "temp": 3500
    },
    {
        "red": 1.0,
        "green": 0.8,
        "blue": 0.6,
        "temp": 4000
    },
    {
        "red": 1.0,
        "green": 0.9,
        "blue": 0.8,
        "temp": 5000
    },
    {
        "red": 1.0,
        "green": 1.0,
        "blue": 0.9,
        "temp": 6000
    },
    {
        "red": 1.0,
        "green": 1.0,
        "blue": 1.0,
        "temp": 6500
    },
]

class Display():
    def __init__(self):
        self.display = self._get_connected_displays()
        self.info = self._get_display_info()
        self.brightness = self._get_brightness()
        self.gamma = self._get_gamma()

    def _shell_with_output(self, command):
        return subprocess.getoutput(command)

    def _get_connected_displays(self):
        return self._shell_with_output("xrandr | grep -w connected | cut -f1 -d ' '")

    def _get_display_info(self):
        display = self.display
        xrandr = f"xrandr --verbose | grep -w {display} -A8"
        output = self._shell_with_output(xrandr)
        return output

    def _get_brightness(self):
        brightness = self._shell_with_output(
            "echo '" + self.info + "' | grep Brightness | cut -f2 -d ' '")
        return float(brightness) if brightness else None

    def _get_gamma(self):
        gamma = self._shell_with_output(
            "echo '" + self.info + "' | grep Gamma | cut -f2- -d: | tr -d ' '")
        if gamma:
            floats = [round(1 / float(value), 1)
                      if  float(value) != 0.0 else 0.0
                    for value in gamma.split(":")]
            return dict(zip(["red", "green", "blue"], floats))
        else:
            print("Gamma not found: {}".format(gamma))

    def _input_format_gamma(self):
        return ":".join([str(v) for v in self.gamma.values()])

    def lookup_temp_by_gamma(self):
        for i, rgb in enumerate(GAMMA_VALUES):
            rgb.pop("temp")
            return(self.gamma)
            if rgb.items() == self.gamma.items():
                return GAMMA_VALUES[i]["temp"]

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
        cmd = f"redshift -P -o -b {new}:{new} -g {self._input_format_gamma()} 2> /dev/null"
        self._shell_with_output(cmd)
        return new

    def change_temp(self, operation):
        color_fields = ["red", "green", "blue"]
        new_gamma = "1.0:1.0:1.0"
        new_rgb = GAMMA_VALUES[10]
        for i, rgb in enumerate(copy.deepcopy(GAMMA_VALUES)):
            rgb.pop("temp")
            if rgb == self.gamma:
                if operation == "+":
                    if i + 1 > len(GAMMA_VALUES) - 1:
                        i = len(GAMMA_VALUES) - 2
                    new_rgb = GAMMA_VALUES[i + 1]
                    new_gamma = ":".join(
                       list(str(v) for k,v in
                             GAMMA_VALUES[i + 1].items()
                             if k in color_fields)
                    )
                    break
                elif operation == "-":
                    if i - 1 < 0:
                        i = 1
                    new_rgb = GAMMA_VALUES[i - 1]
                    new_gamma = ":".join(
                        list(str(v) for k,v in
                             GAMMA_VALUES[i - 1].items()
                             if k in color_fields)
                    )
                    break
        self._shell_with_output(f"redshift -P -o -b {self.brightness}:{self.brightness} -g {new_gamma}")
        return new_rgb["temp"]


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
        if args.target == "display":
            print(display.display)
        elif args.target == "brightness":
            print(display.brightness)
        elif args.target == "temperature":
            print(display.lookup_temp_by_gamma())
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
