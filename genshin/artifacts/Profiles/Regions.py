from typing import List, Tuple

ScreenRegion = Tuple[int, int, int, int]


class RegionProfile:
    def __init__(
        self,
        main_key: ScreenRegion,
        main_val: ScreenRegion,
        stars: ScreenRegion,
        level: ScreenRegion,
        substats: List[ScreenRegion],
    ):
        self.main_key: ScreenRegion = main_key
        self.main_val: ScreenRegion = main_val
        self.stars: ScreenRegion = stars
        self.level: ScreenRegion = level
        self.substats: ScreenRegion = substats
        self.full: ScreenRegion = (
            min(main_key[0], main_val[0], stars[0], level[0], *(s[0] for s in substats)),
            min(main_key[1], main_val[1], stars[1], level[1], *(s[1] for s in substats)),
            max(main_key[2], main_val[2], stars[2], level[2], *(s[2] for s in substats)),
            max(main_key[3], main_val[3], stars[3], level[3], *(s[3] for s in substats)),
        )


K3440X1440 = RegionProfile(
    main_key=(2540, 360, 2880, 400),
    main_val=(2540, 400, 2760, 460),
    stars=(2540, 460, 2800, 520),
    level=(2570, 574, 2638, 606),
    substats=[(2586, 640, 3160, 690), (2586, 690, 3160, 740), (2586, 740, 3160, 790), (2586, 790, 3160, 840)],
)

C3440X1440 = RegionProfile(
    main_key=(2700, 340, 2960, 370),
    main_val=(2700, 370, 2900, 430),
    stars=(2700, 430, 2900, 480),
    level=(2714, 520, 2770, 546),
    substats=[(2730, 560, 3130, 618), (2730, 620, 3130, 660), (2730, 660, 3130, 700), (2730, 700, 3130, 744)],
)

Regions = {
    "K3440X1440": K3440X1440,
    "C3440X1440": C3440X1440,
}
