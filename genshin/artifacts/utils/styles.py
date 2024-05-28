from termcolor import cprint


class text_format:
    def __init__(self, color, highlight, attrs):
        self.color = color
        self.highlight = highlight
        self.attrs = attrs

    def print(self, text):
        cprint(text, self.color, self.highlight, attrs=self.attrs)


class STYLES:
    CRIT_RATE = text_format("yellow", "on_black", ["bold"])
    CRIT_DMG = text_format("yellow", "on_black", ["bold"])
    ENERGY_RECHARGE = text_format("light_magenta", "on_black", ["bold"])
    ELEMENTAL_MASTERY = text_format("light_magenta", "on_black", ["bold"])
    ATK_PCT = text_format("light_blue", "on_black", ["bold"])
    HP_PCT = text_format("light_blue", "on_black", ["bold"])
    DEF_PCT = text_format("dark_grey", "on_black", [])
    ATK = text_format("green", "on_black", [])
    HP = text_format("green", "on_black", [])
    DEF = text_format("dark_grey", "on_black", [])
    DEBUG = text_format("yellow", "on_dark_grey", ["bold"])
    INFO = text_format("blue", "on_dark_grey", ["bold"])
    MESSAGE = text_format("white", "on_black", [])
    MAIN = text_format("red", "on_black", ["bold"])
    LEVEL = text_format("white", "on_black", ["bold"])
