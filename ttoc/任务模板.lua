forceinsecure()
local TTOC = ...
CCTV = TTOC
local Bot = TTOCInitScript("任务模板")
local Log = Bot.Log
-- config为'设定'的窗口，建议show用config:Show(), 可以避免多开窗口
local Config = Bot.Config
local UI = Bot.UI
local MonsterIDUI
local PathUI
local NPCUI
player = CCTV:GetPlayer()
local AttackTable = {
    AttackMonster = {} , Count = 1 ,
    FindPath = true,
    --MoveTo = {},
}
local JumpTimer = 0
local FileTimer = 0
nowTaskID = 0

--定义草药名字统一
SKILL_HERB = 'Herbalism'
SKILL_SKIN = 'Skinning'
if (GetLocale() == "zhCN") then
    SKILL_HERB = '草药学'
    SKILL_SKIN = '剥皮'
end
SKILL_2HAXE = 'Two-Handed Axes'
if GetLocale() == 'zhCN' then
    SKILL_2HAXE = '双手斧'
end
SKILL_QISHU = 'Riding'
if GetLocale() == 'zhCN' then
    SKILL_QISHU = '骑术'
end
local Wait = function(time)
    return TTOCDelay(time / 1000)
end
arrmons = {}
--UI
if not UI:GetWidget('自动组队') then
    UI:AddToggle('自动组队', '任务时自动组周围玩家,Automatically group surrounding players during missions', false)
    UI:AddToggle('使用脚本默认售卖设置', 'Use the script default selling settings', true)
    UI:AddHeader('|cFF00FF001.0版本说明')
    UI:AddLabel('|cFF00FF00* 1234125')
    UI:AddLabel('|cFF00FF00* Now support')
    UI:AddLabel('|cffFF6EB4----有问题及时反馈代理或DIS频道----')
	-- 建议show用config:Show(), 可以避免多开窗口

    Config:Show()
else

    Config:Show()
end

--定义
local GetSetting = function(name)
	--UI:Setting(name) 可以获得值
    return UI:Setting(name)
end

GetScriptUISetting = GetSetting

if _monster == nil then
    _monster = {}
end
--飞行坐骑
function OnFlyMount()
    local _,_,maxSpeed = GetUnitSpeed('player')
    if IsMounted() and maxSpeed > 17 then
        return true
    end
end
function GetZ()
	local x,y,z = CCTV:GetPlayer().Position:GetXYZ()
	return z
end
function GetY()
	local x,y,z = CCTV:GetPlayer().Position:GetXYZ()
	return y
end
function GetX()
	local x,y,z = CCTV:GetPlayer().Position:GetXYZ()
	return x
end
function GoTo(tarx, tary, tarz,dis)
    if dis == nil then
        dis = 0.8
    end
    player:Update()
	if tarx and tary and player:DistanceTo(tarx,tary,tarz) > 1.2 then
		CCTV.MoveTo(tarx, tary, tarz)
	    TTOCDelay(0.1)
        player:Update()
        while player:DistanceTo(tarx, tary, tarz) > dis and not IsDead() do
            TTOCDelay(0.01)
            CCTV.MoveTo(tarx, tary, tarz)
            TTOCDelay(0.1)
            player:Update()
            if GetUnitSpeed('player') == 0 and GetUnitSpeed('pet') == 0 then
                return
            end
        end
	end
end
function JumpTo(tarx, tary, tarz)
	if tarx and tary then
        if CCTV:GetPlayer():DistanceTo(tarx, tary, tarz) > 1.5 then
            CCTV.FaceDirection(tarx, tary, tarz,true)
            MoveForwardStart()
	        TTOCDelay(0.1)
            player:Jump()
            TTOCDelay(0.7)
            MoveForwardStop()
        end
        GoTo(tarx, tary, tarz)
	end
end
local moveToTime = 0
--跳跃
local function Jumpfily()
	if time() - JumpTimer > 1.5 then
		JumpTimer = time()
		if IsMounted() then
			-- Log:Debug('Jump')
			MoveForwardStart()
			JumpOrAscendStart()
			C_Timer.After(0.1, function()
				MoveForwardStop()
				AscendStop()
				moveToTime = 0
			end)
		end
	end
end

--呼吸条剩余
function GetMirrorTimeLeft()
    for idx = 1,3 do
        local id = GetMirrorTimerInfo(idx)--返回有关镜像计时器的信息（疲惫，呼吸和假死计时器）
        if id and id == 'BREATH' then
            return GetMirrorTimerProgress(id) --返回镜像计时器的当前值（疲惫，呼吸和假死计时器）
        end
    end
    return 999999
end
function Shangniao()
    if GetRidingLvl() >= 225 and not IsMounted() then
        UseMount()
        TTOCDelay(1.6)
    end
end
--定义打开物品
function OpenObj(objID)
    local objfinded = CCTV:FindGameObject(function(obj)
        if (obj.ObjectID == objID)
		and obj.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= 8 then
            obj:Update()
            return true
        end
    end)
    if objfinded then
        CCTV.StopMoving()
        Wait(300)
        for i=1,3 do
            CCTV.ObjectInteract(objfinded.Pointer)
            Wait(300)
            for ii = 1,30 do
                if (UnitCastingInfo("player")) ~= nil then
                    Wait(150)
                else
                    break
                end
            end
            Wait(500)
            objfinded = CCTV:FindGameObject(function(obj)
                if (obj.ObjectID == objID)
                and obj.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= 6 then
                    obj:Update()
                    return true
                end
            end)
            if objfinded == nil or CCTV:GetPlayer().Combating and GetTarget() then
                break
            end
        end
        return true
    end
	return false
end
-- 找怪或NPC
function InteractNpc(unitID)
	local mobs = CCTV:FindUnit(
        function(unit)
            if unit.ObjectID == unitID
				and unit.Position:DistanceTo(tx,ty,tz) <= 20
            then
				unit:Update()
                return true
            end
            return false
        end
    )
    if mobs then
        TTOCDelay(1)
        CCTV.ObjectInteract(mobs.Pointer)
        TTOCDelay(2)
	end
end
-- 找怪或NPC
function AttackTarget()
	local mobs = GetTarget()
	if mobs then
        CCTV.ObjectInteract(mobs.Pointer)
    end
end

--寻怪1
local FindMob1Target = {}
local FindMob1UnitID = {
    [19995] = true,
    [19998] = true,
    [21296] = true,
    [20334] = true,
    [20730] = true,
    [21254] = true,
}
local function FindMonster1(dis)
    if dis == nil then
        dis = 30
    end
    -- 第一次搜索
	FindMob1Target = CCTV:FindUnits(function(unit)
		if not unit.Dead and FindMob1UnitID[unit.ObjectID]
            and UnitHealth(unit.Pointer) == UnitHealthMax(unit.Pointer)
            and not unit.IsTargetingMe
            and unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) < dis then
			return true
		end
	end)
	-- 开始监视
	if #FindMob1Target > 0 then
		return true
	end
    return false
end
-- 找怪或NPC
function FindMob(tx,ty,tz,dis,unitID)
    if dis == nil then
        dis = 10
    end
	local mobs = CCTV:FindUnits(
        function(unit)
            if not unit.Dead
				and unit.ObjectID == unitID
				and unit.Position:DistanceTo(tx,ty,tz) <= dis
            then
				unit:Update()
                return true
            end
            return false
        end
    )
	return #mobs > 0
end

-- 找怪或NPC
function FindMob2()
	local mobs = CCTV:FindUnits(
        function(unit)
            if unit.Dead
				and UnitIsSkinnable(unit.Pointer)
            then
				unit:Update()
                print('可剥皮',unit.Pointer)
                return true
            end
            return false
        end
    )
	return #mobs > 0
end

-- 找怪或NPC
function FindMob3(tx,ty,tz,dis)
    if dis == nil then
        dis = 15
    end
	local mobs = CCTV:FindUnits(
        function(unit)
            if not unit.Dead
				and unit.Position:DistanceTo(tx,ty,tz) <= dis
                and UnitCanAttack('player', unit.Pointer)
            then
				unit:Update()
                return true
            end
            return false
        end
    )
    if mobs and #mobs > 0 then
        CCTV:GetPlayer():Stop()
        mobs = mobs[1]
        mobs:TargetUnit()
        Bot.Log:Info('|cFF00FF00反击:|cFFFF0000'..mobs.Name)
        RunMacroText('/startattack')
    end
	return #mobs > 0
end
-- 找怪或NPC
function FindMob4()
	local mobs = CCTV:FindUnits(
        function(unit)
            local x,y,z = unit.Position:GetXYZ()
            local xx,yy,zz = CCTV:GetPlayer().Position:GetXYZ()
            if not unit.Dead
                and unit.ObjectID == 24120
				and getDistance2D(x,y,xx,yy) <= 40
            then
                UseItem(33349)
                CCTV.ClickPosition(x,y,z+1)
				unit:Update()
                return true
            end
            return false
        end
    )
end
-- 反击选怪
timemon = 0
function FindTarMon(dis)
    if dis == nil then
        dis = 30
    end
    if CCTV:GetPlayer().Combating and not IsMounted() and not GetTarget() then
        -- print('战斗中反击')
        local mobs = CCTV:FindUnits(
            function(unit)
                if not unit.Dead
                    and (unit.IsTargetingMe or unit.CreatureType == "Totem" or unit.CreatureType == 'Ward')
                    and unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= dis
                    and UnitCanAttack('player', unit.Pointer)
                then
                    unit:Update()
                    return true
                end
                return false
            end
        )
        if mobs and #mobs > 0 then
            CCTV:GetPlayer():Stop()
            mobs = mobs[1]
            mobs:TargetUnit()
            Bot.Log:Info('|cFF00FF00反击:|cFFFF0000'..mobs.Name)
            if GetTarget() then
                RunMacroText('/startattack')
            end
            return
        end
    end
    if CCTV:GetPlayer().Combating and CCTV:GetPlayer().areaID == 3625 and GetTarget() and GetTarget().ObjectID ~= 21233 then
        local mobs = CCTV:FindUnit(
            function(unit)
                if not unit.Dead
                    and unit.ObjectID == 21233
                    and unit.IsTargetingMe
                    and UnitCanAttack('player', unit.Pointer)
                then
                    unit:Update()
                    return true
                end
                return false
            end
        )
        if mobs then
            CCTV:GetPlayer():Stop()
            mobs:TargetUnit()
            Bot.Log:Info('|cFF00FF00优先攻击:|cFFFF0000'..mobs.Name)
            if GetTarget() then
                RunMacroText('/startattack')
            end
            return
        end
    end

end
-- 找怪或NPC
function FindYuBeiyi()
    if CCTV:GetPlayer().Combating and not GetTarget() and not IsMounted() and
        (not CompleteQuest(12716) or not CompleteQuest(12722) or not CompleteQuest(12719)) then
        local mobs = CCTV:FindUnits(
            function(unit)
                if not unit.Dead and UnitCanAttack('player', unit.Pointer) --单位可以攻击
                    and (unit.IsTargetingMe or
                        ((unit.ObjectID == 28941 or unit.ObjectID == 28942)) and --UnitAffectingCombat 单位影响战斗 UnitAffectingCombat(unit.Pointer) and
                        unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= 10)
                then
                    unit:Update()
                    return true
                end
                return false
            end
        )
        if mobs and #mobs > 0 then
            CCTV:GetPlayer():Stop()
            mobs = mobs[1]
            mobs:TargetUnit()
            Bot.Log:Info('|cFF00FF00攻击:|cFFFF0000'..mobs.Name)
            if GetTarget() then
                RunMacroText('/startattack')
            end
        end
    end
end
timemon2 = 0
function FindTarMon2(dis)
    if dis == nil then
        dis = 15
    end
    if CCTV:GetPlayer().parentMapID ~= 1945 and CCTV:GetPlayer().Combating and not IsMounted() and not GetTarget() then
        local mobs = CCTV:FindUnits(
            function(unit)
                if not unit.Dead
                    and (unit.IsTargetingMe or (unit.ObjectID == 28941 or unit.ObjectID == 28942) and unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= 5)
                    and unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= dis
                    and UnitCanAttack('player', unit.Pointer)
                then
                    unit:Update()
                    return true
                end
                return false
            end
        )
        if mobs and #mobs > 0 then
            CCTV:GetPlayer():Stop()
            mobs = mobs[1]
            mobs:TargetUnit()
            Bot.Log:Info('|cFF00FF00反击:|cFFFF0000'..mobs.Name)
            if GetTarget() then
                RunMacroText('/startattack')
            end
        end
    end
end
-- 身边怪物数量
function GetMonNum(dis)
    if dis == nil then
        dis = 40
    end
    if CCTV:GetPlayer().Combating and not IsMounted() then
        local mobs = CCTV:FindUnits(
            function(unit)
                if not unit.Dead
                    and (unit.IsTargetingMe or unit.CreatureType == "Totem" or unit.CreatureType == 'Ward')
                    and unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= dis
                    and UnitCanAttack('player', unit.Pointer)
                then
                    unit:Update()
                    return true
                end
                return false
            end
        )
        return #mobs
    end
    return 0
end
-- 身边怪物数量
function GetMonNum2(dis)
    if dis == nil then
        dis = 40
    end
    local mobs = CCTV:FindUnits(
        function(unit)
            if not unit.Dead
                and unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= dis
                and UnitCanAttack('player', unit.Pointer)
            then
                unit:Update()
                return true
            end
            return false
        end
    )
    return #mobs
end
-- 身边怪物数量
function GetMonNum3(x,y,z,dis)
    if dis == nil then
        dis = 40
    end
    local mobs = CCTV:FindUnits(
        function(unit)
            if not unit.Dead
                and unit.Position:DistanceTo(x,y,z) <= dis
                and UnitCanAttack('player', unit.Pointer)
            then
                unit:Update()
                return true
            end
            return false
        end
    )
    return #mobs
end
-- 身边NPC数量
function GetNPCNum(npcID,dis)
    if dis == nil then
        dis = 40
    end
    local mobs = CCTV:FindUnits(
        function(unit)
            if not unit.Dead
                and unit.ObjectID == npcID
                and unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= dis
            then
                unit:Update()
                return true
            end
            return false
        end
    )
    return #mobs
end
local findUnitID =
{
    [2978] = true,
    [2979] = true,
}
function SelectUnitByLocationAndId(tx, ty, tz, range, unitId, faceNow)
	if faceNow == nil then
		faceNow = false
	end
    local target =
      CCTV:FindUnits(
        function(unit)
            return unit.ObjectID == unitId and unit.Position:DistanceTo(tx, ty, tz) <= range and not unit.Dead and UnitCanAttack('player', unit.Pointer)
        end
    )
    if target and #target > 0 then
        target = target[1]
        target:TargetUnit()
        if faceNow then
            target:Face()
        end
        return target
    end
    return false
end
function SelectNPCByLocationAndId(tx, ty, tz, range, unitId, faceNow)
	if faceNow == nil then
		faceNow = false
	end
    local target =
      CCTV:FindUnits(
        function(unit)
            return unit.ObjectID == unitId and unit.Position:DistanceTo(tx, ty, tz) <= range
        end
    )
    if target and #target > 0 then
        target = target[1]
        target:TargetUnit()
        if faceNow then
            target:Face()
        end
        return target
    end
    return false
end
function SelectNPCNearest(unitId, range)
    if range == nil then
        range = 8
    end
    local target =
      CCTV:FindUnits(
        function(unit)
            return (not unit.Dead) and unit.ObjectID == unitId and unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= range
        end
    )
    if target and #target > 0 then
        target = target[1]
        target:TargetUnit()
        target:Face()
        return true
    end
    return false
end
function SelectMonNearby(unitId, range)
    if range == nil then
        range = 8
    end
    local target =
      CCTV:FindUnits(
        function(unit)
            return UnitHealth(unit.Pointer) == UnitHealthMax(unit.Pointer)
                and unit.ObjectID == unitId
                and unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= range
        end
    )
    if target and #target > 0 then
        target = target[1]
        target:TargetUnit()
        target:Face()
        return true
    end
    return false
end
function Laguai(unitId, range)
    local zhiye = CCTV:GetPlayer().Class
    if SelectMonNearby(unitId,range) then
        if zhiye == 'PALADIN' then
            CastSpellByID(62124)
        elseif zhiye == 'DEATHKNIGHT' then
            CastSpellByID(49576)
        elseif zhiye == 'MAGE' then
            CastSpellByID(2139)
        elseif zhiye == 'MAGE' then
            CastSpellByID(2139)
        elseif zhiye == 'DRUID' then
            CastSpellByID(16857)
        elseif zhiye == 'HUNTER' then
            CastSpellByID(1978)
        elseif zhiye == 'ROGUE' or zhiye == 'WARRIOR' then
            CastSpellByID(19785)
        elseif zhiye == 'WARLOCK' then
            CastSpellByID(172)
        elseif zhiye == 'PRIEST' then
            CastSpellByID(589)
        elseif zhiye == 'SHAMAN' then
            CastSpellByID(8056)
        end
    end
end
function SelectUnitDead(unitID,dis)
    if unitID == nil then
        unitID = 0
    end
    if dis == nil then
        dis = 10
    end
    local target =
      CCTV:FindUnits(
        function(unit)
            return unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= dis and unit.Dead and not unit:CanLoot() and (unitID == 0 or unitID == unit.ObjectID)
        end
    )
    if target and #target > 0 then
        target = target[1]
        target:TargetUnit()
        target:Face()
        return target
    end
    return false
end
function UnitDeadNearby()
    local target =
      CCTV:FindUnits(
        function(unit)
            return unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= 10 and unit.Dead and not unit:CanLoot()
        end
    )
    if target and #target > 0 then
        return true
    end
    return false
end
--范围组队
function InviteNearby()
    local lvl = CCTV:GetPlayer().Level
    SetSettings({AutoDeclineGroup = false,
    AutoAcceptGroup = {
        level = {lvl - 10, lvl + 10},    -- 选填, 没填就无限制， 55~70
           -- level = {70},    -- ex: 角色60等, 0~70
         distance = 50,      -- 选填, 距离玩家多远，没填就无限制
        --  class = {           -- 选填, 没填就无限制
        --      WARRIOR = true,
        --      ROGUE = true,
        --  }
     },
    })
    if GetScriptUISetting('自动组队') then
        InviteNearbyPlayers({
            players = 4,        -- 邀请人数, 预设4
            level = {lvl-5, lvl+5},    -- 选填, 没填就无限制， 55~70
            -- level = {70},    -- ex: 角色60等, 0~70
            distance = 50,      -- 选填, 距离玩家多远，没填就无限制
            -- class = {           -- 选填, 职业要求，没填就无限制
            --    WARRIOR = true,
            --    ROGUE = true,
            --    DRUID = true,
            -- }
        })
    end
    if UnitIsGroupLeader('player') and GetLootMethod() ~= 'freeforall' then
        RunMacroText('/ffa')
    end
end

--取双手斧技能等级
function Get2HAxeLvl()
    return CCTV:GetPlayer():GetSkill(SKILL_2HAXE).Rank
end
--取剥皮等级
function GetSkinningLvl()
    return CCTV:GetPlayer():GetSkill(SKILL_SKIN).Rank
end
--取剥皮最大等级
function GetSkinningLvlMax()
    return CCTV:GetPlayer():GetSkill(SKILL_SKIN).MaxRank
end
--取骑术技能等级
function GetRidingLvl()
    return CCTV:GetPlayer():GetSkill(SKILL_QISHU).Rank
end

--取草药学等级
function GetHerbLvl()
    return CCTV:GetPlayer():GetSkill(SKILL_HERB).Rank,CCTV:GetPlayer():GetSkill(SKILL_HERB).MaxRank
end
function IsSubtaskCompleted(questid, index)
    for questLogID = 1, GetNumQuestLogEntries() do
        local _, _, _, _, _, _, _, questID = GetQuestLogTitle(questLogID);
        if questID == questid then
            local _, _, done = GetQuestLogLeaderBoard(index, questLogID)
            -- print(GetQuestLogLeaderBoard(index, questLogID))
            return done
        end
    end
end
function GetQuestLeftTime(questid)
    for questLogID = 1, GetNumQuestLogEntries() do
        local _, _, _, _, _, _, _, questID = GetQuestLogTitle(questLogID);
        if questID == questid then
            local lefttime = GetQuestLogTimeLeft(questLogID)
            return lefttime
        end
    end
    return -1
end
--购买指定物品ID
function BuyItemID(itemID)
    local g,i=GetMerchantItemLink
    for i=0,60 do
        if g(i) then
            if strfind(g(i),':'..tostring(itemID)..':') then
                print('Finded:',itemID)
                BuyMerchantItem(i)
                return
            end
        end
    end
end

--身边有篝火
function CloseBonfire()
    if CCTV:GetPlayer().Combating then
        return
    end
    local mobs = CCTV:FindGameObjects(
        function(unit)
            if (strfind(unit.Name, "Bonfire") or strfind(unit.Name,'篝火'))
                and unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= 2
            then
                unit:Update()
                return true
            end
            return false
        end
    )
    if mobs and #mobs > 0 then
        print('|cFF00FF00篝火旁,平移避开')
        local rn = math.random(1,2)
        if rn == 1 then
            StrafeLeftStart()
            TTOCDelay(0.5)
            StrafeLeftStop()
        else
            StrafeRightStart()
            TTOCDelay(0.5)
            StrafeRightStop()
        end
    end
end
--定义巫医NPC存在
local function WuyiNPCcunzai()
	local mobs = TTOC:FindUnits(
		function(unit)
            -- print(2,not unit.Dead , unit.ObjectID == 1449 , unit.Position:DistanceTo(-13738.4609, -29.7435, 44.5561) <= 1 )
			if
				not unit.Dead and unit.ObjectID == 1449 and unit.Position:DistanceTo(-13738.4609, -29.7435, 44.5561) <= 1
			then
				return true
			end
			return false
		end
	)
	return  #mobs >= 1
end

--定义土堆1
function Dingyitudui()
    local mobs = CCTV:FindGameObjects(
        function(unit)
            if unit.ObjectID == 144064 and unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= 5
            then
                unit:Update()
                return true
            end
            return false
        end
    )
    return  #mobs >= 1
end
--NPC存在
function NPCcunzai(x,y,z,npcID,dis)
    if dis == nil then
        dis = 1
    end
	local mobs = TTOC:FindUnits(
		function(unit)
			if
				not unit.Dead and unit.ObjectID == npcID and unit.Position:DistanceTo(x,y,z) <= dis
			then
				return true
			end
			return false
		end
	)
	return  #mobs >= 1
end
--NPC存在
function NPCnearby(npcID,dis)
    if dis == nil then
        dis = 1
    end
	local mobs = TTOC:FindUnits(
		function(unit)
			if
				not unit.Dead and unit.ObjectID == npcID and unit.Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) <= dis
			then
				return true
			end
			return false
		end
	)
	return  #mobs >= 1
end
--NPC存在范围内
function NPCcunzaidis(npcID,x,y,z,dis)
    local mobs = TTOC:FindUnits(
      function(unit)
        if
          not unit.Dead and unit.ObjectID == npcID and unit.Position:DistanceTo(x,y,z) <= dis
        then
          return true
        end
        return false
      end
    )
    return  #mobs >= 1
end
--遍历拾取
function LootBodys()
	--local TTOC = SW
	if  GetBagFreeSlots() < 1 then
	   return
	end

	-- 遍历3遍尸体
	local lootCounts = 0
	for i = 1, 3 do
	   local bodys =
	   CCTV:FindUnits(
		  function(unit)
			 if unit.Dead and unit.Distance <= 5 and CCTV.UnitIsLootable(unit.Pointer) then
				CCTV.ObjectInteract(unit.Pointer)
				TTOCDelay(0.5)
				lootCounts = lootCounts + 1
				return true
			 end
		  end
	   )
	end
end

function DeleteTable(table,val)
    for index, value in ipairs(table) do
        if value == val then
            table.remove(table,index)
            return
        end
    end
end

function GetReadyRuneCountBing() --冰符文
    local runeAmountBing = 0
    for i=5,6 do
        local start, duration, runeReady = GetRuneCooldown(i)
        if runeReady == true then
            runeAmountBing = runeAmountBing+1
        end
    end
    return runeAmountBing
end

function GetReadyRuneCountXue() --鲜血符文
    local runeAmountXue = 0
    for i=1,2 do
        local start, duration, runeReady = GetRuneCooldown(i)
        if runeReady == true then
            runeAmountXue = runeAmountXue+1
        end
    end
    return runeAmountXue
end

function GetReadyRuneCountXieE() --邪恶符文
    local runeAmountXieE = 0
    for i=3,4 do
        local start, duration, runeReady = GetRuneCooldown(i)
        if runeReady == true then
            runeAmountXieE = runeAmountXieE+1
        end
    end
    return runeAmountXieE
end
--目标DEBUFF
function TarHasDebuff(idOrName)
    for fi = 1, 40 do
        local name, _, _, _, duration, expirationTime, unitCaster, _, _, spellId = UnitDebuff('target', fi)
        if name then
            if idOrName == name or idOrName == spellId then
                return true
            end
        end
    end
    return false
end
function HasDebuff(idOrName)
    for fi = 1, 40 do
        local name, _, _, _, duration, expirationTime, unitCaster, _, _, spellId = UnitDebuff('player', fi)
        if name then
            if idOrName == name or idOrName == spellId then
                return true
            end
        end
    end
    return false
end
function DoTradeSkillByName(skillName)
    for idx = 1, GetNumTradeSkills() do
        local name, level, number = GetTradeSkillInfo(idx)
        if name == skillName and number > 0 then
            DoTradeSkill(idx, number)
            return true
        end
    end
    return false
end
function zhuanxiang(dis)
    CCTV:GetPlayer():MouseFacing(dis,true)
end

function CancelAura(idOrName)
    for i = 1, 40 do
        local name, _, _, _, duration, expirationTime, unitCaster, _, _, spellId = UnitAura('player', i)
        if name then
            if type(idOrName) == 'string' and idOrName == name then
                CancelUnitBuff('player', i)
                return true
            end

            if type(idOrName) == 'number' and idOrName == spellId then
                CancelUnitBuff('player', i)
                return true
            end
        end
    end
    return false
end
-- 是否已学会飞行坐骑技能
function IsMountSpellKnown(id)
    local num = GetNumCompanions('MOUNT')
    for idx = 1,num do
        local _,_,mountid = GetCompanionInfo('MOUNT',idx)
        if mountid == id then
            return true
        end
    end
    return false
end
--放弃任务
function GiveupQuest(questid)
    for questLogID = 1, GetNumQuestLogEntries() do
        local _, _, _, _, _, _, _, questID = GetQuestLogTitle(questLogID);
        if questID == questid then
            SelectQuestLogEntry(questLogID)
            SetAbandonQuest()
            AbandonQuest()
            return
        end
    end
end
--死亡骑士输出循环
function DKfight()
    if CCTV:GetPlayer().Class == 'DEATHKNIGHT' and GetTarget() and GetTarget().ObjectID ~= 28606 and GetTarget().ObjectID ~= 28605 and UnitCanAttack('player',GetTarget().Pointer) then
        if GetTarget() and CCTV:GetPlayer():DistanceTo(GetTarget().Position:GetXYZ()) > 20 then
            if GetTarget().ObjectID == 18423 and not TarHasDebuff(49005) then
                CastSpellByID(49005)
                TTOCDelay(1.5)
            end
            if GetSpellCooldown(49576) == 0 then
                Dismount()
                TTOCDelay(0.5)
                CCTV:FacingTagert()
                CastSpellByID(49576)
                TTOCDelay(1.5)
            elseif GetTarget() then
                CCTV.MoveTo(GetTarget().Position:GetXYZ())
                TTOCDelay(1.5)
            end
        else
            if GetTarget() and GetTarget().Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) < 20 then
                CCTV:FacingTagert()
                if GetLocale() == 'zhCN' then
                    RunMacroText('/cast 冰冷触摸')
                else
                    RunMacroText('/cast Icy Touch')
                end
                TTOCDelay(1.5)
            end
        end
        if GetTarget() and CCTV:GetPlayer():DistanceTo(GetTarget().Position:GetXYZ()) > 5 then
            CCTV.MoveTo(GetTarget().Position:GetXYZ())
            TTOCDelay(1.5)
        end
        if GetTarget() and CCTV:GetPlayer().Combating then
            for fi = 1, 2 do
                if GetTarget() and GetTarget().Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) < 20 and not TarHasDebuff(55095) then
                    CCTV:FacingTagert()
                    if GetLocale() == 'zhCN' then
                        RunMacroText('/cast 冰冷触摸')
                    else
                        RunMacroText('/cast Icy Touch')
                    end
                    TTOCDelay(1.5)
                end
            end
            for fi = 1, 2 do
                if GetTarget() and GetTarget().Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) < 5 and not TarHasDebuff(55078) then
                    CCTV:FacingTagert()
                    if GetLocale() == 'zhCN' then
                        RunMacroText('/cast 暗影打击')
                    else
                        RunMacroText('/cast Plague Strike')
                    end
                    TTOCDelay(1.5)
                end
            end
            if GetTarget() and GetTarget().Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) < 30 then
                while GetTarget() and not GetTarget().Dead and UnitPower('player') >= 40 do
                    CCTV:FacingTagert()
                    if GetLocale() == 'zhCN' then
                        RunMacroText('/cast 凋零缠绕')
                    else
                        RunMacroText('/cast Death Coil')
                    end
                    TTOCDelay(1.5)
                end
            end
            if GetTarget() and GetTarget().Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) < 5 then
                CCTV:FacingTagert()
                if GetLocale() == 'zhCN' then
                    RunMacroText('/cast 鲜血打击')
                else
                    RunMacroText('/cast Blood Strike')
                end
                TTOCDelay(1.5)
            end
            if GetTarget() and GetTarget().Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) < 30 then
                while GetTarget() and not GetTarget().Dead and UnitPower('player') >= 40 do
                    CCTV:FacingTagert()
                    if GetLocale() == 'zhCN' then
                        RunMacroText('/cast 凋零缠绕')
                    else
                        RunMacroText('/cast Death Coil')
                    end
                    TTOCDelay(1.5)
                end
            end
            if GetTarget() and GetTarget().Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) < 5 then
                CCTV:FacingTagert()
                if GetLocale() == 'zhCN' then
                    RunMacroText('/cast 灵界打击')
                else
                    RunMacroText('/cast Death Strike')
                end
                TTOCDelay(1.5)
            end
            if GetTarget() and GetTarget().Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) < 5 then
                CCTV:FacingTagert()
                if GetLocale() == 'zhCN' then
                    RunMacroText('/cast 鲜血打击')
                else
                    RunMacroText('/cast Blood Strike')
                end
                TTOCDelay(1.5)
            end
            if GetTarget() and GetTarget().Position:DistanceTo(CCTV:GetPlayer().Position:GetXYZ()) < 30 then
                while GetTarget() and not GetTarget().Dead and UnitPower('player') >= 40 do
                    CCTV:FacingTagert()
                    if GetLocale() == 'zhCN' then
                        RunMacroText('/cast 凋零缠绕')
                    else
                        RunMacroText('/cast Death Coil')
                    end
                    TTOCDelay(1.5)
                end
            end
        end
        LootBodys()
    end
end

local randomPath = {FindPath = true}
local text = {
    --[[

    ]]
------------------------
    {If = "CCTV:GetPlayer().Class == 'DEATHKNIGHT'",End = '死亡骑士'},
        {Run = "DMW.Settings.profile.Rotation['自动食尸鬼管理'] = false"},
    {End = '死亡骑士'},
    {Run = function()
        SetDMWHUD('Rotation',true) --DMW
        SetCVar('XPbarText',1)
    end},
    {Log = 'Info', Text = '任务脚本启动'},
    {Log = 'Info', Text = '正在初始化...'},
    {Settings = 'AutoDeclineGroup' , value = false}, --关闭拒绝组队
    {Run = function()
        SetSettings({
            AutoAcceptGroup = {
            level = {6, 80},    -- 选填, 没填就无限制， 55~70
            -- level = {70},    -- ex: 角色60等, 0~70
            -- distance = 60,      -- 选填, 距离玩家多远，没填就无限制
            -- class = {           -- 选填, 没填就无限制
            --     WARRIOR = true,
            --     ROGUE = true,
            -- }
        }})
    end},
    {Run = function()
        RunMacroText("/leave 1")
        RunMacroText("/leave 2")
        RunMacroText("/leave 3")
        RunMacroText("/leave 4")
        RunMacroText("/leave 5")
        RunMacroText("/leave 6")
    end},
    -- {Run = "DMW.Settings.profile.Rotation['选择形态'] = 3"},
    {Run = "DMW.Settings.profile.Rotation['冰霜之路'] = false"},
    -- {Run = "DMW.Settings.profile.Rotation['鲜血印记'] = false"},
    -- {Run = "DMW.Settings.profile.Rotation['自动食尸鬼管理'] = false"},
}
local text1 = {

        {If = "IsHasQuest(11458) and not CanCompleteQuest(11458)",End = '做任务:伊斯卡尔的复仇'},
            {Log = 'Info', Text = '做任务:伊斯卡尔的复仇'},
            {Settings = 'WalkWater',value = true},
            {If = "CCTV:GetPlayer():DistanceTo(590.9636, -2794.5503, 0.1816) < 20",End = 'go'},
                {MoveTo = {565.9277, -2829.6501, -1.5557,false},},
                {MoveTo = {545.8057, -2884.2703, 0.5180,false},},
                {MoveTo = {546.5701, -2928.0964, 0.1771,false},},
            {End = 'go'},
            {Settings = 'UseMountWhenNotattack',value = true},--使用坐骑不攻击与反击
            {Settings = 'agentRadius',value = 1.5}, --设置导航距离障碍物间距
            {Settings = 'SearchRadius', value = 100}, --掃描怪物半徑
            {Settings = 'UseMount',value = true},--自动使用坐骑
            {Settings = 'WalkWater',value = false},--走水路
            {Settings = 'CombatIngSwitch',value = true},-- 自动战斗，追击，检取开关
            {Settings = 'UnitMaxDiffDis', value = 8},-- 高于我多少码的怪物不主动寻找攻击
            {Settings = 'GameObjMaxDiffDis', value = 100},-- 高于我多少码的物品不主动寻找攻击
            {AttackMonster = {24676} , Count = 1 ,
                MoveTo = {--如果找不到怪就移动，详见上面的MoveTo
                    {{552.7882, -3405.1992, 19.4343},},
                    {{553.2379, -3487.4634, 4.7641},},
                }, Random = 0 ,FindPath = true,Distance = 100,
                filter = {
                    -- {1503.7710, -5262.5332, 206.9825,40}
                }
            --[[Center = {2018.3159, 1580.9576, 71.7780}, --]]
            --[[Distance = 75,--]]
            },
            {Delay = 0.5},
            {Run = "InviteNearby()"}, -- 自动范围组队邀请
        {Loop = '做任务:伊斯卡尔的复仇'},

        { If =  "CCTV:GetPlayer().Level < 80 and CCTV:GetPlayer().mapID ==1454 and CCTV:GetPlayer().mapID ~=1419",End = '奥格传送门去外域'},
            {MoveTo = {1471.7360, -4215.8960, 58.9938,true},},
            {Settings = 'ManualJump',value = true}, -- 打开临时关闭传送
            {ObjInteract = 195142},
            {Delay = 15},
            {Settings = 'ManualJump',value = false},-- 恢复传送
            {If = "CCTV:GetPlayer():DistanceTo(-11708.4004, -3168.0000, -5.0700) < 5", End = '传送过来范围内'},
                  {MoveTo = {-11722.8418, -3170.8994, -9.1604,false},},
            {End = '传送过来范围内'},

            {MoveTo = {-11817.3691, -3182.7058, -30.0096,true},},
        {Loop = '奥格传送门去外域'},

        {Run = function() print(FindMob2()) end}, --线程print
        {If =  function() return FindMob2() end , End = '需要重置副本'}, --额外if方法
            {MoveTo = {1471.7360, -4215.8960, 58.9938,true},},
            {Settings = 'ManualJump',value = true}, -- 打开临时关闭传送
            {ObjInteract = 195142},
            {Delay = 15},
            {Settings = 'ManualJump',value = false},-- 恢复传送
            {If = "CCTV:GetPlayer():DistanceTo(-11708.4004, -3168.0000, -5.0700) < 5", End = '传送过来范围内'},
                  {MoveTo = {-11722.8418, -3170.8994, -9.1604,false},},
            {End = '传送过来范围内'},

            {MoveTo = {-11817.3691, -3182.7058, -30.0096,true},},
            {Run = function() Yijisha110 = false Xuyaojishi = true FindMobXunluo1 = 0 FindMobXunluo2 = 0 end}, 
        {End = '需要重置副本'},

        --执行宏命令
        {If = "IsMounted()",End = '下坐骑'},
		   	{Run = 'RunMacroText("/dismount")'},
		{End = '下坐骑'},

        --额外的配置项
        --[[
                    --判断等待任务超时
                    TimeOutEvent = true,
                    --判定导航卡住事件
                    StuckEvent = true,
                    --陆地导航提前抵达距离
                    ReachDistance = 1.8;
                    --骑马导航提前抵达距离
                    MountReachDistance = 2.6;
                    --飞行骑马导航提前抵达距离
                    flyMountReachDistance = 5;
                    --载具车辆导航提前抵达距离
                    VehicleMountReachDistance = 5;
                    --飞行骑马抵达距离开关,没有不适用
                    AutoLoginfly = false,
                    -- 陆地飞行提高Z高度开关
                    AutoRaiseMoveZ = false;
                    -- 陆地飞行提高move Pos Z
                    RaisemovetoZ = 0;
                    --导航间隔障碍物距离
                    agentRadius = 2,
                    --扫描怪物半徑
                    SearchRadius = 100,
                    --自动拾取
                    AutoLoot = true,
                    --判断回城
                    GoHomeEvent = false,
                    --走水路
                    WalkWater = false,
                    --手动打开临时关闭传送传送
                    ManualJump = false,
                    -- 判断长距离传送事件
                    TPEvent = true,
                    -- 战斗循环自动buff
                    CombatLoopAutoBuff = true,
                    -- 自动战斗,追击,检取开关
                    CombatIngSwitch = true,
                    -- 自动吃喝
                    AutoDrinkFood = true,
                    --自动采集草药
                    AutoGatherHerb = false,
                    --采集草药范围
                    GatherHerbRadius = 150,
                    --自动采集矿物
                    AutoGatherOre = false,
                    --采集矿物范围
                    GatherOreRadius = 150,
                    --自动采集尸体
                    AutoGatherCorpse = false,
                    --不采集灰色
                    NotGatherGray = false,
                    --自动练习开锁
                    AutoLockpick = false,
                    --自动剥皮
                    Autoskin = false,
                    --自动合成
                    AutoUseParticle = true,
                    --自动使用增益卷轴
                    AutoUseScroll = true,
                    --自动使用风蛇
                    AutoUseFengshe = false,
                    --全都吃
                    EatAll = true,
                    --使用食物
                    UseFood = false,
                     --食物名称
                    FoodName = {},
                    --恢复生命值范围
                    FoodPercent = {90 ,95 },
                    --食物数量
                    FoodAmount = 0,
                     --使用饮料
                    UseDrink = false,
                    --饮料名称
                    DrinkName = {},
                    --恢复法力值范围
                    DrinkPercent = {90 ,95 },
                    --饮料数量
                    DrinkAmount = 0,
                    --当背包空格小于等于多少时触发回城
                    MinFreeBagSlotsToGoToTown = 1,
                    --当装备耐久度小于等于%多少时触发回城
                    MinDurabilityPercent = 20,
                    --当弹药数量少于多少时触发回城
                    AmmoAmountToGoToTown = 0,
                    --当总金额达到此数+360铜后触发回城
                    MoneyToGoToTown = 0,
                    --满包回城
                    FullBagToGoToTown = true,
                    --弹药数量
                    AmmoAmount = 0,
                    --反击
                    Counterattack = true,
                    --他人目标反击
                    TapDeniedCounterattack = false,
                    --反击玩家
                    PlayerCounterattack = false,
                    --攻击半径内所有怪物
                    AttackRadiusAllMonster = false,
                    --自动换装
                    AutoEquip = false,
                    --写入Log
                    WriteLog= true,
                    --使用坐骑
                    UseMount = false,
                    --使用坐骑不攻击与反击
                    UseMountWhenNotattack = true,
                    --回家时不反击
                    GoHomeNotattack = true,
                    --下马距离
                    DismountDistance = 30,
                    --上马距离（怪物）
                    MountDistanceToMonster = 60,
                    --上马距离（玩家）
                    MountDistanceToPlayer = 60,
                    --学习所有可学技能
                    LearnAllSkil = false,
                    --指定学习的技能
                    LearnThisSkil = {},
                    --自动拒绝公会
                    AutoDeclineGuild = false,
                    --自动拒绝组队
                    AutoDeclineGroup = false,
                    --自动拒绝决斗s
                    AutoDeclineDuel = false,
                    --自动复活
                    AutoRetrieve = true,
                    --安全复活
                    SafeRetrieve = true,
                     --自动换装
                    AutoEquip= true,
                    -- 使用短距离传送提示
                    UseShortTPBeep = true,
                    -- 怪物死亡距离达到多少后优先喝水
                    LootMaxDistance = 10,
                    -- 判断怪物血量10秒不变拉黑
                    checkTargetHP = true,
                    --长时间停顿炉石回城
                    LongTimePause = true,
                    -- 对象差高度
                    UnitMaxDiffDis = 100,
                    -- 物品差高度
                    GameObjMaxDiffDis = 100,
                    -- 自动接受组队
                    AutoAcceptGroup = false,
                    -- 自动买卖东西--关闭对话NPC将不会进行买卖
                    AutoSellorBuy = true,
        ]]
 
    {Replace = 'text4', Index = 1},

}
local text4 = {

    {Log='Info',Text="脚本停止,后续任务更新中,敬请期待\nThe script has stopped, and the follow-up tasks are being updated, so stay tuned"},
    {Run = 'StopScriptBot()'},
}
local text5 = {}
local text6 = {

}
local text8 = {}



local text9 = {
    -- {Replace = 'text10', Index = 1},
}

-- 存放尸体路径
local Corpse = {}
-- 获得尸体地址
function CorpseAddress()
	Wait(2000)
	x, y, z = CCTV.GetCorpsePosition()
	Corpse[1] = x
	Corpse[2] = y
	Corpse[3] = z
	Corpse[4] = true
	_dis_ = getDistance2D(570.6481, 6932.7852, x, y)
	return _dis_ < 400
end
-- 获得尸体地址
function CorpseAddress2()
	Wait(2000)
	x, y, z = CCTV.GetCorpsePosition()
	Corpse[1] = x
	Corpse[2] = y
	Corpse[3] = z
	Corpse[4] = true
	_dis_ = getDistance2D(2731.9548, 6510.3013, x, y)
	print(_dis_)
	return _dis_ < 40
end

tmpename = ""
--导航找尸体路线
local RunCorpse = {
    {Delay = 5},
	{If = CorpseAddress , End = '尸体在毒蛇湖'},
		{Run = 'print("尸体在副本外")'},
		{Settings = 'agentRadius' , value = 2},
				--判定是否需要重置副本
		--进本
        {Delay = 5},
		{Run = function()
			if StaticPopup1 and StaticPopup1:IsVisible() and StaticPopup1Button1 and StaticPopup1Button1:IsEnabled() then
				RetrieveCorpse()
			end
		end},
		--开启自动复活
		{Settings = 'AutoRetrieve' , value = true},
        {Delay = 2},
	    {Run="CCTV.SetPitch(-PI/2)"},
        {MoveTo = Corpse,},
	    {Run="CCTV.SetPitch(-PI/2)"},
        {MoveTo = Corpse,},
        {If = function() return tmpename ~= '' end,End = '恢复脚本位置'},
		    {Run = "ReplaceScriptQuest(tmpename, 1)"},
        {Else = '恢复脚本位置'},
		    {Run = "ReplaceScriptQuest('text', 1)"},
        {End = '恢复脚本位置'},
	{End = '尸体在毒蛇湖'},
	{If = CorpseAddress2 , End = '尸体在怪堆里'},
		{Run = 'print("尸体在怪堆里")'},
		{Settings = 'agentRadius' , value = 2},
		{Run = function()
			if StaticPopup1 and StaticPopup1:IsVisible() and StaticPopup1Button1 and StaticPopup1Button1:IsEnabled() then
				StaticPopup1Button1:Click()
			end
		end},
        {Delay = 5},
		--开启自动复活
		{Settings = 'AutoRetrieve' , value = true},
        {Delay = 2},
        {MoveTo = {2726.3027, 6513.8198, 11.2265,true},},
        {Delay = 2},
		{Run = function()
			if StaticPopup1 and StaticPopup1:IsVisible() and StaticPopup1Button1 and StaticPopup1Button1:IsEnabled() then
				StaticPopup1Button1:Click()
			end
		end},
		{Settings = 'AutoRetrieve' , value = true},
        {If = function() return tmpename ~= '' end,End = '恢复脚本位置'},
		    {Run = "ReplaceScriptQuest(tmpename, 1)"},
        {Else = '恢复脚本位置'},
		    {Run = "ReplaceScriptQuest('text', 1)"},
        {End = '恢复脚本位置'},
	{End = '尸体在怪堆里'},
    {Replace = 'text', Index = 1},
}
local function DeadEvent()
    local Name = GetNewScriptQuestName()
	if tmpename ~= Name then
		print(Name.." running")
		tmpename = Name
	end
    if Name ~= 'RunCorpse' then
		--SetScriptIndex('text', 1)
        ReplaceScriptQuest('RunCorpse', 1)
        --RunCorpse[#RunCorpse].Replace = 'text'
    end
end
local time18262 = 0
Bot:SetPulse(function(Bots)
	-- if IsDead() then
	-- 	DeadEvent()
	-- end
    if not CCTV:GetPlayer().Combating
        and IsHasQuest(11161)
        and GetUnitSpeed('player') == 0
        and not GetTarget()
        and not HasFoodBuff()
        and not HasDrinkBuff()
        and SelectUnitDead()
        and GetItemCooldown(33088) == 0 then
        UseItem(33088)
        TTOCDelay(0.2)
        while UnitCastingInfo('player') do
            TTOCDelay(0.2)
        end
    end
    player:Update()
    --DKfight()
    if QuestLogDetailFrame:IsShown() then
        QuestLogDetailFrameCloseButton:Click()
    end
    if GetTime() - timemon > 0.5 then
        if GetDMWHUD('Rotation') == 1 and CCTV:GetPlayer():DistanceTo(9333.9004, -7883.9507, 158.4444) > 100 then
            FindTarMon()
            timemon = GetTime()
        end
    end
    if time() - FileTimer > 2 then
        FileTimer = time()
        CloseBonfire()
    end
    if IsMounted() and not IsFlying() and IsFlyableArea() then
        -- if CCTV:GetPlayer():HasAura(32245)
        --     or CCTV:GetPlayer():HasAura(32244)
        --     or CCTV:GetPlayer():HasAura(32243)
        --  then
        if OnFlyMount() then
            SetSettings({UseShortTPBeep = false})
            -- player:Jump(0.15)
            Jumpfily()
            -- JumpOrAscendStart()
            -- TTOCDelay(0.2)
            -- AscendStop()
            -- TTOCDelay(0.1)
            SetSettings({UseShortTPBeep = true})
        end
    end
    if CCTV:GetPlayer():DistanceTo(2669.4158, 6019.5215, 48.0468) < 5 and GetZ() < 49 then
        ClearTask()
        GoTo(2692.3594, 6034.5103, 30.6590)
    end
    if IsHasQuest(11690) and GetTarget() and GetTarget().ObjectID == 25596 and not UnitInVehicle('player') then
        UseItem(34954)
        TTOCDelay(1)
        if UnitInVehicle('player') and Profile('CombatIngSwitch') then
            SetSettings(
                {CombatIngSwitch = false,
                UseMountWhenNotattack = true,
            })
            SetDMWHUD('Rotation',false)
            TTOCDelay(0.1)
        end
    end
    if IsHasQuest(11721) and CCTV:GetPlayer().Combating and GetItemCooldown(34979) == 0 then
        if GetTarget() and (GetTarget().ObjectID == 25789 or GetTarget().ObjectID == 24469)  then
            UseItem(34979)
        end
    end
    if IsHasQuest(11590) and CCTV:GetPlayer().Combating and GetItemCooldown(34691) == 0 then
        if GetTarget() and GetTarget().ObjectID == 25316 and UnitHealth('target') / UnitHealthMax('target') < 0.8 then
            UseItem(34691)
        end
    end
    if IsHasQuest(11957) and CCTV:GetPlayer().Combating and GetItemCooldown(35690) == 0 then
        if GetTarget() and GetTarget().ObjectID == 26232 then
            UseItem(35690)
        end
    end
    if GetTime() - time18262 > 2 then
        if IsHasQuest(11626) and CCTV:GetPlayer().Combating and GetItemCooldown(35850) == 0 then
            if GetTarget() and GetTarget().ObjectID == 26452 then
                ClearTask()
                UseItem(35850)
                TTOCDelay(1.5)
            end
        end
        if IsHasQuest(11896) and not CanCompleteQuest(11896) and IsCombating() and GetItemCooldown(35352) == 0 then
            local tar = GetTarget()
            if tar and (tar.ObjectID == 25753 or tar.ObjectID == 25758 or tar.ObjectID == 25752) then
                UseItem(35352)
                TTOCDelay(1.5)
            end
        end
        if IsHasQuest(11899) and not CanCompleteQuest(11899) and not IsCombating() and SelectUnitDead(25814,6) and GetItemCooldown(35401) == 0 then
            ClearTask()
            CCTV.StopMoving()
            UseItem(35401)
            TTOCDelay(1.5)
        end
        if IsHasQuest(11227) and not IsCombating() then
            Laguai(23945,25)
        end
        if IsHasQuest(11170) and not CanCompleteQuest(11170) then
            FindMob4()
        end
        if IsHasQuest(11919) and GetItemCooldown(35506) == 0 then
            if SelectNPCNearest(26127,60) then
                ClearTask()
                CCTV.StopMoving()
                TTOCDelay(0.5)
                UseItem(35506)
                UseItem(35506)
                TTOCDelay(3)
            end
        end
        if IsHasQuest(11307) and GetItemCooldown(33621) == 0 then
            local tar=GetTarget()
            if tar and (tar.ObjectID == 23564 or tar.ObjectID == 24198 or tar.ObjectID == 24199) then
                ClearTask()
                SetDMWHUD('Rotation',false)
                CCTV.StopMoving()
                UseItem(33621)
                TTOCDelay(3)
                SetDMWHUD('Rotation',true)
            end
        end
        time18262 = GetTime()
    end

    Bots.QuestScriptPulse(Bots)
end)

Bot:AddQuest('RunCorpse',RunCorpse)

--加入脚本
Bot:AddQuest('text',text)
Bot:AddQuest('text1',text1)
Bot:AddQuest('text2',text2)
Bot:AddQuest('text3',text3)
Bot:AddQuest('text4',text4)
Bot:AddQuest('text5',text5)
Bot:AddQuest('text6',text6)
Bot:AddQuest('text7',text7)
Bot:AddQuest('text8',text8)
Bot:AddQuest('text9',text9)


--设定第一个执行的脚本
Bot:SetFirstQuest('text')
Bot:SetStart(function()
    Config:Hide()
      Log:System('=======================')
      Log:System("任务模板")
      Log:System('=======================')
      nowTaskID = Profile('nowTaskIDDoing') or 0
      -- Bot:SetPulse(Bot.QuestScriptPulse)
      SetPulseTime(0.1)
      --动作
      ACCheck(true)
      --传送
      TPCheck(true)
      --自动调整帧数
      SetCVar("maxFPS", 50)
      SetCVar("maxFPSBk", 50)
      SetDMWHUD('Rotation',true) --DMW

      local LearnThisTalentList = {}
      if CCTV:GetPlayer().Class=='MAGE' then
            LearnThisTalentList = {
            }
      end
      if CCTV:GetPlayer().Class=='ROGUE' then
            LearnThisTalentList = {
            }
      end
      if CCTV:GetPlayer().Class=='HUNTER' then
            LearnThisTalentList = {
            }
      end
      if CCTV:GetPlayer().Class=='PRIEST' then
            LearnThisTalentList = {
            }
      end
      if CCTV:GetPlayer().Class=='WARLOCK' then
            LearnThisTalentList = {
            }
      end
      if CCTV:GetPlayer().Class=='PALADIN' then
            LearnThisTalentList = {
                {301, 1},-- 偏斜
                {301, 2},-- 偏斜
                {301, 3},-- 偏斜
                {301, 4},-- 偏斜
                {301, 5},-- 偏斜
                {303, 1},-- 强化审判
                {303, 2},-- 强化审判
                {304, 1},-- 十字军之心
                {304, 2},-- 十字军之心
                {304, 3},-- 十字军之心
                {309, 1},-- 正义追击
                {309, 2},-- 正义追击
                {308, 1},-- 命令圣印
                {305, 1},-- 强化力量祝福
                {305, 2},-- 强化力量祝福
                {307, 1},-- 定罪
                {307, 2},-- 定罪
                {307, 3},-- 定罪
                {307, 4},-- 定罪
                {307, 5},-- 定罪
                {314, 1},-- 圣洁惩戒
                {312, 1},-- 征伐
                {312, 2},-- 征伐
                {312, 3},-- 征伐
                {313, 1},-- 双手武器专精
                {313, 2},-- 双手武器专精
                {313, 3},-- 双手武器专精
                {315, 1},-- 复仇
                {315, 2},-- 复仇
                {315, 3},-- 复仇
                {319, 1},-- 智者审判
                {319, 2},-- 智者审判
                {319, 3},-- 智者审判
                {311, 1},-- 战斗的圣洁
                {311, 2},-- 战斗的圣洁
                {317, 1},-- 战争艺术
                {317, 2},-- 战争艺术
                {311, 3},-- 战斗的圣洁
                {321, 1},-- 圣洁怒火
                {321, 2},-- 圣洁怒火
                {323, 1},-- 十字军打击
                {324, 1},-- 圣光出鞘
                {324, 2},-- 圣光出鞘
                {324, 3},-- 圣光出鞘
                {322, 1},-- 迅捷惩戒
                {325, 1},-- 正义复仇
                {325, 2},-- 正义复仇
                {325, 3},-- 正义复仇
                {322, 2},-- 迅捷惩戒
                {322, 3},-- 迅捷惩戒
                {326, 1},-- 神圣风暴
                {101, 1},-- 精神集中
                {101, 2},-- 精神集中
                {101, 3},-- 精神集中
                {101, 4},-- 精神集中
                {101, 5},-- 精神集中
                {201, 1},-- 神圣之力
                {201, 2},-- 神圣之力
                {201, 3},-- 神圣之力
                {201, 4},-- 神圣之力
                {201, 5},-- 神圣之力
            }
      end
      if CCTV:GetPlayer().Class=='WARRIOR' then
            LearnThisTalentList = {
            }
      end
      if CCTV:GetPlayer().Class=='DRUID' then
            LearnThisTalentList = {
            }
      end
      if CCTV:GetPlayer().Class=='SHAMAN' then
            LearnThisTalentList = {
            }
      end
      if CCTV:GetPlayer().Class=='DEATHKNIGHT' then
            --鲜血天赋
        LearnThisTalentList = {
            {103, 1},   -- 利刃屏障
            {103, 2},   -- 利刃屏障
            {103, 3},   -- 利刃屏障
            {103, 4},   -- 利刃屏障
            {103, 5},   -- 利刃屏障
            {104, 1},   --刀锋护甲
            {104, 2},   --刀锋护甲
            {104, 3},   --刀锋护甲
            {104, 4},   --刀锋护甲
            {104, 5},   --刀锋护甲
            {105, 1},   --血之气息
            {105, 2},   --血之气息
            {105, 3},   --血之气息
            {106, 1},   --双武器专精
            {106, 2},   --双武器专精
            {107, 1},   --符文分流
            {108, 1},   --黑暗定罪
            {108, 2},   --黑暗定罪
            {108, 3},   --黑暗定罪
            {108, 4},   --黑暗定罪
            {108, 5},   --黑暗定罪
            {109, 1},   --死亡符文掌握
            {109, 2},   --死亡符文掌握
            {109, 3},   --死亡符文掌握
            {110, 1},   --强化符文分流
            {110, 2},   --强化符文分流
            {110, 3},   --强化符文分流
            {113, 1},   --血腥打击
            {113, 2},   --血腥打击
            {113, 3},   --血腥打击
            {114, 1},   --战争精英
            {114, 2},   --战争精英
            {114, 3},   --战争精英
            {115, 1},   --鲜血印记
            {116, 1},   --鲜血复仇
            {116, 2},   --鲜血复仇
            {116, 3},   --鲜血复仇
            {117, 1},   --憎恶之力
            {117, 2},   --憎恶之力
            {120, 1},   --强化鲜血灵气
            {120, 2},   --强化鲜血灵气
            {121, 1},   --强化灵界打击
            {121, 2},   --强化灵界打击
            {123, 1},   --吸血鬼之血
            {125, 1},   --心脏打击
            {126, 1},   --莫格莱尼之力
            {126, 2},   --莫格莱尼之力
            {126, 3},   --莫格莱尼之力
            {301, 1},   --险恶攻击
            {302, 1},   --险恶攻击
            {303, 1},   -- 预知
            {303, 2},   -- 预知
            {303, 3},   -- 预知
            {303, 4},   -- 预知
            {303, 5},   -- 预知
            {304, 1},   --蔓延
            {304, 2},   --蔓延
            {305, 1},   --病变
            {305, 2},   --病变
            {305, 3},   --病变
            {310, 1},   --邪爆
        }
      end

      --最先加载的线程初始化
      SetSettings({
            VehicleMountReachDistance = 7,
            --飞行坐骑提高Z高度,开关
            AutoRaiseMoveZ = true,
            --飞行坐骑提高Z高度,默认1
            RaisemovetoZ = 1,
            --飞行骑马抵达距离开关,没有不适用
            AutoLoginfly = true,
            --长时间不动炉石
            LongTimePause = false,
            --自动剥皮
            -- Autoskin = true,
            -- 自动采集草药
            AutoGatherHerb = false,
            -- 不采集灰色物品
            NotGatherGray = true,
            --现在任务ID
            nowTaskIDDoing = nowTaskID,
            --自动加天赋
            LearnThisTalent = LearnThisTalentList,
            --不输出
		    NoPrint = {'Delay','A_AMT:Select Monster','相同目标不选择'},
            --任务超时
            TimeOutEvent = true,
            --卡住事件
		    StuckEvent = true,
            --自动学天赋
            LearnTalent = true,
            --寻路导航间隔
            ReachDistance = 1.7,
            --售卖完了回到原位
            GotoOriginalAddress = false,
            --自动拒绝组公会邀请
            AutoDeclineGuild = true,
            --自动拒绝组组队邀请
            -- AutoDeclineGroup = true,
            --自动拒绝决斗邀请
            AutoDeclineDuel = true,
            --设定距离障碍物范围1～5
            agentRadius = 1.5,
            --使用食物
            UseFood = true,
            --使用饮料
            UseDrink = true,
            --開啟自動休息，不吃藥
            AutoRest = false,
            --开启使用坐骑
            UseMount=true,
            --自动拾取
            AutoLoot = true,
            --勾选后，所有食物都吃,把包内食物/饮料吃完才会触发回城，不用设定FoodName与DrinkName
            EatAll = true,
            --是否判断回城事件
            GoHomeEvent = true,
            --使用炉石
            UseHearthStone = false,
            --当背包空格小于等于多少时触发回城
            MinFreeBagSlotsToGoToTown = 2,
            --当装备耐久度小于等于%多少时触发回城
            MinDurabilityPercent = 20,
            --是否反击
            Counterattack = true,
            --输出信息写入Log
            WriteLog = false,
            -- 安全复活
            SafeRetrieve = true,
            --复活距离
            RetrieveDis = 35,
            --购买最好
            Buybest = true,
            -- --食物数量
            -- FoodAmount = 0,
            -- --饮料数量
            -- DrinkAmount = 0,
            --恢复生命值范围
            FoodPercent = {65 ,95 ,},
            -- 战斗循环自动buff
            CombatLoopAutoBuff = true,
            -- 自动战斗，追击，检取开关
            CombatIngSwitch = true,
            -- 自动吃喝
            AutoDrinkFood = true,
            --使用坐骑不攻击与反击
            -- UseMountWhenNotattack = true,
            --回家时不反击
            GoHomeNotattack = true,
            --下马距离
            DismountDistance = 20,
            --自动复活
            AutoRetrieve = true,
            --自动换装
            -- AutoEquip = true,
            --设定等待超时60秒
            TimeOut = 90,
            --报警储存
            BeepSound = {
                  --GM密语
                  GMMES = GetBeepPath('GM私密警报.wav'),
                  --GM TP
                  GMTP = GetBeepPath('GM传送警报.wav'),
                  --GM短距离TP
                  GMShortTP = GetBeepPath('GM短距离传送警报.wav'),
                  --其他密语
                  MES = GetBeepPath('玩家私密警报.wav'),
                  --玩家攻击
                  PlayerAttack = GetBeepPath('被玩家攻击警报.wav'),
                  --交易
                  Trade = GetBeepPath('交易警报.wav'),
               },

            --副本出入口不传送
            TPExceptPath = {
                --莎拉苟萨的末日
                {4034.2500, 7349.3799, 635.9700},
                --嚎风峡湾
                {1975.7000, -6097.2002, 67.1584},
                {2062.5000, 354.5000, 82.4405},
                --北风苔原
                {2831.0000, 6180.0000, 121.9826},
                {3646.7400, 5893.2002, 174.4830},
                --杜隆塔尔
                {1172.0000, -4153.0000, 51.6460},
                --黑锋要塞
                {2419.9099, -5620.4800, 420.6440},
                {2402.6201, -5633.2798, 377.0210},
                {2359.6399, -5662.4102, 382.2615},
                --出村传送
                {1333.4301, -4375.6001, 26.2046},
                {1326.5027, -4379.0586, 26.2186},
                {1318.4987, -4381.0986, 26.2269},
                {1308.9285, -4384.4937, 26.2445},
                {1300.0652, -4390.1597, 26.2679},
                {1291.8405, -4393.3931, 26.2834},
                {1285.3669, -4396.2354, 26.2989},
                {1279.4382, -4398.8384, 26.3084},
                {1273.6891, -4401.3633, 26.3173},
                {1268.6279, -4400.9150, 26.2911},
                {1263.9688, -4403.9365, 25.9929},
                {1258.5977, -4407.1182, 25.4847},
                {1254.0315, -4411.1201, 24.8955},
                --任务
                {-9143.5801, 375.1030, 90.6907},
                {2323.4768, -5730.5288, 153.9212},
                {2393.6270, -5639.6353, 420.8621},
                {2278.5601, 5983.7100, 142.5684},
                {-2307.4199, 3123.6799, 13.7278},
                {-2260.2600, 3114.4800, 136.3500},
                  --黑暗之门
                  {-11708.4004, -3168.0000, -5.0700},
                  { -11907.7051, -3209.1658, -14.5401},
                  {-248.1130, 922.9000, 84.3497},
                  {9334.5000, -7880.7598, 74.9094},
                  {9330.6602, -7810.8599, 136.5690},
                  --银月城传送到幽暗城
                  {1805.0000, 327.0000, 70.3979},

                  {3641.0000, -4702.0000, 120.7898},
                  {3778.0000, -4612.0000, 227.2542},
                -- 猎鹰岗哨传送宝珠
                {-594.0000, 4079.0000, 93.8246},
                {-589.0000, 4079.0000, 143.2581},
                --地狱火半岛空投任务
                {-25.0458, 2133.9832, 112.7099},
                --千针石林信仰的试炼
                {-5191.2720, -2802.5872, -8.2651},
                --乌鸦
                {-145.2300, 5533.0298, 30.9453},
                --幽暗城传送点
                {1773.4200, 61.7391, -46.3215},
            },
            --不上坐骑
            NotUseMountPath = {
                --赞加沼泽
                {-191.5522, 7315.4224, distance = 30,mapID = 1946},
                {-254.4633, 5504.9941, distance = 20,mapID = 1946},
                    --藏宝海湾
                    {-14315.6377, 493.5990, distance = 80,mapID = 1434},
                    {-14411.0674, 427.5273, distance = 170,mapID = 1434},
                   --杜隆塔尔
                  {1341.9160, -4647.4360,  distance = 15 , mapID = 1411},
                  --幽暗
                  {2062.3582, 263.3801,  distance = 20 , mapID = 1420},
                  {2064.0281, 270.0956,  distance = 20 , mapID = 1420},
                  --格罗姆高
                  {-12431.8154, 210.0732,  distance = 15 , mapID = 1434},
                  --奥格瑞玛
                  {1673.8619, -4338.1714,  distance = 15 , mapID = 1454},
                  --希利苏斯
                  {-6859.3345, 733.9985,  distance = 20 , mapID = 1451},
                  --诅咒之地苦痛堡垒
                  {-10944.0547, -3369.8418,  distance = 40 , mapID = 1419},
                  {-10953.0410, -3454.4758,  distance = 15 , mapID = 1419},
                  --幽暗城电梯
                  {1596.1678, 291.5745,  distance = 20 , mapID = 1458},
                  --加基森海盗洞
                  {-7805.9253, -4998.9248,  distance = 50 , mapID = 1446},
                  --加基森热砂港弹药
                  {-6902.6113, -4831.8154,  distance = 20 , mapID = 1446},
                  --地狱火半岛
                  {139.6259, 2668.5496,  distance = 70 , mapID = 1944},
                  {-164.1416, 2516.4055,  distance = 50 , mapID = 1944},
                  {-146.8090, 2619.0403,  distance = 50 , mapID = 1944},
                  {-155.9017, 2662.7883,  distance = 50 , mapID = 1944},
                  {-36.0416, 2673.1123,  distance = 100 , mapID = 1944},
                  --湿地采集
                  {-3102.5791, -3259.7576,  distance = 30 , mapID = 1437},
                  --荒芜之地采集
                  {-6478.4336, -2454.8972,  distance = 8 , mapID = 1418},
                  --冬泉谷旅店
                  {6717.5620, -4682.05717,  distance = 25 , mapID = 1452},
                  --月光林地不上坐骑
                  {7981.9111, -2576.7666,  distance = 500 , mapID = 1450},
            },
            --设置间距
            agentRadiusPath  = {
                --藏宝海湾
                {-14315.6377, 493.5990, distance = 240, agentRadius = 1 , mapID = 1434},
                  {1341.9160, -4647.4360,  distance = 40, agentRadius = 2 , mapID = 1411},
                  --幽暗
                  {2064.0281, 270.0956, distance = 100, agentRadius = 1 , mapID = 1420},
                  {1604.4379, 238.8718, -52.1473, distance = 2000, agentRadius = 1 , mapID = 1458},
                  {1604.4379, 238.8718, -52.1473, distance = 2000, agentRadius = 1 , mapID = 1420},
                  --格罗姆高
                  {-12431.8154, 210.0732,  distance = 100, agentRadius = 1 , mapID = 1434},
                  --奥格瑞玛
                  {1673.8619, -4338.1714,  distance = 2000, agentRadius = 1 , mapID = 1454},
                  {1971.7612, -4659.5713,  distance = 2000, agentRadius = 1 , mapID = 1454},
                  --暴风
                  {-8791.8115, 652.1405,  distance = 3000, agentRadius = 1 , mapID = 1453},
                  --铁炉堡
                  {-4800.1255, -1106.3363,  distance = 3000, agentRadius = 1 , mapID = 1455},
                  --乱风岗
                  {-5442.4072, -2429.4580,  distance = 100, agentRadius = 0.7 , mapID = 1441},
                  --血精灵8级旅店
                  {9477.5049, -6858.8687,   distance = 40, agentRadius = 1 , mapID = 1941},
                  --暴风
                  {-8984.1797, 1031.3445,   distance = 3000, agentRadius = 1 , mapID = 1453},
                  --夜色镇
                  {-10564.1055, -1163.6105,   distance = 200, agentRadius = 1 , mapID = 1431},
                  --沙塔斯
                  {-1863.2314, 5429.2129,   distance = 1000, agentRadius = 2 , mapID = 1955},
                  --塞尔萨马
                  {-5354.0601, -2952.9070,   distance = 500, agentRadius = 1 , mapID = 1432},
                  --荣耀堡
			      {-679.5225, 2668.0742,   distance = 500, agentRadius = 1 , mapID = 1944},
                  --冬泉谷
                  {6715.5552, -4676.4077,  distance = 40, agentRadius = 0.5 , mapID = 1452},
                },
          })
          if GetScriptUISetting('使用脚本默认售卖设置') then
              SetSettings({
                --贩卖颜色等级0~8
                SellLevel = {[0] = true,[1] = true,[2] = true,[3] = false,},
                --不贩卖列表 {id,id,id
                DoNotSellList = {33612,34597,'Rune of','传送','Hearthstone','炉石','Primal','源生','Mote of','微粒',"Thieves'Tools",'潜行者工具','Flash Powder','闪光粉','矿工锄','Mining Pick',7005,
                    6657,27854,29451,27503,3820,3355,3369,3356,3357,3818,3821,3358,4625,8831,8836,8838,8839,8845,8846,13464,13463,13465,13467,1645,1205,3770,11018,
                    22785,22786,22789,22787,22788,22790,22794,22791,22792,22793,22797,18401,22777,22775,22776,22644,22642,22641,8483,8529,929,1710,3928,13446,858,24401,
                    10620,3858,3860,12359,6037,7911,12365,7912,2772,3575,2776,3577,2838,23424,23445,23425,23446,23449,23426,23427,23447,2771,2841,3576,2775,2842,2770,2840,
                    27498,27499,27500,27501,27502,24449,27676,28102,28103,24291,24245,25719,21881,22829,25978,25433,25416,31670,31671,25977,37201,
                },
                --强制贩卖列表 {id,id,id
                ForceSellList = {},
                --强制销毁
                ForceDeleteList = {'OOX',3745,3711,24475,39355},
                AutoEquip = true,
              })
          end
          if CCTV:GetPlayer().Class == 'DEATHKNIGHT' or CCTV:GetPlayer().Class=='WARRIOR' or CCTV:GetPlayer().Class == 'ROGUE' then
            --最先加载的线程初始化
            SetSettings({
            LearnThisTalent = LearnThisTalentList,
            --使用饮料
            UseDrink = false,
            --恢复法力值范围
            DrinkPercent = {0 ,0 },
            })
          end
end)

Bot:SetStop(function()
      Log:System('=======================')
      Log:System("任务模板")
      Log:System('=======================')
end)

return Bot