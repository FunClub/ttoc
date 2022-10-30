local Bot = TTOCInitScript("采集模板")
local Log = Bot.Log
local Config = Bot.Config
local UI = Bot.UI
local TTOC = ...
CJMB = TTOC
--定义草药名字统一
SKILL_HERB = 'Herbalism'
SKILL_ORE = 'Mining'
if (GetLocale() == "zhCN") then
   SKILL_HERB = '草药学'
   SKILL_ORE = '采矿'
end 

local getheBlackList = {
      [3724] = {Name = "宁神花", SkillReq = 0},
      [1618] = {Name = "宁神花", SkillReq = 0},
      [1617] = {Name = "银叶草", SkillReq = 0},
      [3725] = {Name = "银叶草", SkillReq = 0},
      [1619] = {Name = "地根草", SkillReq = 15},
      [3726] = {Name = "地根草", SkillReq = 15},
      [1620] = {Name = "魔皇草", SkillReq = 50},
      [3727] = {Name = "魔皇草", SkillReq = 50},
      [1621] = {Name = "石南草", SkillReq = 70},
      [3729] = {Name = "石南草", SkillReq = 70},
      [2045] = {Name = "荆棘藻", SkillReq = 85},
      [1622] = {Name = "跌打草", SkillReq = 100},
      [3730] = {Name = "跌打草", SkillReq = 100},
      [1623] = {Name = "野钢花", SkillReq = 115},
      [1628] = {Name = "墓地苔", SkillReq = 120},
      [1624] = {Name = "皇血草", SkillReq = 125},
      [2041] = {Name = "活根草", SkillReq = 150},
      [2042] = {Name = "枯叶草", SkillReq = 160},
      [2046] = {Name = "金棘草", SkillReq = 170},
      [2043] = {Name = "卡德加的胡须", SkillReq = 185},
      [2044] = {Name = "龙齿草", SkillReq = 195},
      [2866] = {Name = "火焰花", SkillReq = 205},
      [142140] = {Name = "紫莲花", SkillReq = 210},
      [180165] = {Name = "紫莲花", SkillReq = 210},
      [142141] = {Name = "阿尔萨斯之泪", SkillReq = 220},
      [176642] = {Name = "阿尔萨斯之泪", SkillReq = 220},
      [142142] = {Name = "太阳草", SkillReq = 230},
      [176636] = {Name = "太阳草", SkillReq = 230},
      [180164] = {Name = "太阳草", SkillReq = 230},
      [142143] = {Name = "盲目草", SkillReq = 235},
      [183046] = {Name = "盲目草", SkillReq = 235},
      [142144] = {Name = "幽灵菇", SkillReq = 245},
      [142145] = {Name = "格罗姆之血", SkillReq = 250},
      [176637] = {Name = "格罗姆之血", SkillReq = 250},
      [180167] = {Name = "黄金参", SkillReq = 260},
      [176583] = {Name = "黄金参", SkillReq = 260},
      [176638] = {Name = "黄金参", SkillReq = 260},
      [180168] = {Name = "梦叶草", SkillReq = 270},
      [176584] = {Name = "梦叶草", SkillReq = 270},
      [176639] = {Name = "梦叶草", SkillReq = 270},
      [180166] = {Name = "山鼠草", SkillReq = 280},
      [176586] = {Name = "山鼠草", SkillReq = 280},
      [176640] = {Name = "山鼠草", SkillReq = 280},
      [176587] = {Name = "哀伤苔", SkillReq = 285},
      [176641] = {Name = "哀伤苔", SkillReq = 285},
      [176588] = {Name = "冰盖草", SkillReq = 290},
      [176589] = {Name = "黑莲花", SkillReq = 300},
      --------------矿物
      [2055] = {Name = "铜矿", SkillReq = 0},
      [181248] = {Name = "铜矿", SkillReq = 0},
      [1731] = {Name = "铜矿", SkillReq = 0},
      [103713] = {Name = "铜矿", SkillReq = 0},
      [3763] = {Name = "铜矿", SkillReq = 0},
      [1610] = {Name = "火岩矿脉", SkillReq = 65},
      [1667] = {Name = "火岩矿脉", SkillReq = 65},
      [103711] = {Name = "锡矿", SkillReq = 65},
      [3764] = {Name = "锡矿", SkillReq = 65},
      [2054] = {Name = "锡矿", SkillReq = 65},
      [181249] = {Name = "锡矿", SkillReq = 65},
      [1732] = {Name = "锡矿", SkillReq = 65},
      [2653] = {Name = "级血石矿脉", SkillReq = 75},
      [73940] = {Name = "软泥覆盖的银矿脉", SkillReq = 75},
      [105569] = {Name = "银矿", SkillReq = 75},
      [1733] = {Name = "银矿", SkillReq = 75},
      [1735] = {Name = "铁矿石", SkillReq = 125},
      [19903] = {Name = "精铁矿脉", SkillReq = 150},
      [181109] = {Name = "金矿", SkillReq = 155},
      [150080] = {Name = "金矿", SkillReq = 155},
      [1734] = {Name = "金矿", SkillReq = 155},
      [73941] = {Name = "软泥覆盖的金矿脉", SkillReq = 155},
      [2040] = {Name = "秘银矿脉", SkillReq = 175},
      [176645] = {Name = "秘银矿脉", SkillReq = 175},
      [150079] = {Name = "秘银矿脉", SkillReq = 175},
      [123310] = {Name = "软泥覆盖的秘银矿脉", SkillReq = 175},
      [165658] = {Name = "黑铁矿脉", SkillReq = 230},
      [123309] = {Name = "软泥覆盖的真银矿脉", SkillReq = 230},
      [2047] = {Name = "真银矿石", SkillReq = 230},
      [150081] = {Name = "真银矿石", SkillReq = 230},
      [123848] = {Name = "软泥覆盖的瑟银矿脉", SkillReq = 245},
      [176643] = {Name = "瑟银矿脉", SkillReq = 245},
      [324] = {Name = "瑟银矿脉", SkillReq = 245},
      [150082] = {Name = "瑟银矿脉", SkillReq = 245},
      [177388] = {Name = "软泥覆盖的富瑟银矿脉", SkillReq = 275},
      [175404] = {Name = "富瑟银矿", SkillReq = 275},
}
local getheBlackListInPath = {                                -------下面是要拉黑的黑名单坐标,自己起名字
      ['NAXX旁的黑莲花'] = {3151.2874,-3728.1858,133.6029},
      ['卡掉线的瘟疫花'] = {3113.6404,-3780.5166,130.5046},
}
--UI
if not UI:GetWidget('采集模板Header') then
      UI:AddHeader('采集模板')
      if not CJMB.IsSimpleVer() then
            UI:AddToggle('超级爬坡', 'Use Super Climb when collecting', false, 0.9)
      end
      if not UI:GetWidget('恢复范围') and CJMB:GetPlayer().Class == 'HUNTER' then
            UI:AddHeader('猎人恢复')
            UI:AddToggle('启动自定义恢复范围','启动自定义恢复范围',false)
            UI:AddRange('猎人生命%', '猎人恢复生命值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到猎人生命 %', '猎人恢复生命值终点站起来', 0, 100, 1, 85, 1.2)
            UI:AddRange('猎人法力%', '猎人恢复法力值起点', 0, 100, 1, 10, 1.2)
            UI:AddRange('到猎人法力 %', '猎人恢复法力值终点站起来', 0, 100, 1, 30, 1.2)
      elseif not UI:GetWidget('恢复范围') and CJMB:GetPlayer().Class == 'MAGE' then
            UI:AddHeader('法师恢复')
            UI:AddToggle('启动自定义恢复范围','启动自定义恢复范围',false)
            UI:AddRange('法师生命%', '法师恢复生命值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到法师生命 %', '法师恢复生命值终点站起来', 0, 100, 1, 85, 1.2)
            UI:AddRange('法师法力%', '法师恢复法力值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到法师法力 %', '法师恢复法力值终点站起来', 0, 100, 1, 85, 1.2)
      elseif not UI:GetWidget('恢复范围') and CJMB:GetPlayer().Class == 'ROGUE' then
            UI:AddHeader('盗贼恢复')
            UI:AddToggle('启动自定义恢复范围','启动自定义恢复范围',false)
            UI:AddRange('盗贼生命%', '盗贼恢复生命值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到盗贼生命 %', '盗贼恢复生命值终点站起来', 0, 100, 1, 85, 1.2)
      elseif not UI:GetWidget('恢复范围') and CJMB:GetPlayer().Class == 'PRIEST' then
            UI:AddHeader('牧师恢复')
            UI:AddToggle('启动自定义恢复范围','启动自定义恢复范围',false)
            UI:AddRange('牧师生命%', '牧师恢复生命值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到牧师生命 %', '牧师恢复生命值终点站起来', 0, 100, 1, 85, 1.2)
            UI:AddRange('牧师法力%', '牧师恢复法力值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到牧师法力 %', '牧师恢复法力值终点站起来', 0, 100, 1, 85, 1.2)
      elseif not UI:GetWidget('恢复范围') and CJMB:GetPlayer().Class == 'WARLOCK' then
            UI:AddHeader('术士恢复')
            UI:AddToggle('启动自定义恢复范围','启动自定义恢复范围',false)
            UI:AddRange('术士生命%', '术士恢复生命值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到术士生命 %', '术士恢复生命值终点站起来', 0, 100, 1, 85, 1.2)
            UI:AddRange('术士法力%', '术士恢复法力值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到术士法力 %', '术士恢复法力值终点站起来', 0, 100, 1, 85, 1.2)
      elseif not UI:GetWidget('恢复范围') and CJMB:GetPlayer().Class == 'DRUID' then
            UI:AddHeader('德鲁伊恢复')
            UI:AddToggle('启动自定义恢复范围','启动自定义恢复范围',false)
            UI:AddRange('德鲁伊生命%', '德鲁伊恢复生命值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到德鲁伊生命 %', '德鲁伊恢复生命值终点站起来', 0, 100, 1, 85, 1.2)
            UI:AddRange('德鲁伊法力%', '德鲁伊恢复法力值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到德鲁伊法力 %', '德鲁伊恢复法力值终点站起来', 0, 100, 1, 85, 1.2)
      elseif not UI:GetWidget('恢复范围') and CJMB:GetPlayer().Class == 'PALADIN' then
            UI:AddHeader('圣骑士恢复')
            UI:AddToggle('启动自定义恢复范围','启动自定义恢复范围',false)
            UI:AddRange('圣骑士生命%', '圣骑士恢复生命值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到圣骑士生命 %', '圣骑士恢复生命值终点站起来', 0, 100, 1, 85, 1.2)
            UI:AddRange('圣骑士法力%', '圣骑士恢复法力值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到圣骑士法力 %', '圣骑士恢复法力值终点站起来', 0, 100, 1, 85, 1.2)
      elseif not UI:GetWidget('恢复范围') and CJMB:GetPlayer().Class == 'SHAMAN' then
            UI:AddHeader('萨满恢复')
            UI:AddToggle('启动自定义恢复范围','启动自定义恢复范围',false)
            UI:AddRange('萨满生命%', '萨满恢复生命值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到萨满生命 %', '萨满恢复生命值终点站起来', 0, 100, 1, 85, 1.2)
            UI:AddRange('萨满法力%', '萨满恢复法力值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到萨满法力 %', '萨满恢复法力值终点站起来', 0, 100, 1, 85, 1.2)
      elseif not UI:GetWidget('恢复范围') and CJMB:GetPlayer().Class == 'WARRIOR' then
            UI:AddHeader('战士恢复')
            UI:AddToggle('启动自定义恢复范围','启动自定义恢复范围',false)
            UI:AddRange('战士生命%', '战士恢复生命值起点', 0, 100, 1, 80, 1.2)
            UI:AddRange('到战士生命 %', '战士恢复生命值终点站起来', 0, 100, 1, 85, 1.2)      
      end

      UI:AddHeader('采集座标黑名单')
      for name, v in pairs(getheBlackListInPath) do
            UI:AddToggle(name, name, false)
      end
      UI:AddHeader('采集黑名单')
      for k, v in pairs(getheBlackList) do
            local name = '拉黑 - ' .. v.Name
            UI:AddToggle(name, name, false)
      end
      

      -- 建议show用config:Show(), 可以避免多开窗口
end

-- 设定座标黑名单
for name, v in pairs(getheBlackListInPath) do
      local blaclToggleUI = UI:GetWidget(name)
      local _set = blaclToggleUI.set
      -- 每次勾选都重建黑名单表
      blaclToggleUI.set = function(info, value)
            local blackList = {}
            for n, v in pairs(getheBlackListInPath) do
                  if value then
                        table.insert(blackList, v)
                  end
            end
            SetSettings({GatherBlackList = blackList})
            _set(info, value)
      end

      blaclToggleUI.set(nil, UI:Setting(name))
end

local s = CreateFrame("Frame")
s.timer = 0
s:SetScript("OnUpdate", function()
      if time() - s.timer > 0.2 then
            s.timer = time()
            if not CJMB.IsSimpleVer() then
                  if UI:Setting('超级爬坡') then
                      CJMB.SetClimbAngle(PI/2)
                  else
                      CJMB.SetClimbAngle()
                  end
            end
      end
end)

--定义
local GetSetting = function(name)
	--UI:Setting(name) 可以获得值
    return UI:Setting(name)
end

GetScriptUISetting = GetSetting
--UI
--恢复
local f = CreateFrame("Frame", "DoMeWhen", UIParent)
f:SetScript(
"OnUpdate",
function()
  DoMeWhenOnUpdateTimer = DoMeWhenOnUpdateTimer or 0
  if UI:Setting('启动自定义恢复范围') and time() - DoMeWhenOnUpdateTimer > 0.1 then
     DoMeWhenOnUpdateTimer = time() 
        local data = {
                  FoodPercent = {0, 0},
                  DrinkPercent = {0, 0} 
            }
      if CJMB:GetPlayer().Class == 'HUNTER' then
            data.FoodPercent[1] = UI:Setting('猎人生命%')
            data.FoodPercent[2] = UI:Setting('到猎人生命 %')
            data.DrinkPercent[1] = UI:Setting('猎人法力%')
            data.DrinkPercent[2] = UI:Setting('到猎人法力 %')
      end
      if CJMB:GetPlayer().Class == 'MAGE' then
            data.FoodPercent[1] = UI:Setting('法师生命%')
            data.FoodPercent[2] = UI:Setting('到法师生命 %')
            data.DrinkPercent[1] = UI:Setting('法师法力%')
            data.DrinkPercent[2] = UI:Setting('到法师法力 %')
      end
      if CJMB:GetPlayer().Class == 'ROGUE' then
            data.FoodPercent[1] = UI:Setting('盗贼生命%')
            data.FoodPercent[2] = UI:Setting('到盗贼生命 %')
      end
      if CJMB:GetPlayer().Class == 'PRIEST' then
            data.FoodPercent[1] = UI:Setting('牧师生命%')
            data.FoodPercent[2] = UI:Setting('到牧师生命 %')
            data.DrinkPercent[1] = UI:Setting('牧师法力%')
            data.DrinkPercent[2] = UI:Setting('到牧师法力 %')
      end
      if CJMB:GetPlayer().Class == 'WARLOCK' then
            data.FoodPercent[1] = UI:Setting('术士生命%')
            data.FoodPercent[2] = UI:Setting('到术士生命 %')
            data.DrinkPercent[1] = UI:Setting('术士法力%')
            data.DrinkPercent[2] = UI:Setting('到术士法力 %')
      end
      if CJMB:GetPlayer().Class == 'DRUID' then
            data.FoodPercent[1] = UI:Setting('德鲁伊生命%')
            data.FoodPercent[2] = UI:Setting('到德鲁伊生命 %')
            data.DrinkPercent[1] = UI:Setting('德鲁伊法力%')
            data.DrinkPercent[2] = UI:Setting('到德鲁伊法力 %')
      end
      if CJMB:GetPlayer().Class == 'PALADIN' then
            data.FoodPercent[1] = UI:Setting('圣骑士生命%')
            data.FoodPercent[2] = UI:Setting('到圣骑士生命 %')
            data.DrinkPercent[1] = UI:Setting('圣骑士法力%')
            data.DrinkPercent[2] = UI:Setting('到圣骑士法力 %')
      end
      if CJMB:GetPlayer().Class == 'SHAMAN' then
            data.FoodPercent[1] = UI:Setting('萨满生命%')
            data.FoodPercent[2] = UI:Setting('到萨满生命 %')
            data.DrinkPercent[1] = UI:Setting('萨满法力%')
            data.DrinkPercent[2] = UI:Setting('到萨满法力 %')
      end
      if CJMB:GetPlayer().Class == 'WARRIOR' then
            data.FoodPercent[1] = UI:Setting('战士生命%')
            data.FoodPercent[2] = UI:Setting('到战士生命 %')
      end
      SetSettings(data)
end
end)

--拉黑
local Herbs = GetEnums('Herbs')
local Ore = GetEnums('Ore')
local Lockpick = GetEnums('Lockpicking')
local GetheData = {Herbs, Ore, Lockpick}
for k, v in pairs(getheBlackList) do
  local name = '拉黑 - ' .. v.Name
      local getheBlackUI = UI:GetWidget(name)
      local tempset = getheBlackUI.set
      getheBlackUI.set = function(info, value)
            for i, g in ipairs(GetheData) do
                  for _, gethe in pairs(g) do
                        if gethe.Name == v.Name then
                              if value then
                                    gethe.SkillReq = 999
                              else
                                    gethe.SkillReq = v.SkillReq
                              end
                        end
                  end
            end
            tempset(info, value)
      end
      getheBlackUI.set(nil, getheBlackUI.get())
end
Config:Show()

local checkGoHomeFrame = CreateFrame("Frame")
local  l = GetLocals()
checkGoHomeFrame.time = GetTime()
checkGoHomeFrame:SetScript("OnUpdate", function()
if GetTime() - checkGoHomeFrame.time > 0.5 then
   checkGoHomeFrame.time = GetTime()
else
   return;
end
      if HasTask('A_GH:Reduction profile') then
            -- 关闭清空回城事件
            SetSettings({GoHomeEvent = false})
            ClearTask()
            ClearGoHome()
            -- 切换自定售卖脚本
            ReplaceScriptQuest('GoHome', 1)
      end
end)
local GoHome = {
      -- 下电梯
      --设置与障碍物宽度间距
      {Settings = 'agentRadius' , value = 1},
      --不走水路,假是不走水路,真是走水路
      {Settings = 'WalkWater', value =true},
      {Run = 'print("去售卖修理")' },
      {Run = function()  ClearGoHome()end},

            {If = "CJMB:GetPlayer().FactionGroup ~= 'Horde'",End = '联盟售卖' },
                  --  --回家路径避免卡位
                  {Settings = 'GoHomePath', value = {},},
                    --离开家路径避免卡位
                  {Settings = 'LeaveHomePath', value = {}},
                  {Settings = 'BuyNPC', value = {}},
                  --设置与障碍物宽度间距
                  {Settings = 'agentRadius' , value = 1},
                  {Run = 'print("飞去南海镇买卖")' },
                  {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                  --与计程车NPC对话
                  {UnitInteract = 12617},
                  {Delay = 1},
                  {Gossip = "taxi"},
                  --选择要空运的选项
                  {Taxi = 44045},
                  --等待2秒
                  {Delay = 2},
                  {Run = 'print("去购买食物")' },
                  {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                  {UnitInteract = 2352},
                  {Gossip = "vendor"},
                  {Delay = 2},
                  {Run = 'print("邮箱")' },
                  {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                  {ObjInteract = 143987},
                  {Delay = 2},
                   --去修理和买弹药
                  {Run = 'print("修理")' },
                  {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                  {UnitInteract = 3543},
                  {Delay = 2},
                  --去修理和买弹药
                  {Run = 'print("买弹药")' },
                  {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                  {UnitInteract = 3541},
                  {Delay = 2},
                  {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                  {Run = 'print("飞回东瘟疫")' },
                  {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                  --飞回东瘟疫
                  {Log='Debug',Text="飞回东瘟疫"},
                  --与计程车NPC对话
                  {UnitInteract = 2432},
                  {Delay = 1},
                  {Gossip = "taxi"},
                  --选择要空运的选项
                  {Taxi = 61034},
                  --等待2秒
                  {Delay = 2},
            {End = '联盟售卖'},
                
            {If = "CJMB:GetPlayer().FactionGroup == 'Horde'",End = '部落售卖' },
                   --设置与障碍物宽度间距
                   {Settings = 'agentRadius' , value = 1},
                   --飞去幽暗
                   {Log='Debug',Text="飞去幽暗"},
                   {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                   --与计程车NPC对话
                   {UnitInteract = 12636},
                   {Delay = 1},
                   {Gossip = "taxi"},
                   --选择要空运的选项
                   {Taxi = 41037},
                   --等待2秒
                   {Delay = 2},
                   --去购买食物
                   {Run = 'print("去购买食物")' },
                   {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                   {UnitInteract = 6741},
                   {Gossip = "vendor"},
                   {Delay = 2},
                   --去邮箱
                   {Run = 'print("去邮箱")' },
                   {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                   {ObjInteract = 177044},
                   {Delay = 2},
                   --去修理和买弹药
                   {Run = 'print("修理和买弹药")' },
                   {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                   {UnitInteract = 4603},
                   {Delay = 2},
                   {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                   --去修理和买弹药
                   {Run = 'print("修理和买弹药")' },
                   {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                   {UnitInteract = 4604},
                   {Delay = 2},
                   {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                   --飞回东瘟疫
                   {Log='Debug',Text="飞回东瘟疫"},
                   --与计程车NPC对话
                   {UnitInteract = 4551},
                   {Delay = 1},
                   {Gossip = "taxi"},
                   --选择要空运的选项
                   {Taxi = 60034},
                   --等待2秒
                   {Delay = 2},
            {End = '部落售卖'},

      {Run = 'print("去采集")' },
      {Run = function() --关闭所有战斗循环
            SetSettings({
                  agentRadius = l.agentRadiusTemp,
                  AttackRadiusAllMonster = l.GoHomeAttackAll
            })
            SetDMWHUD('Rotation',true)
      end},
      {Replace = 'text2'},
}

local text = {
      {Log='Info',Text="怪初始化战斗循环"},
      {If = "CJMB:GetPlayer().Class == 'HUNTER'", End = '猎人恢复设置'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70,85 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {10 ,40 ,}},
      {End = '猎人恢复设置'},
      
      {If = "CJMB:GetPlayer().Class == 'ROGUE' or CJMB:GetPlayer().Class == 'WARRIOR'", End = '战士盗贼恢复设置'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70 ,90 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {0 ,0 ,}},
      {End = '战士盗贼恢复设置'},

      {If = "CJMB:GetPlayer().Level < 58 and CJMB:GetPlayer().Class == 'SHAMAN' or CJMB:GetPlayer().Class == 'PRIEST' or CJMB:GetPlayer().Class == 'HUNTER' or CJMB:GetPlayer().Class == 'DRUID' or CJMB:GetPlayer().Class == 'PALADIN' or CJMB:GetPlayer().Class == 'WARLOCK'", End = '有蓝职业恢复设置'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70,85 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {50 ,85 ,}},
      {End = '有蓝职业恢复设置'},

      {If = "CJMB:GetPlayer().Level >= 58 and CJMB:GetPlayer().Class == 'SHAMAN' or CJMB:GetPlayer().Class == 'PRIEST' or CJMB:GetPlayer().Class == 'HUNTER' or CJMB:GetPlayer().Class == 'DRUID' or CJMB:GetPlayer().Class == 'PALADIN' or CJMB:GetPlayer().Class == 'WARLOCK'", End = '有蓝职业恢复设置1'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70,85 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {50 ,85 ,}},
      {End = '有蓝职业恢复设置1'},

      {If = "CJMB:GetPlayer().Level < 15 and CJMB:GetPlayer().Class == 'WARLOCK'", End = '术士职业恢复设置'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70,85 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {50 ,85 ,}},
      {End = '术士职业恢复设置'},

      {If = "CJMB:GetPlayer().Level >= 15 and CJMB:GetPlayer().Class == 'WARLOCK'", End = '术士职业恢复设置1'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70,85 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {50 ,85 ,}},
      {End = '术士职业恢复设置1'},

      {If = "CJMB:GetPlayer().PetActive == true", End = '设置宠物为被动型'},
      {Run = 'print("设置宠物为被动型")' },
      {Run = 'PetPassiveMode()' },
      {End = '设置宠物为被动型'},
      
      --|cffff0000 红
      --|cffFF6EB4 紫
      --|cFFFFFF00 金黄(用不到)
      --|cFF00FF00 绿
      {Run = 'print("|cFF00FF00 自动东瘟疫采集1.0测试版 东瘟疫启动")'},
      {Run = 'print("|cFF00FF00 采集途中如果有想保存,请在邮寄设置里设置邮寄的物品,就会保存了")'},
      {Replace = 'text2'},
}

local text2 = {
    --判定有蓝职业
      { If =  "CJMB:GetPlayer().Class == 'SHAMAN' or CJMB:GetPlayer().Class == 'PRIEST' or CJMB:GetPlayer().Class == 'HUNTER' or CJMB:GetPlayer().Class == 'DRUID' or CJMB:GetPlayer().Class == 'PALADIN' or CJMB:GetPlayer().Class == 'WARLOCK'",End = 1.2},
      --使用食物
      {Settings = 'UseFood', value = true},
      --使用饮料
      {Settings = 'UseDrink', value = true},
      --開啟自動休息，不吃藥
      {Settings = 'AutoRest', value = false},
      --购买最好
      {Settings = 'Buybest', value = true},
      --食物数量
      {Settings = 'FoodAmount', value = 40},
      --饮料数量
      {Settings = 'DrinkAmount', value = 40},
      --勾选后，把包内食物/饮料吃完才会触发回城，不用设定FoodName与DrinkName
      {Settings = 'EatAll', value = true},
      --远程下马距离
      {Settings = 'DismountDistance', value = 40},
      --骑士下马距离
      { If =  "CJMB:GetPlayer().Class == 'PALADIN'",End = 0.1},
      --近战下马距离
      {Settings = 'DismountDistance', value = 10},
      {End = 0.1},
      {End = 1.2},
      --判定没蓝职业
      { If =  "CJMB:GetPlayer().Class == 'ROGUE' or CJMB:GetPlayer().Class == 'WARRIOR'",End = 1.3},
      --使用食物
      {Settings = 'UseFood', value = true},
      --使用饮料
      {Settings = 'UseDrink', value = false},
      --開啟自動休息，不吃藥
      {Settings = 'AutoRest', value = false},
      --购买最好
      {Settings = 'Buybest', value = true},
      --食物数量
      {Settings = 'FoodAmount', value = 60},
      --饮料数量
      {Settings = 'DrinkAmount', value = 0},
      --勾选后，把包内食物/饮料吃完才会触发回城，不用设定FoodName与DrinkName
      {Settings = 'EatAll', value = true},
      --近战下马距离
      {Settings = 'DismountDistance', value = 0},
      {End = 1.3},
      --判定我是法师许需要购买食物
      { If =  "CJMB:GetPlayer().Class == 'MAGE'",End = 1.4},
      --使用食物
      {Settings = 'UseFood', value = true},
      --使用饮料
      {Settings = 'UseDrink', value = true},
      --開啟自動休息，不吃藥
      {Settings = 'AutoRest', value = false},
      --购买最好
      {Settings = 'Buybest', value = true},
      --食物数量
      {Settings = 'FoodAmount', value = 0},
      --饮料数量
      {Settings = 'DrinkAmount', value = 0},
      --勾选后，把包内食物/饮料吃完才会触发回城，不用设定FoodName与DrinkName
      {Settings = 'EatAll', value = true},
      --远程下马距离
      {Settings = 'DismountDistance', value = 40},
      {End = 1.4},

      --部落去东瘟疫
      --奥格去幽暗城
      {If = "(CJMB:GetPlayer().mapID ==1454 or CJMB:GetPlayer().mapID == 1411) and CJMB:GetPlayer().mapID ~=1420 and CJMB:GetPlayer().FactionGroup == 'Horde'",End = '坐飞船去幽暗城' },
            --开启采矿
            {Settings = 'AutoGatherOre', value =false},
            --开启采药
            {Settings = 'AutoGatherHerb', value =false},
            {Run = 'print("坐飞船去幽暗城")'},
            --等待飞艇 
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            --奥格飞幽暗城
            {TakeSpaceship = 6667 , DownPath = {2066.4841, 289.2147, 97.0327}},
      {Loop = '坐飞船去幽暗城'},
      --去绑定炉石
      {If = "(GetBindLocation() ~= 'Undercity' and GetBindLocation() ~= '幽暗城') and CJMB:GetPlayer().FactionGroup == 'Horde' and CJMB:GetPlayer().mapID == 1420 and GetScriptUISetting('绑定炉石')",End = '绑定幽暗城炉石' },
            --设置与障碍物宽度间距
            {Settings = 'agentRadius' , value = 1},
            {Run = 'print("绑定幽暗城炉石")'},
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {UnitInteract = 6741},
            {Delay = 1},
            --选择选项
            {Gossip = "binder"},
            {Delay = 1},
            { Run = 'ConfirmBinder()' },
            {Delay = 3},
      {Loop = '绑定幽暗城炉石'},
      --幽暗飞圣光
      {If = "CJMB:GetPlayer().mapID == 1458 and CJMB:GetPlayer().mapID ~= 1423 and CJMB:GetPlayer().FactionGroup == 'Horde'",End = '幽暗飞圣光' },
            {Log='Debug',Text="飞回圣光礼拜堂"},
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            --对话售卖
            {UnitInteract = 4775},
            {Delay = 1},
            --与计程车NPC对话
            {UnitInteract = 4551},
            {Delay = 1},
            --选择要空运的选项
            {Gossip = "taxi"},
            --搭车
            {Taxi = 60034},
            --等待2秒
            {Delay = 2},
            {If = "CJMB:GetPlayer().mapID ~= 1423 ",End = '跑去圣光礼拜堂1' },
                  --开启采矿
                  {Settings = 'AutoGatherOre', value =false},
                  --开启采药
                  {Settings = 'AutoGatherHerb', value =false},
                  {Log='Debug',Text="飞行点没开跑去圣光礼拜堂"},
                  --设置与障碍物宽度间距
                  {Settings = 'agentRadius' , value = 1},
                  --不走水路,假是不走水路,真是走水路
                  {Settings = 'WalkWater', value =false},
                  {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                  --与计程车NPC对话
                  {UnitInteract = 12636},
                  {Delay = 2},
            {Loop = '跑去圣光礼拜堂1'},
      {End = '幽暗飞圣光'},

      --联盟去东瘟疫
      --在暴风城去铁炉堡
      {If = "CJMB:GetPlayer().mapID == 1453 and CJMB:GetPlayer().mapID ~= 1455 and CJMB:GetPlayer().FactionGroup ~= 'Horde'",End = '在暴风城不在铁炉堡1' },
            {Log='Debug',Text="去铁炉堡"},
            --坐地铁去铁炉堡
            --去做地铁
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            --传送检测
            {Settings = 'ManualJump' , value = false},
            --进风城的地铁坐标
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            --传送检测
            {Settings = 'ManualJump' , value = true},
            --等待10秒加载地图包
            {Delay=10},
            --判定距离上地铁线程坐标太远掉下来,重新等待坐地铁
            {If="CJMB:GetPlayer():DistanceTo(12.1667, 8.3495, -3.9266)>20",End = 1.1},
            --去做地铁等位,离掉落地点有点距离的地方,掉下去回来
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            --等待地铁到达
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            --铁炉堡下地铁坐标
            {TakeTransport=6795 , DownPath = {12.1667, 8.3495, -3.9266}},
            {Loop=1.1},
            --传送检测
            {Settings = 'ManualJump' , value = false},
            --出铁炉堡地铁的门
            {MoveTo = {72.7980, 10.2072, -4.2966,true},},
            --传送检测
            {Settings = 'ManualJump' , value = true},
            --等待10秒加载地图包
            {Delay=10},
            --拐角
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
      {Loop = '在暴风城不在铁炉堡1'},
      --绑定铁炉堡炉石
      {If = "GetBindLocation() ~= 'Ironforge' and GetBindLocation() ~= '铁炉堡' and CJMB:GetPlayer().FactionGroup ~= 'Horde' and CJMB:GetPlayer().mapID == 1455 and GetScriptUISetting('绑定炉石')",End = '绑定铁炉堡炉石' },
            {Run = 'print("绑定铁炉堡炉石")'},
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {UnitInteract = 5111},
            {Delay = 1},
            --选择选项
            {Gossip = "binder"},
            {Delay = 1},
            { Run = 'ConfirmBinder()' },
            {Delay = 3},
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            --去开铁炉堡飞行点
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {UnitInteract = 1573},
            {Delay=2},
      {Loop = '绑定铁炉堡炉石'},
      --飞去圣光礼拜堂
      {If = "CJMB:GetPlayer().mapID == 1455 and CJMB:GetPlayer().mapID ~= 1423 and CJMB:GetPlayer().FactionGroup ~= 'Horde'",End = '飞去圣光礼拜堂' },
            --飞去圣光礼拜堂
            {Log='Debug',Text="飞去圣光礼拜堂"},
            --对话售卖
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {UnitInteract = 5111},
            {Gossip = "vendor"},
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            --与计程车NPC对话
            {UnitInteract = 1573},
            {Delay = 1},
            {Gossip = "taxi"},
            --选择要空运的选项
            {Taxi = 61034},
            --等待2秒
            {Delay = 2},
                  {If = "CJMB:GetPlayer().mapID ~= 1423",End = '跑去圣光礼拜堂' },
                        --开启采矿
                        {Settings = 'AutoGatherOre', value =false},
                        --开启采药
                        {Settings = 'AutoGatherHerb', value =false},
                        {Log='Debug',Text="没开飞行点去开南海镇和圣光飞行点"},
                        --去南海镇
                        {If = "(CJMB:GetPlayer().mapID == 1455 or CJMB:GetPlayer().mapID == 1432 or CJMB:GetPlayer().mapID == 1426 or CJMB:GetPlayer().mapID ~= 1437) and CJMB:GetPlayer().mapID ~= 1424",End = '在铁炉堡不在湿地2' },
                              {Log='Debug',Text="现在去南海镇"},
                              {Settings = 'BuyNPC', value = {}},
                               --设置与障碍物宽度间距
                              {Settings = 'agentRadius' , value = 1},
                              --不走水路,假是不走水路,真是走水路
                              {Settings = 'WalkWater', value =false},
                              {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                              {Log='Debug',Text="到南海镇开飞行点"},
                              {UnitInteract = 2432},
                              {Delay = 2},
                        {End = '在铁炉堡不在湿地2'},
                        {If = "CJMB:GetPlayer().mapID ~= 1423 ",End = '跑去圣光礼拜堂1' },
                              {Log='Debug',Text="飞行点没开跑去圣光礼拜堂"},
                              {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
                              --与计程车NPC对话
                              {UnitInteract = 12617},
                              {Delay = 2},
                        {Loop = '跑去圣光礼拜堂1'},
                  {Loop = '跑去圣光礼拜堂'},
      {Loop = '飞去圣光礼拜堂'},


      {If = "CJMB:GetPlayer():GetSkill(SKILL_ORE).Rank < 400 or CJMB:GetPlayer():GetSkill(SKILL_HERB).Rank < 400" ,End = '测试采集' },
            --开启采矿
            {Settings = 'AutoGatherOre', value =true},
            --开启采药
            {Settings = 'AutoGatherHerb', value =true},
            --不走水路,假是不走水路,真是走水路
            {Settings = 'WalkWater', value =true},         
            --回家路径避免卡位
            {Settings = 'GoHomePath', value = {},},
            --离开家路径避免卡位
            {Settings = 'LeaveHomePath', value = {}},
            {Settings = 'BuyNPC', value = {
                --邮箱
                {Id = 181236,Path = {2286.6357, -5317.0259, 88.6627}},
                --商人修装的
                {Id = 16376,Path = {2259.2322, -5319.4492, 81.6699}},
            }},  
            --是否判断回城事件
            {Settings = 'GoHomeEvent', value = true},
            {Run = 'print("测试采集")'},
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
            {MoveTo = {X,Y,Z,true},},--X,Y,Z自己改,自己填写
      {Loop = '测试采集' },
}

--加入脚本
Bot:AddQuest('text',text)
--加入脚本
Bot:AddQuest('text2',text2)
--加入脚本
Bot:AddQuest('text3',text3)
--加入脚本
Bot:AddQuest('GoHome',GoHome)
--设定第一个执行的脚本
Bot:SetFirstQuest('text')

Bot:SetPulse(function(Bots)
      local BotTask = Bots.Task
      Bots.QuestScriptPulse(Bots)
end) 

Bot:SetStart(function()
    Config:Hide()
      Log:System('=======================')
      Log:System("采集模板脚本载入")
      Log:System('=======================')
      --Bot:SetPulse(Bot.QuestScriptPulse)
      SetPulseTime(0.1)
      if not CJMB.IsSimpleVer() then
            CJMB:SetNoClip(0)
      end
      --动作
      ACCheck(true)
      --传送
	TPCheck(true)
      --自动调整帧数
      SetCVar("maxFPS", 50)
      SetCVar("maxFPSBk", 50)
      SetDMWHUD('Rotation',true) --DMW
      local LearnThisTalentList = {}
      if CJMB:GetPlayer().Class=='MAGE' then
            LearnThisTalentList = {
                  {303, 3},-- 三点元素精准  
                  {302, 5},-- 五点强化寒冰箭 
                  {305, 3},-- 三点霜寒刺骨 
                  {306, 2},-- 两点强化冰霜新星 
                  {308, 3},-- 三点刺骨寒冰 
                  {313, 5},-- 五点碎冰 
                  {304, 5}, -- 五点寒冰碎片 
                  {316, 3},-- 三点强化冰锥术
                  {315, 1},-- 一点急速冷却 
                  {319, 1},-- 一点寒冰护体 
                  {320, 5},-- 五点极寒之风 
                  {321, 5},-- 五点寒冰箭增效 
                  {317, 2},-- 两点浮冰  
                  {322, 1},-- 一点召唤水元素 
                  {309, 1},-- 一点冰冷血脉 
                  {318, 5},-- 五点深冬之寒  
                  {312, 3},-- 三点冰霜导能 
                  {311, 2},-- 两点极寒延伸 
                  {307, 3},-- 三点极寒冰霜 
                  {314, 1},-- 冰冻之心*1
            }
      end
      if CJMB:GetPlayer().Class=='ROGUE' then
            LearnThisTalentList = {
                  {102, 2}, --冷酷攻击2点
                  {202, 2}, --强化影袭2点
                  {101, 3}, --强化刺骨3点
                  {103, 5}, --恶意5点
                  {109, 5}, --致命偷袭5点
                  {203, 5}, --闪电反射5点
                  {206, 5}, --精确5点
                  {205, 5}, --偏斜5点
                  {208, 1}, --还击1点
                  {212, 5}, --双武器专精5点
                  {214, 1}, --剑刃乱舞1点
                  {209, 1}, --强化疾跑1点
                  {207, 1}, --耐久1点
                  {218, 2}, --武器专家2点
                  {219, 3}, --侵犯3点
                  {221, 1}, --冲动1点
                  {217, 2}, --剑刃飞转2点
                  {220, 2}, --活力2点
                  {223, 5}, --战斗潜能5点
                  {224, 1}, --突袭1点
            }
      end
      if CJMB:GetPlayer().Class=='HUNTER' then
            LearnThisTalentList = {
                  {102, 1}, --耐久训练5点
                  {102, 2}, --耐久训练5点
                  {102, 3}, --耐久训练5点
                  {102, 4}, --耐久训练5点
                  {102, 5}, --耐久训练5点
                  {105, 1}, --厚皮3点
                  {105, 2}, --厚皮3点
                  {105, 3}, --厚皮3点
                  {103, 1}, --火力集中2点
                  {103, 2}, --火力集中2点
                  {109, 1}, --狂怒释放2点
                  {109, 2}, --狂怒释放2点
                  {111, 1}, --凶暴5点
                  {111, 2}, --凶暴5点
                  {111, 3}, --凶暴5点
                  {111, 4}, --凶暴5点
                  {111, 5}, --凶暴5点
                  {113, 1}, --胁迫1点
                  {114, 1}, --野兽戒律2点
                  {114, 2}, --野兽戒律2点
                  {112, 1}, --灵魂联结2点
                  {112, 2}, --灵魂联结2点
                  {116, 1}, --狂乱5点
                  {116, 2}, --狂乱5点
                  {116, 3}, --狂乱5点
                  {116, 4}, --狂乱5点
                  {116, 5}, --狂乱5点
                  {118, 1}, --狂野怒火1点
                  {119, 1}, --猎豹反射3点
                  {119, 2}, --猎豹反射3点
                  {119, 3}, --猎豹反射3点
                  {110, 1}, --强化治疗宠物2点
                  {110, 2}, --强化治疗宠物2点
                  {120, 1}, --蛇之迅捷5点
                  {120, 2}, --蛇之迅捷5点
                  {120, 3}, --蛇之迅捷5点
                  {120, 4}, --蛇之迅捷5点
                  {120, 5}, --蛇之迅捷5点
                  {121, 1}, --野兽之心1点
                  {106, 1}, --强化复活宠物2点
                  {106, 2}, --强化复活宠物2点
                  {115, 1}, --驭兽者2点
                  {115, 2}, --驭兽者2点
                  {202, 1}, --夺命射击5点
                  {202, 2}, --夺命射击5点
                  {202, 3}, --夺命射击5点
                  {202, 4}, --夺命射击5点
                  {202, 5}, --夺命射击5点
                  {204, 1}, --效率5点
                  {204, 2}, --效率5点
                  {204, 3}, --效率5点
                  {204, 4}, --效率5点
                  {204, 5}, --效率5点
                  {205, 1}, --直取要害2点
                  {205, 2}, --直取要害2点
                  {117, 1}, --凶猛灵感3点
                  {117, 2}, --凶猛灵感3点
                  {117, 3}, --凶猛灵感3点
            }
      end
      if CJMB:GetPlayer().Class=='PRIEST' then
            LearnThisTalentList = {
                  {301, 5}, --精神分流5点
                  {102, 5}, --魔杖专精5点
                  {304, 2}, --强化暗言术：痛2点
                  {302, 3}, --昏阙3点
                  {308, 1}, --精神鞭笞1
                  {307, 5}, --强化心灵震爆5点
                  {311, 4}, --暗影之波4点
                  {313, 1}, --吸血鬼的拥抱1点
                  {314, 2}, --强化吸血鬼的拥抱2点
                  {315, 3}, --心灵集中3点
                  {302, 5}, --昏阙5点
                  {311, 5}, --暗影之波5点
                  {317, 1}, --黑暗1点
                  {318, 1}, --暗影形态1点
                  {319, 5}, --暗影能量5点
                  {306, 2}, --强化心灵尖啸2点
                  {312, 1}, --沉默1点
                  {317, 2}, --黑暗2点
                  {321, 1}, --吸血鬼之触1点--45级
                  {317, 5}, --黑暗5点
                  {320, 5}, --悲惨5点
                  {305, 5}, --暗影集中5点
                  {310, 2}, --暗影延伸2点
                  -- {105, 2}, --强化真言术：盾2点
            }
      end
      if CJMB:GetPlayer().Class=='WARLOCK' then
            LearnThisTalentList = {
                  {203, 1},-- 五点恶魔之拥
                  {203, 2},-- 五点恶魔之拥 
                  {203, 3},-- 五点恶魔之拥 
                  {203, 4},-- 五点恶魔之拥 
                  {203, 5},-- 五点恶魔之拥 
                  {205, 1},-- 三强化虚空行者 
                  {205, 2},-- 三强化虚空行者 
                  {205, 3},-- 三强化虚空行者 
                  {204, 1},-- 两强化生命通道 
                  {204, 2},-- 两强化生命通道 
                  {206, 1},-- 3恶魔智力
                  {206, 2},-- 3恶魔智力
                  {206, 3},-- 3恶魔智力
                  {209, 1},-- 三点恶魔耐力
                  {209, 2},-- 三点恶魔耐力
                  {209, 3},-- 三点恶魔耐力
                  {208, 1},-- 1恶魔支配 
                  {210, 1}, -- 1恶魔庇护 
                  {211, 1},-- 2召唤大师
                  {211, 2},-- 2召唤大师
                  {212, 1},-- 5点邪恶强化
                  {212, 2},-- 5点邪恶强化
                  {212, 3},-- 5点邪恶强化
                  {212, 4},-- 5点邪恶强化
                  {212, 5},-- 5点邪恶强化
                  {214, 1},-- 一点恶魔牺牲
                  {217, 1},-- 五点恶魔学识大师 
                  {217, 2},-- 五点恶魔学识大师 
                  {217, 3},-- 五点恶魔学识大师 
                  {217, 4},-- 五点恶魔学识大师 
                  {217, 5},-- 五点恶魔学识大师 
                  {219, 1},-- 1灵魂链接
                  {216, 1},-- 3法力喂食
                  {216, 2},-- 3法力喂食
                  {216, 3},-- 3法力喂食
                  {221, 1},-- 5恶魔战术
                  {221, 2},-- 5恶魔战术
                  {221, 3},-- 5恶魔战术
                  {221, 4},-- 5恶魔战术
                  {221, 5},-- 5恶魔战术
                  {222, 1},-- 一点召唤恶魔卫士
                  {218, 1},-- 3恶魔韧性
                  {218, 2},-- 3恶魔韧性 
                  {218, 3},-- 3恶魔韧性
                  {102, 1},-- 5强化腐蚀术
                  {102, 2},-- 5强化腐蚀术
                  {102, 3},-- 5强化腐蚀术
                  {102, 4},-- 5强化腐蚀术
                  {102, 5},-- 5强化腐蚀术
                  {104, 1},-- 两点强化吸取灵魂
                  {104, 2},-- 两点强化吸取灵魂
                  {105, 1},-- 2强化生命分流
                  {105, 2},-- 2强化生命分流
                  {106, 1},-- 2灵魂虹吸
                  {106, 2},-- 2灵魂虹吸
                  {220, 1},-- 3恶魔知识
                  {220, 2},-- 3恶魔知识
                  {220, 3},-- 3恶魔知识
                  {109, 1},-- 1诅咒增幅
            }
      end
      if CJMB:GetPlayer().Class=='PALADIN' then
            LearnThisTalentList = {
                  {301, 1},-- 强化力量祝福
                  {301, 2},-- 强化力量祝福
                  {301, 3},-- 强化力量祝福
                  {301, 4},-- 强化力量祝福
                  {301, 5},-- 强化力量祝福
                  {302, 1},-- 祈福 
                  {302, 2},-- 祈福 
                  {302, 3},-- 祈福
                  {302, 4},-- 祈福
                  {302, 5},-- 祈福
                  {308, 1},-- 命令圣印
                  {303, 1},-- 强化审判
                  {303, 2},-- 强化审判
                  {304, 1},-- 强化十字军圣印
                  {304, 2},-- 强化十字军圣印
                  {304, 3},-- 强化十字军圣印
                  {307, 1},-- 定罪
                  {307, 2},-- 定罪
                  {307, 3},-- 定罪
                  {307, 4},-- 定罪
                  {314, 1},-- 命令圣印
                  {315, 1},-- 强化圣洁光环
                  {315, 2},-- 强化圣洁光环
                  {307, 5},-- 定罪
                  {309, 1},-- 正义追击   
                  {316, 1},-- 复仇 
                  {316, 2},-- 复仇 
                  {316, 3},-- 复仇
                  {316, 4},-- 复仇
                  {316, 5},-- 复仇       
                  {317, 1},-- 神圣审判 
                  {317, 2},-- 神圣审判 
                  {317, 3},-- 神圣审判          
                  {309, 2},-- 正义追击                            
                  {309, 3},-- 正义追击
                  {319, 1},-- 忏悔
                  {321, 1},-- 狂热
                  {321, 2},-- 狂热
                  {321, 3},-- 狂热
                  {321, 4},-- 狂热
                  {322, 1},-- 十字军打击
                  {321, 5},-- 狂热
                  {313, 1},-- 双手武器专精
                  {313, 2},-- 双手武器专精
                  {313, 3},-- 双手武器专精
                  {317, 1},-- 神圣审判
                  {317, 2},-- 神圣审判
                  {317, 3},-- 神圣审判
                  {312, 1},-- 征伐
                  {312, 2},-- 征伐
                  {312, 3},-- 征伐
                  {202, 1},-- 盾牌壁垒
                  {202, 2},-- 盾牌壁垒
                  {202, 3},-- 盾牌壁垒
                  {202, 4},-- 盾牌壁垒
                  {202, 5},-- 盾牌壁垒
                  {203, 1},-- 精确
                  {203, 2},-- 精确
                  {203, 3},-- 精确
            }
      end
      if CJMB:GetPlayer().Class=='WARRIOR' then
            LearnThisTalentList = {
                  {202, 1},-- 残忍5点
                  {202, 2},-- 残忍5点
                  {202, 3},-- 残忍5点
                  {202, 4},-- 残忍5点
                  {202, 5},-- 残忍5点
                  {204, 1},-- 怒不可遏5点
                  {204, 2},-- 怒不可遏5点
                  {204, 3},-- 怒不可遏5点
                  {204, 4},-- 怒不可遏5点
                  {204, 5},-- 怒不可遏5点
                  {207, 1},-- 血之狂热3点
                  {207, 2},-- 血之狂热3点
                  {207, 3},-- 血之狂热3点
                  {201, 1},-- 震耳噪音 2点
                  {201, 2},-- 震耳噪音 2点
                  {209, 1},-- 双武器专精 5点
                  {209, 2},-- 双武器专精 5点
                  {209, 3},-- 双武器专精 5点
                  {209, 4},-- 双武器专精 5点
                  {209, 5},-- 双武器专精 5点
                  {211, 1},-- 激怒5点
                  {211, 2},-- 激怒5点
                  {211, 3},-- 激怒5点
                  {211, 4},-- 激怒5点
                  {211, 5},-- 激怒5点
                  {216, 1},-- 乱舞5点
                  {216, 2},-- 乱舞5点
                  {216, 3},-- 乱舞5点
                  {216, 4},-- 乱舞5点
                  {216, 5},-- 乱舞5点
                  {213, 1},-- 横扫攻击1点
                  {218, 1},-- 嗜血1点                            
                  {214, 1},-- 武器掌握1点
                  {217, 1},-- 精确3点
                  {217, 2},-- 精确3点
                  {217, 3},-- 精确3点
                  {220, 1},-- 强化狂暴姿态5点
                  {220, 2},-- 强化狂暴姿态5点
                  {220, 3},-- 强化狂暴姿态5点
                  {220, 4},-- 强化狂暴姿态5点
                  {220, 5},-- 强化狂暴姿态5点                                
                  {221, 1},-- 暴怒1点
                  {210, 1},-- 强化斩杀2点
                  {210, 2},-- 强化斩杀2点
                  {102, 1},-- 偏斜5点
                  {102, 2},-- 偏斜5点
                  {102, 3},-- 偏斜5点
                  {102, 4},-- 偏斜5点
                  {102, 5},-- 偏斜5点 
                  {105, 1},-- 钢铁意志5点
                  {105, 2},-- 钢铁意志5点
                  {105, 3},-- 钢铁意志5点
                  {105, 4},-- 钢铁意志5点
                  {105, 5},-- 钢铁意志5点
                  {108, 1},-- 愤怒掌握1点   
                  {109, 1},-- 重伤3点
                  {109, 2},-- 重伤3点
                  {109, 3},-- 重伤3点
                  {101, 1},-- 强化英勇打击1点
                  {111, 1},-- 穿刺2点
                  {111, 2},-- 穿刺2点
            }
      end
	if CJMB:GetPlayer().Class=='HUNTER' then
		SetSettings({
		--当弹药数量少于多少时触发回城
		AmmoAmountToGoToTown = 100,
		--弹药数量
		AmmoAmount = 2600,
        		--食物数量
		FoodAmount = 40,
		--饮料数量
		DrinkAmount = 40,
        --恢复生命值范围
		FoodPercent = {50 ,90 ,},
		--恢复法力值范围
		DrinkPercent = {50 ,90 },
	})
	end
	if CJMB:GetPlayer().Class=='WARRIOR' or CJMB:GetPlayer().Class=='ROGUE' then
		--最先加载的线程初始化
		SetSettings({
		--使用饮料
		UseDrink = false,
		--恢复生命值范围
		FoodPercent = {70 ,90 ,},
		--恢复法力值范围
		DrinkPercent = {0 ,0 },
		--食物数量
		FoodAmount = 40,
		--饮料数量
		DrinkAmount = 0,
		})
	end
	if CJMB:GetPlayer().Class~='WARRIOR' and CJMB:GetPlayer().Class~='ROGUE' and CJMB:GetPlayer().Class~='MAGE' then
		--最先加载的线程初始化
		SetSettings({
		--使用饮料
		UseDrink = true,
		--恢复生命值范围
		FoodPercent = {50 ,90 ,},
		--恢复法力值范围
		DrinkPercent = {50 ,90 },
		--食物数量
        FoodAmount = 40,
        --饮料数量
        DrinkAmount = 40,
		})
	end
	if CJMB:GetPlayer().Class=='MAGE' then
		--最先加载的线程初始化
		SetSettings({
		--使用饮料
		UseDrink = true,
		--恢复生命值范围
		FoodPercent = {50 ,90 ,},
		--恢复法力值范围
		DrinkPercent = {50 ,90 },
		--食物数量
        FoodAmount = 0,
        --饮料数量
        DrinkAmount = 0,
		})
	end
      --最先加载的线程初始化
      SetSettings({
            LearnThisTalent = LearnThisTalentList,
                        --不输出
		--NoPrint = {'Delay',},
            NoPrint = {'Delay','AMTT','Gather',},
            --其他人的怪物打我,真为反击，假为不反击,定点挂机用
            TapDeniedCounterattack = false,
            --任务超时
            TimeOutEvent = true,
            --卡住事件
		StuckEvent = true,
            --自动学天赋
            LearnTalent = true,
            --寻路导航间隔
            ReachDistance = 1.8,
            --售卖完了回到原位
            GotoOriginalAddress = true,
            --自动拒绝组公会邀请
            AutoDeclineGuild = true,
            --自动拒绝组组队邀请
            AutoDeclineGroup = true,
            --自动拒绝决斗邀请
            AutoDeclineDuel = true,
            --开启可以点停止按键,点开始就是点继续,防止傻子点错,中止行程变成重新开始
            ReButtonOnClick =true,
            --设定距离障碍物范围1～5
            agentRadius = 1,
            --使用食物
            UseFood = true,
            --使用饮料
            UseDrink = true,
            --開啟自動休息，不吃藥
            AutoRest = false,
            --找怪范围
            SearchRadius = 100,
            --贩卖低于等于颜色等级的
            SellbelowLevel=true,
            --不攻击等级低于自身等级多少以下的怪物
            NotAttackFewLevelsMonster= 5,
            --开启使用坐骑
            UseMount=true,
            --不走水路,假是不走水路,真是走水路
            WalkWater =true,
            --自动拾取
            --AutoLoot = false,
            --勾选后，所有食物都吃,把包内食物/饮料吃完才会触发回城，不用设定FoodName与DrinkName
            EatAll = true,
            --是否判断回城事件
            GoHomeEvent = true,
            --恢复生命值范围
            FoodPercent = {50 ,90 ,},
            --恢复法力值范围
            DrinkPercent = {50 ,90 ,},
            --使用炉石
            UseHearthStone = false,
            --当背包空格小于等于多少时触发回城
            MinFreeBagSlotsToGoToTown = 2,
            --当装备耐久度小于等于%多少时触发回城
            MinDurabilityPercent = 20,
            --贩卖颜色等级0~8
            --SellLevel = {[0] = true,[1] = true,[2] = true,},
            --不贩卖列表 {id,id,id
            --DoNotSellList = {'Rune of','传送','Hearthstone','炉石','Skinning Knife','剥皮小刀','Mining Pick','矿工锄','Primal','源生','Mote of','微粒','Air','空气','基尔加丹印记',"Mark of Kil'jaeden","Thieves'Tools",'潜行者工具','Flash Powder','闪光粉'},
            --强制贩卖列表 {id,id,id
            --ForceSellList = {},
            --强制销毁
            --ForceDeleteList = {'秘教的命令','Cabal Orders','OOX','瓦希塔帕恩的羽毛',"Washte Pawne's Feather",'拉克塔曼尼的蹄子',"Hoof of Lakota'mani",'被撕破的日记','A Mangled Journal'},
            --是否反击
            Counterattack = true,
            --自动换装
            AutoEquip = true,
            --输出信息写入Log
            WriteLog = true,
            --复活距离
            RetrieveDis = 30,
            --购买最好
            Buybest = true,
            -- --食物数量
            -- FoodAmount = 0,
            -- --饮料数量
            -- DrinkAmount = 0,
            -- --弹药数量
            -- AmmoAmount = 0,
            -- 战斗循环自动buff
            CombatLoopAutoBuff = true,
            -- 自动战斗，追击，检取开关
            CombatIngSwitch = true,
            -- 自动吃喝
            AutoDrinkFood = true,
            --使用坐骑不攻击与反击
            UseMountWhenNotattack = true,
            --回家时不反击
            GoHomeNotattack = true,
            --下马距离
            DismountDistance = 40,
            --自动复活
            AutoRetrieve = true,
            --采集矿石
            AutoGatherOre = true,
            --采集草药
            AutoGatherHerb = true,
            --回家路径避免卡位
            GoHomePath = {},
            --离开家路径避免卡位
            LeaveHomePath = {},
            --回城坐标
            BuyNPC = {},
            --设定等待超时60秒
            TimeOut = 60,
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
                  --黑暗之门
                  {-11906.8906, -3208.9094, -14.8609},
                  {-248.1130, 922.9000, 84.3497},
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
                  {139.6259, 2668.5496,  distance = 50 , mapID = 1944},
                  --湿地采集
                  {-3102.5791, -3259.7576,  distance = 30 , mapID = 1437},
                  --荒芜之地采集
                  {-6478.4336, -2454.8972,  distance = 8 , mapID = 1418},
                  --东瘟疫
                  {-7852.2144, -1134.9771,  distance = 50 , mapID = 1415},
                  {-7897.3672, -1126.1414,  distance = 50 , mapID = 1415},
                  {-7934.5220, -1126.5953,  distance = 40 , mapID = 1415},
                  {-7973.1655, -1135.9192,  distance = 20 , mapID = 1415},
                  --阿拉希
                  {-914.5317, -3535.7561,  distance = 12 , mapID = 1417},
                  --提瑞斯
                  {2019.9589, -459.5869,  distance = 15 , mapID = 1420},
                  --新特兰
                  {283.7154, -2002.9836, 194.1263,  distance = 50 , mapID = 1425},
            },
                --设置间距
            agentRadiusPath  = {
                  {1341.9160, -4647.4360,  distance = 40, agentRadius = 2 , mapID = 1411},
                  --幽暗
                  {2064.0281, 270.0956, distance = 100, agentRadius = 1 , mapID = 1420},
                  {1604.4379, 238.8718, -52.1473, distance = 2000, agentRadius = 1 , mapID = 1458},
                  {1604.4379, 238.8718, -52.1473, distance = 2000, agentRadius = 1 , mapID = 1420},
                  --格罗姆高
                  {-12431.8154, 210.0732,  distance = 40, agentRadius = 2 , mapID = 1434},
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
                  {-1863.2314, 5429.2129,   distance = 1000, agentRadius = 1 , mapID = 1955},
                  --塞尔萨马
                  {-5354.0601, -2952.9070,   distance = 500, agentRadius = 1 , mapID = 1432},
                  --荣耀堡
			{-679.5225, 2668.0742,   distance = 500, agentRadius = 1 , mapID = 1944},
                },
          })
          if CJMB:GetPlayer().Class=='WARRIOR' or CJMB:GetPlayer().Class=='ROGUE' then
            --最先加载的线程初始化
            SetSettings({
            LearnThisTalent = LearnThisTalentList,
            --使用饮料
            UseDrink = false,
            --恢复法力值范围
            DrinkPercent = {0 ,0 },
            --DrinkPercent = {0 ,0 },
            })
          end
          if CJMB:GetPlayer():GetSkill(SKILL_ORE).Rank == 0 or CJMB:GetPlayer():GetSkill(SKILL_HERB).Rank == 0  then
            --最先加载的线程初始化
            SetSettings({
            --采集矿石
            AutoGatherOre = false,
            --采集草药
            AutoGatherHerb = false,
            })
          end
          Log:System("")
          Log:System("|cffff0000 本脚本会修改部分采集数据，建议更换")
          Log:System("|cffff0000 其他脚本后，先重新载入一次。")
end)

Bot:SetStop(function()
      Log:System('=======================')
      Log:System("脚本停止")
      Log:System('=======================')
end)

return Bot