local Bot = TTOCInitScript("TTOC野外刷怪")
local Log = Bot.Log
local UI = Bot.UI
local Config = Bot.Config
local TTOC = ...
--SC为了安全可以自定义,比如BABA = TTOC ,比如YEYE = TTOC ,然后更换SC为你自定义的名字!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
SC = TTOC

local checkGoHomeFrame = CreateFrame("Frame")
local  l = GetLocals()
checkGoHomeFrame.time = GetTime()
checkGoHomeFrame:SetScript("OnUpdate", function()
if GetTime() - checkGoHomeFrame.time > 1 then
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
-- 自定义触发回城设置,可以写自定义的路线和动作~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local GoHome = {
      --设置与障碍物宽度间距
      {Settings = 'agentRadius' , value = 1},
      --不走水路,假是不走水路,真是走水路
      {Settings = 'WalkWater', value =true},
      {Run = 'print("去售卖修理")' },
      {Run = function()  ClearGoHome()end},

            --我是联盟去售卖 改售卖只改下面里面的其他不要动~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            {If = "SC:GetPlayer().FactionGroup ~= 'Horde'",End = '联盟售卖' },
                  --  --回家路径避免卡位
                  {Settings = 'GoHomePath', value = {},},
                    --离开家路径避免卡位
                  {Settings = 'LeaveHomePath', value = {}},
                  {Settings = 'BuyNPC', value = {}},
                  --设置与障碍物宽度间距
                  {Settings = 'agentRadius' , value = 1},
                  -- 联盟没写,请自己添加~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  {Run = 'print("联盟没写,请自己添加")' },

            {End = '联盟售卖'},
                
            --我是部落去售卖 改售卖只改下面里面的其他不要动~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            {If = "SC:GetPlayer().FactionGroup == 'Horde'",End = '部落售卖' },
                  --设置与障碍物宽度间距
                  {Settings = 'agentRadius' , value = 1},
                  --飞回去修理
                  {Run = 'print("飞回去修理")' },
                  --到地方下马
                  {MoveTo = {765.7607, 2160.5457, 274.6170,true},},
                  {If = "IsMounted()",End = '下坐骑'},
                        {Run = 'RunMacroText("/dismount")'},
                  {End = '下坐骑'},
                  {If = "not UseFlyMount()",End = '使用飞天坐骑'},--如果上了坐骑就返回假，没有使用就返回真
                        {Delay = 2},
                        {Run = 'UseFlyMount()'},
                  {Loop = '使用飞天坐骑'},--loop循环到假
                  {Delay = 0.5},
                  --跳一下起飞
                  {Run = 'SC:GetPlayer():Jump()'},
                  --飞到打怪上方
                  {MoveTo = {773.6025, 2165.4106, 373,false},},
                  --飞到萨尔玛上方最高
                  {MoveTo = {187.7820, 2645.7017, 373,false},},
                  --落地坐标
                  {MoveTo = {174.9219, 2631.3901, 90.9768,false},},
                  {MoveTo = {184.2822, 2620.2927, 87.3430,false},},
                  {Delay = 2},
                  --到地方下马
                  {If = "IsMounted()",End = '下坐骑1'},
                        {Run = 'RunMacroText("/dismount")'},
                  {End = '下坐骑1'},
                  --对话食物npc
                  {MoveTo = {189.1208, 2612.9954, 87.2835,true},},
                  {UnitInteract = 16602},
                  {Gossip = "vendor"},
                  {Delay = 2},
                  --对话修理npc
                  {MoveTo = {181.8719, 2607.0977, 87.2835,true},},
                  {UnitInteract = 22225},
                  {Delay = 2},
                  --去萨尔玛门口
                  {MoveTo = {171.3018, 2638.3020, 86.5038,true},},
                  {Run = 'print("在空地飞去打怪")' },
            {End = '部落售卖'},

      {Run = 'print("去打怪")' },
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
      {Log='Info',Text="初始化战斗循环"},
      {If = "SC:GetPlayer().Class=='MAGE'",End = '法师不售卖' },
      {Settings = 'DoNotSellList', value = {'Rune of','传送','Hearthstone','炉石','Mining Pick','矿工锄','Skinning Knife','剥皮小刀','Primal','源生','Mote of','微粒','Air','空气','基尔加丹印记',"Mark of Kil'jaeden","Thieves'Tools",'潜行者工具','Flash Powder','闪光粉'}},
      {End = "法师不售卖"},

      {If = "SC:GetPlayer().Class == 'ROGUE' or SC:GetPlayer().Class == 'WARRIOR'",End = '近战不售卖' },
      {Settings = 'DoNotSellList', value = {'Rune of','传送','Hearthstone','炉石','Skinning Knife','剥皮小刀','Mining Pick','矿工锄','Primal','源生','Mote of','微粒','Air','空气','基尔加丹印记',"Mark of Kil'jaeden","Thieves'Tools",'潜行者工具','Flash Powder','闪光粉','Smoked Talbuk Venison','熏烤塔布羊排','Roasted Quail','烤鹌鹑','Bladespire Bagel','刀塔面圈','Clefthoof Ribs','裂蹄肋排','Homemade Cherry Pie','自制樱桃馅饼',"Mag'har Grainbread",'玛格汉面包',}},
      --售卖
      --{Settings = 'ForceSellList', value = {'亚麻布','毛料','丝绸','魔纹布','符文布','Linen Cloth','Wool Cloth','Silk Cloth','Mageweave Cloth','Runecloth'}},
      {End = "近战不售卖"},

      {If = "SC:GetPlayer().Class == 'SHAMAN' or SC:GetPlayer().Class == 'PRIEST' or SC:GetPlayer().Class == 'HUNTER' or SC:GetPlayer().Class == 'DRUID' or SC:GetPlayer().Class == 'PALADIN' or SC:GetPlayer().Class == 'WARLOCK'",End = '有蓝职业不售卖' },
      {Settings = 'DoNotSellList', value = {'Rune of','传送','Hearthstone','炉石','Skinning Knife','剥皮小刀','Mining Pick','矿工锄','Primal','源生','Mote of','微粒','Air','空气','基尔加丹印记',"Mark of Kil'jaeden",'Smoked Talbuk Venison','熏烤塔布羊排','Roasted Quail','烤鹌鹑','Bladespire Bagel','刀塔面圈','Clefthoof Ribs','裂蹄肋排','Homemade Cherry Pie','自制樱桃馅饼',"Mag'har Grainbread",'玛格汉面包',}},
      --售卖
      --{Settings = 'ForceSellList', value = {'亚麻布','毛料','丝绸','魔纹布','符文布','Linen Cloth','Wool Cloth','Silk Cloth','Mageweave Cloth','Runecloth',}},
      {End = "有蓝职业不售卖"},

      {If = "SC:GetPlayer().Class == 'HUNTER'", End = '猎人恢复设置'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70,85 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {10 ,40 ,}},
      {End = '猎人恢复设置'},
      
      {If = "SC:GetPlayer().Class == 'ROGUE' or SC:GetPlayer().Class == 'WARRIOR'", End = '战士盗贼恢复设置'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70 ,90 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {0 ,0 ,}},
      {End = '战士盗贼恢复设置'},

      {If = "SC:GetPlayer().Level < 58 and SC:GetPlayer().Class == 'SHAMAN' or SC:GetPlayer().Class == 'PRIEST' or SC:GetPlayer().Class == 'HUNTER' or SC:GetPlayer().Class == 'DRUID' or SC:GetPlayer().Class == 'PALADIN' or SC:GetPlayer().Class == 'WARLOCK'", End = '有蓝职业恢复设置'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70,85 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {50 ,85 ,}},
      {End = '有蓝职业恢复设置'},

      {If = "SC:GetPlayer().Level >= 58 and SC:GetPlayer().Class == 'SHAMAN' or SC:GetPlayer().Class == 'PRIEST' or SC:GetPlayer().Class == 'HUNTER' or SC:GetPlayer().Class == 'DRUID' or SC:GetPlayer().Class == 'PALADIN' or SC:GetPlayer().Class == 'WARLOCK'", End = '有蓝职业恢复设置1'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70,85 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {50 ,85 ,}},
      {End = '有蓝职业恢复设置1'},

      {If = "SC:GetPlayer().Level < 15 and SC:GetPlayer().Class == 'WARLOCK'", End = '术士职业恢复设置'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70,85 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {50 ,85 ,}},
      {End = '术士职业恢复设置'},

      {If = "SC:GetPlayer().Level >= 15 and SC:GetPlayer().Class == 'WARLOCK'", End = '术士职业恢复设置1'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70,85 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {50 ,85 ,}},
      {End = '术士职业恢复设置1'},

      {If = "SC:GetPlayer().PetActive == true", End = '设置宠物为被动型'},
      {Run = 'print("设置宠物为被动型")' },
      {Run = 'PetPassiveMode()' },
      {End = '设置宠物为被动型'},

      --如果我是法师的初始化
      {If = "SC:GetPlayer().Class=='MAGE'", End = 0},
            --是否接过任务
            --IsHasQuest(QuestID)
            --是否完成过任务
            --IsCompletedQuest(QuestID)
            --是否可以完成任务
            --CanCompleteQuest(QuestID,index)
            {Log='Info',Text="初始化法师战斗循环"},
            {Run = "DMW.Settings.profile.Rotation['奥术智慧'] = true"},
            {Run = "DMW.Settings.profile.Rotation['冰甲术/霜甲术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['熔岩护甲'] = false"},
            {Run = "DMW.Settings.profile.Rotation['魔甲术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['魔法抑制'] = true"},
            {Run = "DMW.Settings.profile.Rotation['法术反制'] = true"},
            {Run = "DMW.Settings.profile.Rotation['寒冰护体'] = true"},
            {Run = "DMW.Settings.profile.Rotation['法力护盾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['生命低于'] = 20"},
            {Run = "DMW.Settings.profile.Rotation['智能拉怪'] = 2"},
            {If = "SC:GetPlayer().Level >= 4", End = 30},
            {Run = "DMW.Settings.profile.Rotation['寒冰箭'] = true"},
            {Run = "DMW.Settings.profile.Rotation['大火球'] = false"},
            {End = 30},
            {If = "SC:GetPlayer().Level < 4", End = 31},
            {Run = "DMW.Settings.profile.Rotation['寒冰箭'] = false"},
            {Run = "DMW.Settings.profile.Rotation['大火球'] = true"},
            {End = 31},
            {Run = "DMW.Settings.profile.Rotation['炎爆术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['召唤水元素'] = true"},
            {Run = "DMW.Settings.profile.Rotation['火焰冲击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['冲击波'] = false"},
            {Run = "DMW.Settings.profile.Rotation['燃烧'] = false"},
            {Run = "DMW.Settings.profile.Rotation['灼烧'] = false"},
            {Run = "DMW.Settings.profile.Rotation['冰霜新星'] = true"},
            {Run = "DMW.Settings.profile.Rotation['冰霜新星时后退'] = true"},
            {Run = "DMW.Settings.profile.Rotation['水元素冰霜新星'] = true"},
            {Run = "DMW.Settings.profile.Rotation['宠物自动攻击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['让宠物自动攻击目标'] = true"},
            {Run = "DMW.Settings.profile.Rotation['冰锥术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['龙息术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['冰枪术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['奥术飞弹'] = false"},
            {Run = "DMW.Settings.profile.Rotation['急速冷却'] = false"},
            {Run = "DMW.Settings.profile.Rotation['急速冷却生命低于'] = 45"},
            {Run = "DMW.Settings.profile.Rotation['冰冷血脉'] = true"},
            {Run = "DMW.Settings.profile.Rotation['冰冷血脉生命低于'] = 90"},
            {Run = "DMW.Settings.profile.Rotation['造水术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['造食术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['唤醒'] = true"},
            {Run = "DMW.Settings.profile.Rotation['唤醒法力值百分比'] = 35"},
            {Run = "DMW.Settings.profile.Rotation['解除次级诅咒'] = true"},
            {Run = "DMW.Settings.profile.Rotation['变形术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['使用法术石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['制造法力石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['法术石法力值'] = 60"},
            {Run = "DMW.Settings.profile.Rotation['法力分流法力值百分比'] = 80"},
	      {Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90"},
            {Log='Info',Text="初始化完成"},
      {End = 0},

      --如果我是盗贼的初始化
      {If = "SC:GetPlayer().Class=='ROGUE'", End = 0.5},
            --是否接过任务
            --IsHasQuest(QuestID)
            --是否完成过任务
            --IsCompletedQuest(QuestID)
            --是否可以完成任务
            --CanCompleteQuest(QuestID,index)
            {Log='Info',Text="初始化盗贼战斗循环"},
            {Run = "DMW.Settings.profile.Rotation['自动攻击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['脚踢'] = true"},
            {Run = "DMW.Settings.profile.Rotation['取消攻击后摇'] = true"},
            {Run = "DMW.Settings.profile.Rotation['邪恶攻击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['毒刃'] = false"},
            {Run = "DMW.Settings.profile.Rotation['剔骨'] = true"},
            {Run = "DMW.Settings.profile.Rotation['切割'] = true"},
            {Run = "DMW.Settings.profile.Rotation['剑刃乱舞'] = true"},
            {Run = "DMW.Settings.profile.Rotation['冲动'] = 3"},
            {Run = "DMW.Settings.profile.Rotation['开怪模式'] = 1"},
            {Run = "DMW.Settings.profile.Rotation['战斗剑PVE'] = true"},
            {Run = "DMW.Settings.profile.Rotation['菊花茶'] = false"},
            {Run = "DMW.Settings.profile.Rotation['无限晕锁'] = false"},
            {Run = "DMW.Settings.profile.Rotation['消失'] = true"},
            {Run = "DMW.Settings.profile.Rotation['闪避'] = true"},
            {Run = "DMW.Settings.profile.Rotation['开启闪避的血量百分比'] = 30"},
            {Run = "DMW.Settings.profile.Rotation['疾跑'] = true"},
            {Log='Info',Text="初始化完成"},
      {End = 0.5},

      --如果我是猎人的初始化
      {If = "SC:GetPlayer().Class=='HUNTER'", End = 0.6},
            --是否接过任务
            --IsHasQuest(QuestID)
            --是否完成过任务
            --IsCompletedQuest(QuestID)
            --是否可以完成任务
            --CanCompleteQuest(QuestID,index)
            {Log='Info',Text="初始化猎人战斗循环"},
            {Run = "DMW.Settings.profile.Rotation['自动攻击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['目标是宠物时拉开距离'] = true"},
            {Run = "DMW.Settings.profile.Rotation['自动雄鹰守护'] = true"},
            {Run = "DMW.Settings.profile.Rotation['自动灵猴守护'] = true"},
            {Run = "DMW.Settings.profile.Rotation['多重射击'] = false"},
            {Run = "DMW.Settings.profile.Rotation['奥术射击'] = false"},
            {Run = "DMW.Settings.profile.Rotation['猎人印记'] = true"},
            {Run = "DMW.Settings.profile.Rotation['急速射击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['瞄准射击'] = false"},
            {Run = "DMW.Settings.profile.Rotation['稳固射击'] = false"},
            {Run = "DMW.Settings.profile.Rotation['逃脱'] = true"},
            {Run = "DMW.Settings.profile.Rotation['假死'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂野怒火'] = true"},
            {Run = "DMW.Settings.profile.Rotation['猛禽一击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['猫鼬撕咬'] = true"},
            {Run = "DMW.Settings.profile.Rotation['摔绊'] = false"},
            {Run = "DMW.Settings.profile.Rotation['杀戮命令'] = true"},
            {Run = "DMW.Settings.profile.Rotation['毒蛇钉刺'] = false"},
            {Run = "DMW.Settings.profile.Rotation['宠物自动攻击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['召唤宠物'] = true"},
            {Run = "DMW.Settings.profile.Rotation['复活宠物'] = true"},
            {Run = "DMW.Settings.profile.Rotation['胁迫'] = true"},
            {Run = "DMW.Settings.profile.Rotation['宠物嘲讽'] = true"},
            {Run = "DMW.Settings.profile.Rotation['治疗宠物'] = true"},
            {Run = "DMW.Settings.profile.Rotation['治疗宠物生命百分比'] = 50"},
            {Log='Info',Text="初始化完成"},
      {End = 0.6},

      --如果我是牧师的初始化
      {If = "SC:GetPlayer().Class=='PRIEST'", End = 0.7},
            --是否接过任务
            --IsHasQuest(QuestID)
            --是否完成过任务
            --IsCompletedQuest(QuestID)
            --是否可以完成任务
            --CanCompleteQuest(QuestID,index)
            {Log='Info',Text="初始化牧师战斗循环"},
            {Run = "DMW.Settings.profile.Rotation['开启DPS'] = true"},
            {Run = "DMW.Settings.profile.Rotation['优先攻击最后敌人'] = true"},
            {Run = "DMW.Settings.profile.Rotation['开怪前上盾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['使用[暗言术：痛]拉怪'] = true"},
            {Run = "DMW.Settings.profile.Rotation['暗言术：痛'] = true"},
            {Run = "DMW.Settings.profile.Rotation['沉默'] = true"},
            {Run = "DMW.Settings.profile.Rotation['精神鞭笞'] = true"},
            {Run = "DMW.Settings.profile.Rotation['精神鞭笞法力值百分比'] = 10"},
            {If = "SC:GetPlayer().Level < 10", End = 30},
            {Run = "DMW.Settings.profile.Rotation['惩击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['惩击法力值百分比'] = 10"},
            {Run = "DMW.Settings.profile.Rotation['心灵震爆'] = false"},
            {Run = "DMW.Settings.profile.Rotation['心灵震爆法力值百分比'] = 10"},
            {End = 30},
            {If = "SC:GetPlayer().Level >= 10", End = '大于十关惩击'},
            {Run = "DMW.Settings.profile.Rotation['惩击'] = false"},
            {Run = "DMW.Settings.profile.Rotation['惩击法力值百分比'] = 10"},
            {Run = "DMW.Settings.profile.Rotation['心灵震爆'] = true"},
            {Run = "DMW.Settings.profile.Rotation['心灵震爆法力值百分比'] = 10"},
            {End = '大于十关惩击'},
            {Run = "DMW.Settings.profile.Rotation['心灵尖啸'] = true"},
            {Run = "DMW.Settings.profile.Rotation['心灵尖啸人数'] = 3"},
            {Run = "DMW.Settings.profile.Rotation['吸血鬼的拥抱'] = true"},
            {Run = "DMW.Settings.profile.Rotation['吸血鬼之触'] = true"},
            {Run = "DMW.Settings.profile.Rotation['暗影恶魔'] = true"},
            {Run = "DMW.Settings.profile.Rotation['暗言术灭击杀'] = true"},
            {Run = "DMW.Settings.profile.Rotation['暗言术灭击杀死亡时间'] = 4"},
            {Run = "DMW.Settings.profile.Rotation['绝望祷言'] = false"},
            {Run = "DMW.Settings.profile.Rotation['心灵尖啸人数'] = 30"},
            {Run = "DMW.Settings.profile.Rotation['心灵之火'] = true"},
            {Run = "DMW.Settings.profile.Rotation['祛病术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['驱散魔法'] = false"},
            {Run = "DMW.Settings.profile.Rotation['暗影守卫'] = true"},
            {Run = "DMW.Settings.profile.Rotation['暗影形态'] = true"},
            {Run = "DMW.Settings.profile.Rotation['暗影形态生命百分比'] = 21"},
            {Run = "DMW.Settings.profile.Rotation['清除暗影形态'] = 20"},
            {Run = "DMW.Settings.profile.Rotation['快速治疗'] = true"},
            {Run = "DMW.Settings.profile.Rotation['快速治疗百分比'] = 20"},
            {Run = "DMW.Settings.profile.Rotation['真言术：盾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['真言术：盾百分比'] = 85"},
            {Run = "DMW.Settings.profile.Rotation['恢复'] = true"},
            {Run = "DMW.Settings.profile.Rotation['恢复百分比'] = 85"},
            {Run = "DMW.Settings.profile.Rotation['队伍 - 真言术：韧'] = true"},
            {Run = "DMW.Settings.profile.Rotation['使用法术石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['制造法力石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['法术石法力值'] = 60"},
            {Run = "DMW.Settings.profile.Rotation['法力分流法力值百分比'] = 80"},
	      {Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90"},
            {Log='Info',Text="初始化完成"},
      {End = 0.7},

      --如果我是术士的初始化
      {If = "SC:GetPlayer().Class=='WARLOCK'", End = 0.8},
            --是否接过任务
            --IsHasQuest(QuestID)
            --是否完成过任务
            --IsCompletedQuest(QuestID)
            --是否可以完成任务
            --CanCompleteQuest(QuestID,index)
            {Log='Info',Text="初始化术士战斗循环"},
            {Run = "DMW.Settings.profile.Rotation['自动Buff'] = true"},
            {Run = "DMW.Settings.profile.Rotation['邪甲术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['制造治疗石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['制造灵魂石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['绑定灵魂石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['生命分流'] = true"},
            {Run = "DMW.Settings.profile.Rotation['战斗中不使用生命分流'] = false"},
            {Run = "DMW.Settings.profile.Rotation['生命分流法力值'] = 70"},
            {Run = "DMW.Settings.profile.Rotation['生命分流生命值'] = 50"},
            {Run = "DMW.Settings.profile.Rotation['有仇恨不使用生命分流'] = true"},
            {Run = "DMW.Settings.profile.Rotation['指定召唤宠物'] = 1"},
            {Run = "DMW.Settings.profile.Rotation['恶魔支配指定召唤'] = false"},
            {Run = "DMW.Settings.profile.Rotation['智能召唤宠物'] = true"},
            {Run = "DMW.Settings.profile.Rotation['恶魔支配智能召唤'] = true"},
            {Run = "DMW.Settings.profile.Rotation['黑暗契约'] = false"},
            {Run = "DMW.Settings.profile.Rotation['战斗中不使用黑暗契约'] = false"},
            {Run = "DMW.Settings.profile.Rotation['黑暗契约法力值'] = 60"},
            {Run = "DMW.Settings.profile.Rotation['黑暗契约宠物魔法值'] = 35"},
            {Run = "DMW.Settings.profile.Rotation['吞噬暗影'] = true"},
            {Run = "DMW.Settings.profile.Rotation['吞噬暗影生命值'] = 70"},
            {Run = "DMW.Settings.profile.Rotation['牺牲'] = true"},
            {Run = "DMW.Settings.profile.Rotation['牺牲生命值'] = 5"},
            {Run = "DMW.Settings.profile.Rotation['自动宠物攻击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['暗影箭'] = 3"},
            {Run = "DMW.Settings.profile.Rotation['暗影箭法力值'] = 35"},
            {Run = "DMW.Settings.profile.Rotation['无魔杖暗影箭'] = true"},
            {Run = "DMW.Settings.profile.Rotation['dot敌人数量'] = 3"},
            {Run = "DMW.Settings.profile.Rotation['诅咒增幅'] = true"},
            {Run = "DMW.Settings.profile.Rotation['诅咒'] = 2"},
            {Run = "DMW.Settings.profile.Rotation['轮流诅咒'] = true"},
            {Run = "DMW.Settings.profile.Rotation['腐蚀术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['轮流腐蚀术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['献祭'] = true"},
            {Run = "DMW.Settings.profile.Rotation['轮流献祭'] = false"},
            {Run = "DMW.Settings.profile.Rotation['生命虹吸'] = false"},
            {Run = "DMW.Settings.profile.Rotation['轮流生命虹吸'] = false"},
            {Run = "DMW.Settings.profile.Rotation['暗影灼烧'] = false"},
            {Run = "DMW.Settings.profile.Rotation['吸取生命二'] = false"},
            {Run = "DMW.Settings.profile.Rotation['烧尽'] = true"},
            {Run = "DMW.Settings.profile.Rotation['痛苦无常'] = false"},
            {Run = "DMW.Settings.profile.Rotation['腐蚀之种子'] = true"},
            {Run = "DMW.Settings.profile.Rotation['吸取生命'] = true"},
            {Run = "DMW.Settings.profile.Rotation['吸取生命生命值'] = 90"},
            {Run = "DMW.Settings.profile.Rotation['生命通道'] = true"},
            {Run = "DMW.Settings.profile.Rotation['生命通道宠物HP'] = 50"},
            {Run = "DMW.Settings.profile.Rotation['暗影防护结界'] = true"},
            {Run = "DMW.Settings.profile.Rotation['暗影之怒'] = true"},
            {Run = "DMW.Settings.profile.Rotation['恐惧多余目标'] = false"},
            {Run = "DMW.Settings.profile.Rotation['恐惧术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['吸取灵魂'] = true"},
            {Run = "DMW.Settings.profile.Rotation['最大碎片数停止吸取灵魂'] = true"},
            {Run = "DMW.Settings.profile.Rotation['最大碎片数量'] = 3"},
            {Run = "DMW.Settings.profile.Rotation['使用法术石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['制造法力石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['法术石法力值'] = 60"},
            {Run = "DMW.Settings.profile.Rotation['法力分流法力值百分比'] = 80"},
	      {Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90"},
            {Log='Info',Text="初始化完成"},
      {End = 0.8},

      --如果我是圣骑的初始化
      {If = "SC:GetPlayer().Class=='PALADIN'", End = 0.9},
            --是否接过任务
            --IsHasQuest(QuestID)
            --是否完成过任务
            --IsCompletedQuest(QuestID)
            --是否可以完成任务
            --CanCompleteQuest(QuestID,index)
            {Log='Info',Text="初始化圣骑战斗循环"},
            {Run = "DMW.Settings.profile.Rotation['开启DPS'] = true"},
            {Run = "DMW.Settings.profile.Rotation['优先攻击最后的敌人'] = true"},
            {Run = "DMW.Settings.profile.Rotation['指定祝福'] = 2"},
            {Run = "DMW.Settings.profile.Rotation['队伍-王者祝福'] = false"},
            {Run = "DMW.Settings.profile.Rotation['队伍-拯救祝福'] = false"},
            {Run = "DMW.Settings.profile.Rotation['队伍-力量祝福'] = false"},
            {Run = "DMW.Settings.profile.Rotation['指定光环'] = 1"},
            {Run = "DMW.Settings.profile.Rotation['野外惩戒智能光环'] = true"},
            {Run = "DMW.Settings.profile.Rotation['乘骑智能十字军光环'] = true"},
            {Run = "DMW.Settings.profile.Rotation['使用审判'] = true"},
            {Run = "DMW.Settings.profile.Rotation['指定圣印'] = 1"},
            {Run = "DMW.Settings.profile.Rotation['惩戒智能审判'] = true"},
            {Run = "DMW.Settings.profile.Rotation['防骑智能审判'] = false"},
            {Run = "DMW.Settings.profile.Rotation['指定审判'] = 1"},
            {Run = "DMW.Settings.profile.Rotation['智能公正审判'] = true"},
            {Run = "DMW.Settings.profile.Rotation['十字军打击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['制裁之锤'] = true"},
            {Run = "DMW.Settings.profile.Rotation['驱邪术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['愤怒之锤'] = true"},
            {Run = "DMW.Settings.profile.Rotation['奉献'] = true"},
            {Run = "DMW.Settings.profile.Rotation['输出复仇之怒'] = true"},
            {Run = "DMW.Settings.profile.Rotation['正义之怒保持'] = false"},
            {Run = "DMW.Settings.profile.Rotation['使用复仇者之盾拉怪'] = false"},
            {Run = "DMW.Settings.profile.Rotation['神圣之盾保持'] = false"},
            {Run = "DMW.Settings.profile.Rotation['队伍 - 正义防御'] = false"},
            {Run = "DMW.Settings.profile.Rotation['队伍-复活术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['队伍 - 复仇之怒治疗'] = false"},
            {Run = "DMW.Settings.profile.Rotation['清洁术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['纯净术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['队伍 - 圣光术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['队伍 - 圣光术百分比'] = 80"},
            {Run = "DMW.Settings.profile.Rotation['队伍 - 圣光闪现'] = false"},
            {Run = "DMW.Settings.profile.Rotation['队伍 - 圣光闪现百分比'] = 50"},
            {Run = "DMW.Settings.profile.Rotation['队伍 - 神圣震击'] = false"},
            {Run = "DMW.Settings.profile.Rotation['队伍 - 神圣震击百分比'] = 90"},
            {Run = "DMW.Settings.profile.Rotation['圣光术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['圣光术百分比'] = 30"},
            {Run = "DMW.Settings.profile.Rotation['圣光闪现'] = false"},
            {Run = "DMW.Settings.profile.Rotation['圣光闪现百分比'] = 10"},
            {Run = "DMW.Settings.profile.Rotation['圣盾术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['圣盾术百分比'] = 25"},
            {Run = "DMW.Settings.profile.Rotation['圣佑术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['圣佑术百分比'] = 25"},
            {Run = "DMW.Settings.profile.Rotation['圣疗术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['圣疗术百分比'] = 20"},
            
            {Run = "DMW.Settings.profile.Rotation['使用法术石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['制造法力石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['法术石法力值'] = 60"},
            {Run = "DMW.Settings.profile.Rotation['法力分流法力值百分比'] = 80"},
	      {Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90"},
            {Log='Info',Text="初始化完成"},
      {End = 0.9},

      --如果我是战士的初始化
      {If = "SC:GetPlayer().Class=='WARRIOR'", End = 0.11},
            --是否接过任务
            --IsHasQuest(QuestID)
            --是否完成过任务
            --IsCompletedQuest(QuestID)
            --是否可以完成任务
            --CanCompleteQuest(QuestID,index)
            {Log='Info',Text="初始化战士战斗循环"},
            {Run = "DMW.Settings.profile.Rotation['开启DPS'] = true"},
            {Run = "DMW.Settings.profile.Rotation['自动面对目标'] = true"},
            {Run = "DMW.Settings.profile.Rotation['自动攻击目标'] = true"},
            {Run = "DMW.Settings.profile.Rotation['指定战斗循环'] = 1"},
            {Run = "DMW.Settings.profile.Rotation['智能战斗循环'] = true"},
            {Run = "DMW.Settings.profile.Rotation['冲锋'] = true"},
            {Run = "DMW.Settings.profile.Rotation['斩杀'] = true"},
            {Run = "DMW.Settings.profile.Rotation['撕裂'] = false"},
            {Run = "DMW.Settings.profile.Rotation['破甲攻击'] = false"},
            {Run = "DMW.Settings.profile.Rotation['震荡猛击'] = false"},
            {Run = "DMW.Settings.profile.Rotation['乘胜追击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['猛击'] = false"},
            {Run = "DMW.Settings.profile.Rotation['血性狂暴'] = true"},
            {Run = "DMW.Settings.profile.Rotation['血性狂暴怒气值'] = 10"},
            {Run = "DMW.Settings.profile.Rotation['英勇打击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['英勇打击怒气值'] = 30"},
            {Run = "DMW.Settings.profile.Rotation['顺劈斩'] = true"},
            {Run = "DMW.Settings.profile.Rotation['顺劈斩人数'] = 2"},
            {Run = "DMW.Settings.profile.Rotation['战斗怒吼'] = true"},
            {Run = "DMW.Settings.profile.Rotation['挫志怒吼'] = 2"},
            {Run = "DMW.Settings.profile.Rotation['切换姿态损失的怒气值'] = 0"},
            {Run = "DMW.Settings.profile.Rotation['命令怒吼'] = true"},
            {Run = "DMW.Settings.profile.Rotation['命令怒吼血量'] = 30"},
            {Run = "DMW.Settings.profile.Rotation['泻怒'] = 70"},
            {Run = "DMW.Settings.profile.Rotation['压制'] = true"},
            {Run = "DMW.Settings.profile.Rotation['断筋'] = false"},
            {Run = "DMW.Settings.profile.Rotation['智能断筋'] = true"},
            {Run = "DMW.Settings.profile.Rotation['横扫攻击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['横扫攻击人数'] = 2"},
            {Run = "DMW.Settings.profile.Rotation['雷霆一击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['雷霆一击人数'] = 3"},
            {Run = "DMW.Settings.profile.Rotation['反击风暴'] = true"},
            {Run = "DMW.Settings.profile.Rotation['反击风暴生命百分比'] = 30"},
            {Run = "DMW.Settings.profile.Rotation['致死打击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['旋风斩'] = true"},
            {Run = "DMW.Settings.profile.Rotation['旋风斩人数'] = 3"},
            {Run = "DMW.Settings.profile.Rotation['死亡之愿'] = true"},
            {Run = "DMW.Settings.profile.Rotation['死亡之愿生命值'] = 50"},
            {Run = "DMW.Settings.profile.Rotation['鲁莽'] = true"},
            {Run = "DMW.Settings.profile.Rotation['鲁莽生命值'] = 50"},
            {Run = "DMW.Settings.profile.Rotation['鲁莽人数'] = 2"},
            {Run = "DMW.Settings.profile.Rotation['嗜血'] = true"},
            {Run = "DMW.Settings.profile.Rotation['嗜血生命值'] = 70"},
            {Run = "DMW.Settings.profile.Rotation['拳击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴之怒'] = true"},
            {Run = "DMW.Settings.profile.Rotation['暴怒'] = true"},
            {Run = "DMW.Settings.profile.Rotation['嘲讽'] = false"},
            {Run = "DMW.Settings.profile.Rotation['复仇'] = false"},
            {Run = "DMW.Settings.profile.Rotation['盾击'] = false"},
            {Run = "DMW.Settings.profile.Rotation['盾牌格挡'] = false"},
            {Run = "DMW.Settings.profile.Rotation['盾牌猛击'] = false"},
            {Run = "DMW.Settings.profile.Rotation['缴械'] = false"},
            {Run = "DMW.Settings.profile.Rotation['破釜沉舟'] = false"},
            {Run = "DMW.Settings.profile.Rotation['嗜血生命值'] = 70"},
            {Run = "DMW.Settings.profile.Rotation['盾墙'] = false"},
            {Run = "DMW.Settings.profile.Rotation['嗜血生命值'] = 70"},            
            {Run = "DMW.Settings.profile.Rotation['使用法术石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['制造法力石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['法术石法力值'] = 60"},
            {Run = "DMW.Settings.profile.Rotation['法力分流法力值百分比'] = 80"},
	      {Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90"},
            {Log='Info',Text="初始化完成"},
      {End = 0.11},

      --如果我是德鲁伊的初始化
      {If = "SC:GetPlayer().Class=='DRUID'", End = 0.12},
            --是否接过任务
            --IsHasQuest(QuestID)
            --是否完成过任务
            --IsCompletedQuest(QuestID)
            --是否可以完成任务
            --CanCompleteQuest(QuestID,index)
            {Log='Info',Text="初始化战士战斗循环"},
            {Run = "DMW.Settings.profile.Rotation['选择形态'] = 3"},
            {Run = "DMW.Settings.profile.Rotation['野外智能形态'] = true"},
            {Run = "DMW.Settings.profile.Rotation['猎豹形态开怪'] = 5"},
            {Run = "DMW.Settings.profile.Rotation['野外智能开怪'] = true"},
            {Run = "DMW.Settings.profile.Rotation['自动取消变形'] = true"},
            {Run = "DMW.Settings.profile.Rotation['形态切换'] = true"},
            {Run = "DMW.Settings.profile.Rotation['潜行'] = true"},
            {Run = "DMW.Settings.profile.Rotation['裂伤-猫'] = true"},
            {Run = "DMW.Settings.profile.Rotation['裂伤-熊'] = true"},
            {Run = "DMW.Settings.profile.Rotation['斜掠'] = true"},
            {Run = "DMW.Settings.profile.Rotation['割裂'] = true"},
            {Run = "DMW.Settings.profile.Rotation['割伤'] = true"},
            {Run = "DMW.Settings.profile.Rotation['凶猛撕咬'] = true"},
            {Run = "DMW.Settings.profile.Rotation['猛击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['横扫'] = true"},
            {Run = "DMW.Settings.profile.Rotation['挫志咆哮'] = true"},
            {Run = "DMW.Settings.profile.Rotation['重殴'] = true"},
            {Run = "DMW.Settings.profile.Rotation['重殴怒气值'] = 20"},
            {Run = "DMW.Settings.profile.Rotation['狂暴回复'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴回复百分比'] = 60"},
            {Run = "DMW.Settings.profile.Rotation['精灵之火(野性)'] = true"},
            {Run = "DMW.Settings.profile.Rotation['精灵之火(野性)拉怪'] = false"},
            {Run = "DMW.Settings.profile.Rotation['激怒'] = true"},
            {Run = "DMW.Settings.profile.Rotation['激活'] = true"},
            {Run = "DMW.Settings.profile.Rotation['野性印记'] = true"},
            {Run = "DMW.Settings.profile.Rotation['荆棘术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['清晰预兆'] = true"},
            {Run = "DMW.Settings.profile.Rotation['猛虎之怒'] = true"},
            {Run = "DMW.Settings.profile.Rotation['消毒术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['非战斗消毒术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['移除诅咒'] = false"},
            {Run = "DMW.Settings.profile.Rotation['非战斗移除诅咒'] = true"},
            {Run = "DMW.Settings.profile.Rotation['驱毒术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['非战斗驱毒术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['精灵之火'] = true"},
            {Run = "DMW.Settings.profile.Rotation['树皮术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['树皮术百分比'] = 50"},
            {Run = "DMW.Settings.profile.Rotation['治疗之触'] = false"},
            {Run = "DMW.Settings.profile.Rotation['愈合'] = false"},
            {Run = "DMW.Settings.profile.Rotation['回春术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['回春术百分比'] = 60"},
            {Run = "DMW.Settings.profile.Rotation['战斗回春术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['战斗回春术百分比'] = 60"},
            {Run = "DMW.Settings.profile.Rotation['生命绽放'] = false"},
            {Run = "DMW.Settings.profile.Rotation['使用治疗石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['治疗药水'] = true"},
	      {Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90"},
            {Log='Info',Text="初始化完成"},
      {End = 0.12},

      --如果我是萨满的初始化
      {If = "SC:GetPlayer().Class=='SHAMAN'", End = 0.12},
            --是否接过任务
            --IsHasQuest(QuestID)
            --是否完成过任务
            --IsCompletedQuest(QuestID)
            --是否可以完成任务
            --CanCompleteQuest(QuestID,index)
            {Log='Info',Text="初始化战士战斗循环"},
            {Run = "DMW.Settings.profile.Rotation['使用图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['大地之力图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['灼热图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['灼热图腾法力值'] = 50"},
            {Run = "DMW.Settings.profile.Rotation['火舌图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['火舌图腾法力值'] = 50"},
            {Run = "DMW.Settings.profile.Rotation['熔岩图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['熔岩图腾法力值'] = 50"},
            {Run = "DMW.Settings.profile.Rotation['火焰新星图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['火焰新星图腾法力值'] = 50"},
            {Run = "DMW.Settings.profile.Rotation['风怒图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['风之优雅图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['石肤图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['石爪图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['空气图腾'] = false"},
            {Run = "DMW.Settings.profile.Rotation['治疗之泉图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['法力之泉图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['冰霜震击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['地震术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['地震术法力值'] = 50"},
            {Run = "DMW.Settings.profile.Rotation['烈焰震击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['烈焰震击法力值'] = 50"},
            {Run = "DMW.Settings.profile.Rotation['风暴打击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['地震术-打断'] = true"},
            {Run = "DMW.Settings.profile.Rotation['闪电之盾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['水之护盾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['嗜血'] = true"},
            {Run = "DMW.Settings.profile.Rotation['嗜血生命值'] = 35"},
            {Run = "DMW.Settings.profile.Rotation['萨满之怒'] = true"},
            {Run = "DMW.Settings.profile.Rotation['萨满之怒生命值'] = 40"},
            {Run = "DMW.Settings.profile.Rotation['火元素图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['火元素图腾生命值'] = 30"},
            {Run = "DMW.Settings.profile.Rotation['土元素图腾'] = true"},
            {Run = "DMW.Settings.profile.Rotation['土元素图腾生命值'] = 30"},
            {Run = "DMW.Settings.profile.Rotation['智能武器附魔'] = true"},
            {Run = "DMW.Settings.profile.Rotation['武器附魔'] = 1"},
            {Run = "DMW.Settings.profile.Rotation['消毒术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['祛病术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['净化术'] = false"},
            {Run = "DMW.Settings.profile.Rotation['非战斗消毒术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['非战斗祛病术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['非战斗净化术'] = true"},
            {Run = "DMW.Settings.profile.Rotation['水下呼吸'] = true"},
            {Run = "DMW.Settings.profile.Rotation['次级治疗波'] = true"},
            {Run = "DMW.Settings.profile.Rotation['次级治疗波生命值'] = 50"},
            {Run = "DMW.Settings.profile.Rotation['治疗波'] = true"},
            {Run = "DMW.Settings.profile.Rotation['治疗波生命值'] = 30"},

            {Run = "DMW.Settings.profile.Rotation['使用治疗石'] = true"},
            {Run = "DMW.Settings.profile.Rotation['治疗药水'] = true"},
	      {Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90"},
            {Log='Info',Text="初始化完成"},
      {End = 0.12},
      {Replace = 'text2'},
}

local text2 = {
      {If = "SC:GetPlayer().Class == 'HUNTER' and SC:GetPlayer().Level >= 1 and SC:GetPlayer().Level < 10", End = '猎人购买弹药400'},
      --弹药数量
      {Settings = 'AmmoAmount', value = 400},
      {End = '猎人购买弹药400'},

      {If = "SC:GetPlayer().Class == 'HUNTER' and SC:GetPlayer().Level >= 10 and SC:GetPlayer().Level < 30", End = '猎人购买弹药1000'},
      --弹药数量
      {Settings = 'AmmoAmount', value = 1000},
      {End = '猎人购买弹药1000'},

      {If = "SC:GetPlayer().Class == 'HUNTER' and SC:GetPlayer().Level >= 30 and SC:GetPlayer().Level <= 70", End = '猎人购买弹药1600'},
      --弹药数量
      {Settings = 'AmmoAmount', value = 1800},
      {End = '猎人购买弹药1600'},
    --判定有蓝职业
      { If =  "SC:GetPlayer().Class == 'SHAMAN' or SC:GetPlayer().Class == 'PRIEST' or SC:GetPlayer().Class == 'HUNTER' or SC:GetPlayer().Class == 'DRUID' or SC:GetPlayer().Class == 'PALADIN' or SC:GetPlayer().Class=='WARLOCK'",End = 1.2},
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
      {Settings = 'EatAll', value = false},
      --远程下马距离
      {Settings = 'DismountDistance', value = 40},
      --骑士下马距离
      { If =  "SC:GetPlayer().Class == 'PALADIN'",End = 0.1},
      --近战下马距离
      {Settings = 'DismountDistance', value = 50},
      {End = 0.1},
      {End = 1.2},
      --判定没蓝职业
      { If =  "SC:GetPlayer().Class == 'ROGUE' or SC:GetPlayer().Class == 'WARRIOR'",End = 1.3},
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
      {Settings = 'EatAll', value = false},
      --近战下马距离
      {Settings = 'DismountDistance', value = 0},
      {End = 1.3},
      --判定我是法师许需要购买食物
      { If =  "SC:GetPlayer().Class == 'MAGE'",End = 1.4},
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
      {Settings = 'EatAll', value = false},
      --远程下马距离
      {Settings = 'DismountDistance', value = 40},
    {End = 1.4},
     -- 我是部落 and 等级大于1 小于 71
    {If = "SC:GetPlayer().Level >= 1 and SC:GetPlayer().Level < 71 ", End = 1},
                  --不走水路,假是不走水路,真是走水路
                  {Settings = 'WalkWater', value =true},         
                  --回家路径避免卡位
                  {Settings = 'GoHomePath', value = {},},
                  --离开家路径避免卡位
                  {Settings = 'LeaveHomePath', value = {}},
                  --不设置对话npc 不能邮寄，等作者添加对话邮寄
                  {Settings = 'BuyNPC', value = {
                    --食物商人 商人的id path等商人的坐标
                    {Id =16602  ,Path = {{189.4791, 2613.2114, 87.2836}}},
                    --修装的  商人的id path等商人的坐标
                    {Id =22225  ,Path = {{182.6368, 2606.4153, 87.2836}}},
                    --邮箱id和对话邮箱站着的坐标
                    {Id =181381  ,Path = {{172.7257, 2623.0557, 86.8361}}},
                  }},
                  --是否判断回城事件
                  {Settings = 'GoHomeEvent', value = true},
  
                  --我在地狱火半岛，不在打怪周围100码
                  {If = "SC:GetPlayer().mapID == 1944 and SC:GetPlayer():DistanceTo(773.3190, 2159.4668, 273.5144)  > 100 ",End = '飞去打怪地方'},
                        --去萨尔玛门口
                        {MoveTo = {171.3018, 2638.3020, 86.5038,true},},
                        {Run = 'print("在空地飞去打怪")' },
                        {If = "not UseFlyMount()",End = '使用飞天坐骑'},--如果上了坐骑就返回假，没有使用就返回真
                              {Delay = 2},
                              {Run = 'UseFlyMount()'},
                        {Loop = '使用飞天坐骑'},--loop循环到假
                        {Delay = 0.5},
                        --跳一下起飞
                        {Run = 'SC:GetPlayer():Jump()'},
                        --飞到最高
                        {MoveTo = {187.7820, 2645.7017, 373,false},},
                        --飞过去打怪上方
                        {MoveTo = {774.9570, 2081.4443, 373,false},},
                        --落地坐标
                        {Run = 'print("落地")' },
                        {MoveTo = {774.9570, 2081.4443, 273.5144,false},},
                        {Delay = 2},
                        --到地方下马
                        {Run = 'RunMacroText("/dismount")'},
                  {End = '飞去打怪地方'},

            --找怪范围
            {Settings = 'SearchRadius', value = 40},
            {AttackMonster = {22323} , Count = 1 , --左侧是打怪的怪物id,1513,1918,1919,1506,1507,1508
            MoveTo = {--下面是录制的打怪的要去的坐标
	      	  {{774.9570, 2081.4443, 272.3184},},--定点打怪坐标,想多去坐标就多加
                      --{{773.3190, 2159.4668, 273.5144},},--定点打怪坐标,想多去坐标就多加
            }, Random = 0 ,FindPath =true,
            },
    {Loop = 1},







}


--加入脚本
Bot:AddQuest('text',text)
--加入脚本
Bot:AddQuest('text2',text2)
--加入脚本
Bot:AddQuest('GoHome',GoHome)
--设定第一个执行的脚本
Bot:SetFirstQuest('text')
Bot:SetStart(function()
    Config:Hide()
      Log:System('=======================')
      Log:System("脚本载入")
      Log:System('=======================')
      Bot:SetPulse(Bot.QuestScriptPulse)
      SetPulseTime(0.1)
      if not SC.IsSimpleVer() then
		SC:SetNoClip(0)
      end
      --自动调整帧数
      SetCVar("maxFPS", 50)
      SetCVar("maxFPSBk", 50)
      SetDMWHUD('Rotation',true) --DMW
      local LearnThisTalentList = {}
      --自动加天赋
      if SC:GetPlayer().Class=='MAGE' then
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
      if SC:GetPlayer().Class=='ROGUE' then
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
      if SC:GetPlayer().Class=='HUNTER' then
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
                  {109, 3}, --狂怒释放3点
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
            }
      end
      if SC:GetPlayer().Class=='PRIEST' then
            LearnThisTalentList = {
                  {301, 1}, --精神分流5点
                  {301, 2}, --精神分流5点
                  {301, 3}, --精神分流5点
                  {301, 4}, --精神分流5点
                  {301, 5}, --精神分流5点
                  {102, 1}, --魔杖专精5点
                  {102, 2}, --魔杖专精5点
                  {102, 3}, --魔杖专精5点
                  {102, 4}, --魔杖专精5点
                  {102, 5}, --魔杖专精5点
                  {304, 1}, --强化暗言术：痛2点
                  {304, 2}, --强化暗言术：痛2点
                  {302, 1}, --昏阙5点
                  {302, 2}, --昏阙5点
                  {302, 3}, --昏阙5点
                  {308, 1}, --精神鞭笞1
                  {307, 1}, --强化心灵震爆5点
                  {307, 2}, --强化心灵震爆5点
                  {307, 3}, --强化心灵震爆5点
                  {307, 4}, --强化心灵震爆5点
                  {307, 5}, --强化心灵震爆5点
                  {311, 1}, --暗影之波4点
                  {311, 2}, --暗影之波4点
                  {311, 3}, --暗影之波4点
                  {311, 4}, --暗影之波4点
                  {313, 1}, --吸血鬼的拥抱1点
                  {314, 1}, --强化吸血鬼的拥抱2点
                  {314, 2}, --强化吸血鬼的拥抱2点
                  {315, 1}, --心灵集中3点
                  {315, 2}, --心灵集中3点
                  {315, 3}, --心灵集中3点
                  {302, 4}, --昏阙5点
                  {302, 5}, --昏阙5点
                  {311, 1}, --暗影之波5点
                  {311, 2}, --暗影之波5点
                  {311, 3}, --暗影之波5点
                  {311, 4}, --暗影之波5点
                  {311, 5}, --暗影之波5点
                  {317, 1}, --黑暗1点
                  {318, 1}, --暗影形态1点
                  {319, 1}, --暗影能量5点
                  {319, 2}, --暗影能量5点
                  {319, 3}, --暗影能量5点
                  {319, 4}, --暗影能量5点
                  {319, 5}, --暗影能量5点
                  {306, 1}, --强化心灵尖啸2点
                  {306, 2}, --强化心灵尖啸2点
                  {312, 1}, --沉默1点
                  {317, 1}, --黑暗2点
                  {317, 2}, --黑暗2点
                  {321, 1}, --吸血鬼之触1点--45级
                  {317, 1}, --黑暗5点
                  {317, 2}, --黑暗5点
                  {317, 3}, --黑暗5点
                  {317, 4}, --黑暗5点
                  {317, 5}, --黑暗5点
                  {320, 1}, --悲惨5点
                  {320, 2}, --悲惨5点
                  {320, 3}, --悲惨5点
                  {320, 4}, --悲惨5点
                  {320, 5}, --悲惨5点
                  {305, 1}, --暗影集中5点
                  {305, 2}, --暗影集中5点
                  {305, 3}, --暗影集中5点
                  {305, 4}, --暗影集中5点
                  {305, 5}, --暗影集中5点
                  {310, 1}, --暗影延伸2点
                  {310, 2}, --暗影延伸2点
                  {105, 1}, --强化真言术：盾2点
                  {105, 2}, --强化真言术：盾2点
            }
      end
      if SC:GetPlayer().Class=='WARLOCK' then
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
      if SC:GetPlayer().Class=='PALADIN' then
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
      if SC:GetPlayer().Class=='WARRIOR' then
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
      if SC:GetPlayer().Class=='DRUID' then
            LearnThisTalentList = {
                  {201, 1},-- 凶暴 5点
                  {201, 2},-- 凶暴 5点
                  {201, 3},-- 凶暴 5点
                  {201, 4},-- 凶暴 5点
                  {201, 5},-- 凶暴 5点
                  {204, 1},-- 野蛮冲撞 2点
                  {204, 2},-- 野蛮冲撞 2点
                  {205, 1},-- 厚皮 3点
                  {205, 2},-- 厚皮 3点
                  {205, 3},-- 厚皮 3点
                  {206, 1},-- 豹之迅捷 2点
                  {206, 2},-- 豹之迅捷 2点
                  {208, 1},-- 锋利兽爪 3点
                  {208, 2},-- 锋利兽爪 3点
                  {208, 3},-- 锋利兽爪 3点
                  {211, 1},-- 原始狂怒 2点
                  {211, 2},-- 原始狂怒 2点
                  {210, 1},-- 猛兽攻击 3点
                  {210, 2},-- 猛兽攻击 3点
                  {210, 3},-- 猛兽攻击 3点
                  {209, 1},-- 撕碎攻击 2点
                  {209, 2},-- 撕碎攻击 2点
                  {212, 1},-- 野蛮暴怒 2点
                  {212, 2},-- 野蛮暴怒 2点
                  {213, 1},-- 精灵之火 1点
                  {215, 1},-- 野性之心 5点
                  {215, 2},-- 野性之心 5点
                  {215, 3},-- 野性之心 5点
                  {215, 4},-- 野性之心 5点
                  {215, 5},-- 野性之心 5点
                  {218, 1},-- 兽群领袖 1点
                  {219, 1},-- 强化兽群领袖 2点
                  {219, 2},-- 强化兽群领袖 2点
                  {216, 1},-- 适者生存 3点
                  {216, 2},-- 适者生存 3点
                  {216, 3},-- 适者生存 3点
                  {220, 1},-- 狩猎天性 5点
                  {220, 2},-- 狩猎天性 5点
                  {220, 3},-- 狩猎天性 5点
                  {220, 4},-- 狩猎天性 5点
                  {220, 5},-- 狩猎天性 5点
                  {221, 1},-- 裂伤 1点
                  {301, 1},-- 强化野性印记 5点
                  {301, 2},-- 强化野性印记 5点
                  {301, 3},-- 强化野性印记 5点
                  {301, 4},-- 强化野性印记 5点
                  {301, 5},-- 强化野性印记 5点
                  {303, 1},-- 自然主义 5点
                  {303, 2},-- 自然主义 5点
                  {303, 3},-- 自然主义 5点
                  {303, 4},-- 自然主义 5点
                  {303, 5},-- 自然主义 5点
                  {308, 1},-- 清晰预兆 1点
                  {302, 1},-- 激怒 5点
                  {302, 2},-- 激怒 5点
                  {302, 3},-- 激怒 5点
                  {302, 4},-- 激怒 5点
                  {302, 5},-- 激怒 5点
                  {306, 1},-- 强烈3点
                  {306, 2},-- 强烈3点
                  {306, 3},-- 强烈3点
            }
      end
      if SC:GetPlayer().Class=='SHAMAN' then
            LearnThisTalentList = {
                  {201, 1}, --先祖知识5点
                  {201, 2}, --先祖知识5点
                  {201, 3}, --先祖知识5点
                  {201, 4}, --先祖知识5点
                  {201, 5}, --先祖知识5点
                  {204, 1}, --雷鸣猛击5点
                  {204, 2}, --雷鸣猛击5点
                  {204, 3}, --雷鸣猛击5点
                  {204, 4}, --雷鸣猛击5点
                  {204, 5}, --雷鸣猛击5点
                  {208, 1}, --萨满专注1点
                  {207, 1}, --强化图腾2点
                  {207, 2}, --强化图腾2点
                  {205, 1}, --强化幽灵之狼2点
                  {205, 2}, --强化幽灵之狼2点
                  {210, 1}, --乱舞5点
                  {210, 2}, --乱舞5点
                  {210, 3}, --乱舞5点
                  {210, 4}, --乱舞5点
                  {210, 5}, --乱舞5点
                  {214, 1}, --元素武器3点
                  {214, 2}, --元素武器3点
                  {214, 3}, --元素武器3点
                  {213, 1}, --灵魂武器1点
                  {211, 1}, --坚韧1点
                  {216, 1}, --武器掌握5点
                  {216, 2}, --武器掌握5点
                  {216, 3}, --武器掌握5点
                  {216, 4}, --武器掌握5点
                  {216, 5}, --武器掌握5点
                  {119, 1}, --风暴打击1点
                  {218, 1}, --双武器1点
                  {215, 1}, --精神敏锐3点
                  {215, 2}, --精神敏锐3点
                  {215, 3}, --精神敏锐3点
                  {220, 1}, --怒火释放5点
                  {220, 2}, --怒火释放5点
                  {220, 3}, --怒火释放5点
                  {220, 4}, --怒火释放5点
                  {220, 5}, --怒火释放5点
                  {221, 1}, --萨满之怒1点
                  {217, 1}, --双武器专精3点
                  {217, 2}, --双武器专精3点
                  {217, 3}, --双武器专精3点
                  {302, 1}, --潮汐集中5点
                  {302, 2}, --潮汐集中5点
                  {302, 3}, --潮汐集中5点
                  {302, 4}, --潮汐集中5点
                  {302, 5}, --潮汐集中5点
                  {301, 1}, --强化治疗波5点
                  {301, 2}, --强化治疗波5点
                  {301, 3}, --强化治疗波5点
                  {301, 4}, --强化治疗波5点
                  {301, 5}, --强化治疗波5点
                  {306, 1}, --自然指引3点
                  {306, 2}, --自然指引3点
                  {306, 3}, --自然指引3点
                  {305, 1}, --图腾集中4点
                  {305, 2}, --图腾集中4点
                  {305, 3}, --图腾集中4点
                  {305, 4}, --图腾集中4点
            }
      end
      --如果我是猎人
      if SC:GetPlayer().Class=='HUNTER' then
         SetSettings({
                  --当弹药数量少于多少时触发回城
                  AmmoAmountToGoToTown = 100,
            })
            if SC:GetPlayer().Level < 10 then --小于10级要购买弹药数量
                  SetSettings({
                  AmmoAmount = 400
            })
            elseif SC:GetPlayer().Level >= 10 and SC:GetPlayer().Level < 30 then --大于10级要购买弹药数量
                  SetSettings({
                  AmmoAmount = 1000
            })
            elseif SC:GetPlayer().Level >= 30 and SC:GetPlayer().Level <= 70 then --打于30级要购买弹药数量
                  SetSettings({
                  AmmoAmount = 1000
            })
            end
      end
      --最先加载的线程初始化
      SetSettings({
            LearnThisTalent = LearnThisTalentList,
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
            agentRadius = 0.4,
            --使用食物
            UseFood = true,
            --使用饮料
            UseDrink = true,
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
            EatAll = true,
            --是否判断回城事件
            GoHomeEvent = false,
            --恢复生命值范围
            FoodPercent = {70 ,90 ,},
            --恢复法力值范围
            DrinkPercent = {85 ,90 ,},
            --使用炉石
            UseHearthStone = false,
            --当背包空格小于等于多少时触发回城
            MinFreeBagSlotsToGoToTown = 2,
            --当装备耐久度小于等于%多少时触发回城
            MinDurabilityPercent = 20,
            --当弹药数量少于多少时触发回城
            AmmoAmountToGoToTown = 0,
            --贩卖颜色等级0~8
            SellLevel = {[0] = true,[1] = true,[2] = true,},
            --不贩卖列表 {id,id,id
            DoNotSellList = {'Rune of','传送','Hearthstone','炉石','Primal','源生','Mote of','微粒','Air','空气','基尔加丹印记',"Mark of Kil'jaeden","Thieves'Tools",'潜行者工具','Flash Powder','闪光粉'},
            --强制贩卖列表 {id,id,id
            ForceSellList = {'亚麻布','毛料','丝绸','魔纹布','符文布','硬肉干','清凉的泉水','血岩碎片','森林蘑菇','Linen Cloth','Wool Cloth','Silk Cloth','Mageweave Cloth','Runecloth','Tough Jerky','Refreshing Spring Water','Blood Shard','Forest Mushroom Cap',},
            --强制销毁
            ForceDeleteList = {'秘教的命令','Cabal Orders','OOX','被撕破的日记','A Mangled Journal'},
            --是否反击
            Counterattack = true,
            --自动换装
            AutoEquip = true,
            --输出信息写入Log
            WriteLog = true,
            --复活距离
            RetrieveDis = 38,
            --购买最好
            Buybest = true,
            --食物数量
            FoodAmount = 0,
            --饮料数量
            DrinkAmount = 0,
            --弹药
            AmmoAmount = 0,
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
            DismountDistance = 50,
            --自动复活
            AutoRetrieve = true,
            --回家路径避免卡位
            GoHomePath = {},
            --离开家路径避免卡位
            LeaveHomePath = {},
            --回城坐标
            BuyNPC = {},
            --设定等待超时60秒
            TimeOut = 60,
            --传送避免
            TPExceptPath = {
                  --地铁门
                  {72.7980, 10.2072, -4.2966},
                  {-8354.2305, 524.0680, 91.7971},
                  {73.0952, 2490.7520, -4.2964},
                  {-4839.5630, -1323.9087, 501.8681},
                              --黑暗之门
                  { -11907.7051, -3209.1658, -14.5401},
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
                  --加基森
                  {-7138.3945, -3786.4583,  distance = 65 , mapID = 1446},
                  --希利苏斯
                  {-6859.3345, 733.9985, 45.6638,  distance = 20 , mapID = 1451},
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
            },
      })
end)

Bot:SetStop(function()
      Log:System('=======================')
      Log:System("脚本停止")
      Log:System('=======================')
end)

return Bot