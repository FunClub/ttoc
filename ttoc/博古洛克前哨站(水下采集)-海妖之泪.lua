local Bot = TTOCInitScript("博古洛克前哨站-海妖之泪")
local Log = Bot.Log
local UI = Bot.UI
local Config = Bot.Config
local TTOC = ...
--SC为了安全可以自定义,比如BABA = TTOC ,比如YEYE = TTOC ,然后更换SC为你自定义的名字!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
SC = TTOC
   
local text = {
      {If = "SC:GetPlayer().Class == 'HUNTER'", End = '猎人恢复设置'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70,85 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {30 ,85 ,}},
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
      {Settings = 'DrinkPercent', value = {30 ,85 ,}},
      {End = '有蓝职业恢复设置'},

      {If = "SC:GetPlayer().Level >= 58 and SC:GetPlayer().Class == 'SHAMAN' or SC:GetPlayer().Class == 'PRIEST' or SC:GetPlayer().Class == 'HUNTER' or SC:GetPlayer().Class == 'DRUID' or SC:GetPlayer().Class == 'PALADIN' or SC:GetPlayer().Class == 'WARLOCK'", End = '有蓝职业恢复设置1'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70,85 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {30 ,85 ,}},
      {End = '有蓝职业恢复设置1'},

      {If = "SC:GetPlayer().Level < 15 and SC:GetPlayer().Class == 'WARLOCK'", End = '术士职业恢复设置'},
      --恢复生命值范围
      {Settings = 'FoodPercent', value = {70,85 ,}},
      --恢复法力值范围
      {Settings = 'DrinkPercent', value = {30 ,85 ,}},
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
            {Run = "DMW.Settings.profile.Rotation['冰霜新星'] = false"},
            {Run = "DMW.Settings.profile.Rotation['冰霜新星时后退'] = true"},
            {Run = "DMW.Settings.profile.Rotation['水元素冰霜新星'] = true"},
            {Run = "DMW.Settings.profile.Rotation['宠物自动攻击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['让宠物自动攻击目标'] = true"},
            {Run = "DMW.Settings.profile.Rotation['冰锥术'] = false"},
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
            {Run = "DMW.Settings.profile.Rotation['变形术'] = false"},
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
            {Run = "DMW.Settings.profile.Rotation['奥术射击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['猎人印记'] = true"},
            {Run = "DMW.Settings.profile.Rotation['急速射击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['瞄准射击'] = false"},
            {Run = "DMW.Settings.profile.Rotation['稳固射击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['逃脱'] = false"},
            {Run = "DMW.Settings.profile.Rotation['假死'] = true"},
            {Run = "DMW.Settings.profile.Rotation['狂野怒火'] = true"},
            {Run = "DMW.Settings.profile.Rotation['猛禽一击'] = true"},
            {Run = "DMW.Settings.profile.Rotation['猫鼬撕咬'] = true"},
            {Run = "DMW.Settings.profile.Rotation['摔绊'] = false"},
            {Run = "DMW.Settings.profile.Rotation['杀戮命令'] = true"},
            {Run = "DMW.Settings.profile.Rotation['毒蛇钉刺'] = true"},
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
            {Run = "DMW.Settings.profile.Rotation['魔息术'] = true"},
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
      {Replace = 'mainScript'},
}

local LT_Util = {
      hasDebuff = function (idOrName)
            for i = 1, 40 do
                local name, _, _, _, duration, expirationTime, unitCaster, _, _, spellId = UnitDebuff('player', i)
                if name then
                    if type(idOrName) == 'string' and idOrName == name then
                        return true
                    end
        
                    if type(idOrName) == 'number' and idOrName == spellId then
                        return true
                    end
                end
            end
            return false
        end,
      hasBuff = function (idOrName)
            for i = 1, 40 do
                local name, _, _, _, duration, expirationTime, unitCaster, _, _, spellId = UnitBuff('player', i)
                if name then
                    if type(idOrName) == 'string' and idOrName == name then
                        return true
                    end
        
                    if type(idOrName) == 'number' and idOrName == spellId then
                        return true
                    end
                end
            end
            return false
      end,
    
  

}
local LT = {
      --[[
            使用BUFF物品
            itemName=物品名,BuffName=Buff名称
      --]]
      useBuffItem = function (itemName)
            if itemName == '' then
                 return
            end
            local itemBuffMap = {
                  ['特效敏捷药剂'] = '特效敏捷' ,
                  ['极效敏捷药剂'] = '极效敏捷' ,
                  ['法术能量药剂'] = '法能药剂' ,
                  ['法能药剂'] = '法能药剂' ,
                  ['特效魔血药剂'] = '强效法力回复' ,
                  ['极效魔血药剂'] = '强效法力回复',
                  ['水下呼吸药剂'] = '水下呼吸',
                  ['强力水下呼吸药剂'] = '强效水下呼吸'  
            }
            local buffName;
            for key, value in pairs(itemBuffMap) do
                 if key == itemName then
                        buffName = value
                        break
                 end
            end
             ;
            if GetItemCount(itemName,false,false)>0 and not LT_Util.hasBuff(buffName) and not LT_Util.hasDebuff('鬼魂')  then
                  print('吃['..itemName..']')
                  RunMacroText('/use '..itemName)
                  TTOCDelay(1)
            end
      end,

      --[[
            给武器使用临时附魔物品
            itemName=物品名,BuffName=Buff名称
      --]]
      addWeaponEnchant = function (itemName)
            if itemName == '' then
                  return
             end
            local hasEnchant,_ = GetWeaponEnchantInfo()
            if(GetItemCount(itemName,false,false)>0 and not hasEnchant and not SC:GetPlayer().InCombat and not  SC:GetPlayer().IsDead ) then
                  print("使用武器附魔["..itemName..']')
                  RunMacroText('/use [button:1] '..itemName)
                  RunMacroText('/use [button:1] 16')
                  TTOCDelay(1)
            end
      end,

     
}



--[[
      使用背包里的BUFF物品
--]]
local function useBuff()
      LT.useBuffItem(UI:Setting('呼吸药剂'))
      LT.useBuffItem(UI:Setting('战斗药剂'))
      LT.useBuffItem(UI:Setting('守护药剂'))
      LT.addWeaponEnchant(UI:Setting('武器涂油'))
end





local mainScript = {
      
      --大于1级小于71级循环打怪
      {If = "SC:GetPlayer().Level >= 1 and SC:GetPlayer().Level <= 80", End = '自定义打怪'},
            {Run = function ()
                  useBuff()
            end},
            {If = "GetItemCount('冬鳞蚌壳',false,false)>=100", End = '购买海妖之泪'},
                  {Run = 'print("购买海妖之泪")'},
                  {MoveTo = {4366.9658, 6089.8257, 0.6821,true},},
                  {UnitInteract = 25206},
                  {Gossip = "vendor"},
                  {Run='BuyItem(36784,1)'},
                  {Delay = 5},
                  {Run = function ()
                        CloseMerchant()--关闭商人窗口
                  end},
            {Loop = '购买海妖之泪'},
            --回家路径避免卡位 如果回家时候卡位用
            {Settings = 'GoHomePath', value = {
                  {4319.2847, 6061.2754, 0.9000},
                  {4284.3032, 5865.4443, 59.3179},
            },},
            --离开家路径避免卡位 如果离开家时候卡位用
            {Settings = 'LeaveHomePath', value = {
                  {4284.3032, 5865.4443, 59.3179},
                 --{4319.2847, 6061.2754, 0.9000},
            },},
            {Settings = 'BuyNPC', value = {
                  --修装的
                  {Id =27067  ,Path = {4510.5200, 5703.3525, 81.5402}},
                   --食物商人    id是商人的npcid    后面的坐标是我站着对话商人的坐标
                  {Id =27069  ,Path = {4506.3574, 5707.3179, 81.5212}},
                  --弓箭商人
                  {Id =27058  ,Path = {4502.2437, 5757.5645, 81.5365}},
            }},
            --是否判断回城事件
            {Settings = 'GoHomeEvent', value = true},

            --采集循环设置
            {GatherHerb = {187367} , Count = 1 ,Distance=45,
		MoveTo = {--如果找不到怪就移动，详见上面的MoveTo

            { { 4224.2930, 6025.4868, 0.3209 }, },
            
            { { 4141.9160, 6044.4146, -38.1353 }, },
            { { 4165.3247, 6059.0913, -46.6490 }, },
            { { 4169.7495, 6073.1118, -49.7985 }, },
            { { 4199.4863, 6086.6479, -54.9624 }, },
            { { 4228.8120, 6095.7119, -60.0563 }, },
            { { 4258.7861, 6108.3628, -61.8094 }, },
            { { 4292.3169, 6100.6851, -72.0530 }, },
            { { 4318.9243, 6128.9238, -63.0690 }, },
            { { 4345.0361, 6147.5195, -61.9704 }, },
            { { 4370.4131, 6177.6079, -56.9772 }, },
            { { 4380.8003, 6202.5864, -107.2557 }, },
            
		}, Random = 0 ,FindPath =true,
		
		},

           
           
      {Loop = '自定义打怪'},

      
}


local function init()
      local objID = 187367
--       local u = SC.FindGameObject()
--       print(u)
    
--      for index,item in pairs(u) do 
--          print(index)
--      end\
     
      OpenObj(objID)
end
-- 初始化界面
local function initUI()
      if not UI:GetWidget('基本配置')then
            UI:AddLabel('背包放战斗、守护药剂、武器油，会自动使用')
            UI:AddInput('战斗药剂')
            UI:AddInput('守护药剂') 
            UI:AddInput('武器涂油') 
            UI:AddInput('呼吸药剂') 
      end
end
--加入脚本
Bot:AddQuest('text',text)
--加入脚本
Bot:AddQuest('mainScript',mainScript)

--设定第一个执行的脚本
Bot:SetFirstQuest('text')
Bot:SetStart(function()
     Config:Hide()
      --最先执行的地方，不会被自动化（吃喝穿装等）插队
      Log:System("《博古洛克前哨站-海妖之泪》开始")
      Bot:SetPulse(Bot.QuestScriptPulse)
      SetPulseTime(0.1)
      --自动调整帧数
      SetCVar("maxFPS", 50)
      SetCVar("maxFPSBk", 50)
      SetDMWHUD('Rotation',true) --DMW
      local LearnThisTalentList = {}

      
      initUI()
     

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
            elseif SC:GetPlayer().Level >= 30 and SC:GetPlayer().Level <= 80 then --打于30级要购买弹药数量
                  SetSettings({
                  AmmoAmount = 6000
            })
            end
      end

      --最先加载的线程初始化
      SetSettings({
            --自动采矿
            AutoGatherOre = false,
            --自动采药
            AutoGatherHerb = false,
            LearnThisTalent = LearnThisTalentList,
            --其他人的怪物打我,真为反击，假为不反击,定点挂机用
            TapDeniedCounterattack = true,
            --任务超时
            TimeOutEvent = true,
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
            agentRadius = 3,
            --使用食物
            UseFood = true,
            --使用饮料
            UseDrink = true,
            --開啟自動休息，不吃藥
            AutoRest = false,
            --找怪范围
            SearchRadius = 50,
            --采矿范围
            GatherOreRadius = 200,
             --采药范围
            GatherHerbRadius = 200,
            --贩卖低于等于颜色等级的
            SellbelowLevel=false,
            --不攻击等级低于自身等级多少以下的怪物
            NotAttackFewLevelsMonster= 5,
            --开启使用坐骑
            UseMount=true,
            --不走水路,假是不走水路,真是走水路
            WalkWater =true,
            --自动拾取
            AutoLoot = false,
            --勾选后，所有食物都吃,把包内食物/饮料吃完才会触发回城，不用设定FoodName与DrinkName

            EatAll = true,
            --是否判断回城事件
            GoHomeEvent = true,
            --恢复生命值范围
           -- FoodPercent = {70 ,90 ,},
            --恢复法力值范围
            --DrinkPercent = {50 ,90 ,},
            --使用炉石
            UseHearthStone = false,
            --当背包空格小于等于多少时触发回城
            MinFreeBagSlotsToGoToTown = 2,
            --当装备耐久度小于等于%多少时触发回城
            MinDurabilityPercent = 20,
            --贩卖颜色等级0~8
            SellLevel = {[0] = false,[1] = false,[2] = false,[3] = false,[4] = false,},
            --不贩卖列表 
            DoNotSellList = {'海妖之泪','北海珍珠','繁殖期的黑水蚌','冬鳞蚌壳','雪莲花','巫妖花','金苜蓿','蛇信草','冰棘草','塔兰德拉的玫瑰','卷丹','结晶','永恒','钴矿石','药剂','法力之油','巫师之油','美味风蛇','符文法力药水','传送','炉石','剥皮小刀','矿工锄','潜行者工具','Flash Powder','闪光粉'},
            --强制贩卖列表 如果需要可以自行添加
            ForceSellList = {'蜜饯苔藓','冰霉果','多汁的蚌肉'},
            --强制销毁
            ForceDeleteList = {'秘教的命令','Cabal Orders','OOX','瓦希塔帕恩的羽毛',"Washte Pawne's Feather",'拉克塔曼尼的蹄子',"Hoof of Lakota'mani",'被撕破的日记','A Mangled Journal'},
            --是否反击
            Counterattack = true,
            --自动换装
            AutoEquip = false,
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
                  { -11907.7051, -3209.1658, -14.5401},
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
                  --地狱火半岛
                  {139.6259, 2668.5496,  distance = 50 , mapID = 1944},
                  {-164.1416, 2516.4055,  distance = 50 , mapID = 1944},
                  {-146.8090, 2619.0403,  distance = 50 , mapID = 1944},
                  {-155.9017, 2662.7883,  distance = 50 , mapID = 1944},
                  {-36.0416, 2673.1123,  distance = 100 , mapID = 1944},
                  --湿地采集
                  {-3102.5791, -3259.7576,  distance = 30 , mapID = 1437},
                  --荒芜之地采集
                  {-6475.7896, -2464.4644,  distance = 30 , mapID = 1418},
                  --冬泉谷旅店
                  {6717.5620, -4682.05717,  distance = 25 , mapID = 1452},
                  --月光林地不上坐骑
                  {7981.9111, -2576.7666,  distance = 500 , mapID = 1450},
            },
            --设置间距
            agentRadiusPath  = {
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
          --如果我是战士或者盗贼的使用饮料
          if SC:GetPlayer().Class=='WARRIOR' or SC:GetPlayer().Class=='ROGUE' then
            --最先加载的线程初始化
            SetSettings({
            LearnThisTalent = LearnThisTalentList,
            --使用饮料
            UseDrink = false,
            --恢复生命值范围
            FoodPercent = {70 ,90 ,},
            --恢复法力值范围
            DrinkPercent = {0 ,0 },
            --DrinkPercent = {0 ,0 },
            })
          end
end)

Bot:SetStop(function()
      Log:System('脚本停止')
     
end)



return Bot