forceinsecure()
local TTOC = ...
JBMB = TTOC
local player = JBMB:GetPlayer()

local Bot = TTOCInitScript("盗贼-地狱火城墙")
if GetLocale() == "zhCN" then
else
	Bot = TTOCInitScript("Rogue - Hellfire Ramparts")
end
-- config为'设定'的窗口，建议show用config:Show(), 可以避免多开窗口
local Config = Bot.Config

local Log = Bot.Log
local Config = Bot.Config

-- 这个bag是一次性的，不会更新，可能要手动get，或者是我日后加入自动跟新的功能
local bag = GetBag()
local Spell = GetSpells()
local UI = Bot.UI
local frame = nil
local IsLooting = false
local NeedEnterDungeon = false
local NeedOutDungeon = false
local PlayerLeavedDungeon = false
local PlayerInDungeon = false
local WaitInDungeon = false 
local Wait = function(time)
    return TTOCDelay(time / 1000)
end

--UI
if not UI:GetWidget('爆本限制Header') then
    UI:AddHeader('爆本限制')
    UI:AddRange('爆本限制(单位:分钟)', '限制多少分钟刷一次,默认14.9分钟', 0, 60, 0.1,14.9, true)
    UI:AddRange('爆本后等待(单位:分钟)', '爆本后等待多少分钟再尝试进本,默认3分钟', 0, 60, 1, 1, true)

    UI:AddHeader('杂项')
	UI:AddToggle("只报警GM警报", "勾选后语音警报只报警GM语音,不勾选默认全部,更改后请重载", false)
	UI:AddToggle("副本内等待重置时间", "勾选后会在副本内等待一定时间再小退5分钟出本", false)
	--UI:AddToggle('死亡重置副本', '死亡后重置副本', false)
	--UI:AddToggle('包满售卖', '包满出本售卖', true)
	--UI:AddToggle('包满拍卖物品', '会在背包剩余数量达到一定剩余触发拍卖物品\n|cffff0000使用邮箱的寄件数据\n|cffff0000必须安装AuctionMaster拍卖插件', true)
    --UI:AddToggle("拍卖完去工会存钱", "拍卖完去工会存钱，[留(x)铜不存工会]必须填", false)
	--UI:AddRange('拍卖无价格时原价倍数', '无价格时物品按照原价多少倍数售卖', 1, 100, 1, 10, true)
	--UI:AddRange('拍卖使用第几低价格', '使用第几低价格拍卖的价格售卖', 1, 25, 1,5, true)
    --UI:AddInput("留(x)铜不存工会", "不想存钱请填0", "0", 'full')
	UI:AddHeader('|cFF00FF00 1.0版本说明')
	UI:AddLabel('|cffFF6EB4 此路径无违规操作,69级盗贼即可，最好70级。每日收益稳定1500+G,每小时60G左右.优势:要求低，收益稳定!')
	UI:AddLabel('|cffFF6EB4 There is no illegal operation in this path, level 69 thieves can be, preferably level 70. The daily earnings are stable at 1500+G, around 60G per hour. Advantages: low requirements, stable returns!')
	UI:AddHeader('|c0000FFFF 盗贼要求：')
	UI:AddLabel('|cffFF6EB4 天赋：必须点出【伺机待发】和【暗影步】！！！【欺诈高手】【伪装】【邪恶计谋】点满，其它随意。')
	UI:AddLabel('|cffFF6EB4 Talents: Must point out the [Waiting for Opportunity] and [Shadow Step] !!! [Fraud Master] [Disguise] [Evil Scheme] full of points, other random.')
	UI:AddLabel('|cffFF6EB4 开锁等级要达到300+。')
	UI:AddLabel('|cffFF6EB4 Unlock level to reach 300+.')
	UI:AddLabel('|cffFF6EB4 装备：主手武器必备，其它尽量高耐装。')
	UI:AddLabel('|cffFF6EB4 Equipment: The main weapon is necessary, and the others are as high as possible.')
	UI:AddLabel('|cffFF6EB4 炉石绑定部落：萨尔玛,联盟：荣耀堡')
	UI:AddLabel('|cffFF6EB4 Hearthstone Bound Tribes: Salma, Alliance: Fort Glory')
	UI:AddLabel('|cffFF6EB4----有问题及时反馈代理或DIS频道----')
	-- 建议show用config:Show(), 可以避免多开窗口
    Config:Show()
else
    	-- 建议show用config:Show(), 可以避免多开窗口
    Config:Show()
end

--定义
local GetSetting = function(name)
	--UI:Setting(name) 可以获得值
    return UI:Setting(name)
end

GetScriptUISetting = GetSetting

--进出副本触发
local frameOnEvent = function(self, event, ...)
    local message, sender, language, arg4, arg5, arg6 = ...

    -- 队长在队伍频道消息
    if event == 'CHAT_MSG_PARTY_LEADER' then
        -- 队员在队伍频道消息
        if not UnitIsGroupLeader('player') and message == 'ENTER_DUNGEON' then
            -- 如果我不是队长并且接收到队长消息 ENTER_DUNGEON
            NeedEnterDungeon = true
            print('收到命令进入副本...')
        end
        if not UnitIsGroupLeader('player') and message == 'OUT_DUNGEON' then
            -- 如果我不是队长并且接收到队长消息 OUT_DUNGEON
            NeedOutDungeon = true
            print('收到命令退出副本...')
        end
    elseif event == 'CHAT_MSG_PARTY' then
        if UnitIsGroupLeader('player') and message == 'PLAYER_LEAVED_DUNGEON' then
            -- 如果我是队长并且接收到队员消息 PLAYER_LEAVED_DUNGEON
            PlayerLeavedDungeon = true
            print('队员已经离开副本')
        end
        if UnitIsGroupLeader('player') and message == 'PLAYER_IN_DUNGEON' then
            -- 如果我是队长并且接收到队员消息 PLAYER_LEAVED_DUNGEON
            PlayerInDungeon = true
            print('队员已经进入副本')
        end
    elseif event == 'CHAT_MSG_SYSTEM' then
        -- if  message:find('你在短时间内进入副本的次数过多') then
         if message == '你在短时间内进入副本的次数过多。' then
            -- 系统消息
            WaitInDungeon = true

        end
    elseif event == 'LOOT_OPENED' then
        IsLooting = true
    elseif event == 'LOOT_CLOSED' then
        IsLooting = false
    end
end

--buff
local function buffs()
    local player = JBMB:GetPlayer()
    local bag = GetBag()
    TTOCDelay(2)
	Log:Write('休息吃喝Buff')
    if GetItemCount(27502,false,false) >= 1 and not player:HasAura(8101) then
        bag:UseItemID(27502)
        TTOCDelay(1)
        print('耐力卷轴 V')
    end		
    
    if GetItemCount(27501,false,false) >= 1 and not player:HasAura(8114) then
        bag:UseItemID(27501)
        TTOCDelay(1)
        print('精神卷轴 V')
    end	
    
    if GetItemCount(27500,false,false) >= 1 then
        bag:UseItemID(27500)
        TTOCDelay(1)
        print('保护卷轴 V')
    end			
    
    if GetItemCount(27498,false,false) >= 1 then
        bag:UseItemID(27498)
        TTOCDelay(1)
        print('敏捷卷轴 V')
    end			
    
    if GetItemCount(27503,false,false) >= 1 then
        bag:UseItemID(27503)
        TTOCDelay(1)
        print('力量卷轴 V')
    end		
    
    if GetItemCount(22018,false,false) < 10 and GetItemCount(30703,false,false) < 10 and GetItemCount(8079,false,false) < 10 and GetItemCount(8078,false,false) < 10 and player.FreeBagSlots >= 1   then
        print('制造魔法水')
        if IsSpellKnown(27090) then
            CastSpellByID(27090)
        elseif IsSpellKnown(37420) then
            CastSpellByID(37420)
		elseif IsSpellKnown(10140) then
            CastSpellByID(10140)
		elseif IsSpellKnown(10139) then
            CastSpellByID(10139)
        end	
        TTOCDelay(3.5)
    end	
    
    if GetItemCount(22019,false,false) < 10 and GetItemCount(22895,false,false) < 10 and GetItemCount(8076,false,false) and player.FreeBagSlots >= 1   then
        print('制造魔法面包')
        if IsSpellKnown(33717) then
            CastSpellByID(33717)
        elseif IsSpellKnown(28612) then
            CastSpellByID(28612)
		elseif IsSpellKnown(10145) then
            CastSpellByID(10145)
        end	
        TTOCDelay(3.5)
    end		  
	
	while ((UnitPower('player', 0) / UnitPowerMax('player', 0) * 100) < 80 or
	player.PowerPct < 80
	)and 
	not IsDead()  do
		player:Update()
		print('坐下回蓝') 
		if not HasDrinkBuff() then
			UseDrink()
		end

		if not HasFoodBuff() and player.PowerPct < 80 then
			UseFood()
		end
		
		DoEmote('SIT') 
		TTOCDelay(2)
	end		
	player:Jump()  
	
    if KeepBuff(10157, 900) then
        CastSpellByID(10157)
        TTOCDelay(2)
        print('奥术智慧')
    end
    if KeepBuff(22783, 900) then
        CastSpellByID(22783)
        TTOCDelay(2)
        print('魔甲术')
    end
    if KeepBuff(33944, 600) and KeepBuff(10174, 600) then
		if IsSpellKnown(33944) then
            CastSpellByID(33944)
        elseif IsSpellKnown(10174) then
            CastSpellByID(10174)
        end	
        TTOCDelay(2)
        print('魔法抑制')
    end
    while ((UnitPower('player', 0) / UnitPowerMax('player', 0) * 100) < 80 or
	player.PowerPct < 80
	)and 
	not IsDead()  do
		player:Update()
		print('坐下回蓝') 
		if not HasDrinkBuff() then
			UseDrink()
		end

		if not HasFoodBuff() and player.PowerPct < 80 then
			UseFood()
		end
		
		DoEmote('SIT') 
		TTOCDelay(2)
	end	
    			
    if GetItemCount(22044,false,false) < 1 and GetItemCount(8008,false,false) < 1 and player.FreeBagSlots >= 1  then
		if IsSpellKnown(27101) then
            CastSpellByID(27101)
			print('制造魔法玉石')
        elseif IsSpellKnown(10054) then
            CastSpellByID(10054)
			print('制造魔法红宝石')
        end	
        TTOCDelay(4.6)
    end		
    
    
    if GetItemCount(8008,false,false) < 1 and GetItemCount(8007,false,false) < 1 and player.FreeBagSlots >= 1  then
		if IsSpellKnown(10054) then
            CastSpellByID(10054)
			print('制造魔法红宝石')
        elseif IsSpellKnown(10053) then
            CastSpellByID(10053)
			print('制造魔法黄水晶')
        end	
        TTOCDelay(4.5)
    end	

	if not IsSpellKnown(27101) and GetItemCount(8007,false,false) < 1 and player.FreeBagSlots >= 1  then
		if IsSpellKnown(10053) then
            CastSpellByID(10053)
			print('制造魔法黄水晶')
        end	
        TTOCDelay(4.5)
    end	
	
	if (UnitPower('player', 0) / UnitPowerMax('player', 0) * 100) < 90 then
		print('坐下回蓝') 
		DoEmote('SIT') 
		TTOCDelay(2)
	end	
end
-- DungeonTimerTime = 15.5
--副本计时器
DungeonTimer = {
    -- 计时器设定时间 单位秒
    MaxTime = GetSetting('爆本限制(单位:分钟)') * 60,
    StartTime = nil,
    -- 开始计时
    Start = function()
        if not DungeonTimer.StartTime then
            DungeonTimer.StartTime = GetTime()
            -- print('副本计时器启动')
			if GetLocale() == "zhCN" then
				Log:Debug("副本计时器启动")
			else
				Log:Debug("DungeonTimer has started")
			end
        end
    end,
    -- 等待计时器结束
    Wait = function()
		if DungeonTimer.StartTime ~= nil then
			-- print('等待计时器结束')
			if GetLocale() == "zhCN" then
				Log:Debug("等待计时器结束")
			else
				Log:Debug("Waiting for Dungeontimer stop")
			end
			DungeonTimer.MaxTime = GetSetting('爆本限制(单位:分钟)') * 60
			while GetTime() - DungeonTimer.StartTime < DungeonTimer.MaxTime do
	   
				if GetLocale() == "zhCN" then
				   Log:Debug('防爆本倒计时:%s秒', math.floor(DungeonTimer.MaxTime - 
				   (GetTime() - DungeonTimer.StartTime)))
				else
					Log:Debug('Dungeontimer left:%s秒', math.floor(DungeonTimer.MaxTime - 
					   (GetTime() - DungeonTimer.StartTime)))
				end
				TTOCDelay(1)
			end
		end
        DungeonTimer.StartTime = nil
    end
}

--背包收益
local function CurrentTotalMoney()
    local profitInCopper = 0
    local itemsSold = 0
    JBMB:GetBagItems(
        function(itemInfo, bag, slot)
            -- print(itemInfo.Link, '价格=',GetCoinTextureString(itemInfo.SellPrice * itemInfo.Count))
            itemsSold = itemsSold + 1
            profitInCopper = profitInCopper + (itemInfo.SellPrice * itemInfo.Count)
            return true
        end
    )

    if (profitInCopper > 0 and itemsSold > 0) then
        print('当前背包总收益=', GetCoinTextureString(profitInCopper))
        print('当前角色金币=', GetCoinTextureString(GetMoney()))
        local totalMoney = profitInCopper + GetMoney()
        -- print(totalMoney)
        print('当前总资产=', GetCoinTextureString(totalMoney))
        return totalMoney
    end

    return 0
end
 --闪现
local function FaceBlink(x, y, z)
    print('闪现')
    if x and y then
        JBMB.FaceDirection(x, y, z, true)
    -- Wait(1000)
    end
    MoveForwardStart()
    Wait(100)
    Spell.Blink:Cast()
    MoveForwardStop()
end




--吹风
local function FaceConeOfCold(x, y, z)
    print('吹风')
    if x and y then
        JBMB.FaceDirection(x, y, z, true)
    -- Wait(1000)
    end
    MoveForwardStart()
    Wait(100)
    Spell.ConeOfCold:Cast()
    MoveForwardStop()
end
--暴风雪
local function BlizzardCastTime()
    local name, _, _, startTime, endTime, _, _, spellID = ChannelInfo()
    if not spellID or (spellID ~= 10 and spellID ~= 10185 and spellID ~= 10186 and spellID ~= 10187) then
        return 0
    end

    return GetTime() - startTime / 1000
    -- /run local name, _, _, startTime, endTime, _, _, spellID = ChannelInfo();print(endTime/1000-GetTime())print(spellID)
end
--暴风雪
local function BlizzardLeftTime()
    local name, _, _, startTime, endTime, _, _, spellID = ChannelInfo()
    if not spellID or (spellID ~= 10 and spellID ~= 10185 and spellID ~= 10186 and spellID ~= 10187) then
        return 0
    end

    return endTime / 1000 - GetTime()
 
end
--暴风雪1
local function Blizzard1To(x, y, z)
    CastSpellByID(10)
    Wait(50)
    JBMB.ClickPosition(x, y, z)
    if BlizzardCastTime() == 0 then
        JBMB.ClickPosition(x, y, z)
    end
end
--暴风雪6
local function Blizzard6To(x, y, z)
    CastSpellByID(10187)
    Wait(50)
    JBMB.ClickPosition(x, y, z)
    if BlizzardCastTime() == 0 then
        JBMB.ClickPosition(x, y, z)
    end
end 
--暴风雪7
local function Blizzard7To(x, y, z)
    CastSpellByID(27085)
    Wait(50)
    JBMB.ClickPosition(x, y, z)
    if BlizzardCastTime() == 0 then
        JBMB.ClickPosition(x, y, z)
    end
end 

function GetItemsCount(ItemId)
	local itemTotalCount = 0
    for bag = 0, 4 do
        for slot = 1, 20 do
            local itemCount = select(2, GetContainerItemInfo(bag, slot))
            local id = GetContainerItemID(bag, slot)
			if id == ItemId then
				itemTotalCount = itemTotalCount + itemCount
			end
        end
    end
	return itemTotalCount
end

function BuyFlashPowder(buyNum)
	local itemCount = GetItemsCount(5140)
	local needBuyNum = (buyNum - itemCount)
	local surBuyNum = math.fmod(needBuyNum, 20)
	local needBuyGroup = math.modf(needBuyNum / 20)
	local nmap = GetSubZoneText()
	if needBuyGroup > 0 then
		if nmap == "泰雷多尔" or nmap == "Telredor" then
			for	i = 1, needBuyGroup do
				BuyMerchantItem(24, 20)
			end
		else
			for	i = 1, needBuyGroup do
				BuyMerchantItem(19, 20)
			end
		end
	end
	if nmap == "泰雷多尔" or nmap == "Telredor" then
		if surBuyNum > 0 then
			BuyMerchantItem(24, surBuyNum)
		end
	else
		if surBuyNum > 0 then
			BuyMerchantItem(19, surBuyNum)
		end
	end
end
--潜行
function Stealth()
	while not JBMB:GetPlayer():HasAura(1787) and UnitHealth('player') > 1 and not JBMB:GetPlayer().Combating do
		if GetLocale() == "zhCN" then
			RunMacroText("/cast 潜行")
		else
			RunMacroText("/cast Stealth")
		end
		TTOCDelay(1)				
	end
end


function fengshe()
	local i,n,t,id
	for i=1,10 do
		n,_,_,_,_,t,_,_,_,id = UnitAura('player',i)
		if n then
			if id >= 8219 and id <= 8222 then
				if t - GetTime() > 300 then
					return true
				end
			end
		end
    end
	return false
end
function fengshe1()
	local i,n,t,id
	for i=1,10 do
		n,_,_,_,_,t,_,_,_,id = UnitAura('player',i)
		if n then
			if id >= 8219 and id <= 8222 then
				return true
			end
		end
    end
	return false
end
--定义打开物品
function Openobject() 
    local Opentreasure = TTOC:FindGameObject(function(obj)
        if obj.ObjectID == 184933 or obj.ObjectID == 184932 or obj.ObjectID == 184931 or obj.ObjectID == 184930 then
              obj:Update() 
              --print('obj.Distance',obj.Distance,obj.Distance <= 15)
              if obj.Distance and obj.Distance <= 8 then
                    return true
              else
                    return false
              end
        end
    end)
    if Opentreasure ~= nil then
        TTOC.StopMoving()
        Wait(500)
		if GetLocale() == "zhCN" then
			RunMacroText("/cast 消失")
		else
			RunMacroText("/cast Vanish")
		end
        TTOC.ObjectInteract(Opentreasure.Pointer)
        print('Open Chest...')
        Wait(7000)
		return true
    end
	return false
end


--找箱子1
function Findbox1()
    local Objectore = JBMB:FindGameObject(
        function(obj)
        if (obj.ObjectID == 184933 or obj.ObjectID == 184932 or obj.ObjectID == 184931 or obj.ObjectID == 184930) and obj.Position:DistanceTo(-1203.09, 1430.39, 68.5473) <= 10 then
            obj:Update() 
			print("找到箱子")
            return true
        end
    end)
    return Objectore ~= nil
end
function Openbox1()
    if Openobject() then
		return true
	end
	return false
end

--找箱子2
function Findbox2()
        local Objectore2 = JBMB:FindGameObject(
        function(obj)
        if (obj.ObjectID == 184933 or obj.ObjectID == 184932 or obj.ObjectID == 184931 or obj.ObjectID == 184930) and obj.Position:DistanceTo(-1298.64,1584.77,91.7841) <= 10 then
            obj:Update() 
            return true
        end
    end)
    return Objectore2 ~= nil
end

function JumpForward(x, y, z)
	-- print('往前跳')
	if x and y then
		JBMB.FaceDirection(x, y, z, true)
	-- Wait(1000)
	end
	MoveForwardStart()
	player:Jump()
	Wait(500)
	MoveForwardStop()
end
function MoveForward(x, y, z, t)
	if t == nil then
		t=70
	end
	if x and y then
		JBMB.FaceDirection(x, y, z, true)
	-- Wait(1000)
	end
	MoveForwardStart()
	Wait(t)
	MoveForwardStop()
end
function ForwardAutoRun(x, y, z)
	if x and y then
		JBMB.FaceDirection(x, y, z, true)
		ToggleAutoRun()
	end
end
--寻怪1
local FindMob1Target = {}
local FindMob1UnitID = {
    [17264] = true,
}
local function FindMob1()
    -- 第一次搜索
	FindMob1Target = JBMB:FindUnits(function(unit)
		if not unit.Dead and unit.ObjectID == 17264 and unit.Position:DistanceTo(JBMB:GetPlayer().Position:GetXYZ()) < 11 then
			return true
		end
	end)
	-- 开始监视
	if #FindMob1Target > 0 then
		for i,unit in ipairs(FindMob1Target) do
			unit:Update()
			local Dis = unit.Position:DistanceTo(JBMB:GetPlayer().Position:GetXYZ())
			--print(i,'怪物距离座标 = ',Dis)
			if Dis <= 11 then
				--print('吃闷棍的到达')
				if GetLocale() == "zhCN" then
					RunMacroText("/tar 噬骨掠夺者")
				else
					RunMacroText("/tar Bonechewer Ravener")
				end
				CastSpellByID(11297)
				Wait(200)
				CastSpellByID(11297)
				Wait(200)
				CastSpellByID(11297)
				Wait(200)
				CastSpellByID(11297)
				return false
			end
		end
	end
	if JBMB:GetPlayer():DistanceTo(X,Y,Z) > 70 or JBMB.GetPlayer():DistanceTo(X,Y,Z) < 1.5 then
		return false
	end
    return true
end

--寻怪2
local FindMob2Target = {}
local FindMob2UnitID = {
    [17280] = true,
}
local function FindMob2()
    -- 第一次搜索
	FindMob2Target = JBMB:FindUnits(function(unit)
		if not unit.Dead and FindMob2UnitID[unit.ObjectID] and
		unit.Position:DistanceTo(-1265.14, 1660.42, 68.5927) <= 15 then
			return true
		end
	end)
	if #FindMob2Target == 0 then
		return false
	end
	-- 开始监视
	for i,unit in ipairs(FindMob2Target) do
		unit:Update()
		local Dis = unit.Position:DistanceTo(-1265.14, 1660.42, 68.5927)
		if Dis <= 15 then
			return true
		end
	end
	return false
 
end

--寻怪3
local FindMob3Target = {}
local FindMob3UnitID = {
    [17280] = true,
}
local function FindMob3()
	FindMob3Target = JBMB:FindUnits(function(unit)
		if not unit.Dead and FindMob3UnitID[unit.ObjectID] and
			unit.Position:DistanceTo(-1253.19, 1471.48, 68.5762) < 19 then
			return true
		end
	end)
	if #FindMob3Target == 0 then
		return false
	end
	-- 开始监视
	for i,unit in ipairs(FindMob3Target) do
		unit:Update()
		local Dis = unit.Position:DistanceTo(-1253.19, 1471.48, 68.5762)
		if Dis < 19 then
			return true
		end
	end
	return false
end

--寻怪4
local FindMob4Target = {}
local FindMob4UnitID = {
    [17280] = true,
}
local function FindMob4()
    -- 第一次搜索
	FindMob4Target = JBMB:FindUnits(function(unit)
		if not unit.Dead and FindMob4UnitID[unit.ObjectID] and
		unit.Position:DistanceTo(X,Y,Z) <= 25 then
			return true
		end
	end)
	if #FindMob4Target == 2 then
		return false
	end
	-- 开始监视
	local num = 0
	for i,unit in ipairs(FindMob4Target) do
		unit:Update()
		local Dis = unit.Position:DistanceTo(-1277.76, 1614.29, 91.7613)
		if Dis <= 8 then
			return false
		end
		Dis = unit.Position:DistanceTo(X,Y,Z)
		if Dis <= 25 then
			num = num + 1
		end
	end
	if num < 3 then
		return false
	end
	return true
end

--寻怪5
local FindMob5Target = {}
local FindMob5UnitID = {
    [17280] = true,
}
local function FindMob5()
    -- 第一次搜索
	FindMob5Target = JBMB:FindUnits(function(unit)
		if not unit.Dead and FindMob5UnitID[unit.ObjectID] and
		unit.Position:DistanceTo(-1298.64,1584.77,91.7841) <= 25 then
			return true
		end
	end)
	local num = 0
	-- 开始监视
	for i,unit in ipairs(FindMob5Target) do
		unit:Update()
		local Dis = unit.Position:DistanceTo(-1298.64,1584.77,91.7841)
		--print(i,'怪物距离座标 = ',Dis)
		if Dis <= 20 then
			num = num + 1
		end
	end
	if num > 2 then
		return true
	end
	return false
end


local function dakaibaoxiang()
    local player = JBMB:GetPlayer()
    local Bag = GetBag()
  if GetItemCount(29569,false,false) > 0 and player.FreeBagSlots >= 1 then
      return true
    end
  return false
end

local function DeleteFlash()

local flash = GetItemCount(5140,false,false)
local lattice = flash/20
for i, item in ipairs(GetBag().ItemType[15]) do
    if item.itemID == 5140 and lattice > 2 then
        item:Delete()
        lattice = lattice-1
    end
end
end

--靠近怪2码 
function MoveToUnitByLocationAndId(x, y, z, range, unitId, faceNow)
    if type(unitId) == 'number' then
        unitId = {unitId}
    end
    local UnitId = {}
    for i,v in ipairs(unitId) do
        UnitId[v] = true
    end
    if not tempTarget then
        tempTarget = JBMB:FindUnit(
            function(unit)
                -- print(unit:DistanceTo(x,y,z), UnitCanAttack("player", unit.Pointer))
                return not unit.Dead and 
                UnitId[unit.ObjectID] and 
                UnitCanAttack('player', unit.Pointer) and
                unit:DistanceTo(x, y, z) <= range and             
                unit.GUID ~=player.GUID
            end
        )
    else
        local target = tempTarget
        --print('Select target')
        target:Update()    
        target:TargetUnit()
        local p = JBMB:GetPlayer()
        target.Distance = p:DistanceTo(target)

        if faceNow then
            --print('Face target')
            target:Face()
        end
    
        --print('target Distance is ', target.Distance)
        if target.Distance > 4.5 then
            -- 移动
            target:Face()
            --print('move target')
            MoveForwardStart()
            --Delay(0.2)
            return
        elseif target.Distance <= 4.5 then
            --print('player stop')
            JBMB:GetPlayer():Stop()
            MoveForwardStop()
            tempTarget = nil
            return true
        end
    return false
    end
end

function SelectUnitByLocationAndId(x, y, z, range, unitId, faceNow)
    local target =
      JBMB:FindUnits(
        function(unit)
            --print(unit:DistanceTo(x,y,z), UnitCanAttack("player", unit.Pointer),unit.ObjectID)
            return unit.ObjectID == unitId and unit:DistanceTo(x, y, z) <= range and not unit.Dead and UnitCanAttack('player', unit.Pointer) and unit.GUID ~=player.GUID
        end
    )

    if target and #target > 0 then
        target = target[1]  
		print("选中怪1:"..tostring(unitId))
        target:TargetUnit()
		print("选中怪2:"..tostring(unitId))
        if faceNow then
			--print('面向怪')
            target:Face()
        end
        return target
    end

    return false
end

--遍历拾取
local function LootBodys()
	if  GetBagFreeSlots() < 1 then
	   return
	end
	
	-- 遍历3遍尸体
	local lootCounts = 0
	for i = 1, 3 do
	   local bodys =
	   JBMB:FindUnits(
		  function(unit)
			 if unit.Dead and unit.Distance <= 5 and JBMB.UnitIsLootable(unit.Pointer) then
				--print('Loot ' .. unit.Pointer)
				JBMB.ObjectInteract(unit.Pointer)
				-- Wait(0)
				TTOCDelay(2)
				lootCounts = lootCounts + 1
				return true
			 end
		  end
	   )
	   --TestCore.Log:Info('5码内尸体数量 > ', #bodys, ' 总拾取次数 > ', lootCounts)
	end
end

--定义残本判断
local function IfBadDungeon()
	local mobs = JBMB:FindUnits(
    	function(unit)
    		if
    			not unit.Dead and (unit.ObjectID == 17724) and unit.Position:DistanceTo(60.2029, -52.9288, -2.7494) <= 50
    		 then
    			return true
    		end
    		return false
    	end
    )		
    return  #mobs == 0
end
--定义门口怪的判断是否在坐标内
local function waitTargetToThis()
	local mob77 =JBMB:FindUnits(
		function(unit)
			if not unit.Dead and (unit.ObjectID == 17724) and
					unit.Position:DistanceTo(51.4424, -44.7409, -2.7507) <= 2   
			 then
				return true
			end
			return false
		end
	)

	return #mob77 == 0
end

local function combat()
        if JBMB:GetPlayer().Combating and GetSpellCooldown(26889) == 0     
        then
		Wait(1500)
        CastSpellByID(26889)
        Wait(500)    
        end
        if   GetSpellCooldown(26889) ~= 0 and GetSpellCooldown(14185) == 0
        then
		Wait(500) 
        CastSpellByID(14185)
        Wait(1500)    
        end      
        end


--飞向地牢的路径模板
DungeonPathFly = {
	-- -- -----------------------------------幽暗沼泽飞进本流程
	-- --关闭水路
	-- --部落跑过去路径
	-- --联盟跑过去路径
    --  --准备下地坐标
    --  {768.4631, 6702.4570, 20.3187,true},
    -- -- -------------遍历40码内没有玩家,自己身上没有技能id,spell=2096 or spell=10909执行下一个动作
    --  {Run = "JBMB:SetNoClip(15)"},
    -- -- --进建筑坐标--平行过去
    --  {Run = 'JBMB:SetFloating(true, 2)'},
    --  {MoveTo = {772.4426, 6696.0391, 20.3187}},
    -- -- --下到中转坐标--下降
    --  {Run = 'JBMB:SetFloating(true, 3)'},
    --  {Run = "JBMB:MoveToZ(-9.2950)"},
    -- -- --平行过去
    -- -- -------------------------------------------中转到下到地面坐标X,Y轴,蒸汽和奴隶可以用
    --  {Run = 'JBMB:SetFloating(true, 2)'},
    --  {820.6580, 6735.4399, -9.2950},
    -- -- --下到地面坐标下降--
    --  --{Run = 'print("JBMB:MoveToZ(-71)")'},
    --  {Run = 'JBMB:SetFloating(true, 3)'},
    --  {Run = "JBMB:MoveToZ(-71)"},
    --  --JBMB:MoveToZ(-71) 
    -- -- --关闭飞天,出去
    --  {Run = "JBMB:SetNoClip(0)"},
    -- -- --到达坐标地面坐标
    --  {820.6580, 6735.4399, -72.5466},
    
    -- --------------------------------------蒸汽地窟准备到达坐标,
    -- --{MoveTo = {838.5764, 6957.4390, -81.4573},},
    -- --蒸汽地窟到达坐标
    -- --{MoveTo = {837.8406, 6957.5811, -81.4573},},
    -- --蒸汽地窟关闭飞天
    
    -- --------------------------------------奴隶围栏准备到达坐标
    -- --{MoveTo = {821.1389, 7050.8218, -72.5},},
    -- --奴隶围栏到达坐标
    -- --{MoveTo = {819.7551, 7051.8936, -72.4065},},
    -- --奴隶围栏关闭飞天
	-- --开启水路
}

--跑路前往地牢的路径模版
DungeonPath = {



}
--计算后的捷径路径
DungeonShortcut = {}
--计算捷径路径
function takeShortcut()
	local p = JBMB:GetPlayer()
	p:Update()
	local x, y, z = p.PosX, p.PosY, p.PosZ
	local Dis = {}
	local DisSort = {}
	local StartIndex = 1;
	--取最近路径
	if z then
		for i,path in ipairs(DungeonPath) do
			local dx, dy, dz = unpack(path)
			table.insert(Dis,JBMB.GetDistanceBetweenPositions(x, y, z, dx, dy, dz) )
		end

		local min = 99999
		for i,v in ipairs(Dis) do 
			if v < min then 
				min = v
				StartIndex = i
			end
		end
	end

	--路径拷贝
	local index = 1
	local endInex = 1
	if #DungeonPath- StartIndex > #DungeonShortcut then
		endInex = #DungeonPath
	else
		endInex = #DungeonShortcut + StartIndex
	end
	for i = StartIndex, endInex do
		DungeonShortcut[index] = DungeonPath[i]
		if DungeonShortcut[index] then DungeonShortcut[index][4] = nil end
		index = index+1
	end

	--第一段用导航
	DungeonShortcut[1][4] = true
end
local Monst1=0
-- 去外域
local text = {
	--设置与障碍物宽度间距
	{Run = function() --关闭所有战斗循环
			SetDMWHUD('Rotation',false) 
		end},
	--野外设定档开 吃喝反击
		{Settings = 'EatAll = false' , value = false},
		{Settings = 'CombatLoopAutoBuff' , value = false},
		{Settings = 'CombatIngSwitch' , value = false},
		{Settings = 'AutoDrinkFood' , value = false},
		{Settings = 'UseFood' , value = false},
		{Settings = 'AutoRetrieve' , value = false},
		{Settings = 'AutoEquip' , value = false},
		{Settings = 'agentRadius' , value = 2},
		{Settings='UseMount',value=true,},
	{Run = function() InterfaceOptionsMousePanelClickMoveStyleDropDown:SetValue('2') end},
	
	
	--如果我是盗贼的初始化
	{Run = 'print("Check if you are a Rogue.")'},
	{Run = 'print("检查职业是否是盗贼。")'},
	--{If = "JBMB:GetPlayer().Class == 'ROGUE'",End = 0.1},
	{If = " JBMB:GetPlayer().Class == 'ROGUE' ",End = 0.1},
	{Log='Info',Text="我是盗贼可以开始"},
	{End = 0.1},
--[[	{If = "JBMB:GetPlayer().Class ~= 'ROGUE'",End = 0.2},---------------------------------------------------------------------------------------
	{Log='Info',Text="I am not a Rogue. Please change to a Rogue"},
	{Run = 'StopScriptBot()'},
	{End = 0.2},--]]

	{Run = 'print("Check where you are.")'},
	{Run = 'print("检查当前地图")'},

	--我不在副本
	{If = "JBMB:GetPlayer().mapID ~= 543",End = 0.3},
		{Run = 'print(JBMB:GetPlayer().mapID)'},
		{Run = 'print("You are not in the Hellfire Ramparts pot right now.")'},
		{Run = 'print("现在不在地狱火城墙。 去地牢  ")'},
	{End = 0.3},
		
		
		
    
	--部落
	    {If = " (JBMB:GetPlayer().mapID == 1454 or JBMB:GetPlayer().mapID == 1411)",End = 801},--杜隆塔尔、奥格瑞玛坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 801},

		{If = " (JBMB:GetPlayer().mapID == 1450) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 802},--月光林地去奥格坐飞艇飞去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{7467.8618, -2120.8735, 492.3428,true},},},
		    {UnitInteract = 12740},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044},
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 802},

		{If = " (JBMB:GetPlayer().mapID == 1452) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 803},--冬泉谷去奥格坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{6814.2651, -4608.3730, 710.6697,true},},},
		    {UnitInteract = 11139},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044}, 
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 803},

		{If = " (JBMB:GetPlayer().mapID == 1447) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 804},--艾萨拉去奥格坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{3662.1682, -4389.8037, 113.0556,true},},},
		    {UnitInteract = 8610},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044}, 
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 804},

		{If = " (JBMB:GetPlayer().mapID == 1448) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 805},--费伍德去奥格坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{3662.1682, -4389.8037, 113.0556,true},},},
		    {UnitInteract = 11900},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044}, 
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 805},

		{If = " (JBMB:GetPlayer().mapID == 1439) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 806},--黑海岸去奥格坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {
		    	{4962.6807, 212.2710, 40.7657,true},
		    	{4852.3174, 218.3125, 50.4000,true},	
		    	{4852.3174, 218.3125, 50.4000,true},
		    	{4570.1299, 286.6467, 57.6168,true},
		    	{4398.3271, 212.0867, 52.5208,true},
		    	{4294.6772, 152.7960, 46.0416,true},
		    	{4159.4111, 54.2504, 26.2614,true},
		    	{4073.8813, 6.5671, 15.7115,true},
		    	{3920.5359, 27.4551, 15.4675,true},
		    	{3862.2388, 54.2881, 15.2460,true},
		    	{2308.2051, -2523.0540, 103.3029,true},
		              },
		    },
		    {UnitInteract = 12616},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044}, 
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 806},

		{If = " (JBMB:GetPlayer().mapID == 1440) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 807},--灰谷去奥格坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{2308.2051, -2523.0540, 103.3029,true},},},
		    {UnitInteract = 12616},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044}, 
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 807},

		{If = " (JBMB:GetPlayer().mapID == 1442) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 808},--石爪山去奥格坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{966.6833, 1040.3712, 104.2813,true},},},
		    {UnitInteract = 4312},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044}, 
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 808},
		
		{If = " (JBMB:GetPlayer().mapID == 1443) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 809},--凄凉之地去奥格坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{-1768.9594, 3261.6790, 5.2021,true},},},
		    {UnitInteract = 6726},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044}, 
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 809},

		{If = " (JBMB:GetPlayer().mapID == 1412) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 810},--莫高雷坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{1329.9248, -4651.2988, 54.0065,true},},},
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 810},

		{If = " (JBMB:GetPlayer().mapID == 1456) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 811},--雷霆崖坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{-1198.7920, 26.0679, 176.9492,true},},},
		    {UnitInteract = 2995},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044}, 
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 811},

		{If = " (JBMB:GetPlayer().mapID == 1413) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 812},--贫瘠之地坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{-438.9249, -2596.9033, 95.8097,true},},},
		    {UnitInteract = 3615},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044},
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 812},

		{If = " (JBMB:GetPlayer().mapID == 1445) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 813},--尘泥沼泽坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{-3148.2634, -2842.2581, 34.5915,true},},},
		    {UnitInteract = 11899},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044},
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 813},

		{If = " (JBMB:GetPlayer().mapID == 1444) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 814},--菲拉斯坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{-4420.8027, 198.9360, 25.0624,true},},},
		    {UnitInteract = 8020},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044}, 
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 814},

		{If = " (JBMB:GetPlayer().mapID == 1451) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 815},--希利苏斯坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{-6809.8384, 839.9401, 49.7013,true},},},
		    {UnitInteract = 15178},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044}, 
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 815},

		{If = " (JBMB:GetPlayer().mapID == 1449) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 816},--环形山坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{-6112.0850, -1141.0996, -187.2837,true},},},
		    {UnitInteract = 10583},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044}, 
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 816},

		{If = " (JBMB:GetPlayer().mapID == 1446) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 817},--塔纳利斯坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{-7046.8643, -3779.2107, 10.1961,true},},},
		    {UnitInteract = 7824},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044}, 
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 817},

		{If = " (JBMB:GetPlayer().mapID == 1441) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 818},--千针石林坐飞船去格罗姆高
		    {Run = 'print("You are in Kalimdor.Now go to the Eastern Kingdoms")'},
		    {MoveTo = {{-438.9249, -2596.9033, 95.8097,true},},},
		    {UnitInteract = 3615},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 62044}, 
		    --坐飞艇门口关闭坐骑
		    {MoveTo = {1336.9308, -4631.6035, 23.9545,true},},
		    {Settings='UseMount',value=false,},
		    -------------就位等飞船去格罗姆高,在杜隆塔尔不在格罗姆高
		    {MoveTo = {1360.5188, -4637.8931, 53.8521,true},},
		    -------------下飞船坐标
		    {TakeSpaceship = 6666 , DownPath = {-12450.8760, 218.3462, 31.6212}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    {Delay = 1},
		    --选择要空运的选项
		    {Gossip = "taxi"},
		{End = 818},

		--东部王国去往各地的飞机飞向格罗姆高

		{If = " (JBMB:GetPlayer().mapID == 1420 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 901},--提瑞斯法林地去格罗姆高
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
            --到飞艇门口不使用坐骑
            {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
            --不使用坐骑
            {Settings='UseMount',value=false,},
            --等待飞艇 
            {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
            --飞格罗姆高
            {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
            --去门口然后开启上坐骑
            {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
            --开启使用
            {Settings='UseMount',value=true,},
            --对话飞行点管理员开飞行点
            {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
            --交互NPCid
            {UnitInteract = 1387},
            --等待3秒
            {Delay = 3},
		{End = 901},

		{If = " (JBMB:GetPlayer().mapID == 1458 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 902},--幽暗城去格罗姆高
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
            --到飞艇门口不使用坐骑
            {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
            --不使用坐骑
            {Settings='UseMount',value=false,},
            --等待飞艇 
            {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
            --飞格罗姆高
            {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
            --去门口然后开启上坐骑
            {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
            --开启使用
            {Settings='UseMount',value=true,},
            --对话飞行点管理员开飞行点
            {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
            --交互NPCid
            {UnitInteract = 1387},
            --等待3秒
            {Delay = 3},
		{End = 902},

		{If = " (JBMB:GetPlayer().mapID == 1421 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 903},--银松森林去瑟伯切尔坐飞机
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
            --到飞艇门口不使用坐骑
            {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
            --不使用坐骑
            {Settings='UseMount',value=false,},
            --等待飞艇 
            {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
            --飞格罗姆高
            {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
            --去门口然后开启上坐骑
            {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
            --开启使用
            {Settings='UseMount',value=true,},
            --对话飞行点管理员开飞行点
            {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
            --交互NPCid
            {UnitInteract = 1387},
            --等待3秒
            {Delay = 3},
		{End = 903},

		{If = " (JBMB:GetPlayer().mapID == 1416 ) or (JBMB:GetPlayer().mapID == 1424 ) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 904},--奥山和希尔斯布莱德去塔伦米尔坐飞机
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {0.6738, -859.7436, 58.7783,true},},
		    {UnitInteract = 2389},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 904},

		{If = " (JBMB:GetPlayer().mapID == 1417 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 905},--阿拉希高地去落锤镇坐飞机
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {-919.0114, -3497.4626, 70.4500,true},},
		    {UnitInteract = 2851 },
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 905},

		{If = " (JBMB:GetPlayer().mapID == 1425 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 906},--辛特兰去恶齿村坐飞机
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {-635.2600, -4720.5000, 5.3800,true},},
		    {UnitInteract = 4314 },
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 906},

		{If = " (JBMB:GetPlayer().mapID == 1423 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 907},--东瘟疫之地去圣光之愿坐飞机
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {2329.8982, -5289.4126, 81.7763,true},},
		    {UnitInteract = 12636},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 907},

		{If = " (JBMB:GetPlayer().mapID == 1422 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 908},--西瘟疫之地去幽暗城坐飞机
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {1587.5754, 248.4125, -52.1512,true},},
		    {UnitInteract = 4551},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 908},

	  	{If = " (JBMB:GetPlayer().mapID == 1437 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 909},--湿地去落锤镇坐飞机
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {-919.0114, -3497.4626, 70.4500,true},},
		    {UnitInteract = 2851 },
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 909},

		{If = " (JBMB:GetPlayer().mapID == 1418 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 910},--荒芜之地去卡加斯坐飞机
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {-6632.4985, -2179.9534, 244.1400,true},},
		    {UnitInteract = 2861 },
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 910},

		{If = " (JBMB:GetPlayer().mapID == 1432 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 911},--洛克莫丹去卡加斯坐飞机
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {-6632.4985, -2179.9534, 244.1400,true},},
		    {UnitInteract = 2861 },
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 911},

		{If = " (JBMB:GetPlayer().mapID == 1427 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 912},--灼热峡谷去瑟银哨塔坐飞机
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {-6557.4717, -1100.2766, 309.9315,true},},
		    {UnitInteract = 3305 },
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 912},

		{If = " (JBMB:GetPlayer().mapID == 1428 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 913},--燃烧平原去烈焰峰坐飞机
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {-7502.6494, -2188.7424, 165.6134,true},},
		    {UnitInteract = 13177 },
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 913},
		
		{If = " (JBMB:GetPlayer().mapID == 1426 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 914},--丹莫罗去落锤镇坐飞机
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {-919.0114, -3497.4626, 70.4500,true},},
		    {UnitInteract = 2851 },
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 914},

		{If = " (JBMB:GetPlayer().mapID == 1429 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 915},--艾尔文森林直接跑去黑暗之门
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {-9894.1680, -1041.9669, 29.7325,true},
		              {-9946.6543, -1106.1857, 20.8255,true},
		              {-10460.5156, -1630.8428, 74.4214,true},
		    		  {-10388.0918, -2697.3401, 21.6803,true},
		    		  {-11909.8584, -3209.2463, -14.8526,true},},
		{End = 915},
		
		{If = " (JBMB:GetPlayer().mapID == 1433 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 916},--赤脊山直接跑去黑暗之门
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {-9497.8818, -2252.6736, 76.1332,true},
		              {-9946.6543, -1106.1857, 20.8255,true},
		              {-10460.5156, -1630.8428, 74.4214,true},
		    		  {-10388.0918, -2697.3401, 21.6803,true},
		    		  {-11909.8584, -3209.2463, -14.8526,true},},
		{End = 916},

		{If = " (JBMB:GetPlayer().mapID == 1433 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 917},--暮色森林直接跑去黑暗之门
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {-9946.6543, -1106.1857, 20.8255,true},
		              {-10460.5156, -1630.8428, 74.4214,true},
		    		  {-10388.0918, -2697.3401, 21.6803,true},
		    		  {-11909.8584, -3209.2463, -14.8526,true},},
		{End = 917},

		{If = " (JBMB:GetPlayer().mapID == 1436 )  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 918},--西部荒野飞去黑暗之门
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {-11098.2676, 476.5627, 22.3865,true},},
		    {MoveTo = {-11080.9053, 451.3322, 19.2021,false},},
		    {MoveTo = {-11120.5918, 408.1519, 19.7492,false},},
		    {MoveTo = {-11151.8584, 374.2730, 19.8346,false},},
		    {MoveTo = {-11186.2619, 343.4361, 19.8346,false},},
		    {MoveTo = {-11235.1699, 315.2827, 19.1622,false},},
		    {MoveTo = {-11339.7432, 297.8274, 11.2143,false},},
		    {MoveTo = {-11467.3330, 249.4213, 11.6311,false},},
		    {MoveTo = {-12416.1641, 145.7162, 3.2596,true},},
		    {UnitInteract = 1387 },
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 918},

		{If = " (JBMB:GetPlayer().mapID == 1942)  and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 921},--幽魂之地飞去黑暗之门
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {6116.0430, -6999.6445, 137.5124,true},},
		    {MoveTo = {6100.0430, -6999.6445, 137.5124,false},},
		    {Delay = 5},
		    {MoveTo = {3233.1980, -4472.4438, 110.2752,true},},
		    {MoveTo = {2329.8982, -5289.4126, 81.7763,true},},
		    {UnitInteract = 12636},
		    {Delay = 1},
		    {Gossip = "taxi"},
			{Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 921},

		{If = " (JBMB:GetPlayer().mapID == 1941 ) or (JBMB:GetPlayer().mapID == 1954 ) and JBMB:GetPlayer().FactionGroup == 'Horde'",End = 922},--银月城和永歌森林坐飞机去黑暗之门
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    {MoveTo = {6116.0430, -6999.6445, 137.5124,true},},
		    {MoveTo = {6100.0430, -6999.6445, 137.5124,false},},
		    {Delay = 5},
		    {MoveTo = {3233.1980, -4472.4438, 110.2752,true},},
		    {MoveTo = {2329.8982, -5289.4126, 81.7763,true},},
		    {UnitInteract = 12636},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    {Taxi = 41037},
		    {Run = 'print("You are in Eastern Kingdoms.Now go to the The Dark Portal")'},
		    --去格罗姆高
		    --到飞艇门口不使用坐骑
		    {MoveTo = {2049.3557, 284.4896, 56.8506,true},},
		    --不使用坐骑
		    {Settings='UseMount',value=false,},
		    --等待飞艇 
		    {MoveTo = {2058.4863, 238.1419, 99.7663,true},},
		    --飞格罗姆高
		    {TakeSpaceship = 6663 , DownPath = {-12409.2910, 206.6652, 31.6421}},
		    --去门口然后开启上坐骑
		    {MoveTo = {-12426.5146, 225.3430, 1.2272,true},},
		    --开启使用
		    {Settings='UseMount',value=true,},
		    --对话飞行点管理员开飞行点
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --交互NPCid
		    {UnitInteract = 1387},
		    --等待3秒
		    {Delay = 3},
		{End = 922},

		--在格罗姆高不在悲伤沼泽
		{ If =  "JBMB:GetPlayer().mapID == 1434 and JBMB:GetPlayer().mapID ~=1435 and JBMB:GetPlayer().FactionGroup == 'Horde'",End = '在格罗姆高不在悲伤沼泽'},
		    {Log='Debug',Text="去悲伤沼泽"},
            {Log='Debug',Text="go to the sadness swamp"},
		    --对话飞行点管理员
		    {MoveTo = {-12396.6934, 159.3965, 2.7677,true},},
		    --飞去悲伤沼泽
		    {Log='Debug',Text="搭计程车拉！"},
		    --与计程车NPC对话
		    {UnitInteract = 1387},
		    {Delay = 1},
		    {Gossip = "taxi"},
		    --选择要空运的选项
		    {Taxi = 53078},
		    --等待2秒
		    {Delay = 2},
		{End = '在格罗姆高不在悲伤沼泽'},

		{ If =  " (JBMB:GetPlayer().mapID == 1434 or JBMB:GetPlayer().mapID == 1431) and JBMB:GetPlayer().mapID ~= 1435 and JBMB:GetPlayer().FactionGroup == 'Horde'",End = '没有开悲伤沼泽飞行点'},--没有开悲伤沼泽飞行点去开飞行点
	        {Log='Debug',Text="悲伤沼泽飞行点没开,去开飞行点"},
	        {Log='Debug',Text="Sad Swamp is not open. Get to the point"},
	        {MoveTo = {
                  {-12402.8760, 150.6582, 2.9500,true},
                  {-12338.4033, 173.9039, 2.9468,true},
                  {-12295.1055, 178.0452, 8.0324,true},
                  {-12215.2822, 146.5054, 16.3130,true},
                  {-12171.2471, 115.9793, 12.3032,true},
                  {-12143.0449, 93.1879, -0.5851,true},
                  {-12080.8203, 72.6275, -6.1264,true},
                  {-11902.2598, 36.2855, 19.0714,true},
                  {-11879.0352, -1.2373, 30.0462,true},
                  {-11850.2305, -34.7799, 39.8054,true},
                  {-11792.7227, -72.4531, 39.7268,true},
                  {-11776.7090, -100.9448, 42.2009,true},
                  {-11729.9648, -184.9736, 39.5550,true},
                  {-11696.0947, -221.8694, 39.5557,true},
                  {-11602.9570, -280.8261, 37.0537,true},
                  {-11542.4385, -321.9379, 35.7677,true},
                  {-11511.6084, -313.7547, 36.1819,true},
                  {-11457.7207, -288.3326, 40.9200,true},
                  {-11396.5195, -286.7752, 58.5520,true},
                  {-11384.5410, -315.7233, 64.7370,true},
                  {-11367.4277, -363.1586, 65.9893,true},
                  {-11346.9404, -380.9394, 65.4450,true},
                  {-11298.4287, -369.5118, 65.4721,true},
                  {-11211.0889, -384.0286, 50.1498,true},
                  {-11100.0869, -373.9390, 44.6429,true},
                  {-11038.0508, -367.4806, 45.3181,true},
                  {-10996.2539, -360.9784, 42.4498,true},
                  {-10927.1738, -362.7667, 39.6752,true},
                  {-10909.2637, -378.3951, 40.1659,true},
                  {-10908.8301, -488.5533, 49.8604,true},
                  {-10922.0107, -550.4426, 53.9369,true},
                  {-10940.6416, -585.7981, 54.0331,true},
                  {-10957.5244, -626.5322, 55.1059,true},
                  {-10954.7588, -649.2392, 55.3533,true},
                  {-10923.3916, -693.0667, 55.6963,true},
                  {-10903.1475, -730.4190, 54.9706,true},
                  {-10850.3261, -792.2638, 56.1722,true},
                  {-10833.5928, -816.0204, 56.3419,true},
                  {-10819.8359, -843.9113, 55.8899,true},
                  {-10797.4424, -922.3871, 55.7986,true},
                  {-10806.5195, -979.6606, 55.4773,true},
                  {-10804.5420, -1030.0162, 47.1507,true},
                  {-10775.1738, -1120.9873, 29.3087,true},
                  {-10754.0020, -1191.9497, 27.2529,true},
                  {-10746.3174, -1231.2227, 30.0039,true},
                  {-10747.4287, -1266.1578, 31.6899,true},
                  {-10737.8633, -1289.3019, 37.7828,true},
                  {-10685.3203, -1320.5244, 43.3744,true},
                  {-10679.3818, -1336.1040, 47.4127,true},
                  {-10625.7832, -1319.8915, 54.1036,true},
                  {-10587.7568, -1334.8008, 49.3562,true},
                  {-10570.5322, -1327.7054, 49.3132,true},
                  {-10553.3672, -1324.1174, 45.2774,true},
                  {-10547.0156, -1329.9469, 46.7214,true},
                  {-10533.8047, -1381.4424, 57.2325,true},
                  {-10512.6348, -1401.0605, 62.9568,true},
                  {-10475.0449, -1430.8182, 66.3415,true},
                  {-10455.4912, -1460.7280, 70.5550,true},
                  {-10449.3799, -1508.3889, 74.6405,true},
                  {-10462.3125, -1620.8298, 73.6529,true},
                  {-10462.1680, -1681.5762, 80.1806,true},
                  {-10455.7773, -1738.9825, 87.6216,true},
                  {-10432.4482, -1794.0442, 97.2948,true},
                  {-10436.9648, -1846.8203, 102.7603,true},
                  {-10444.9199, -1876.3074, 104.5771,true},
                  {-10436.4023, -1935.5646, 104.4089,true},
                  {-10437.7051, -1974.0143, 102.0743,true},
                  {-10431.0723, -2011.3945, 97.6967,true},
                  {-10442.2197, -2032.9246, 94.9386,true},
                  {-10502.4912, -2048.6335, 92.8925,true},
                  {-10550.4268, -2099.2241, 91.8988,true},
                  {-10590.0615, -2130.1316, 91.4341,true},
                  {-10585.5322, -2182.5671, 89.8790,true},
                  {-10556.5488, -2297.2930, 91.6194,true},
                  {-10546.4053, -2357.6941, 85.0532,true},
                  {-10479.6426, -2386.8772, 74.5066,true},
                  {-10406.3213, -2415.0557, 59.2491,true},
                  {-10386.4453, -2442.9688, 47.5039,true},
                  {-10420.6650, -2534.9246, 25.0289,true},
                  {-10446.8506, -2618.1628, 23.5269,true},
                  {-10455.7627, -2701.8145, 23.7010,true},
                  {-10469.6084, -2768.2158, 22.7357,true},
                  {-10509.5605, -2907.7339, 21.6999,true},
                  {-10513.8730, -2997.3630, 21.7299,true},
                  {-10498.0967, -3056.9780, 21.7135,true},
                  {-10463.4463, -3141.9172, 20.3723,true},
                  {-10459.7861, -3189.7507, 20.1786,true},
                  {-10462.0850, -3220.5259, 20.1792,true},
                  {-10449.7207, -3261.6655, 20.1795,true},
            }},	
            --对话飞行点npc
            {UnitInteract = 6026},
			{Delay = 3},
        {End = '没有开悲伤沼泽飞行点'},

		 --去黑暗之门
		{ If =  "JBMB:GetPlayer().mapID == 1435 and JBMB:GetPlayer().mapID ~=1419 and JBMB:GetPlayer().FactionGroup == 'Horde'",End = '部落去黑暗之门'},
		    {MoveTo = {-10454.1621, -3250.9370, 20.3947,true},},
		    {MoveTo = {-10461.1963, -3224.2612, 20.1780,true},},
		    {MoveTo = {-10459.6973, -3169.8167, 20.1788,true},},
		    {MoveTo = {-10465.7539, -3127.5664, 20.1789,true},},
		    {MoveTo = {-10500.7637, -3057.5649, 22.1155,true},},
		    {MoveTo = {-10555.1504, -3042.0723, 24.8515,true},},
		    {MoveTo = {-10600.6387, -3019.1638, 28.5583,true},},
		    {MoveTo = {-10647.7910, -2986.9250, 30.0925,true},},
		    {MoveTo = {-10729.5244, -2984.2065, 45.3436,true},},
		    {MoveTo = {-10770.2930, -2992.2939, 48.4412,true},},
		    {MoveTo = {-11523.7510, -3132.9558, 4.5318,true},},
		    {MoveTo = {-11799.0898, -3204.0710, -28.6924,true},},
		    {MoveTo = {-11817.3691, -3182.7058, -30.0096,true},},
		{End = '部落去黑暗之门'},

		--部落进黑暗之门
		{ If =  "JBMB:GetPlayer().mapID == 1419 and JBMB:GetPlayer().mapID ~=1944 and JBMB:GetPlayer().FactionGroup == 'Horde'",End = '部落进黑暗之门'},
            --传送检测
            {Settings = 'ManualJump' , value = false},
            {MoveTo = {-11822.8545, -3189.9780, -30.7212,true},},
            {MoveTo = {-11830.4229, -3193.8445, -30.3324,true},},
            {MoveTo = {-11906.8906, -3208.9094, -14.8609,true},},
            {Delay = 20},
            --传送检测
            {Settings = 'ManualJump' , value = true},
        {End = '部落进黑暗之门'},
        --不走水路,假是不走水路,真是走水路
        {Settings = 'WalkWater', value =true},

      --部落黑暗之门飞裂石堡
		{If = "JBMB:GetPlayer().FactionGroup == 'Horde' and JBMB:GetPlayer():DistanceTo(-248.1130, 922.9000, 84.3497) < 500",End = '部落黑暗之门飞裂石堡' },
		{Log='Debug',Text="飞裂石堡"},
		{Log='Debug',Text="Flying Sabulakin "},
		{MoveTo = {-236.4947, 1018.6127, 54.3273,true},},
		{Log='Debug',Text="搭计程车拉！"},
		{Delay = 1},
		--关闭自动坐骑
		{Settings='UseMount',value=false,},
		--与计程车NPC对话
		{UnitInteract = 18930},
		{Delay = 1},
		--与计程车NPC对话
		{UnitInteract = 18930},
		{Delay = 1},
		{Gossip = "taxi"},
		--选择要空运的选项
		{Taxi = 65050},
		--等待2秒
		{Delay = 5},
		--开启自动坐骑
		{Settings='UseMount',value=true,},
		 --没有飞成功,部落飞去萨尔玛
		 {If = " (JBMB:GetPlayer().FactionGroup == 'Horde' and JBMB:GetPlayer():DistanceTo(-180.1238, 1025.6989, 54.2027) < 500)",End = '部落去萨尔玛' },
			  {Log='Debug',Text="没有开启裂石堡飞行点,去开飞行点"},
			 {Log='Debug',Text="The Teredor flight point is not turned on, go to the flight point "},
			 {MoveTo = {-236.4947, 1018.6127, 54.3273,true},},
			 {Log='Debug',Text="搭计程车拉！"},
			 {Delay = 1},
			 --关闭自动坐骑
			 {Settings='UseMount',value=false,},
			 --与计程车NPC对话
			 {UnitInteract = 18930},
			 {Delay = 1},
			 --与计程车NPC对话
			 {UnitInteract = 18930},
			 {Delay = 1},
			 {Gossip = "taxi"},
			 --选择要空运的选项
			 {Taxi = 65050},
			 --等待2秒
			 {Delay = 5},
			 --开启自动坐骑
			 {Settings='UseMount',value=true,},
		 {End = '部落去萨尔玛'},
 
		 --去猎鹰岗哨开飞行点,在萨尔玛,不在猎鹰岗哨
		--[[ { If =  "JBMB:GetPlayer().areaID == 3536 and JBMB:GetPlayer().areaID ~= 3554 and JBMB:GetPlayer().FactionGroup == 'Horde'",End = '去猎鹰岗哨开飞行点'},
			   {Log='Debug',Text="去猎鹰岗哨开飞行点"},
			   {Log='Debug',Text="Go to Falcon Point to open the flight point "},
			   {MoveTo = {
			   {-35.5224, 2906.3110, 31.4904,true},
			   {-73.8867, 3029.7556, 5.5111,true},
			   {-54.6314, 3077.6697, -0.9118,true},
			   {-47.1847, 3179.1550, -0.5982,true},
			   {-65.9448, 3468.3840, 73.0656,true},
			   {-50.4831, 3600.7603, 73.4494,true},
			   {-75.7375, 3658.5120, 65.9887,true},
			   {-102.7536, 3744.5879, 69.4843,true},
			   {-121.4091, 3778.8787, 71.9397,true},
			   {-217.3750, 3843.1960, 84.0292,true},
			   {-348.0565, 3896.7612, 68.0967,true},
			   {-435.3221, 3949.5376, 73.3204,true},
			   {-490.7410, 4056.5662, 53.4419,true},
			   {-547.6294, 4170.8989, 47.4171,true},
			   {-588.4676, 4211.5005, 49.8205,true},
			   {-627.8893, 4207.0176, 52.9670,true},
			   {-631.8958, 4197.0703, 56.3939,true},
			   {-628.5366, 4172.3989, 62.5491,true},
			   {-638.9700, 4154.3442, 64.1736,true},
			   {-669.9065, 4134.1372, 66.5398,true},
			   {-662.8769, 4112.5488, 74.3476,true},
			   {-644.6748, 4104.1167, 80.1518,true},
			   {-621.4053, 4117.7568, 86.9505,true},
			   {-593.9669, 4104.6890, 90.8185,true},
			   }},	
			   --对话开启飞行点
			   --与计程车NPC对话
			   {UnitInteract = 18942},
			   {Delay = 1},
		 {End = '去猎鹰岗哨开飞行点'},--]]
 
		--[[ --去开裂石堡飞行点
		 { If =  "JBMB:GetPlayer().mapID ~= 1952 and JBMB:GetPlayer().FactionGroup == 'Horde' ",End = '去开裂石堡飞行点'},
			   {Log='Debug',Text="去开裂石堡飞行点"},
			   {Log='Debug',Text="Go to the Flying Point of Cracked Stone Fort "},
			   {MoveTo = {
				{-238.0574, 4845.7295, 29.2679,true},
				{-244.2599, 5087.0708, 75.9701,true},
				{-237.9067, 5130.5845, 80.9273,true},
				{-244.5294, 5169.3276, 82.9607,true},
				{-262.1408, 5210.7661, 74.0665,true},
				{-280.6744, 5261.6440, 58.8433,true},
				{-276.0135, 5282.7886, 49.9264,true},
				{-249.1759, 5316.5566, 32.2550,true},
				{-224.7230, 5355.8799, 23.0848,true},
				{-219.2239, 5376.6836, 23.3121,true},
				{-223.9996, 5400.0293, 22.7700,true},
				{-257.5096, 5417.1699, 21.1145,true},
				{-276.1772, 5428.4336, 21.2740,true},
				{-319.1433, 5476.8853, 21.0883,true},
				{-338.7618, 5481.4648, 20.6459,true},
				{-412.3362, 5483.7021, 21.3044,true},
				{-452.8225, 5461.7173, 21.9352,true},
				{-470.7740, 5450.8105, 22.5917,true},
				{-505.9516, 5445.9653, 21.7972,true},
				{-567.4084, 5422.2437, 21.2138,true},
				{-598.0647, 5412.9644, 21.3009,true},
				{-631.8300, 5387.7114, 22.1456,true},
				{-681.6185, 5379.2031, 21.9514,true},
				{-751.6300, 5385.5708, 22.7747,true},
				{-773.1927, 5390.9771, 22.9733,true},
				{-859.0596, 5415.6743, 23.6498,true},
				{-904.6343, 5420.0425, 23.7648,true},
				{-980.4329, 5380.2681, 21.5238,true},
				{-1011.8536, 5388.3823, 22.3597,true},
				{-1036.7092, 5381.9302, 22.0298,true},
				{-1131.2769, 5349.1953, 25.7677,true},
				{-1176.4780, 5333.1504, 30.0961,true},
				{-1252.3628, 5264.8643, 40.4309,true},
				{-1324.6370, 5197.9233, 51.9614,true},
				{-1382.3267, 5181.9565, 61.7990,true},
				{-1459.9076, 5189.3218, 54.0646,true},
				
				{-2565.5571, 4427.8882, 39.2886,true},
			   }},	
			   --对话开启飞行点
			   --与计程车NPC对话
			   {UnitInteract = 18807},
			   {Delay = 1},
		 {End = '去开裂石堡飞行点'},--]]

        {If = "GetBindLocation() ~= 'Thrallmar' and GetBindLocation() ~= '萨尔玛' and JBMB:GetPlayer().FactionGroup == 'Horde'",End = '绑定萨尔玛炉石' },
        		 {Run = 'print("绑定萨尔玛炉石")'},
        		 {MoveTo = {189.7266, 2612.5342, 87.2840,true},},
        		 --与NPC对话
        		 {UnitInteract = 16602},
        		 --选择选项
        		 {Gossip = "binder"},
        		 {Delay=1},
        		 { Run = 'ConfirmBinder()' },
        		 {Delay=3},
        {Loop = '绑定萨尔玛炉石'},
	 {End = '部落黑暗之门飞裂石堡'},

    --部落结束

    --联盟开始
	    ---我是联盟在铁炉堡
		{If = "JBMB:GetPlayer().mapID == 1455 and JBMB:GetPlayer().mapID ~= 1453 and JBMB:GetPlayer().FactionGroup ~= 'Horde'",End = '在铁炉堡不在暴风城' },
		    {Run = 'print("坐地铁去暴风城")'},
            {Run = 'print("Take the subway to Stormwind City")'},
	        {MoveTo = {-4834.2344, -1286.5520, 501.8680,true},},
	        --传送检测
	        {Settings = 'ManualJump' , value = false},
	        --进地铁门
	        {MoveTo = {-4839.5630, -1323.9087, 501.8681,true},},
	        --传送检测
	        {Settings = 'ManualJump' , value = true},
	        --等待10秒加载地图包
	        {Delay=10},
	        --判定距离上地铁线程坐标太远掉下来,重新等待坐地铁
	        {If="JBMB:GetPlayer():DistanceTo(10.9874, 2490.4941, -4.0178)>20",End = 1.8},
	        --去做地铁等位,离掉落地点有点距离的地方,掉下去回来
	        {MoveTo = {28.8624, 10.4693, -4.2973,true},},
	        --等待地铁到达
	        {MoveTo = {12.1667, 8.3495, -3.9266,true},},
	        --暴风城下地铁坐标
	        {TakeTransport=6795 , DownPath = {10.9874, 2490.4941, -4.0178}},
	        {Loop=1.8},
	        --传送检测
	        {Settings = 'ManualJump' , value = false},
	        --出暴风城的地铁坐标
	        {MoveTo = {73.0952, 2490.7520, -4.2964,true},},
	        --传送检测
	        {Settings = 'ManualJump' , value = true},
	        --等待10秒加载地图包
	        {Delay=10},
	    {Loop = '在铁炉堡不在暴风城'},

	    --我是联盟在暴风城
        { If =  "JBMB:GetPlayer().mapID ==1453  and JBMB:GetPlayer().mapID ~=1431 and JBMB:GetPlayer().FactionGroup ~= 'Horde'",End = '我是联盟在暴风城'},
            --飞去夜色镇
            {MoveTo = {-8809.7236, 599.1157, 96.8079,true},},
            {MoveTo = {-8851.0049, 524.6660, 105.9991,true},},
            {MoveTo = {-8851.0088, 501.6681, 109.6053,true},},
            {Log='Debug',Text="飞去夜色镇"},
		    {Log='Debug',Text="Fly to night town "},
            --与计程车NPC对话
            {UnitInteract = 352},
            --选择要空运的选项
            {Gossip = "taxi"},
            --搭车
            --{Taxi = "十字路口"},
            {Taxi = 46079},
            --等待2秒
            {Delay=2},
		    ---------------------------夜色镇飞行点没开去开飞行点
		        --没有开夜色镇飞行点
		        {If = "JBMB:GetPlayer().mapID == 1436 and JBMB:GetPlayer().areaID ~= 42",End = '没有开夜色镇飞行点' },
		            --去开夜色镇飞行点
		            {MoveTo = {
		            	  {-10708.9463, 1031.4412, 33.3270,true},
		            	  {-10752.8926, 1019.6052, 32.8761,true},
		            	  {-10830.6152, 1009.8274, 32.7528,true},
		            	  {-10913.3379, 994.0904, 35.6657,true},
		            	  {-10936.0420, 972.8287, 33.4563,true},
		            	  {-10941.4863, 932.8136, 31.5969,true},
		            	  {-10928.9736, 850.7224, 32.6847,true},
		            	  {-10911.2744, 807.9391, 33.1638,true},
		            	  {-10880.2275, 751.8963, 31.0323,true},
		            	  {-10866.1504, 659.6194, 31.3467,true},
		            	  {-10864.2871, 589.1820, 31.1081,true},
		            	  {-10831.8564, 477.4719, 29.8227,true},
		            	  {-10817.7441, 413.0800, 29.3336,true},
		            	  {-10813.7637, 334.8568, 30.1448,true},
		            	  {-10787.5439, 205.6337, 30.4391,true},
		            	  {-10754.2441, 132.2661, 28.6510,true},
		            	  {-10753.7705, 72.0011, 29.0481,true},
		            	  {-10781.6650, -3.9408, 29.9328,true},
		            	  {-10838.2988, -174.9105, 33.9995,true},
		            	  {-10857.4189, -258.7740, 38.0605,true},
		            	  {-10897.3613, -367.9908, 39.1953,true},
		            	  {-10905.8037, -419.2619, 42.1648,true},
		            	  {-10910.2695, -511.3189, 52.0764,true},
		            	  {-10923.9912, -558.5794, 53.9153,true},
		            	  {-10948.1523, -597.8741, 55.1530,true},
		            	  {-10956.5664, -629.4385, 55.1087,true},
		            	  {-10954.7383, -647.4371, 55.2964,true},
		            	  {-10902.4717, -732.3017, 55.0693,true},
		            	  {-10846.5771, -794.2355, 56.1893,true},
		            	  {-10822.0850, -841.3371, 55.9089,true},
		            	  {-10797.9863, -911.6076, 55.9403,true},
		            	  {-10798.1689, -944.4212, 56.6279,true},
		            	  {-10807.5908, -981.3045, 55.3793,true},
		            	  {-10803.6406, -1034.7292, 46.3165,true},
		            	  {-10770.3018, -1128.2126, 28.0852,true},
		            	  {-10745.4600, -1157.4384, 26.0914,true},
		            	  {-10687.6621, -1190.3384, 27.2814,true},
		            	  {-10641.6602, -1194.2013, 28.5089,true},
		            	  {-10592.4268, -1188.7001, 27.6520,true},
		            	  {-10581.9385, -1190.2113, 27.4166,true},
		            	  {-10575.2725, -1207.1616, 26.1850,true},
		            	  {-10561.2891, -1213.4492, 27.6853,true},
		            	  {-10539.1533, -1258.8727, 33.0112,true},
		            	  {-10526.0850, -1272.8773, 38.4487,true},
		            	  {-10520.0459, -1271.3359, 39.7872,true},
		            }},
		            --开飞行点
		            {UnitInteract = 2409},
		            {Delay=2},
                {End = '没有开夜色镇飞行点'},
        {End = '我是联盟在暴风城'},

		--在夜色镇or悲伤沼泽or逆风小径,不在诅咒之地
		{ If =  " (JBMB:GetPlayer().mapID == 1431 or JBMB:GetPlayer().mapID == 1435 or JBMB:GetPlayer().mapID == 1430) and JBMB:GetPlayer().mapID ~=1419 and JBMB:GetPlayer().FactionGroup ~= 'Horde'",End = '联盟去诅咒之地'},
            {Log='Debug',Text="去诅咒之地"},
		    {Log='Debug',Text="Go to the cursed land "},
			{MoveTo = {-10463.8516, -2406.3643, 71.4691,true},},
            {MoveTo = {-10415.5205, -2412.4338, 62.5820,true},},
            {MoveTo = {-10393.9521, -2427.8101, 52.6667,true},},
            {MoveTo = {-10386.9307, -2451.0659, 45.5407,true},},
            {MoveTo = {-10415.6914, -2573.5024, 22.5662,true},},
            {MoveTo = {-10421.0166, -2602.7917, 21.6823,true},},
            {MoveTo = {-10422.6777, -2619.4871, 23.4917,true},},
            {MoveTo = {-10439.2910, -2645.0537, 21.7222,true},},
            {MoveTo = {-10514.9697, -2761.8867, 23.2611,true},},
            {MoveTo = {-10551.2744, -2781.2761, 22.8233,true},},
            {MoveTo = {-10557.3457, -2858.0129, 23.8810,true},},
            {MoveTo = {-10540.2676, -2958.0398, 22.1973,true},},
            {MoveTo = {-10525.3955, -3019.8794, 21.7936,true},},
            {MoveTo = {-10536.4600, -3042.5635, 22.2602,true},},
            {MoveTo = {-10577.3711, -3038.3071, 27.6287,true},},
            {MoveTo = {-10651.3301, -2986.4043, 30.6721,true},},
            {MoveTo = {-11812.6445, -3198.8394, -30.7370,true},},
		{End = '联盟去诅咒之地'},

				
		--进入黑暗之门
		{ If =  "JBMB:GetPlayer().mapID == 1419 and JBMB:GetPlayer().mapID ~=1944 and JBMB:GetPlayer().FactionGroup ~= 'Horde'",End = '联盟进入黑暗之门'},
		    {Log='Debug',Text="进入黑暗之门"},
		    {Log='Debug',Text="Enter the Dark Portal "},
		    --传送检测
		    {Settings = 'ManualJump' , value = false},
		    {MoveTo = {-11830.4229, -3193.8445, -30.3324,true},},
		    {MoveTo = {-11906.8906, -3208.9094, -14.8609,true},},
		    {Delay = 20},
		    --传送检测
		    {Settings = 'ManualJump' , value = true},
		{Loop = '联盟进入黑暗之门'},
		
		----到荣耀堡
		{If = "JBMB:GetPlayer():DistanceTo(-321.6697, 1027.3817, 54.1596) < 20 ", End = '飞到荣耀堡'},
			{Log='Debug',Text="飞去荣耀堡开飞行点"},
			{Log='Debug',Text="The Alliance flies to Alleria  "},
			{MoveTo = {-312.7271, 1022.2858, 54.2382,true},},
			{Log='Debug',Text="搭计程车拉！"},
			--与计程车NPC对话
			{UnitInteract = 18931},
			{Delay = 1},
			{Gossip = "taxi"},
			--选择要空运的选项
			{Taxi = 64057},
			--等待2秒
			{Delay = 5},
		{End = '飞到荣耀堡'},
				
		--黑暗之门飞去奥蕾莉亚
        --[[{If = "JBMB:GetPlayer():DistanceTo(-248.1130, 922.9000, 84.3497) < 300 and JBMB:GetPlayer().FactionGroup ~= 'Horde'", End = '联盟飞去奥蕾莉亚'},
            {MoveTo = {-310.4633, 1021.0280, 54.2579,true},},
            {Log='Debug',Text="联盟飞去奥蕾莉亚"},
		    {Log='Debug',Text="Fly to Teredor "},
            --与计程车NPC对话
            {UnitInteract = 18931},
            {Delay = 1},
			{UnitInteract = 18931},
            {Delay = 1},
            {Gossip = "taxi"},
            --选择要空运的选项
            {Taxi = 55076},
            --等待2秒
            {Delay = 5},
                 --没有开泰雷多尔飞行点去开飞行点
                {If = "JBMB:GetPlayer():DistanceTo(-321.6697, 1027.3817, 54.1596) < 20 ", End = '没有开奥蕾莉亚飞行点'},
				    {Log='Debug',Text="飞去荣耀堡开飞行点"},
				    {Log='Debug',Text="The Alliance flies to Alleria  "},
                    {MoveTo = {-312.7271, 1022.2858, 54.2382,true},},
                    {Log='Debug',Text="搭计程车拉！"},
                    --与计程车NPC对话
                    {UnitInteract = 18931},
                    {Delay = 1},
                    {Gossip = "taxi"},
                    --选择要空运的选项
                    {Taxi = 64057},
                    --等待2秒
                    {Delay = 5},
                {End = '没有开奥蕾莉亚飞行点'},
				    --去塔哈马特神庙,在荣耀堡,不在塔哈马特神庙
                    { If =  "JBMB:GetPlayer().mapID ~= 1952",End = '去奥蕾莉亚'},
					    {Log='Debug',Text="去奥蕾莉亚开飞行点"},
				        {Log='Debug',Text="Go to Alleria to open a flight point "},
                        {MoveTo = {
							{-238.0574, 4845.7295, 29.2679,true},
							{-244.2599, 5087.0708, 75.9701,true},
							{-237.9067, 5130.5845, 80.9273,true},
							{-244.5294, 5169.3276, 82.9607,true},
							{-262.1408, 5210.7661, 74.0665,true},
							{-280.6744, 5261.6440, 58.8433,true},
							{-276.0135, 5282.7886, 49.9264,true},
							{-249.1759, 5316.5566, 32.2550,true},
							{-224.7230, 5355.8799, 23.0848,true},
							{-219.2239, 5376.6836, 23.3121,true},
							{-223.9996, 5400.0293, 22.7700,true},
							{-257.5096, 5417.1699, 21.1145,true},
							{-276.1772, 5428.4336, 21.2740,true},
							{-319.1433, 5476.8853, 21.0883,true},
							{-338.7618, 5481.4648, 20.6459,true},
							{-412.3362, 5483.7021, 21.3044,true},
							{-452.8225, 5461.7173, 21.9352,true},
							{-470.7740, 5450.8105, 22.5917,true},
							{-505.9516, 5445.9653, 21.7972,true},
							{-567.4084, 5422.2437, 21.2138,true},
							{-598.0647, 5412.9644, 21.3009,true},
							{-631.8300, 5387.7114, 22.1456,true},
							{-681.6185, 5379.2031, 21.9514,true},
							{-751.6300, 5385.5708, 22.7747,true},
							{-773.1927, 5390.9771, 22.9733,true},
							{-859.0596, 5415.6743, 23.6498,true},
							{-904.6343, 5420.0425, 23.7648,true},
							{-980.4329, 5380.2681, 21.5238,true},
							{-1011.8536, 5388.3823, 22.3597,true},
							{-1036.7092, 5381.9302, 22.0298,true},
							{-1131.2769, 5349.1953, 25.7677,true},
							{-1176.4780, 5333.1504, 30.0961,true},
							{-1252.3628, 5264.8643, 40.4309,true},
							{-1324.6370, 5197.9233, 51.9614,true},
							{-1382.3267, 5181.9565, 61.7990,true},
							{-1459.9076, 5189.3218, 54.0646,true},

							{-2988.8083, 3873.7603, 9.3169,true},
                    }},	
                    --对话开启飞行点
                    --与计程车NPC对话
                    {UnitInteract = 18809},
					{Delay = 1},
                    {End = '去奥蕾莉亚'},
        {End = '联盟飞去奥蕾莉亚'},--]]

		{If = "GetBindLocation() ~= 'Honor Hold' and GetBindLocation() ~= '荣耀堡' and JBMB:GetPlayer().FactionGroup ~= 'Horde'",End = '绑定荣耀堡炉石' },
            {Run = 'print("绑定荣耀堡炉石")'},
            {MoveTo = {-708.8386, 2736.7227, 94.7334,true},},
            --与NPC对话
            {UnitInteract = 16826},
            --选择选项
            {Gossip = "binder"},
            {Delay=1},
            { Run = 'ConfirmBinder()' },
            {Delay=3},
        {Loop = '绑定荣耀堡炉石'},
 

    --联盟结束
	  {Replace = 'text1', Index = 1},
             }

--爆本等待随机导航等待
local randomPath = {FindPat = true}

-- 去副本
local text1 = {
	{Settings='UseMount',value=true,},
	
	{If = " JBMB:GetPlayer():GetDurabilityPercent() <= 20 or JBMB:GetPlayer():GetMinDurabilityPercent() <= 20 or CalculateTotalNumberOfFreeBagSlots() < 8 or GetItemsCount(5140)< 5 or JBMB:GetPlayer():DistanceTo(189, 2612, 87.28) < 80 and JBMB:GetPlayer().FactionGroup == 'Horde' or  JBMB:GetPlayer():DistanceTo(X,Y,Z) < 80 and JBMB:GetPlayer().FactionGroup ~= 'Horde'" ,
	End = '回城售卖维修' },
		{If = " JBMB:GetPlayer():DistanceTo(189, 2612, 87.28) > 90 and JBMB:GetPlayer().FactionGroup == 'Horde' or  JBMB:GetPlayer():DistanceTo(X,Y,Z) > 80 and JBMB:GetPlayer().FactionGroup ~= 'Horde'" ,	End = '炉石回城' },
			{Log='Info',Text="炉石"},
			  --使用炉石
			{UseItem = 6948},
			{Delay=15},
			{Log='Info',Text="炉石完毕"},
		{End = "炉石回城"},
		{Log='Info',Text="去修理"},
		{Replace = 'text5', Index = 1},
	{Loop = '回城售卖维修' }, 
	{If = " (JBMB:GetPlayer().mapID ~= 543) and JBMB:GetPlayer():DistanceTo(-363.317, 3078.97, -14.9989)  > 50 and JBMB:GetPlayer().FactionGroup == 'Horde'",End = '部落不在副本门口'},		 
        {Delay = 1},
		{MoveTo = {X,Y,Z,true},},
		{MoveTo = {-280.0154, 3053.6011, -4.3071,true},},
		{Run = function() Stealth() end},
		{Settings='UseMount',value=false,},
		{MoveTo = {-286.2883, 3040.3838, -4.7985},},
		{MoveTo = {-297.2342, 3034.8694, -3.6833},},
		{MoveTo = {-308.3719, 3036.1133, -3.1086},},
		{MoveTo = {-319.3790, 3035.2488, -16.1027},},
		{MoveTo = {-332.8889, 3048.4873, -17.1931},},
		{MoveTo = {-359.5469, 3068.8662, -15.1165},},
		{MoveTo = {-362.3260, 3075.6772, -15.0450},},

        {Delay = 1},

	{End = '部落不在副本门口'},

	{If = " (JBMB:GetPlayer().mapID ~= 543) and JBMB:GetPlayer():DistanceTo(-363.317, 3078.97, -14.9989)  > 50 and JBMB:GetPlayer().FactionGroup ~= 'Horde'",End = '联盟不在副本门口'},		 
	    {Delay = 1},
		{MoveTo = {-497.5761, 2997.6948, 5.3195,true},},
		{MoveTo = {-434.3469, 3015.5278, -16.3024,true},},
		{MoveTo = {-339.9817, 3038.2227, -16.5541,true},},
		{MoveTo = {-335.7849, 3046.6147, -16.9350,true},},
		{MoveTo = {-362.3260, 3075.6772, -15.0450,true},},
	{End = '联盟不在副本门口'},



	--副本出来重置
	{If = " (JBMB:GetPlayer().mapID ~= 543) and JBMB:GetPlayer():DistanceTo(-363.317, 3078.97, -14.9989)  < 20 ",End = '我在副本门口'},
        {Delay = 1},
		{Run = function() DungeonTimer.Wait() end},
		{Run = function() Stealth() end},
		{Settings='UseMount',value=false,},
        {Run = 'roadcount = math.random(1,4)'},
        
        {If = "roadcount == 1",End = '进本01'},
        --{Log='Info',Text="1"},
		{Run = function() JBMB.MoveTo(X,Y,Z) end},
        {End = '进本01'},
        {If = "roadcount == 2",End = '进本02'},
        --{Log='Info',Text="2"},
		{Run = function() JBMB.MoveTo(X,Y,Z) end},
        {End = '进本02'},
        {If = "roadcount == 3",End = '进本03'},
        --{Log='Info',Text="3"},
		{Run = function() JBMB.MoveTo(X,Y,Z) end},	
        {End = '进本03'},
        {If = "roadcount == 4",End = '进本04'},
        --{Log='Info',Text="3"},			  	
		{Run = function() JBMB.MoveTo(X,Y,Z) end},
        {End = '进本04'},
	  
		{Run = "print('等待切换地图成功')"}, 
		{If = " not WaitInDungeon and JBMB:GetPlayer().mapID ~= 543", End = "等待进本"},
			{Delay = 1},
		{Loop = "等待进本"},
		{Delay = 1},
			--爆本等待进本
		{If = 'WaitInDungeon or JBMB:GetPlayer().mapID ~= 543' ,End = 'WaitInDungeon'},
			{Run = function()          
				WaitInDungeon = false
				STATUS = 'Wait'
				print('爆本了 等待几分钟再尝试进本')
				randomPath[1] = {JBMB:GetRandomPosition(-363.524, 3079.12, -15.0032, 3)}
			end}, 
			{MoveTo = randomPath},
			{Delay = 1},
			{Run = function()
				ReturnToSelectCharacterScreen(GetSetting('爆本后等待(单位:分钟)')*60)
		    	STATUS = ''
				end},
			--[[{Delay = function()          
				__start__ = __start__ or time()
				if time() < __start__ + GetSetting('爆本后等待(单位:分钟)') * 60 then
					return false
				end
				__start__ = nil
				STATUS = ''
				return true
			end}, --]]
			{Delay = 20},
			{Run = 'roadcount = math.random(1,4)'},
			
			{If = "roadcount == 1",End = '进本01'},
			--{Log='Info',Text="1"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本01'},
			{If = "roadcount == 2",End = '进本02'},
			--{Log='Info',Text="2"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本02'},
			{If = "roadcount == 3",End = '进本03'},
			--{Log='Info',Text="3"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},	
			{End = '进本03'},
			{If = "roadcount == 4",End = '进本04'},
			--{Log='Info',Text="3"},			  	
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本04'},
		  
			{Run = "print('等待切换地图成功')"}, 
			{If = " not WaitInDungeon and JBMB:GetPlayer().mapID ~= 543", End = "等待进本"},
				{Delay = 1},
			{Loop = "等待进本"},
			{Delay = 1},
		{End = 'WaitInDungeon'},
	{Loop = '我在副本门口'},

	---去副本门口
	{If = "JBMB:GetPlayer().mapID == 1944 and JBMB:GetPlayer():DistanceTo(-363.317, 3078.97, -14.9989)  > 20 ",End = 200},
		{Run = 'print("去地狱火城墙副本")'},
		--关闭自动吃喝反击
			 -- 战斗循环自动buff
			 {Settings = 'CombatLoopAutoBuff' , value = true},
			 -- 自动战斗，追击，检取开关
			 {Settings = 'CombatIngSwitch' , value = false},
			 --关闭自动吃喝判断
			 {Settings = 'AutoDrinkFood' , value = false},
			 --关闭自动吃
			 {Settings = 'UseFood' , value = false},
			 --关闭自动喝
			 {Settings = ' UseDrink' , value = false},
			 --关闭自动复活
			 {Settings = 'AutoRetrieve' , value = false},
			 --关闭自动换装
			 {Settings = 'AutoEquip' , value = false},
			 --关闭自动休息
			 {Settings = 'AutoRest' , value = false},
			 --关闭GM传送
			 {Settings = 'ManualJump' , value = false},

		--联盟不在副本
		{If = "JBMB:GetPlayer().FactionGroup ~= 'Horde'", End = '联盟不在副本'},

			{Delay = 1},
			{Settings='UseMount',value=false,},
			{MoveTo = {-363.524, 3079.12, -15.0032,true},},	
			{Run = function() Stealth() end},
			{Run = function() DungeonTimer.Wait() end},
	 
			--进本
			{Delay = 1},
			{Settings='UseMount',value=false,},
			{Run = 'roadcount = math.random(1,4)'},
			
			{If = "roadcount == 1",End = '进本01'},
			--{Log='Info',Text="1"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本01'},
			{If = "roadcount == 2",End = '进本02'},
			--{Log='Info',Text="2"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本02'},
			{If = "roadcount == 3",End = '进本03'},
			--{Log='Info',Text="3"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},	
			{End = '进本03'},
			{If = "roadcount == 4",End = '进本04'},
			--{Log='Info',Text="3"},			  	
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本04'},
		  
			{Run = "print('等待切换地图成功')"}, 
			{If = " not WaitInDungeon and JBMB:GetPlayer().mapID ~= 543", End = "等待进本"},
				{Delay = 1},
			{Loop = "等待进本"},
			{Delay = 1},
	  
	    {End = '联盟不在副本'},

   	    --部落没在副本
	    {If = "JBMB:GetPlayer().FactionGroup == 'Horde'",End = '部落没在副本'},
			{MoveTo = {-362.3260, 3075.6772, -15.0450},},
			{Run = function() Stealth() end},
				
			--门口
			--进本
			{Run = function() DungeonTimer.Wait() end},
			--{Run = 'GoInDungeon(-365.6255, 3083.7322, -14.6801)'},
			{Delay = 5},
			{Settings='UseMount',value=false,},
			{Run = 'roadcount = math.random(1,4)'},
			
			{If = "roadcount == 1",End = '进本01'},
			--{Log='Info',Text="1"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本01'},
			{If = "roadcount == 2",End = '进本02'},
			--{Log='Info',Text="2"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本02'},
			{If = "roadcount == 3",End = '进本03'},
			--{Log='Info',Text="3"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},	
			{End = '进本03'},
			{If = "roadcount == 4",End = '进本04'},
			--{Log='Info',Text="3"},			  	
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本04'},
		  
			{Run = "print('等待切换地图成功')"}, 
			{If = " not WaitInDungeon and JBMB:GetPlayer().mapID ~= 543", End = "等待进本"},
				{Delay = 1},
			{Loop = "等待进本"},
			{Delay = 1},
		{End = '部落没在副本'},
	{Loop = 200},


	{If = " (JBMB:GetPlayer().mapID ~= 543) and JBMB:GetPlayer():DistanceTo(-363.317, 3078.97, -14.9989)  < 20 ",End = '我在副本门口'},
	    {Delay = 1},
	    --进本
		{Run = function() DungeonTimer.Wait() end},
	    --{Run = 'GoInDungeon(-365.6255, 3083.7322, -14.6801)'},
        {Delay = 1},
		{Settings='UseMount',value=false,},
        {MoveTo = {-363.524, 3079.12, -15.0032,true},},	
		{Run = function() Stealth() end},
        {Run = 'roadcount = math.random(1,4)'},
        
        {If = "roadcount == 1",End = '进本01'},
        --{Log='Info',Text="1"},
		{Run = function() JBMB.MoveTo(X,Y,Z) end},
        {End = '进本01'},
        {If = "roadcount == 2",End = '进本02'},
        --{Log='Info',Text="2"},
		{Run = function() JBMB.MoveTo(X,Y,Z) end},
        {End = '进本02'},
        {If = "roadcount == 3",End = '进本03'},
        --{Log='Info',Text="3"},
		{Run = function() JBMB.MoveTo(X,Y,Z) end},	
        {End = '进本03'},
        {If = "roadcount == 4",End = '进本04'},
        --{Log='Info',Text="3"},			  	
		{Run = function() JBMB.MoveTo(X,Y,Z) end},
        {End = '进本04'},
	  
		{Run = "print('等待切换地图成功')"}, 
		{If = " not WaitInDungeon and JBMB:GetPlayer().mapID ~= 543", End = "等待进本"},
			{Delay = 1},
		{Loop = "等待进本"},
		{Delay = 1},

		{If = 'WaitInDungeon or JBMB:GetPlayer().mapID ~= 543' ,End = 'WaitInDungeon'},
		    {Run = function()          
		    		 WaitInDungeon = false
		    		 STATUS = 'Wait'
		    		 print('爆本了 等待几分钟再尝试进本')
					randomPath[1] = {JBMB:GetRandomPosition(-363.524, 3079.12, -15.0032, 3)}
		    	 end}, 
		    	 {MoveTo = randomPath},
				{Delay = 1},
				{Run = function()
					ReturnToSelectCharacterScreen(GetSetting('爆本后等待(单位:分钟)')*60)
		    		STATUS = ''
					end},
		    	 --[[{Delay = function()          
		    		 __start__ = __start__ or time()
		    		 if time() < __start__ + GetSetting('爆本后等待(单位:分钟)') * 60 then
		    			 return false
		    		 end
		    		 __start__ = nil
		    		 STATUS = ''
		    		 return true
		    	 end}, --]]
			{Delay = 20},
			{Run = 'roadcount = math.random(1,4)'},
			
			{If = "roadcount == 1",End = '进本01'},
			--{Log='Info',Text="1"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本01'},
			{If = "roadcount == 2",End = '进本02'},
			--{Log='Info',Text="2"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本02'},
			{If = "roadcount == 3",End = '进本03'},
			--{Log='Info',Text="3"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},	
			{End = '进本03'},
			{If = "roadcount == 4",End = '进本04'},
			--{Log='Info',Text="3"},			  	
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本04'},
		  
			{Run = "print('等待切换地图成功')"}, 
			{If = " not WaitInDungeon and JBMB:GetPlayer().mapID ~= 543", End = "等待进本"},
				{Delay = 1},
			{Loop = "等待进本"},
			{Delay = 1},
	    {End = 'WaitInDungeon'},
	{Loop = '我在副本门口'},
		  
		{If = "JBMB:GetPlayer().mapID == 543 ",End = 500},

		{Run = "print('副本中')"}, 
		{Delay = 1},
		{Settings = 'GoHomeEvent', value = false},
		--输出循环开始
		{Replace = 'text2', Index = 1},
		{End = 500},
}
-- 拉怪
local text2 = {
 	--关闭自动吃喝反击
	-- 战斗循环自动buff
	{Run = function() --关闭所有战斗循环
		SetDMWHUD('Rotation',false) 
		end},
		{Settings = 'CombatLoopAutoBuff' , value = false},
		-- 自动战斗，追击，检取开关
		{Settings = 'CombatIngSwitch' , value = false},
		--关闭自动吃喝判断
		{Settings = 'AutoDrinkFood' , value = false},
		--关闭自动吃
		{Settings = 'UseFood' , value = false},
		--关闭自动喝
		{Settings = ' UseDrink' , value = false},
		--关闭自动复活
		{Settings = 'AutoRetrieve' , value = false},
		--关闭自动换装
		{Settings = 'AutoEquip' , value = false},
		--关闭自动休息
		{Settings = 'AutoRest' , value = false},
		--不使用坐骑
		{Settings='UseMount',value=false,},
    --进本初始化信息
    {Run = function()
		if JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 then
			DungeonTimer.Start()
		end
		ThisTimeTotalTime = GetTime()
		SetDMWHUD('Rotation',false)
		STATUS = ''
		--CancelAura(1787)
    end},
    {Run = function()
		RunMacroText("/leave 1")
		RunMacroText("/leave 2")
		RunMacroText("/leave 3")
		RunMacroText("/leave 4")
		RunMacroText("/leave 5")
		RunMacroText("/leave 6")
    end},
	{Settings = 'agentRadius' , value = 0.3},

	
        -------------------------------------------------
        --{MoveTo = {-5.3392, 2.4731, -0.9537}},
        --装备耐久不够炉石回城修理

      
		
		{Delay = 1},
	    {If = " (JBMB:GetPlayer():GetDurabilityPercent() <= 20 or JBMB:GetPlayer():GetMinDurabilityPercent() <= 20 or CalculateTotalNumberOfFreeBagSlots() < 8 or GetItemsCount(5140)< 5) and GetItemCooldown(6948) == 0 " ,
		End = '副本内炉石回城售卖维修' },
			{If = "JBMB:GetPlayer().mapID == 543" ,End = '炉石回去修理' },
				--炉石回家
				{Log='Info',Text="炉石"},
				  --使用炉石
				{UseItem = 6948},
				{Delay=15},
				{Log='Info',Text="炉石完毕"},
			{Loop = '炉石回去修理' }, 
			{Log='Info',Text="去修理"},
			{Replace = 'text5', Index = 1},
	    {Loop = '副本内炉石回城售卖维修' }, 
		{Delay = 1},
	----------------1--------------------
		
		--打开GM传送
		{Settings = 'ManualJump' , value = true},
		{Run = function() Stealth() end},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 1},
		    {MoveTo = {X,Y,Z},},
		{End = 1},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 2},
		    {Run = 'JBMB.FaceDirection(X,Y,Z, true)'},
		    {Run = function()
						ToggleAutoRun()
                    end},
			{Log='Info',Text = "等待闷棍噬骨掠夺者"},
			{Run = function()
						if GetLocale() == "zhCN" then
							RunMacroText("/tar 噬骨掠夺者")
						else
							RunMacroText("/tar Bonechewer Ravener")
						end
                    end},
		{End = 2},
		{If = FindMob1, End = 'FindMob1'},
			{Run = 'JBMB.FaceDirection(X,Y,Z, true)'},		
			{Delay = 0.01},
		{Loop = 'FindMob1'},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 55 ", End = 2.1},
			{MoveTo = {X,Y,Z},},
			{Run = function()
					if GetLocale() == "zhCN" then
						RunMacroText("/cast 闷棍")
					else
						RunMacroText("/cast Sap")
					end
				end},
		{End = 2.1},
	-------------------------------------
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 3},
			{If = FindMob2, End = 'FindMob2'},
				{Log='Info',Text = "等待军犬回去"},
			{Loop = 'FindMob2'},
			{Run = function()
					if GetLocale() == "zhCN" then
						RunMacroText("/cast 疾跑")
					else
						RunMacroText("/cast Sprint")
					end
				end},
			{MoveTo = {X,Y,Z},},
		{End = 3},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 3},
			{MoveTo = {X,Y,Z},},
		{End = 3},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 3},
			{MoveTo = {X,Y,Z},},
		{End = 3},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 3},
			{MoveTo = {X,Y,Z},},
		{End = 3},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 3},
			{MoveTo = {X,Y,Z},},
		{End = 3},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 3},
			{MoveTo = {X,Y,Z},},
		{End = 3},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 3},
			{MoveTo = {X,Y,Z},},
		{End = 3},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 4},
			{MoveTo = {X,Y,Z},},
			{Run = 'JBMB.FaceDirection(X,Y,Z, true)'},
			{Run = function()
					if GetLocale() == "zhCN" then
						RunMacroText("/tar 噬骨毁灭者")
						RunMacroText("/cast 闷棍")
					else
						RunMacroText("/tar Bonechewer Destroyer")
						RunMacroText("/cast Sap")
					end
				end},
			{MoveTo = {X,Y,Z4},},	
		{End = 4},	
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z4) < 15 ", End = 4},
			{MoveTo = {X,Y,Z},},
		{End = 4},	
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 4},
			{MoveTo = {X,Y,Z},},
		{End = 4},	
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 4},
			{MoveTo = {X,Y,Z},},
		{End = 4},	
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 4},
			{MoveTo = {X,Y,Z},},
		{End = 4},	
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 4},
			{MoveTo = {X,Y,Z},},	
		{End = 4},	
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 5},
			{If = FindMob3, End = 'FindMob3'},
				{Log='Info',Text = "等待军犬离开"},
			{Loop = 'FindMob3'},
			{Log='Info',Text = "继续前进"},
			{MoveTo = {X,Y,Z,false},},
		{End = 5},	
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 6},
			{MoveTo = {X,Y,Z},},	
		{End = 6},	
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 6},
			{MoveTo = {X,Y,Z},},	
			{Run = function() MoveForwardStop() end},
			{Run = 'JBMB.FaceDirection(X,Y,Z, true)'},
			{Run = function() MoveForwardStart() JBMB:GetPlayer():Jump() end},
			{Delay = 1},
			{Run = 'JBMB.FaceDirection(X,Y,Z, true)'},
			{Run = function() MoveForwardStart() end},
			{Delay = 1.8},
			{Run = function() MoveForwardStop() end},
			{MoveTo = {X,Y,Z,false},},	
		{End = 6},	
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 7},
			{If = Findbox1, End = 'Findbox1'},
				{Log='Info',Text = "准备开第一个箱子"},
				{If = " GetSpellCooldown(26889) ~= 0",End = "消失CD"},
					{Run = function()
							if GetSpellCooldown(14185) == 0 then
								if GetLocale() == "zhCN" then
									RunMacroText("/cast 伺机待发")
								else
									RunMacroText("/cast Preparation")
								end
								Wait(1500)
							end
						end},
					{Log='Info',Text = "等待消失技能冷却.Waiting for Vanish Cooldown."},
				{Loop = "消失CD"},
				{MoveTo = {X,Y,Z},},
				{MoveTo = {X,Y,Z},},
				{Delay = 0.5},
				{If = Openbox1, End = 'Openbox1'},
				{End = "Openbox1"},
			{Loop = 'Findbox1'}, 
			{Delay = 1},
			{Run = function() Stealth() end},
			{If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 20 ", End = 7.1},
				{MoveTo = {X,Y,Z,true},},
			{End = 7.1},
		{End = 7},	
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 8},
			{If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 8.1},
				{MoveTo = {X,Y,Z,true},},
				{Run = function() 
								if GetSpellCooldown(14185) == 0 then
									if GetLocale() == "zhCN" then
										RunMacroText("/cast 伺机待发")
									else
										RunMacroText("/cast Preparation")
									end
								end
						end},
			{End = 8.1},	
			{If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 8.1},
				{MoveTo = {-1173.46, 1421.14, 68.4378,true},},
			{End = 8.1},	
			{Run = function() 
							if GetSpellCooldown(11305) == 0 then
								if GetLocale() == "zhCN" then
									RunMacroText("/cast 疾跑")
								else
									RunMacroText("/cast Sprint")
								end
							end 
					end},
			{If = " JBMB:GetPlayer():DistanceTo(-1173.46, 1421.14, 68.4378) < 15 ", End = 8.1},
				{MoveTo = {X,Y,Z,true},},
			{End = 8.1},	
		{End = 8},	
		--{Run = 'print(JBMB:GetPlayer():DistanceTo(X,Y,Z) < 6)'},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 8},
			{MoveTo = {X,Y,Z,true},},
		{End = 8},	
		--{Run = 'print(JBMB:GetPlayer():DistanceTo(X,Y,Z) < 6)'},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 8},
			{MoveTo = {X,Y,Z,true},},
		{End = 8},	
		--{Run = 'print(JBMB:GetPlayer():DistanceTo(X,Y,Z) < 6)'},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 8},
			{MoveTo = {X,Y,Z,true},},
		{End = 8},	
		--{Run = 'print(JBMB:GetPlayer():DistanceTo(X,Y,Z) < 6)'},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 8},
			{MoveTo = {X,Y,Z,true},},
		{End = 8},	
		--{Run = 'print(JBMB:GetPlayer():DistanceTo(X,Y,Z) < 6)'},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 8},
			{MoveTo = {X,Y,Z,true},},
		{End = 8},	
		--{Run = 'print(JBMB:GetPlayer():DistanceTo(X,Y,Z) < 6)'},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 8},
			{MoveTo = {X,Y,Z,true},},
		{End = 8},	
		--{Run = 'print(JBMB:GetPlayer():DistanceTo(X,Y,Z) < 6)'},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 8},
			{MoveTo = {X,Y,Z,true},},
		{End = 8},	
		--{Run = 'print(JBMB:GetPlayer():DistanceTo(X,Y,Z) < 6)'},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 9},
			{MoveTo = {X,Y,Z,true},},
		{End = 9},
		--{Run = 'print(JBMB:GetPlayer():DistanceTo(X,Y,Z) < 6)'},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 9},
			{MoveTo = {X,Y,Z,true},},
		{End = 9},
		--{Run = 'print(JBMB:GetPlayer():DistanceTo(X,Y,Z) < 6)'},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 9},
			{MoveTo = {X,Y,Z,true},},
			{If = "JBMB:GetPlayer().Race == 'Gnome' and not fengshe() and GetItemsCount(6657) > 0", End = "Gnome"},
				{UseItem = 6657},
				{Delay = 1.5},
				{Run = function() Stealth() end},
			{End = "Gnome"},
		{End = 9},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 9},
			{MoveTo = {X,Y,Z,true},},
		{End = 9},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 9},
			{MoveTo = {X,Y,Z,true},},
		{End = 9},
	    {If = " JBMB:GetPlayer():DistanceTo(-X,Y,Z) < 15 ", End = 9},
			{MoveTo = {X,Y,Z,true},},
		{End = 9},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 9},
			{MoveTo = {X,Y,Z,true},},
		{End = 9},
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 9},
			{MoveTo = {X,Y,Z,true},},
			{Run = function() 
					TargetNearestEnemy() 
					if GetLocale() == "zhCN" then
						RunMacroText("/cast 闷棍")
					else
						RunMacroText("/cast Sap")
					end
				end},
			
			{MoveTo = {X,Y,Z},},
		{End = 9},	
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 10},
			{MoveTo = {X,Y,Z},},
			{MoveTo = {X,Y,Z},},
			{If = FindMob4, End = "FindMob4"},
				{Log='Info',Text = "等待碎手军犬通过"},
			{Loop = "FindMob4"},
		{End = 10},	
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 11},
			{MoveTo = {X,Y,Z},},
			{MoveTo = {X,Y,Z},},
			{Run = function() 
					if GetLocale() == "zhCN" then
						RunMacroText("/tar 血环暗法师")
						RunMacroText("/cast 暗影步")
					else
						RunMacroText("/tar Bleeding Hollow Darkcaster")
						RunMacroText("/cast Shadowstep")
					end
					end},
			{Delay = 0.2},
			{Run = function() 
							if GetLocale() == "zhCN" then
								RunMacroText("/cast 闷棍")
							else
								RunMacroText("/cast Sap")
							end
						end},
			{If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) > 3",End = "jump"},
			{Run = function() JumpForward(X,Y,Z) end},
			{Loop = "jump"},
			{Delay = 1},
			{MoveTo = {X,Y,Z},},
			--打开GM传送
			--{Settings = 'ManualJump' , value = true},
		{End = 11},	
	    {If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 12},
			{If = Findbox2, End = 'Findbox2'},
				{Log='Info',Text = "准备开第二个箱子"},
				{If = " GetSpellCooldown(26889) ~= 0",End = "消失CD"},
					{Log='Info',Text = "等待消失技能冷却"},
				{Loop = "消失CD"},
				{MoveTo = {X,Y,Z},},
				{Run = function() 
							if GetLocale() == "zhCN" then
								RunMacroText("/cast 闷棍")
							else
								RunMacroText("/cast Sap")
							end
						end},
						{Delay = 0.5},
						
						{If = "JBMB:GetPlayer().Race == 'Gnome' ", End = "Gnome"},
							{If = fengshe1, End = "fengshe"},
								{MoveTo = {X,Y,Z},},
							{Else = "fengshe"},
								{MoveTo = {X,Y,Z},},
							{End = "fengshe"},
						{Else = "Gnome"},
							{If = " JBMB:GetPlayer().Race == 'Dwarf'",End = "Dwarf"},
								{MoveTo = {X,Y,Z},},
							{Else = "Dwarf"},
								{MoveTo = {X,Y,Z},},
							{End = "Dwarf"},
						{End = "Gnome"},
						{Delay = 0.5},
						{Run = "InterfaceOptionsMousePanelClickToMove:SetValue('0')"},
						{Delay = 1},
						{If = Openbox1, End = 'Openbox1'},
						{Delay = 1},
						{End = "Openbox1"},
						{Run = "InterfaceOptionsMousePanelClickToMove:SetValue('1')"},
					{Loop = 'Findbox2'},
					{Run = function() Stealth() end},
					{MoveTo = {X,Y,Z},},
					--{Run = function() MoveForward(-1298.64,1584.77,91.7841,100) end},
			{Delay = 1},
		{End = 12},	
		
--装备耐久不够炉石回城修理

	    {If = " (JBMB:GetPlayer():GetDurabilityPercent() <= 20 or JBMB:GetPlayer():GetMinDurabilityPercent() <= 20 or CalculateTotalNumberOfFreeBagSlots() < 8 or GetItemsCount(5140)< 5) and GetItemCooldown(6948) == 0 " ,
		End = '副本内炉石回城售卖维修' },
			{If = "JBMB:GetPlayer().mapID == 543" ,End = '炉石回去修理' },
				--炉石回家
				{Log='Info',Text="炉石"},
				  --使用炉石
				{UseItem = 6948},
				{Delay=15},
				{Log='Info',Text="炉石完毕"},
			{Loop = '炉石回去修理' }, 
			{Log='Info',Text="去修理"},
			{Run = "ResetInstances()"},
			{Replace = 'text5', Index = 1},
	    {Loop = '副本内炉石回城售卖维修' }, 
		
		{If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 1.1},
			{Run = function()
					local wt=0
					__waittime = 0
					if DungeonTimer.MaxTime and DungeonTimer.StartTime then
						wt = math.floor(DungeonTimer.MaxTime - (GetTime() - DungeonTimer.StartTime))
					else
						wt = 0
					end
					if wt == 0 then
						Log:Debug("小退等待 300 秒 后登录")
						print("|cFF00FF00 Logout and waiting for 300 senconds to login.")
						ReturnToSelectCharacterScreen(305)
						__waittime = wt
					else
						if wt <= 300 then
							wt = 305
						end
						__waittime = wt
						
						if UI:Setting('副本内等待重置时间') then
							Log:Debug("等待 "..tostring(wt-305).." 秒 后小退")
							Wait((wt-305) * 1000)
							Log:Debug("小退等待 300 秒 后重登")
							print("|cFF00FF00 Logout and waiting for 300 senconds to login.")
							ReturnToSelectCharacterScreen(305)
						else
							Log:Debug("小退等待 "..tostring(wt).." 秒 后重登")
							print("|cFF00FF00 Logout and waiting for "..tostring(wt).." senconds to login.")
							ReturnToSelectCharacterScreen(wt)
						end
					end
				end},
			{If = " JBMB:GetPlayer():DistanceTo(X,Y,Z) < 15 ", End = 1.2},
				{Delay = 1},
			{Loop = 1.2},
		{End = 1.1},
		{Delay = 3},
		{Run = function() print("|cFF00FF00 Login Game done.") end},
		{Delay = 1},
		{Run = function() Stealth() end},
		{If = "JBMB:GetPlayer():DistanceTo(X,Y,Z) < 20 ",End = "出本"},
			{Run = function() ForwardAutoRun(X,Y,Z) end},
			{Delay = 8},
		{Loop = "出本"},
		{Delay = 1},
		{Run = "ResetInstances()"},
		{Delay = 1}, 
--过副本门口

		{Delay = 1},
        {Replace = 'text1', Index = 1},		
		{Delay = 1},
		
--=================================================	
	
}


local text3 = {
    {Run = 'CastSpellByID(1787)'}, 	
    --{MoveTo = {7.6184, 1.6859, -0.9543,true}}, 
		
	{Replace = 'text4', Index = 1},
}
-- 出本等待

local text4 = {
 	    {Delay=5},
	{Replace = 'text6', Index = 1},
}

-- 卡死包满售卖
local text5 = {

	--设置与障碍物宽度间距
	{Settings = 'agentRadius' , value = 2},
	--不使用坐骑
	{Settings='UseMount',value=true,},

	   {Log='Info',Text="去维修售卖"},
       {If = "JBMB:GetPlayer().FactionGroup ~= 'Horde'",End = 333 },
			{MoveTo = {X,Y,Z,true},},
			--对话修理售卖npc
			{UnitInteract = 22227 },
			{Delay = 15},
			--去邮箱
			{MoveTo = {X,Y,Z,true},},
			{ObjInteract = 181380},
			{Delay = 1},
			{ObjInteract = 181380},
			{Delay = 1},
			{Run = function()  
					RunMacroText("/click OpenAllMail")
				end},
			{Delay = 5},
			--补充闪光粉
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
			{UnitInteract = 18802 },
            {Gossip = "vendor"},
			{Delay = 1},
			{Run = function() BuyFlashPowder(80) end},
			{Delay = 2},
			
			{Run = function()
					local wt=0
					if DungeonTimer.MaxTime and DungeonTimer.StartTime then
						wt = math.floor(DungeonTimer.MaxTime - (GetTime() - DungeonTimer.StartTime))
					else
						wt = 0
					end
					if wt > 0 then
						wt = wt - 60
						if wt > 0 then
							Log:Debug("等待 "..tostring(wt).." 秒 后继续")
							print("|cFF00FF00 Waiting for "..tostring(wt).." senconds to continue.")
							Wait(wt * 1000)
						end
					end
				end},
			{Log='Info',Text="去副本联盟"},
			{Replace = 'text1', Index = 1},
       {End = 333 },

       {If = "JBMB:GetPlayer().FactionGroup == 'Horde'",End = 666 },
			{Log='Info',Text="去售卖"},
			{MoveTo = {X,Y,Z,true},},

			--对话修理售卖npc
			{UnitInteract = 22225},
			{Delay = 15},
			--去邮箱
			{MoveTo = {X,Y,Z,true},},
			{ObjInteract = 181381},
			{Delay = 1},
			{Run = function()  
					RunMacroText("/click OpenAllMail")
				end},
			{Delay = 5},
			--补充闪光粉
			{MoveTo = {X,Y,Z, true},},
			{UnitInteract = 16588},
            {Gossip = "vendor"},
			{Delay = 1},
			{Run = function() BuyFlashPowder(80) end},
			{Delay = 1},
			
			{Run = function()
					local wt=0
					if DungeonTimer.MaxTime and DungeonTimer.StartTime then
						wt = math.floor(DungeonTimer.MaxTime - (GetTime() - DungeonTimer.StartTime))
					else
						wt = 0
					end
					if wt > 0 then
						wt = wt - 60
						if wt > 0 then
							Log:Debug("等待 "..tostring(wt).." 秒 后继续")
							print("|cFF00FF00 Waiting for "..tostring(wt).." senconds to continue.")
							Wait(wt * 1000)
						end
					end
				end},
			{Log='Info',Text="去副本部落"},
			
			{Replace = 'text1', Index = 1},
	   {End = 666 },
}	   

-- 炉石包满和修理售卖
local text6 = {

	--设置与障碍物宽度间距
	{Settings = 'agentRadius' , value = 2},
	--不使用坐骑
	{Settings='UseMount',value=true,},
	    {Log='Info',Text="去售卖"},
           {MoveTo = {X,Y,Z,true},},	 
 	       {MoveTo = {X,Y,Z,true},},
           --对话修理售卖npc
           {UnitInteract = 20986},
		   {Delay = 10},

	    {If = "(GetScriptUISetting('包满拍卖物品') and _CanUseHearthstone()) and (CalculateTotalNumberOfFreeBagSlots() < 25 or GetItemCount(23436,false,false) >= 10 or GetItemCount(23437,false,false) >= 10 or GetItemCount(23438,false,false) >= 10 or GetItemCount(23439,false,false) >= 10 or GetItemCount(23440,false,false) >= 10 or GetItemCount(23441,false,false) >= 10)" ,End = '去拍卖' },	
		   {Run = function() --关闭所有战斗循环
			SetDMWHUD('Rotation',false) 
			end},
			{Settings = 'CombatLoopAutoBuff' , value = true},
			-- 自动战斗，追击，检取开关
			{Settings = 'CombatIngSwitch' , value = false},
			--关闭自动吃喝判断
			{Settings = 'AutoDrinkFood' , value = false},
			--关闭自动吃
			{Settings = 'UseFood' , value = false},
			--关闭自动喝
			{Settings = ' UseDrink' , value = false},
			--关闭自动复活
			{Settings = 'AutoRetrieve' , value = true},
			--关闭自动休息
			{Settings = 'AutoRest' , value = false},
			--不使用坐骑
			{Settings='UseMount',value=true,},
		    {If = "JBMB:GetPlayer().mapID == 1952",End = '去沙塔斯' },
			{Log='Info',Text = "去沙塔斯传送门"},
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
		    {MoveTo = {X,Y,Z,true},},
            {End = '去沙塔斯' },
            {If = "JBMB:GetPlayer().mapID == 1955 or JBMB:GetPlayer().mapID == 1458 or JBMB:GetPlayer().mapID == 1455",End = '点门去拍卖' },
            {Run = function() 
				print('去拍卖')
				_GoToAuction(Bot) 
			end}, 
            {End = '点门去拍卖' },
        {End = '去拍卖' },

	   {Log='Info',Text="去副本"},
       {MoveTo = {X,Y,Z,true},},	 
       {MoveTo = {X,Y,Z,true},},	   
       {Replace = 'text1', Index = 1},
 
}



local Locals = GetLocals()
-- 自订被传送的动作
Locals.GMTPHandler = function()
    --测试
	local x,y,z = JBMB:GetPlayer().Position:GetXYZ()
	if JBMB:GetPlayer():DistanceTo(X,Y,Z) < 8 and z > 68 and z < 69 then
		print('被传送了')
		JBMB:StopMoving()
		--测试传送以后输出10次时间
		for i = 1, 3 do
			TTOCDelay(1)
		end
		Stealth()
		TurnLeftStart()
		Wait(300)
		TurnLeftStop()
		Wait(500)
		TurnRightStart()
		Wait(1400)
		TurnRightStop()
		Wait(1200)
		JBMB.MoveTo(X,Y,Z)
		Wait(2500)
		JBMB:StopMoving()
		Wait(1200)
		TurnRightStart()
		Wait(400)
		TurnRightStop()
		Wait(500)
		TurnLeftStart()
		Wait(1300)
		TurnLeftStop()
		Wait(1200)
		x,y,z = JBMB:GetRandomPosition(X,Y,Z,5)
		if x and y then
			if JBMB:GetPlayer():DistanceTo(x,y,z) < 25 then
				JBMB.FaceDirection(x, y, z, true)
				JBMB.MoveTo(x, y, z)
				Wait(1000)
			end
		end
		MoveForwardStart()
		while JBMB:GetPlayer():DistanceTo(x,y,z) < 30 do 
			if JBMB:GetPlayer():DistanceTo(x,y,z) < 3 then
				break
			end
			Wait(100)
		end
		MoveForwardStop()
		JBMB:StopMoving()
		local n = math.random(1,3)
		for i=1,n do 
			TurnRightStart()
			Wait(math.random(500,800))
			TurnRightStop()
			Wait(math.random(300,1500))
			TurnLeftStart()
			Wait(math.random(500,800))
			TurnLeftStop()
			Wait(math.random(300,1500))
		end
		Wait(math.random(300,1500))
		if JBMB:GetPlayer():DistanceTo(x,y,z) < 15 then
			JBMB.FaceDirection(X,Y,Z, true)
			MoveForwardStart()
			while JBMB:GetPlayer():DistanceTo(X,Y,Z) < 30 do 
				if JBMB:GetPlayer():DistanceTo(X,Y,Z) < 3 then
					break
				end
				Wait(100)
			end
			MoveForwardStop()
			JBMB:StopMoving()
			Stealth()
		end
		n = math.random(1,3)
		for i=1,n do 
			TurnRightStart()
			Wait(math.random(500,800))
			TurnRightStop()
			Wait(math.random(300,1500))
			TurnLeftStart()
			Wait(math.random(500,800))
			TurnLeftStop()
			Wait(math.random(300,1500))
		end
		Wait(math.random(300,1500))
		if JBMB:GetPlayer():DistanceTo(x,y,z) < 20 then
			JBMB.FaceDirection(X,Y,Z, true)
			MoveForwardStart()
			while JBMB:GetPlayer():DistanceTo(X,Y,Z) < 30 do 
				if JBMB:GetPlayer():DistanceTo(X,Y,Z) < 3 then
					break
				end
				Wait(100)
			end
			MoveForwardStop()
			JBMB:StopMoving()
		end
		if JBMB:GetPlayer():DistanceTo(x,y,z) < 30 then
			n = math.random(3,8)
			for i=1,n do 
				StrafeLeftStart()
				Wait(math.random(300,800))
				StrafeLeftStop()
				Wait(math.random(300,1500))
				StrafeRightStart()
				Wait(math.random(500,800))
				StrafeRightStop()
				JBMB:StopMoving()
				Wait(math.random(300,800))
			end
			Wait(math.random(300,1500))
		end
		n = math.random(3,6)
		for i=1,n do 
			TurnRightStart()
			Wait(math.random(500,800))
			TurnRightStop()
			Wait(math.random(300,1500))
			TurnLeftStart()
			Wait(math.random(500,800))
			TurnLeftStop()
			Wait(math.random(300,1500))
		end
		JBMB:StopMoving()
		Wait(math.random(300,1500))
		Log:Debug("处理完毕，等待传回")
		for i=1,120 do
			if JBMB:GetPlayer():DistanceTo(x,y,z) < 30 then
				TTOCDelay(1)
			else
				break
			end
		end
		if JBMB:GetPlayer():DistanceTo(x,y,z) > 30 then
			Locals.GMTPReturnHandler()
		end
		-- 告诉框架停止其他操作，等待回传
		--Locals.WaitGMTP = true
		--  告诉框架结束任务
	end
    return true
end

-- 自订被传回的动作
Locals.GMTPReturnHandler = function()
    --测试 
	Log:Debug("被传回了。I'm came back~!")
    --测试传送以后输出10次时间
	Log:Debug("等待2分钟。Waiting 2 minutes")
    for i = 1, 120 do
        TTOCDelay(1)
    end
	Log:Debug("处理完毕，继续执行")
    -- 告诉框架结束任务
    return true
end

---自定义判断被传送处理

function GMTPCheck()
	local x,y,z = JBMB:GetPlayer().Position:GetXYZ()
	if JBMB:GetPlayer():DistanceTo(X,Y,Z) < 8 and z > 68 and z < 69 then
		print('被传送了')
		--测试传送以后输出10次时间
		for i = 1, 3 do
			TTOCDelay(1)
		end
		Stealth()
		TurnLeftStart()
		Wait(300)
		TurnLeftStop()
		Wait(500)
		TurnRightStart()
		Wait(1400)
		TurnRightStop()
		Wait(1200)
		JBMB.MoveTo(X,Y,Z)
		Wait(1200)
		JBMB:StopMoving()
		Wait(1200)
		TurnRightStart()
		Wait(400)
		TurnRightStop()
		Wait(500)
		TurnLeftStart()
		Wait(1300)
		TurnLeftStop()
		Wait(1200)
		x,y,z = JBMB:GetRandomPosition(X,Y,Z,5)
		
		if x and y then
			JBMB.FaceDirection(x, y, z, true)
			JBMB.MoveTo(x, y, z)
			Wait(1000)
		end
		MoveForwardStart()
		while JBMB:GetPlayer():DistanceTo(x,y,z) < 30 do 
			if JBMB:GetPlayer():DistanceTo(x,y,z) < 3 then
				break
			end
			Wait(100)
		end
		MoveForwardStop()
		JBMB:StopMoving()
		local n = math.random(1,3)
		for i=1,n do 
			TurnRightStart()
			Wait(math.random(500,800))
			TurnRightStop()
			Wait(math.random(300,1500))
			TurnLeftStart()
			Wait(math.random(500,800))
			TurnLeftStop()
			Wait(math.random(300,1500))
		end
		Wait(math.random(300,1500))
		if JBMB:GetPlayer():DistanceTo(x,y,z) < 15 then
			JBMB.FaceDirection(X,Y,Z, true)
			MoveForwardStart()
			while JBMB:GetPlayer():DistanceTo(X,Y,Z) < 30 do 
				if JBMB:GetPlayer():DistanceTo(X,Y,Z) < 3 then
					break
				end
				Wait(100)
			end
			MoveForwardStop()
			JBMB:StopMoving()
			Stealth()
		end
		n = math.random(1,3)
		for i=1,n do 
			TurnRightStart()
			Wait(math.random(500,800))
			TurnRightStop()
			Wait(math.random(300,1500))
			TurnLeftStart()
			Wait(math.random(500,800))
			TurnLeftStop()
			Wait(math.random(300,1500))
		end
		Wait(math.random(300,1500))
		if JBMB:GetPlayer():DistanceTo(x,y,z) < 20 then
			JBMB.FaceDirection(X,Y,Z, true)
			MoveForwardStart()
			while JBMB:GetPlayer():DistanceTo(X,Y,Z) < 30 do 
				if JBMB:GetPlayer():DistanceTo(X,Y,Z) < 3 then
					break
				end
				Wait(100)
			end
			MoveForwardStop()
			JBMB:StopMoving()
		end
		if JBMB:GetPlayer():DistanceTo(x,y,z) < 30 then
			n = math.random(3,8)
			for i=1,n do 
				StrafeLeftStart()
				Wait(math.random(300,800))
				StrafeLeftStop()
				Wait(math.random(300,1500))
				StrafeRightStart()
				Wait(math.random(500,800))
				StrafeRightStop()
				JBMB:StopMoving()
				Wait(math.random(300,800))
			end
			Wait(math.random(300,1500))
		end
		n = math.random(3,6)
		for i=1,n do 
			TurnRightStart()
			Wait(math.random(500,800))
			TurnRightStop()
			Wait(math.random(300,1500))
			TurnLeftStart()
			Wait(math.random(500,800))
			TurnLeftStop()
			Wait(math.random(300,1500))
		end
		JBMB:StopMoving()
		Wait(math.random(300,1500))
		Log:Debug("处理完毕，等待传回")
		for i=1,120 do
			if JBMB:GetPlayer():DistanceTo(x,y,z) < 30 then
				TTOCDelay(1)
			else
				break
			end
		end
	end	
end
-- 设定档 off
local settings = {
    -- 战斗循环自动buff
    CombatLoopAutoBuff = false,
	-- 自动战斗，追击，检取开关
    CombatIngSwitch = false,
	--关闭自动吃喝判断
    AutoDrinkFood = false,
	--关闭自动吃
	UseFood = false,
	--关闭自动喝
	UseDrink = false,
	--关闭自动复活
    AutoRetrieve = false,
	--关闭自动换装
    AutoEquip = false,
	--关闭自动休息
    AutoRest = false,
	--卡住事件
	StuckEvent = true,
	--传送
    TPEvent = true,
    -- 使用短距离传送提示
    UseShortTPBeep = true,
}


-- 存放尸体路径
local Corpse = {}
-- 存放水中尸体上方路径
local waterCorpse = {}
-- 获得尸体地址
function CorpseAddress()
	Wait(2000)
	print('跑尸体')
	x, y, z = JBMB.GetCorpsePosition()
	Corpse[1] = x
	Corpse[2] = y
	Corpse[3] = z
	_dis_ = getDistance2D(-360.0498,3067.8955, x, y)
	if JBMB:PathInWater(x,y,z) then
		x, y, z = JBMB:PathInWater(x,y,z)
		waterCorpse[1] = x
		waterCorpse[2] = y
		waterCorpse[3] = z
		_inwater_ = false
	end
	return _dis_ < 1
end
-- 与尸体距离
function CorpseDisease()
	if #Corpse > 0 then 
		local p = JBMB:GetPlayer()
		p:Update()
		local x, y, z = unpack(Corpse)
		local X, Y, Z = p.PosX, p.PosY, p.PosZ
		return JBMB.GetDistanceBetweenPositions(x, y, z, X, Y, Z)
	end
    return 0
end
-- 与地牢水面距离
function upWaterDisease()
	local p = JBMB:GetPlayer()
		p:Update()
		local X, Y, Z = p.PosX, p.PosY, p.PosZ
		return JBMB.GetDistanceBetweenPositions(X,Y,Z, X, Y, Z)
end
-- 下潜水洞路径
local WaterCave = {
}
-- 尸体是否在水洞
function InWaterCave()
	--print('#Corpse > 0',#Corpse > 0)
	if #Corpse > 0 then 
		for i,v in ipairs(WaterCave) do
			local x, y, z = unpack(Corpse)
			local X, Y, Z, dis  = unpack(v)
			--print(i,JBMB.GetDistanceBetweenPositions(x, y, z, X, Y, Z))
			--print(i,JBMB:PathIsBlocked(x, y, z, X, Y, Z))
			if JBMB.GetDistanceBetweenPositions(x, y, z, X, Y, Z) < dis and 
			not JBMB:PathIsBlocked(x, y, z, X, Y, Z) then
				return true
			end
		end
	end
    return false
end

--导航找尸体路线
local RunCorpse = {
    {Delay = 5},
	{Settings='StuckEvent',value=true,},

    ------------------------------------------------------我是部落
	{If = CorpseAddress , End = '尸体在副本'},
	    {If = "JBMB:GetPlayer().FactionGroup == 'Horde'",End = '部落跑尸' },
            {Run = "print('部落尸体在副本')"},
            --关闭自动复活
            {Settings = 'AutoRetrieve' , value = false},
	    	{If = "GetScriptUISetting('死亡重置副本')",End = '死亡重置副本1' },
                {Run = "ResetInstances()"},
	        {End = '死亡重置副本1'},
	        --进本
     
	    	{Delay = 1},
	    	{MoveTo = {X,Y,Z,true},},
	    	{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
	    	{Run = function()
	    		if StaticPopup1 and StaticPopup1:IsVisible() and StaticPopup1Button1 and StaticPopup1Button1:IsEnabled() then
	    			RetrieveCorpse()
	    		end
	    	end},
            {Run = 'roadcount = math.random(1,4)'},
            
			{If = "roadcount == 1",End = '进本01'},
			--{Log='Info',Text="1"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本01'},
			{If = "roadcount == 2",End = '进本02'},
			--{Log='Info',Text="2"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本02'},
			{If = "roadcount == 3",End = '进本03'},
			--{Log='Info',Text="3"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},	
			{End = '进本03'},
			{If = "roadcount == 4",End = '进本04'},
			--{Log='Info',Text="3"},			  	
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本04'},
		  
			{Run = "print('等待切换地图成功')"}, 
			{If = " not WaitInDungeon and JBMB:GetPlayer().mapID ~= 543", End = "等待进本"},
				{Delay = 1},
			{Loop = "等待进本"},
			{Delay = 1},
	    	   
	    	--{MoveTo = {-364.7054, 3082.9756, -14.7021,true},},
     
	    	 {Run = "ReplaceScriptQuest('text2', 1)"},
	    	 --{Replace = "text"},
	    {End = '部落跑尸'},
    
    
	    -------------------------------------------------------我是联盟
	    {If = "JBMB:GetPlayer().FactionGroup ~= 'Horde'",End = '联盟跑尸' },
	    	{Run = "print('联盟尸体在副本')"},
            --关闭自动复活
            {Settings = 'AutoRetrieve' , value = false},
	    	{If = "GetScriptUISetting('死亡重置副本')",End = '死亡重置副本1' },
	    	{Run = "ResetInstances()"},
    
	    	{End = '死亡重置副本1'},
	        --进本
      
	    	{Delay = 1},
	    	{MoveTo = {X,Y,Z,true},},
	    	{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},
			{MoveTo = {X,Y,Z,true},},	
	    	{Run = function()
	    		if StaticPopup1 and StaticPopup1:IsVisible() and StaticPopup1Button1 and StaticPopup1Button1:IsEnabled() then
	    			RetrieveCorpse()
	    		end
	    	end},
            {Run = 'roadcount = math.random(1,4)'},
            
			{If = "roadcount == 1",End = '进本01'},
			--{Log='Info',Text="1"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本01'},
			{If = "roadcount == 2",End = '进本02'},
			--{Log='Info',Text="2"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本02'},
			{If = "roadcount == 3",End = '进本03'},
			--{Log='Info',Text="3"},
			{Run = function() JBMB.MoveTo(X,Y,Z) end},	
			{End = '进本03'},
			{If = "roadcount == 4",End = '进本04'},
			--{Log='Info',Text="3"},			  	
			{Run = function() JBMB.MoveTo(X,Y,Z) end},
			{End = '进本04'},
		  
			{Run = "print('等待切换地图成功')"}, 
			{If = " not WaitInDungeon and JBMB:GetPlayer().mapID ~= 543", End = "等待进本"},
				{Delay = 1},
			{Loop = "等待进本"},
			{Delay = 1},
	    	{Run = "ReplaceScriptQuest('text2', 1)"},
        {End = '联盟跑尸'},
	{End = '尸体在副本'},


	{If = not CorpseAddress , End = '尸体在副本外'},
		{Run = 'print("尸体在副本外")'},
		{Settings = 'agentRadius' , value = 2},
				--判定是否需要重置副本		
		{If = "GetScriptUISetting('死亡重置副本')",End = '死亡重置副本2' },
		    {Run = "ResetInstances()"},
		{End = '死亡重置副本2'},
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
		{MoveTo = {X,Y,Z,true},},
		{Run = "ReplaceScriptQuest('text1', 1)"},
	{End = '尸体在副本外'},
      
	{Run= "print('尸体去哪了?这不该发生')"},
	{Log='Info',Text="停止脚本"},
    {Run = 'StopScriptBot()'},
	{Run = "ReplaceScriptQuest('text1', 1)"},
}

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

tmpename = ""
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
Bot:AddQuest('RunCorpse',RunCorpse)

Bot:AddQuest('text',text)
--加入脚本
Bot:AddQuest('text1',text1)
--加入脚本
Bot:AddQuest('text2',text2)
--加入脚本
Bot:AddQuest('text3',text3)
--加入脚本
Bot:AddQuest('text4',text4)
--加入脚本
Bot:AddQuest('text5',text5)
--加入脚本
Bot:AddQuest('text6',text6)
--设定第一个执行的脚本
Bot:SetFirstQuest('text')

Bot:SetStart(function()
    Config:Hide()
      Log:System('---------')
      Log:System("盗贼-地狱火城墙")
      Log:System('---------')	
      Log:System("脚本启动")
      Log:System('---------')	
	  
      if not frame then
        frame = CreateFrame('Frame', nil, UIParent)
        frame:SetScript('OnEvent', frameOnEvent)
      end
      frame:RegisterEvent('LOOT_OPENED')
      frame:RegisterEvent('LOOT_CLOSED')
      frame:RegisterEvent('CHAT_MSG_SYSTEM')
      frame:RegisterEvent('CHAT_MSG_PARTY')
      frame:RegisterEvent('CHAT_MSG_PARTY_LEADER')	  	  
	  JBMB:SetNoClip(0)
      --动作
      ACCheck(true)
      --传送
      TPCheck(true)
 	  --自动调整帧数
	   SetCVar("maxFPS", 50)
	   SetCVar("maxFPSBk", 50)
       SetDMWHUD('Rotation',false)
	   --进入战斗提示
	  CombatingPrint(true)
      Log:System('---------')
      SetPulseTime(0.05)
	        --最先加载的线程初始化
			local LearnThisTalentList = {}
	        --最先加载的线程初始化
			if JBMB:GetPlayer().Class=='ROGUE' then
				LearnThisTalentList = {
					{301, 1},-- 五点欺诈高手
					{301, 2},-- 五点欺诈高手
					{301, 3},-- 五点欺诈高手
					{301, 4},-- 五点欺诈高手
					{301, 5},-- 五点欺诈高手
					{305, 1},-- 五点伪装
					{305, 2},-- 五点伪装
					{305, 3},-- 五点伪装
					{305, 4},-- 五点伪装
					{305, 5},-- 五点伪装
					{303, 1},-- 2点狡诈 
					{303, 2},-- 2点狡诈 
					{304, 1},-- 2点邪恶计谋
					{304, 2},-- 2点邪恶计谋
					{307, 1},-- 1点鬼魅攻击
					{309, 1},-- 3点调整
					{309, 2},-- 3点调整 
					{309, 3},-- 3点调整
					{310, 1},-- 2点飘忽不定
					{310, 2},-- 2点飘忽不定
					{312, 1},-- 2点察觉
					{312, 2},-- 2点察觉
					{313, 1},-- 1点伺机待发
					{314, 1},-- 2点卑鄙
					{314, 2},-- 2点卑鄙
					{316, 1},-- 三点敏锐大师
					{316, 2},-- 三点敏锐大师
					{316, 3},-- 三点敏锐大师
					{317, 1},-- 2点致命
					{317, 2},-- 2点致命
					{318, 1},-- 三点附体之影
					{318, 2},-- 三点附体之影
					{318, 3},-- 三点附体之影
					{319, 1},-- 1点预谋
					{320, 1},-- 三点装死
					{320, 2},-- 三点装死
					{320, 3},-- 三点装死
					{321, 1},-- 5点邪恶召唤
					{321, 2},-- 5点邪恶召唤
					{321, 3},-- 5点邪恶召唤
					{321, 4},-- 5点邪恶召唤
					{321, 5},-- 5点邪恶召唤
					{322, 1},-- 1点暗影步
					{203, 1},-- 5点闪电反射
					{203, 2},-- 5点闪电反射
					{203, 3},-- 5点闪电反射
					{203, 4},-- 5点闪电反射
					{203, 5},-- 5点闪电反射
					{205, 1},-- 5点偏斜
					{205, 2},-- 5点偏斜
					{205, 3},-- 5点偏斜
					{205, 4},-- 5点偏斜
					{205, 5},-- 5点偏斜
				}
		  end
      SetSettings({
            LearnThisTalent = LearnThisTalentList,
			--不输出
			NoPrint = {'Delay',},
			--卡住事件
			StuckEvent = true,
            --自动学天赋
            LearnTalent = true,
            --寻路导航间隔
            ReachDistance = 1.8,
            --售卖完了回到原位
            GotoOriginalAddress = false,
            --自动拒绝组公会邀请
            AutoDeclineGuild = true,
            --自动拒绝组组队邀请
            AutoDeclineGroup = true,
            --自动拒绝决斗邀请
            AutoDeclineDuel = true,
            --开启可以点停止按键,点开始就是点继续,防止傻子点错,中止行程变成重新开始
            ReButtonOnClick =true,
            --设定距离障碍物范围1～5
            agentRadius = 0.5,
            --使用食物
            UseFood = false,
            --使用饮料
            UseDrink = false,
            --開啟自動休息，不吃藥
            AutoRest = false,
            --找怪范围
            SearchRadius = 100,
            --贩卖低于等于颜色等级的
            SellbelowLevel=false,
            --不攻击等级低于自身等级多少以下的怪物
            NotAttackFewLevelsMonster= 5,
            --开启使用坐骑
            UseMount=true,
            --不走水路,假是不走水路,真是走水路
            WalkWater =true,
            --自动拾取
            AutoLoot = true,
            --勾选后，所有食物都吃,把包内食物/饮料吃完才会触发回城，不用设定FoodName与DrinkName
            EatAll = false,
            --是否判断回城事件
            GoHomeEvent = false,
            --恢复生命值范围
            FoodPercent = {90 ,95 ,},
            --恢复法力值范围
            DrinkPercent = {90 ,95 ,},
            --使用炉石
            UseHearthStone = false,
            --当背包空格小于等于多少时触发回城
            MinFreeBagSlotsToGoToTown = 6,
            --当装备耐久度小于等于%多少时触发回城
            MinDurabilityPercent = 0,
            --当弹药数量少于多少时触发回城
            AmmoAmountToGoToTown = 0,
            --贩卖颜色等级0~8
            SellLevel = {[0] = true,[1] = true,[2] = true,[3] = true,},
            --不贩卖列表 {id,id,id
            DoNotSellList = {'Rune of','传送','Hearthstone','炉石','Primal','源生','Mote of','微粒','Air','空气','基尔加丹印记',"Mark of Kil'jaeden","Thieves'Tools",'潜行者工具','Flash Powder','闪光粉','红曜石','Living Ruby','黎明石','Dawnstone','黄晶玉','Noble Topaz','夜目石','Nightseye','矿石','Ore','矿工锄','Mining Pick',6657,},
            --强制贩卖列表 {id,id,id
            ForceSellList = {'亚麻布','玛格汉面包','熏烤塔布羊排','毛料','丝绸','魔纹布','符文布','硬肉干','清凉的泉水','血岩碎片','森林蘑菇','Linen Cloth','Wool Cloth','Silk Cloth','Mageweave Cloth','Runecloth','Tough Jerky','Refreshing Spring Water','Blood Shard','Forest Mushroom Cap',13444,13446,},
            --强制销毁
            ForceDeleteList = {'秘教的命令','Cabal Orders','OOX'},
            --是否反击
            Counterattack = false,
            --自动换装
            AutoEquip = false,
            --输出信息写入Log
            WriteLog = false,
            --复活距离
            RetrieveDis = 1,
            --购买最好
            Buybest = false,
            --食物数量
            FoodAmount = 0,
            --饮料数量
            DrinkAmount = 0,
            -- 战斗循环自动buff
            CombatLoopAutoBuff = false,
            -- 自动战斗，追击，检取开关
            CombatIngSwitch = false,
            -- 自动吃喝
            AutoDrinkFood = false,
            --使用坐骑不攻击与反击
            UseMountWhenNotattack = true,
            --回家时不反击
            GoHomeNotattack = true,
            --下马距离
            DismountDistance = 1,
            --自动复活
            AutoRetrieve = false,
            --回城坐标
            BuyNPC = {},
            --自动使用卷轴
            AutoUseScroll = false,
            --副本出入口不传送
            TPExceptPath = {
                  --黑暗之门
				  {-3072.0762, 4942.4873, -101.0470},
				  {-364.7054, 3082.9756, -14.7021},
				  {-305.9259, 3167.2961, 30.9376},
				  {8.6220, -09.2583, -2.7565},
				  {-248.1130, 922.9000, 84.3497},
				  {-11908.6611, -3208.0249, -14.8124},
				  {-3086.5100, 4942.4302, -101.0470},
				  {7.6184, 1.6859, -0.9543},
				  {-3081.8826, 4942.6245, -101.0470},
				  {7.0860, 0.9973, -0.9543},
				{-1357.2795, 1636.7310, 67.6398},
				{-364.5295, 3082.1545, -14.7270},
            },
			--不上坐骑
            NotUseMountPath = {
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
			   --萨尔玛
			   --{139.6259, 2668.5496,  distance = 50 , mapID = 1944},
			   --地狱火城墙
			   {-360.8565, 3076.6018,  distance = 30 , mapID = 1944},
			   --熔炉
			   {-305.9259, 3167.2961,  distance = 50 , mapID = 1944},
		 },
			 --设置间距
		 agentRadiusPath  = {
			   {1341.9160, -4647.4360,  distance = 40, agentRadius = 1 , mapID = 1411},
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
			   {-4800.1255, -1106.3363,  distance = 3000, agentRadius = 0.7 , mapID = 1455},
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
			 },
      })
	    if UI:Setting('只报警GM警报') then
            SetSettings({
                --报警储存
			    BeepSound = {
                    --GM密语
                    GMMES = GetBeepPath('GM私密警报.wav'),
                    --GM TP
                    GMTP = GetBeepPath('GM传送警报.wav'),
                    --GM短距离TP
                    GMShortTP = GetBeepPath('GM短距离传送警报.wav'),
                    --其他密语
                    MES = GetBeepPath(),
                    --玩家攻击
                    PlayerAttack = GetBeepPath(),
                    --交易
                    Trade = GetBeepPath(),
                     },
        })
        else 
            SetSettings({
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
            })
        end
end)

--定义复活
Bot:SetPulse(function(Bots) 
	if IsDead() then  
		DeadEvent()
	end
	if StaticPopup1 and StaticPopup1:IsVisible() and
	(StaticPopup1.which == "DEATH" or StaticPopup1.which == "XP_LOSS_NO_SICKNESS")and
	StaticPopup1Button1 and
	StaticPopup1Button1:IsEnabled() then
		player:Update()
		_mapID_ = player.mapID
		TTOCDelay(2)
		JBMB:SetNoClip(0)
		JBMB:SetFloating(false)
		TTOCDelay(2)
		print('BotTaskClear')
		BotTaskClear()
		ReleaseCorpse() 
        SetDMWHUD('Rotation',false)		
	end
	if JBMB:GetPlayer():DistanceTo(-1316.0006, 1634.6033, 91.7453) > 60 and JBMB:GetPlayer().Combating and JBMB:GetPlayer().mapID == 543 then  
		combat()
	end
	Bots.QuestScriptPulse(Bots)	
end)

Bot:SetStop(function()
	--进入战斗提示
	CombatingPrint(false)
	--关闭浮空穿墙
	JBMB:SetNoClip(0)
    Log:System('---------')
    Log:System("盗贼-地狱火城墙")
    Log:System('---------')	
    Log:System("脚本停止")
    Log:System('---------')	
	if frame then
        frame:UnregisterEvent('LOOT_OPENED')
        frame:UnregisterEvent('LOOT_CLOSED')
        frame:UnregisterEvent('CHAT_MSG_SYSTEM')
        frame:UnregisterEvent('CHAT_MSG_PARTY')
        frame:UnregisterEvent('CHAT_MSG_PARTY_LEADER')
    end
end)

return Bot