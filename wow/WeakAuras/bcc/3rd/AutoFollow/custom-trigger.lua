function(event,arg1,_,_,_,arg5,_,_,_,_,_,_,_,_)
    if event == "CHAT_MSG_PARTY" or event =="CHAT_MSG_PARTY_LEADER"or event =="CHAT_MSG_RAID_LEADER" or event =="CHAT_MSG_RAID" then
        local name= UnitName("player")
        if (arg1 =="11"or arg1=="111")  and name ~= arg5 then
            print("开始跟随玩家->"..arg5)
            FollowUnit(arg5)
        end
        if arg1=="22" or arg1=="222"  then
            print("停止跟随")
            FollowUnit("player")
        end
    end
end
