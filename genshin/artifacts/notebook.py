def coeff(lhs, rhs, bar):
    lhs = (lhs - bar) / bar
    rhs = (rhs - bar) / bar
    return lhs / rhs


print("")
print("Columbina HP Hig:")
print(coeff(804521, max(800418, 807188), 792038))
print("Columbina HP Low:")
print(coeff(759023, max(755929, 765988), 748690))
print("Columbina EM Hig:")
print(coeff(799866, max(800418, 807188), 792038))
print("Columbina EM Low:")
print(coeff(715994, max(717319, 726798), 710385))

print("")
print("During (CD% Circlet) ATK Hig:")
print(coeff(1039046.952, max(1023701.761, 1038307.258), 1023701.761))
print("During (CD% Circlet) ATK Low:")
print(coeff(1027855.842, max(1029201.187, 1030537.166), 1014456.874))
print("During (ATK% Circlet) ATK Hig:")
print(coeff(1710093.911, max(1704691.86, 1711965.026), 1688820.963))
print("During (ATK% Circlet) ATK Low:")
print(coeff(1680357.519, max(1684028.898, 1683839.235), 1661559.092))

print("")
print("Ineffa ATK Hig:")
print(coeff(536430.9575, max(535603.979, 538292.7249), 526477.3693))
print("Ineffa ATK Low:")
print(coeff(510808.5232, max(514326.0138, 514033.262), 502542.0454))
print("Ineffa EM Hig:")
print(coeff(533058.2284, max(535603.979, 538292.7249), 526477.3693))
print("Ineffa EM Low:")
print(coeff(482541.9934, max(488369.7663, 488091.7887), 477180.4939))

print("")
print("Xiangling ATK Hig:")
print(coeff(14859.20765, max(15006.06881, 15011.39692), 14666.11708))
print("Xiangling ATK Low:")
print(coeff(13451.68568, max(13607.9828, 13597.08261), 13295.18811))
print("Xiangling EM Hig:")
print(coeff(12625.60002, max(12829.13306, 12818.85674), 12534.24111))
print(coeff(19721.73417, max(19998.70901, 19982.68976), 19539.01635))
print("Xiangling EM Low:")
print(coeff(22115.25758, max(22346.03543, 22353.9697), 21839.80202))

print("")
print("Xingqiu ATK Hig:")
print(coeff(3822.852353, max(3824.458317, 3825.816243), 3737.817955))
print("Xingqiu ATK Low:")
print(coeff(3718.64959, max(3735.597114, 3732.604847), 3649.730242))
