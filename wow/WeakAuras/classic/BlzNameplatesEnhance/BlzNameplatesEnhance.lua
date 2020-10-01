-- On Init
do
    SetCVar("namePlateMinScale", .75)
    SetCVar("namePlateMaxScale", .75)
    SetCVar("nameplateSelectedScale", .75)
    SetCVar("nameplateMinScale", .75)
    SetCVar("nameplateMinAlpha", .7)
    SetCVar("nameplateOccludedAlphaMult", .5)
    
    hooksecurefunc("CompactUnitFrame_OnUpdate",
        function(frame)
            if C_NamePlate.GetNamePlateForUnit(frame.unit) ~=
C_NamePlate.GetNamePlateForUnit("player") and not UnitIsPlayer(frame.unit) and
not CompactUnitFrame_IsTapDenied(frame) then
                local threat = UnitThreatSituation("player", frame.unit) or 0
                local reaction = UnitReaction(frame.unit, "player")
                if threat == 3 then
                    r, g, b = 1, 0, 0
                elseif threat == 2 then
                    r, g, b = 1, 0.3, 0.3
                elseif threat == 1 then
                    r, g, b = 1, 0.2, 0
                elseif reaction == 4 then
                    r, g, b = 1, 1, 0
                else
                    r, g, b = 1, 0.5, 0
                end
                frame.healthBar:SetStatusBarColor(r, g, b, 1)
            end
        end
    )
end
