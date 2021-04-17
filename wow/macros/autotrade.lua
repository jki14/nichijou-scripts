/run local at=CreateFrame('Frame');at:RegisterEvent('TRADE_ACCEPT_UPDATE');at:SetScript('OnEvent',function()DEFAULT_CHAT_FRAME:AddMessage('detected',1, 1, 0)end);
/run local at=CreateFrame('Frame');at:RegisterEvent('TRADE_ACCEPT_UPDATE');at:SetScript('OnEvent',function()DEFAULT_CHAT_FRAME:AddMessage('start',1, 1, 0)AcceptTrade()DEFAULT_CHAT_FRAME:AddMessage('end',1, 1, 0)end);
