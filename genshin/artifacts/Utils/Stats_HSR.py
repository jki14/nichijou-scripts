from copy import deepcopy
from typing import List

import numpy as np

import Utils.Stats
from Utils.Constants import one, oneIncCoeExp
from Utils.Stats import StatInfo
from Utils.TextStyle import TextStyle

SPD = StatInfo(
    key="SPD",
    zhTW="速度",
    onceIncrementMax=np.double(2.3) / oneIncCoeExp,
    appendFactor=np.double(4),
    weight=np.double(0),
    textStyle=TextStyle("yellow", "on_black", ["bold"]),
)

HP = StatInfo(
    key="HP",
    zhTW="生命值",
    onceIncrementMax=np.double(38.103755) / oneIncCoeExp,
    appendFactor=np.double(10),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

ATK = StatInfo(
    key="ATK",
    zhTW="攻擊力",
    onceIncrementMax=np.double(19.051877) / oneIncCoeExp,
    appendFactor=np.double(10),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

DEF = StatInfo(
    key="DEF",
    zhTW="防禦力",
    onceIncrementMax=np.double(19.051877) / oneIncCoeExp,
    appendFactor=np.double(10),
    weight=np.double(0),
    textStyle=TextStyle("dark_grey", "on_black", []),
)

HP_PCT = StatInfo(
    key="HP%",
    zhTW="生命值",
    onceIncrementMax=np.double(3.888) / oneIncCoeExp,
    appendFactor=np.double(10),
    weight=np.double(0),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
)

ATK_PCT = StatInfo(
    key="ATK%",
    zhTW="攻擊力",
    onceIncrementMax=np.double(3.888) / oneIncCoeExp,
    appendFactor=np.double(10),
    weight=np.double(0),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
)

DEF_PCT = StatInfo(
    key="DEF%",
    zhTW="防禦力",
    onceIncrementMax=np.double(4.86) / oneIncCoeExp,
    appendFactor=np.double(10),
    weight=np.double(0),
    textStyle=TextStyle("dark_grey", "on_black", []),
)

BREAK_EFFECT = StatInfo(
    key="Break Effect%",
    zhTW="擊破特攻",
    onceIncrementMax=np.double(5.832) / oneIncCoeExp,
    appendFactor=np.double(8),
    weight=np.double(0),
    textStyle=TextStyle("yellow", "on_black", ["bold"]),
)

EFFECT_HIT = StatInfo(
    key="Effect Hit%",
    zhTW="效果命中",
    onceIncrementMax=np.double(3.888) / oneIncCoeExp,
    appendFactor=np.double(8),
    weight=np.double(0),
    textStyle=TextStyle("light_magenta", "on_black", ["bold"]),
)

EFFECT_RES = StatInfo(
    key="Effect RES%",
    zhTW="效果抗性",
    onceIncrementMax=np.double(3.888) / oneIncCoeExp,
    appendFactor=np.double(8),
    weight=np.double(0),
    textStyle=TextStyle("light_magenta", "on_black", ["bold"]),
)

CRIT_RATE = StatInfo(
    key="CRIT Rate%",
    zhTW="暴擊率",
    onceIncrementMax=np.double(2.916) / oneIncCoeExp,
    appendFactor=np.double(6),
    weight=np.double(0),
    textStyle=TextStyle("yellow", "on_black", ["bold"]),
)

CRIT_DMG = StatInfo(
    key="CRIT DMG%",
    zhTW="暴擊傷害",
    onceIncrementMax=np.double(5.832) / oneIncCoeExp,
    appendFactor=np.double(6),
    weight=np.double(0),
    textStyle=TextStyle("yellow", "on_black", ["bold"]),
)

ENERGY_REGENERATION = StatInfo(
    key="Energy Regeneration%",
    zhTW="能量恢復效率",
    onceIncrementMax=np.double(1),
    appendFactor=np.double(0),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

HEALING_BOOST = StatInfo(
    key="Healing Boost%",
    zhTW="治療量",
    onceIncrementMax=np.double(1),
    appendFactor=np.double(0),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

DMG_BOOST = StatInfo(
    key="DMG Boost%",
    zhTW="傷害提高",
    onceIncrementMax=np.double(1),
    appendFactor=np.double(0),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

Stats: List[StatInfo] = [
    SPD,
    HP,
    ATK,
    DEF,
    HP_PCT,
    ATK_PCT,
    DEF_PCT,
    BREAK_EFFECT,
    EFFECT_HIT,
    EFFECT_RES,
    CRIT_RATE,
    CRIT_DMG,
    ENERGY_REGENERATION,
    HEALING_BOOST,
    DMG_BOOST,
]

StatsN: int = len(Stats)
StatHitsVec = np.array([one / stat.onceIncrementMax for stat in Stats], dtype=np.double)
StatAppendFactorsVec = np.array([stat.appendFactor for stat in Stats], dtype=np.double)

def override() -> None:
    Utils.Stats.Stats = Stats
    Utils.Stats.StatsN = StatsN
    Utils.Stats.StatHitsVec = StatHitsVec
    Utils.Stats.StatAppendFactorsVec = StatAppendFactorsVec
