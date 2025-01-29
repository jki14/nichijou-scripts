from typing import List, Tuple

ScreenRegion = Tuple[int, int, int, int]


class RegionsPrfl:
    def __init__(
        self,
        main_key: ScreenRegion = None,
        main_val: ScreenRegion = None,
        stars: ScreenRegion = None,
        level: ScreenRegion = None,
        substats: List[ScreenRegion] = None,
        full: ScreenRegion = None,
    ):
        if full is None:
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
            self.single: bool = False
        else:
            self.full: ScreenRegion = full
            self.single: bool = True

    def translated(self, dx, dy):
        if not self.single:
            return RegionsPrfl(
                main_key=tuple(self.main_key[i] + dx if (i & 1) == 0 else self.main_key[i] + dy for i in range(4)),
                main_val=tuple(self.main_val[i] + dx if (i & 1) == 0 else self.main_val[i] + dy for i in range(4)),
                stars=tuple(self.stars[i] + dx if (i & 1) == 0 else self.stars[i] + dy for i in range(4)),
                level=tuple(self.level[i] + dx if (i & 1) == 0 else self.level[i] + dy for i in range(4)),
                substats=[
                    tuple(self.substats[i][j] + dx if (j & 1) == 0 else self.substats[i][j] + dy for j in range(4)) for i in range(4)
                ],
            )
        else:
            return RegionsPrfl(
                full=tuple(self.full[i] + dx if (i & 1) == 0 else self.full[i] + dy for i in range(4)),
            )


K3440X1440 = RegionsPrfl(
    main_key=(2540, 360, 2880, 400),
    main_val=(2540, 400, 2760, 460),
    stars=(2540, 460, 2800, 520),
    level=(2570, 574, 2638, 606),
    substats=[(2586, 640, 3160, 690), (2586, 690, 3160, 740), (2586, 740, 3160, 790), (2586, 790, 3160, 840)],
)

C3440X1440 = RegionsPrfl(
    main_key=(2700, 340, 2960, 370),
    main_val=(2700, 370, 2900, 430),
    stars=(2700, 430, 2900, 480),
    level=(2714, 520, 2770, 546),
    substats=[(2730, 560, 3130, 618), (2730, 620, 3130, 660), (2730, 660, 3130, 700), (2730, 700, 3130, 744)],
)

C3440X1440MO = C3440X1440.translated(-934, 70)

C3440X1440CA = RegionsPrfl(full=(2840, 180, 3294, 624))

P3440X1440 = RegionsPrfl(
    main_key=(2100, 450, 2560, 500),
    main_val=(2100, 500, 2380, 580),
    stars=(2100, 580, 2400, 660),
    level=(2110, 716, 2200, 760),
    substats=[(2140, 790, 2680, 855), (2140, 855, 2680, 920), (2140, 920, 2680, 985), (2140, 985, 2680, 1050)],
)

RegionsPrfls = {
    "K3440X1440": K3440X1440,
    "C3440X1440": C3440X1440,
    "C3440X1440MO": C3440X1440MO,
    "C3440X1440CA": C3440X1440CA,
    "P3440X1440": P3440X1440,
}
