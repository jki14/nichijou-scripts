from os import system
from typing import List

from termcolor import colored, cprint


def clear():
    system("clear")
    print("\033[s", end="")


class TextStyle:
    def __init__(
        self,
        textColor: str,
        textHighlights: str,
        attributes: List[str],
    ):
        self.textColor = textColor
        self.textHighlights = textHighlights
        self.attributes = attributes

    def print(self, text):
        print(colored(text, self.textColor, self.textHighlights, attrs=self.attributes), end=" ")

    def println(self, text, dynamic=False):
        prefix = "\033[u\033[J" if dynamic else ""
        print(prefix + colored(text, self.textColor, self.textHighlights, attrs=self.attributes), end="\n" if dynamic else "\n\033[s")


DebugStyle = TextStyle("red", "on_white", ["bold"])
InfoStyle = TextStyle("black", "on_white", ["bold"])
LevelStyle = TextStyle("white", "on_black", ["bold"])
MainStatStyle = TextStyle("red", "on_black", ["bold"])
