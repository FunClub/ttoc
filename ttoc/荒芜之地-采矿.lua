local Bot = TTOCInitScript("自定义打怪模板1029")
local Log = Bot.Log
local UI = Bot.UI
local Config = Bot.Config
local TTOC = ...
LT = TTOC

local text = {
      --如果我是法师的初始化
      { If = "SC:GetPlayer().Class=='MAGE'", End = 0 },
      --是否接过任务
      --IsHasQuest(QuestID)
      --是否完成过任务
      --IsCompletedQuest(QuestID)
      --是否可以完成任务
      --CanCompleteQuest(QuestID,index)
      { Log = 'Info', Text = "初始化法师战斗循环" },
      { Run = "DMW.Settings.profile.Rotation['奥术智慧'] = true" },
      { Run = "DMW.Settings.profile.Rotation['冰甲术/霜甲术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['熔岩护甲'] = false" },
      { Run = "DMW.Settings.profile.Rotation['魔甲术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['魔法抑制'] = true" },
      { Run = "DMW.Settings.profile.Rotation['法术反制'] = true" },
      { Run = "DMW.Settings.profile.Rotation['寒冰护体'] = true" },
      { Run = "DMW.Settings.profile.Rotation['法力护盾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['生命低于'] = 20" },
      { Run = "DMW.Settings.profile.Rotation['智能拉怪'] = 2" },
      { If = "SC:GetPlayer().Level >= 4", End = 30 },
      { Run = "DMW.Settings.profile.Rotation['寒冰箭'] = true" },
      { Run = "DMW.Settings.profile.Rotation['大火球'] = false" },
      { End = 30 },
      { If = "SC:GetPlayer().Level < 4", End = 31 },
      { Run = "DMW.Settings.profile.Rotation['寒冰箭'] = false" },
      { Run = "DMW.Settings.profile.Rotation['大火球'] = true" },
      { End = 31 },
      { Run = "DMW.Settings.profile.Rotation['炎爆术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['召唤水元素'] = true" },
      { Run = "DMW.Settings.profile.Rotation['火焰冲击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['冲击波'] = false" },
      { Run = "DMW.Settings.profile.Rotation['燃烧'] = false" },
      { Run = "DMW.Settings.profile.Rotation['灼烧'] = false" },
      { Run = "DMW.Settings.profile.Rotation['冰霜新星'] = true" },
      { Run = "DMW.Settings.profile.Rotation['冰霜新星时后退'] = true" },
      { Run = "DMW.Settings.profile.Rotation['水元素冰霜新星'] = true" },
      { Run = "DMW.Settings.profile.Rotation['宠物自动攻击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['让宠物自动攻击目标'] = true" },
      { Run = "DMW.Settings.profile.Rotation['冰锥术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['龙息术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['冰枪术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['奥术飞弹'] = false" },
      { Run = "DMW.Settings.profile.Rotation['急速冷却'] = false" },
      { Run = "DMW.Settings.profile.Rotation['急速冷却生命低于'] = 45" },
      { Run = "DMW.Settings.profile.Rotation['冰冷血脉'] = true" },
      { Run = "DMW.Settings.profile.Rotation['冰冷血脉生命低于'] = 90" },
      { Run = "DMW.Settings.profile.Rotation['造水术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['造食术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['唤醒'] = true" },
      { Run = "DMW.Settings.profile.Rotation['唤醒法力值百分比'] = 35" },
      { Run = "DMW.Settings.profile.Rotation['解除次级诅咒'] = true" },
      { Run = "DMW.Settings.profile.Rotation['变形术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['使用法术石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['制造法力石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['法术石法力值'] = 60" },
      { Run = "DMW.Settings.profile.Rotation['法力分流法力值百分比'] = 80" },
      { Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90" },
      { Log = 'Info', Text = "初始化完成" },
      { End = 0 },

      --如果我是盗贼的初始化
      { If = "SC:GetPlayer().Class=='ROGUE'", End = 0.5 },
      --是否接过任务
      --IsHasQuest(QuestID)
      --是否完成过任务
      --IsCompletedQuest(QuestID)
      --是否可以完成任务
      --CanCompleteQuest(QuestID,index)
      { Log = 'Info', Text = "初始化盗贼战斗循环" },
      { Run = "DMW.Settings.profile.Rotation['自动攻击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['脚踢'] = true" },
      { Run = "DMW.Settings.profile.Rotation['取消攻击后摇'] = true" },
      { Run = "DMW.Settings.profile.Rotation['邪恶攻击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['毒刃'] = false" },
      { Run = "DMW.Settings.profile.Rotation['剔骨'] = true" },
      { Run = "DMW.Settings.profile.Rotation['切割'] = true" },
      { Run = "DMW.Settings.profile.Rotation['剑刃乱舞'] = true" },
      { Run = "DMW.Settings.profile.Rotation['冲动'] = 3" },
      { Run = "DMW.Settings.profile.Rotation['开怪模式'] = 1" },
      { Run = "DMW.Settings.profile.Rotation['战斗剑PVE'] = true" },
      { Run = "DMW.Settings.profile.Rotation['菊花茶'] = false" },
      { Run = "DMW.Settings.profile.Rotation['无限晕锁'] = false" },
      { Run = "DMW.Settings.profile.Rotation['消失'] = true" },
      { Run = "DMW.Settings.profile.Rotation['闪避'] = true" },
      { Run = "DMW.Settings.profile.Rotation['开启闪避的血量百分比'] = 30" },
      { Run = "DMW.Settings.profile.Rotation['疾跑'] = true" },
      { Log = 'Info', Text = "初始化完成" },
      { End = 0.5 },

      --如果我是猎人的初始化
      { If = "SC:GetPlayer().Class=='HUNTER'", End = 0.6 },
      --是否接过任务
      --IsHasQuest(QuestID)
      --是否完成过任务
      --IsCompletedQuest(QuestID)
      --是否可以完成任务
      --CanCompleteQuest(QuestID,index)
      { Log = 'Info', Text = "初始化猎人战斗循环" },
      { Run = "DMW.Settings.profile.Rotation['自动攻击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['目标是宠物时拉开距离'] = true" },
      { Run = "DMW.Settings.profile.Rotation['自动雄鹰守护'] = true" },
      { Run = "DMW.Settings.profile.Rotation['自动灵猴守护'] = true" },
      { Run = "DMW.Settings.profile.Rotation['多重射击'] = false" },
      { Run = "DMW.Settings.profile.Rotation['奥术射击'] = false" },
      { Run = "DMW.Settings.profile.Rotation['猎人印记'] = true" },
      { Run = "DMW.Settings.profile.Rotation['急速射击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['瞄准射击'] = false" },
      { Run = "DMW.Settings.profile.Rotation['稳固射击'] = false" },
      { Run = "DMW.Settings.profile.Rotation['逃脱'] = true" },
      { Run = "DMW.Settings.profile.Rotation['假死'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂野怒火'] = true" },
      { Run = "DMW.Settings.profile.Rotation['猛禽一击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['猫鼬撕咬'] = true" },
      { Run = "DMW.Settings.profile.Rotation['摔绊'] = false" },
      { Run = "DMW.Settings.profile.Rotation['杀戮命令'] = true" },
      { Run = "DMW.Settings.profile.Rotation['毒蛇钉刺'] = false" },
      { Run = "DMW.Settings.profile.Rotation['宠物自动攻击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['召唤宠物'] = true" },
      { Run = "DMW.Settings.profile.Rotation['复活宠物'] = true" },
      { Run = "DMW.Settings.profile.Rotation['胁迫'] = true" },
      { Run = "DMW.Settings.profile.Rotation['宠物嘲讽'] = true" },
      { Run = "DMW.Settings.profile.Rotation['治疗宠物'] = true" },
      { Run = "DMW.Settings.profile.Rotation['治疗宠物生命百分比'] = 50" },
      { Log = 'Info', Text = "初始化完成" },
      { End = 0.6 },

      --如果我是牧师的初始化
      { If = "SC:GetPlayer().Class=='PRIEST'", End = 0.7 },
      --是否接过任务
      --IsHasQuest(QuestID)
      --是否完成过任务
      --IsCompletedQuest(QuestID)
      --是否可以完成任务
      --CanCompleteQuest(QuestID,index)
      { Log = 'Info', Text = "初始化牧师战斗循环" },
      { Run = "DMW.Settings.profile.Rotation['开启DPS'] = true" },
      { Run = "DMW.Settings.profile.Rotation['优先攻击最后敌人'] = true" },
      { Run = "DMW.Settings.profile.Rotation['开怪前上盾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['使用[暗言术：痛]拉怪'] = true" },
      { Run = "DMW.Settings.profile.Rotation['暗言术：痛'] = true" },
      { Run = "DMW.Settings.profile.Rotation['沉默'] = true" },
      { Run = "DMW.Settings.profile.Rotation['精神鞭笞'] = true" },
      { Run = "DMW.Settings.profile.Rotation['精神鞭笞法力值百分比'] = 10" },
      { If = "SC:GetPlayer().Level < 10", End = 30 },
      { Run = "DMW.Settings.profile.Rotation['惩击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['惩击法力值百分比'] = 10" },
      { Run = "DMW.Settings.profile.Rotation['心灵震爆'] = false" },
      { Run = "DMW.Settings.profile.Rotation['心灵震爆法力值百分比'] = 10" },
      { End = 30 },
      { If = "SC:GetPlayer().Level >= 10", End = '大于十关惩击' },
      { Run = "DMW.Settings.profile.Rotation['惩击'] = false" },
      { Run = "DMW.Settings.profile.Rotation['惩击法力值百分比'] = 10" },
      { Run = "DMW.Settings.profile.Rotation['心灵震爆'] = true" },
      { Run = "DMW.Settings.profile.Rotation['心灵震爆法力值百分比'] = 10" },
      { End = '大于十关惩击' },
      { Run = "DMW.Settings.profile.Rotation['心灵尖啸'] = true" },
      { Run = "DMW.Settings.profile.Rotation['心灵尖啸人数'] = 3" },
      { Run = "DMW.Settings.profile.Rotation['吸血鬼的拥抱'] = true" },
      { Run = "DMW.Settings.profile.Rotation['吸血鬼之触'] = true" },
      { Run = "DMW.Settings.profile.Rotation['暗影恶魔'] = true" },
      { Run = "DMW.Settings.profile.Rotation['暗言术灭击杀'] = true" },
      { Run = "DMW.Settings.profile.Rotation['暗言术灭击杀死亡时间'] = 4" },
      { Run = "DMW.Settings.profile.Rotation['绝望祷言'] = false" },
      { Run = "DMW.Settings.profile.Rotation['心灵尖啸人数'] = 30" },
      { Run = "DMW.Settings.profile.Rotation['心灵之火'] = true" },
      { Run = "DMW.Settings.profile.Rotation['祛病术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['驱散魔法'] = false" },
      { Run = "DMW.Settings.profile.Rotation['暗影守卫'] = true" },
      { Run = "DMW.Settings.profile.Rotation['暗影形态'] = true" },
      { Run = "DMW.Settings.profile.Rotation['暗影形态生命百分比'] = 21" },
      { Run = "DMW.Settings.profile.Rotation['清除暗影形态'] = 20" },
      { Run = "DMW.Settings.profile.Rotation['快速治疗'] = true" },
      { Run = "DMW.Settings.profile.Rotation['快速治疗百分比'] = 20" },
      { Run = "DMW.Settings.profile.Rotation['真言术：盾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['真言术：盾百分比'] = 85" },
      { Run = "DMW.Settings.profile.Rotation['恢复'] = true" },
      { Run = "DMW.Settings.profile.Rotation['恢复百分比'] = 85" },
      { Run = "DMW.Settings.profile.Rotation['队伍 - 真言术：韧'] = true" },
      { Run = "DMW.Settings.profile.Rotation['使用法术石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['制造法力石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['法术石法力值'] = 60" },
      { Run = "DMW.Settings.profile.Rotation['法力分流法力值百分比'] = 80" },
      { Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90" },
      { Log = 'Info', Text = "初始化完成" },
      { End = 0.7 },

      --如果我是术士的初始化
      { If = "SC:GetPlayer().Class=='WARLOCK'", End = 0.8 },
      --是否接过任务
      --IsHasQuest(QuestID)
      --是否完成过任务
      --IsCompletedQuest(QuestID)
      --是否可以完成任务
      --CanCompleteQuest(QuestID,index)
      { Log = 'Info', Text = "初始化术士战斗循环" },
      { Run = "DMW.Settings.profile.Rotation['自动Buff'] = true" },
      { Run = "DMW.Settings.profile.Rotation['邪甲术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['制造治疗石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['制造灵魂石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['绑定灵魂石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['生命分流'] = true" },
      { Run = "DMW.Settings.profile.Rotation['战斗中不使用生命分流'] = false" },
      { Run = "DMW.Settings.profile.Rotation['生命分流法力值'] = 70" },
      { Run = "DMW.Settings.profile.Rotation['生命分流生命值'] = 50" },
      { Run = "DMW.Settings.profile.Rotation['有仇恨不使用生命分流'] = true" },
      { Run = "DMW.Settings.profile.Rotation['指定召唤宠物'] = 1" },
      { Run = "DMW.Settings.profile.Rotation['恶魔支配指定召唤'] = false" },
      { Run = "DMW.Settings.profile.Rotation['智能召唤宠物'] = true" },
      { Run = "DMW.Settings.profile.Rotation['恶魔支配智能召唤'] = true" },
      { Run = "DMW.Settings.profile.Rotation['黑暗契约'] = false" },
      { Run = "DMW.Settings.profile.Rotation['战斗中不使用黑暗契约'] = false" },
      { Run = "DMW.Settings.profile.Rotation['黑暗契约法力值'] = 60" },
      { Run = "DMW.Settings.profile.Rotation['黑暗契约宠物魔法值'] = 35" },
      { Run = "DMW.Settings.profile.Rotation['吞噬暗影'] = true" },
      { Run = "DMW.Settings.profile.Rotation['吞噬暗影生命值'] = 70" },
      { Run = "DMW.Settings.profile.Rotation['牺牲'] = true" },
      { Run = "DMW.Settings.profile.Rotation['牺牲生命值'] = 5" },
      { Run = "DMW.Settings.profile.Rotation['自动宠物攻击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['暗影箭'] = 3" },
      { Run = "DMW.Settings.profile.Rotation['暗影箭法力值'] = 35" },
      { Run = "DMW.Settings.profile.Rotation['无魔杖暗影箭'] = true" },
      { Run = "DMW.Settings.profile.Rotation['dot敌人数量'] = 3" },
      { Run = "DMW.Settings.profile.Rotation['诅咒增幅'] = true" },
      { Run = "DMW.Settings.profile.Rotation['诅咒'] = 2" },
      { Run = "DMW.Settings.profile.Rotation['轮流诅咒'] = true" },
      { Run = "DMW.Settings.profile.Rotation['腐蚀术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['轮流腐蚀术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['献祭'] = true" },
      { Run = "DMW.Settings.profile.Rotation['轮流献祭'] = false" },
      { Run = "DMW.Settings.profile.Rotation['生命虹吸'] = false" },
      { Run = "DMW.Settings.profile.Rotation['轮流生命虹吸'] = false" },
      { Run = "DMW.Settings.profile.Rotation['暗影灼烧'] = false" },
      { Run = "DMW.Settings.profile.Rotation['吸取生命二'] = false" },
      { Run = "DMW.Settings.profile.Rotation['烧尽'] = true" },
      { Run = "DMW.Settings.profile.Rotation['痛苦无常'] = false" },
      { Run = "DMW.Settings.profile.Rotation['腐蚀之种子'] = true" },
      { Run = "DMW.Settings.profile.Rotation['吸取生命'] = true" },
      { Run = "DMW.Settings.profile.Rotation['吸取生命生命值'] = 90" },
      { Run = "DMW.Settings.profile.Rotation['生命通道'] = true" },
      { Run = "DMW.Settings.profile.Rotation['生命通道宠物HP'] = 50" },
      { Run = "DMW.Settings.profile.Rotation['暗影防护结界'] = true" },
      { Run = "DMW.Settings.profile.Rotation['暗影之怒'] = true" },
      { Run = "DMW.Settings.profile.Rotation['恐惧多余目标'] = false" },
      { Run = "DMW.Settings.profile.Rotation['恐惧术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['吸取灵魂'] = true" },
      { Run = "DMW.Settings.profile.Rotation['最大碎片数停止吸取灵魂'] = true" },
      { Run = "DMW.Settings.profile.Rotation['最大碎片数量'] = 3" },
      { Run = "DMW.Settings.profile.Rotation['使用法术石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['制造法力石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['法术石法力值'] = 60" },
      { Run = "DMW.Settings.profile.Rotation['法力分流法力值百分比'] = 80" },
      { Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90" },
      { Log = 'Info', Text = "初始化完成" },
      { End = 0.8 },

      --如果我是圣骑的初始化
      { If = "SC:GetPlayer().Class=='PALADIN'", End = 0.9 },
      --是否接过任务
      --IsHasQuest(QuestID)
      --是否完成过任务
      --IsCompletedQuest(QuestID)
      --是否可以完成任务
      --CanCompleteQuest(QuestID,index)
      { Log = 'Info', Text = "初始化圣骑战斗循环" },
      { Run = "DMW.Settings.profile.Rotation['开启DPS'] = true" },
      { Run = "DMW.Settings.profile.Rotation['优先攻击最后的敌人'] = true" },
      { Run = "DMW.Settings.profile.Rotation['指定祝福'] = 2" },
      { Run = "DMW.Settings.profile.Rotation['队伍-王者祝福'] = false" },
      { Run = "DMW.Settings.profile.Rotation['队伍-拯救祝福'] = false" },
      { Run = "DMW.Settings.profile.Rotation['队伍-力量祝福'] = false" },
      { Run = "DMW.Settings.profile.Rotation['指定光环'] = 1" },
      { Run = "DMW.Settings.profile.Rotation['野外惩戒智能光环'] = true" },
      { Run = "DMW.Settings.profile.Rotation['乘骑智能十字军光环'] = true" },
      { Run = "DMW.Settings.profile.Rotation['使用审判'] = true" },
      { Run = "DMW.Settings.profile.Rotation['指定圣印'] = 1" },
      { Run = "DMW.Settings.profile.Rotation['惩戒智能审判'] = true" },
      { Run = "DMW.Settings.profile.Rotation['防骑智能审判'] = false" },
      { Run = "DMW.Settings.profile.Rotation['指定审判'] = 1" },
      { Run = "DMW.Settings.profile.Rotation['智能公正审判'] = true" },
      { Run = "DMW.Settings.profile.Rotation['十字军打击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['制裁之锤'] = true" },
      { Run = "DMW.Settings.profile.Rotation['驱邪术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['愤怒之锤'] = true" },
      { Run = "DMW.Settings.profile.Rotation['奉献'] = true" },
      { Run = "DMW.Settings.profile.Rotation['输出复仇之怒'] = true" },
      { Run = "DMW.Settings.profile.Rotation['正义之怒保持'] = false" },
      { Run = "DMW.Settings.profile.Rotation['使用复仇者之盾拉怪'] = false" },
      { Run = "DMW.Settings.profile.Rotation['神圣之盾保持'] = false" },
      { Run = "DMW.Settings.profile.Rotation['队伍 - 正义防御'] = false" },
      { Run = "DMW.Settings.profile.Rotation['队伍-复活术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['队伍 - 复仇之怒治疗'] = false" },
      { Run = "DMW.Settings.profile.Rotation['清洁术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['纯净术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['队伍 - 圣光术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['队伍 - 圣光术百分比'] = 80" },
      { Run = "DMW.Settings.profile.Rotation['队伍 - 圣光闪现'] = false" },
      { Run = "DMW.Settings.profile.Rotation['队伍 - 圣光闪现百分比'] = 50" },
      { Run = "DMW.Settings.profile.Rotation['队伍 - 神圣震击'] = false" },
      { Run = "DMW.Settings.profile.Rotation['队伍 - 神圣震击百分比'] = 90" },
      { Run = "DMW.Settings.profile.Rotation['圣光术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['圣光术百分比'] = 30" },
      { Run = "DMW.Settings.profile.Rotation['圣光闪现'] = false" },
      { Run = "DMW.Settings.profile.Rotation['圣光闪现百分比'] = 10" },
      { Run = "DMW.Settings.profile.Rotation['圣盾术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['圣盾术百分比'] = 25" },
      { Run = "DMW.Settings.profile.Rotation['圣佑术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['圣佑术百分比'] = 25" },
      { Run = "DMW.Settings.profile.Rotation['圣疗术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['圣疗术百分比'] = 20" },

      { Run = "DMW.Settings.profile.Rotation['使用法术石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['制造法力石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['法术石法力值'] = 60" },
      { Run = "DMW.Settings.profile.Rotation['法力分流法力值百分比'] = 80" },
      { Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90" },
      { Log = 'Info', Text = "初始化完成" },
      { End = 0.9 },

      --如果我是战士的初始化
      { If = "SC:GetPlayer().Class=='WARRIOR'", End = 0.11 },
      --是否接过任务
      --IsHasQuest(QuestID)
      --是否完成过任务
      --IsCompletedQuest(QuestID)
      --是否可以完成任务
      --CanCompleteQuest(QuestID,index)
      { Log = 'Info', Text = "初始化战士战斗循环" },
      { Run = "DMW.Settings.profile.Rotation['开启DPS'] = true" },
      { Run = "DMW.Settings.profile.Rotation['自动面对目标'] = true" },
      { Run = "DMW.Settings.profile.Rotation['自动攻击目标'] = true" },
      { Run = "DMW.Settings.profile.Rotation['指定战斗循环'] = 1" },
      { Run = "DMW.Settings.profile.Rotation['智能战斗循环'] = true" },
      { Run = "DMW.Settings.profile.Rotation['冲锋'] = true" },
      { Run = "DMW.Settings.profile.Rotation['斩杀'] = true" },
      { Run = "DMW.Settings.profile.Rotation['撕裂'] = false" },
      { Run = "DMW.Settings.profile.Rotation['破甲攻击'] = false" },
      { Run = "DMW.Settings.profile.Rotation['震荡猛击'] = false" },
      { Run = "DMW.Settings.profile.Rotation['乘胜追击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['猛击'] = false" },
      { Run = "DMW.Settings.profile.Rotation['血性狂暴'] = true" },
      { Run = "DMW.Settings.profile.Rotation['血性狂暴怒气值'] = 10" },
      { Run = "DMW.Settings.profile.Rotation['英勇打击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['英勇打击怒气值'] = 30" },
      { Run = "DMW.Settings.profile.Rotation['顺劈斩'] = true" },
      { Run = "DMW.Settings.profile.Rotation['顺劈斩人数'] = 2" },
      { Run = "DMW.Settings.profile.Rotation['战斗怒吼'] = true" },
      { Run = "DMW.Settings.profile.Rotation['挫志怒吼'] = 2" },
      { Run = "DMW.Settings.profile.Rotation['切换姿态损失的怒气值'] = 0" },
      { Run = "DMW.Settings.profile.Rotation['命令怒吼'] = true" },
      { Run = "DMW.Settings.profile.Rotation['命令怒吼血量'] = 30" },
      { Run = "DMW.Settings.profile.Rotation['泻怒'] = 70" },
      { Run = "DMW.Settings.profile.Rotation['压制'] = true" },
      { Run = "DMW.Settings.profile.Rotation['断筋'] = false" },
      { Run = "DMW.Settings.profile.Rotation['智能断筋'] = true" },
      { Run = "DMW.Settings.profile.Rotation['横扫攻击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['横扫攻击人数'] = 2" },
      { Run = "DMW.Settings.profile.Rotation['雷霆一击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['雷霆一击人数'] = 3" },
      { Run = "DMW.Settings.profile.Rotation['反击风暴'] = true" },
      { Run = "DMW.Settings.profile.Rotation['反击风暴生命百分比'] = 30" },
      { Run = "DMW.Settings.profile.Rotation['致死打击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['旋风斩'] = true" },
      { Run = "DMW.Settings.profile.Rotation['旋风斩人数'] = 3" },
      { Run = "DMW.Settings.profile.Rotation['死亡之愿'] = true" },
      { Run = "DMW.Settings.profile.Rotation['死亡之愿生命值'] = 50" },
      { Run = "DMW.Settings.profile.Rotation['鲁莽'] = true" },
      { Run = "DMW.Settings.profile.Rotation['鲁莽生命值'] = 50" },
      { Run = "DMW.Settings.profile.Rotation['鲁莽人数'] = 2" },
      { Run = "DMW.Settings.profile.Rotation['嗜血'] = true" },
      { Run = "DMW.Settings.profile.Rotation['嗜血生命值'] = 70" },
      { Run = "DMW.Settings.profile.Rotation['拳击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴之怒'] = true" },
      { Run = "DMW.Settings.profile.Rotation['暴怒'] = true" },
      { Run = "DMW.Settings.profile.Rotation['嘲讽'] = false" },
      { Run = "DMW.Settings.profile.Rotation['复仇'] = false" },
      { Run = "DMW.Settings.profile.Rotation['盾击'] = false" },
      { Run = "DMW.Settings.profile.Rotation['盾牌格挡'] = false" },
      { Run = "DMW.Settings.profile.Rotation['盾牌猛击'] = false" },
      { Run = "DMW.Settings.profile.Rotation['缴械'] = false" },
      { Run = "DMW.Settings.profile.Rotation['破釜沉舟'] = false" },
      { Run = "DMW.Settings.profile.Rotation['嗜血生命值'] = 70" },
      { Run = "DMW.Settings.profile.Rotation['盾墙'] = false" },
      { Run = "DMW.Settings.profile.Rotation['嗜血生命值'] = 70" },
      { Run = "DMW.Settings.profile.Rotation['使用法术石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['制造法力石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['法术石法力值'] = 60" },
      { Run = "DMW.Settings.profile.Rotation['法力分流法力值百分比'] = 80" },
      { Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90" },
      { Log = 'Info', Text = "初始化完成" },
      { End = 0.11 },

      --如果我是德鲁伊的初始化
      { If = "SC:GetPlayer().Class=='DRUID'", End = 0.12 },
      --是否接过任务
      --IsHasQuest(QuestID)
      --是否完成过任务
      --IsCompletedQuest(QuestID)
      --是否可以完成任务
      --CanCompleteQuest(QuestID,index)
      { Log = 'Info', Text = "初始化战士战斗循环" },
      { Run = "DMW.Settings.profile.Rotation['选择形态'] = 3" },
      { Run = "DMW.Settings.profile.Rotation['野外智能形态'] = true" },
      { Run = "DMW.Settings.profile.Rotation['猎豹形态开怪'] = 5" },
      { Run = "DMW.Settings.profile.Rotation['野外智能开怪'] = true" },
      { Run = "DMW.Settings.profile.Rotation['自动取消变形'] = true" },
      { Run = "DMW.Settings.profile.Rotation['形态切换'] = true" },
      { Run = "DMW.Settings.profile.Rotation['潜行'] = true" },
      { Run = "DMW.Settings.profile.Rotation['裂伤-猫'] = true" },
      { Run = "DMW.Settings.profile.Rotation['裂伤-熊'] = true" },
      { Run = "DMW.Settings.profile.Rotation['斜掠'] = true" },
      { Run = "DMW.Settings.profile.Rotation['割裂'] = true" },
      { Run = "DMW.Settings.profile.Rotation['割伤'] = true" },
      { Run = "DMW.Settings.profile.Rotation['凶猛撕咬'] = true" },
      { Run = "DMW.Settings.profile.Rotation['猛击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['横扫'] = true" },
      { Run = "DMW.Settings.profile.Rotation['挫志咆哮'] = true" },
      { Run = "DMW.Settings.profile.Rotation['重殴'] = true" },
      { Run = "DMW.Settings.profile.Rotation['重殴怒气值'] = 20" },
      { Run = "DMW.Settings.profile.Rotation['狂暴回复'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴回复百分比'] = 60" },
      { Run = "DMW.Settings.profile.Rotation['精灵之火(野性)'] = true" },
      { Run = "DMW.Settings.profile.Rotation['精灵之火(野性)拉怪'] = false" },
      { Run = "DMW.Settings.profile.Rotation['激怒'] = true" },
      { Run = "DMW.Settings.profile.Rotation['激活'] = true" },
      { Run = "DMW.Settings.profile.Rotation['野性印记'] = true" },
      { Run = "DMW.Settings.profile.Rotation['荆棘术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['清晰预兆'] = true" },
      { Run = "DMW.Settings.profile.Rotation['猛虎之怒'] = true" },
      { Run = "DMW.Settings.profile.Rotation['消毒术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['非战斗消毒术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['移除诅咒'] = false" },
      { Run = "DMW.Settings.profile.Rotation['非战斗移除诅咒'] = true" },
      { Run = "DMW.Settings.profile.Rotation['驱毒术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['非战斗驱毒术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['精灵之火'] = true" },
      { Run = "DMW.Settings.profile.Rotation['树皮术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['树皮术百分比'] = 50" },
      { Run = "DMW.Settings.profile.Rotation['治疗之触'] = false" },
      { Run = "DMW.Settings.profile.Rotation['愈合'] = false" },
      { Run = "DMW.Settings.profile.Rotation['回春术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['回春术百分比'] = 60" },
      { Run = "DMW.Settings.profile.Rotation['战斗回春术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['战斗回春术百分比'] = 60" },
      { Run = "DMW.Settings.profile.Rotation['生命绽放'] = false" },
      { Run = "DMW.Settings.profile.Rotation['使用治疗石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['治疗药水'] = true" },
      { Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90" },
      { Log = 'Info', Text = "初始化完成" },
      { End = 0.12 },

      --如果我是萨满的初始化
      { If = "SC:GetPlayer().Class=='SHAMAN'", End = 0.12 },
      --是否接过任务
      --IsHasQuest(QuestID)
      --是否完成过任务
      --IsCompletedQuest(QuestID)
      --是否可以完成任务
      --CanCompleteQuest(QuestID,index)
      { Log = 'Info', Text = "初始化战士战斗循环" },
      { Run = "DMW.Settings.profile.Rotation['使用图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['大地之力图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['灼热图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['灼热图腾法力值'] = 50" },
      { Run = "DMW.Settings.profile.Rotation['火舌图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['火舌图腾法力值'] = 50" },
      { Run = "DMW.Settings.profile.Rotation['熔岩图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['熔岩图腾法力值'] = 50" },
      { Run = "DMW.Settings.profile.Rotation['火焰新星图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['火焰新星图腾法力值'] = 50" },
      { Run = "DMW.Settings.profile.Rotation['风怒图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['风之优雅图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['石肤图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['石爪图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['空气图腾'] = false" },
      { Run = "DMW.Settings.profile.Rotation['治疗之泉图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['法力之泉图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['冰霜震击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['地震术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['地震术法力值'] = 50" },
      { Run = "DMW.Settings.profile.Rotation['烈焰震击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['烈焰震击法力值'] = 50" },
      { Run = "DMW.Settings.profile.Rotation['风暴打击'] = true" },
      { Run = "DMW.Settings.profile.Rotation['地震术-打断'] = true" },
      { Run = "DMW.Settings.profile.Rotation['闪电之盾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['水之护盾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['嗜血'] = true" },
      { Run = "DMW.Settings.profile.Rotation['嗜血生命值'] = 35" },
      { Run = "DMW.Settings.profile.Rotation['萨满之怒'] = true" },
      { Run = "DMW.Settings.profile.Rotation['萨满之怒生命值'] = 40" },
      { Run = "DMW.Settings.profile.Rotation['火元素图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['火元素图腾生命值'] = 30" },
      { Run = "DMW.Settings.profile.Rotation['土元素图腾'] = true" },
      { Run = "DMW.Settings.profile.Rotation['土元素图腾生命值'] = 30" },
      { Run = "DMW.Settings.profile.Rotation['智能武器附魔'] = true" },
      { Run = "DMW.Settings.profile.Rotation['武器附魔'] = 1" },
      { Run = "DMW.Settings.profile.Rotation['消毒术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['祛病术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['净化术'] = false" },
      { Run = "DMW.Settings.profile.Rotation['非战斗消毒术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['非战斗祛病术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['非战斗净化术'] = true" },
      { Run = "DMW.Settings.profile.Rotation['水下呼吸'] = true" },
      { Run = "DMW.Settings.profile.Rotation['次级治疗波'] = true" },
      { Run = "DMW.Settings.profile.Rotation['次级治疗波生命值'] = 50" },
      { Run = "DMW.Settings.profile.Rotation['治疗波'] = true" },
      { Run = "DMW.Settings.profile.Rotation['治疗波生命值'] = 30" },

      { Run = "DMW.Settings.profile.Rotation['使用治疗石'] = true" },
      { Run = "DMW.Settings.profile.Rotation['治疗药水'] = true" },
      { Run = "DMW.Settings.profile.Rotation['奥术洪流'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴'] = true" },
      { Run = "DMW.Settings.profile.Rotation['狂暴生命值'] = 90" },
      { Log = 'Info', Text = "初始化完成" },
      { End = 0.12 },
      { Replace = 'text2' },
}

local text2 = {

      --大于1级小于71级循环打怪
      { If = "SC:GetPlayer().Level >= 1 and SC:GetPlayer().Level < 71", End = '自定义打怪' },
      { Run = 'print("打怪开始")' },
      --回家路径避免卡位 如果回家时候卡位用
      { Settings = 'GoHomePath', value = {
            --{2235.0337, 252.1912, 33.6516},
            --{2235.0337, 252.1912, 33.6516},
      }, },
      --离开家路径避免卡位 如果离开家时候卡位用
      { Settings = 'LeaveHomePath', value = {
            --{2235.0337, 252.1912, 33.6516},
            --{2235.0337, 252.1912, 33.6516},
      }, },
      { Settings = 'BuyNPC', value = {
            --食物商人    id是商人的npcid    后面的坐标是我站着对话商人的坐标
            { Id = 5688, Path = { 2269.5105, 244.9443, 34.2571 } },
            --修装的
            { Id = 2135, Path = { 2237.7668, 312.2936, 36.7219 } },
            --弓箭商人
            { Id = 2134, Path = { 2253.0049, 269.9004, 34.2600 } },
      } },
      --是否判断回城事件
      { Settings = 'GoHomeEvent', value = true },
      --打怪循环设置
      { AttackMonster = { }, Count = 1, --0000,0000是要打的怪物id
            MoveTo = { --0000.0000,0000.0000,0000.0000 是要巡逻的坐标
            { { -6971.6777, -2310.2969, 250.9775 }, },
            { { -7153.8799, -2225.7085, 298.1453 }, },
            { { -7235.2939, -2180.8779, 295.6250 }, },
            { { -7297.7183, -2279.9690, 244.5971 }, },
            { { -7231.4268, -2302.3799, 246.8419 }, },
            { { -7369.1064, -2441.5574, 302.6467 }, },
            { { -7254.7676, -2519.5762, 285.3705 }, },
            { { -7138.6787, -2466.5034, 256.4856 }, },
            { { -7024.2852, -2503.0374, 242.9503 }, },
            { { -6894.2729, -2583.6328, 242.2628 }, },
            { { -6908.8516, -2698.3030, 241.6693 }, },
            { { -7115.1748, -2888.8044, 242.7184 }, },
            { { -7205.6587, -3086.5674, 296.9392 }, },
            { { -7270.0972, -3175.8008, 296.0389 }, },
            { { -7113.7705, -3140.4399, 244.2527 }, },
            { { -6903.3457, -3087.4346, 251.8236 }, },
            { { -6760.9224, -3175.9490, 240.8118 }, },
            { { -6863.6733, -3338.1328, 242.3063 }, },
            { { -7163.4399, -3362.2307, 245.4500 }, },
            { { -7286.3535, -3448.7505, 307.1573 }, },
            { { -7217.6821, -3494.1104, 313.0633 }, },
            { { -7127.4175, -3483.1626, 247.8991 }, },
            { { -7049.5972, -3610.6003, 241.6669 }, },
            { { -6945.9648, -3628.4453, 241.6683 }, },
            { { -6837.2729, -3613.1853, 245.0018 }, },
            { { -6770.5747, -3800.4023, 264.2359 }, },
            { { -6960.2266, -3941.8254, 263.8896 }, },
            { { -6925.1992, -4042.8433, 264.5957 }, },
            { { -6833.9116, -4117.0220, 264.2389 }, },
            { { -6625.6899, -4076.1609, 264.6751 }, },
            { { -6481.8340, -4113.5913, 263.8886 }, },
            { { -6449.3936, -3878.1855, 309.1560 }, },
            { { -6299.6787, -3499.1353, 249.9012 }, },
            { { -6176.0078, -3438.5742, 239.7147 }, },
            { { -6501.1533, -3335.9834, 246.6271 }, },
            { { -6743.1382, -2938.1667, 244.9527 }, },
            { { -6610.1016, -2943.2380, 241.8447 }, },
            { { -6494.8179, -2421.4075, 292.7441 }, },
            { { -6786.6670, -2472.4900, 255.6919 }, },
            { { -6868.6987, -2371.7024, 246.3314 }, },
            
            }, Random = 0, FindPath = true,
      },
      { Loop = '自定义打怪' },
}
function commonSetting()
      --脚本配置
      SetSettings({
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
            GotoOriginalAddress = false,
            --自动拒绝组公会邀请
            AutoDeclineGuild = true,
            --自动拒绝组组队邀请
            AutoDeclineGroup = true,
            --自动拒绝决斗邀请
            AutoDeclineDuel = true,
            --开启可以点停止按键,点开始就是点继续,防止傻子点错,中止行程变成重新开始
            ReButtonOnClick = true,
            --设定距离障碍物范围1～5
            agentRadius = 0.4,
            --使用食物
            UseFood = true,
            --使用饮料
            UseDrink = true,
            --開啟自動休息，不吃藥
            AutoRest = false,
            --找怪范围
            SearchRadius = 200,
            --贩卖低于等于颜色等级的
            SellbelowLevel = false,
            --不攻击等级低于自身等级多少以下的怪物
            NotAttackFewLevelsMonster = 5,
            --开启使用坐骑
            UseMount = true,
            --不走水路,假是不走水路,真是走水路
            WalkWater = false,
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
            --贩卖颜色等级0~8
            SellLevel = { [0] = true, [1] = true, [2] = true, },
            --不贩卖列表
            DoNotSellList = { 'Rune of', '传送', 'Hearthstone', '炉石', 'Skinning Knife', '剥皮小刀',
                  'Mining Pick', '矿工锄', 'Primal', '源生', 'Mote of', '微粒', 'Air', '空气', '基尔加丹印记',
                  "Mark of Kil'jaeden", "Thieves'Tools", '潜行者工具', 'Flash Powder', '闪光粉' },
            --强制贩卖列表 如果需要可以自行添加
            --ForceSellList = {},
            --强制销毁
            ForceDeleteList = { '秘教的命令', 'Cabal Orders', 'OOX', '瓦希塔帕恩的羽毛',
                  "Washte Pawne's Feather", '拉克塔曼尼的蹄子', "Hoof of Lakota'mani", '被撕破的日记',
                  'A Mangled Journal' },
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
            TPExceptPath    = {
                  --黑暗之门
                  { -11907.7051, -3209.1658, -14.5401 },
                  { -248.1130, 922.9000, 84.3497 },
            },
            --不上坐骑
            NotUseMountPath = {
                  --杜隆塔尔
                  { 1341.9160, -4647.4360, distance = 15, mapID = 1411 },
                  --幽暗
                  { 2062.3582, 263.3801, distance = 20, mapID = 1420 },
                  { 2064.0281, 270.0956, distance = 20, mapID = 1420 },
                  --格罗姆高
                  { -12431.8154, 210.0732, distance = 15, mapID = 1434 },
                  --奥格瑞玛
                  { 1673.8619, -4338.1714, distance = 15, mapID = 1454 },
                  --希利苏斯
                  { -6859.3345, 733.9985, distance = 20, mapID = 1451 },
                  --诅咒之地苦痛堡垒
                  { -10944.0547, -3369.8418, distance = 40, mapID = 1419 },
                  { -10953.0410, -3454.4758, distance = 15, mapID = 1419 },
                  --幽暗城电梯
                  { 1596.1678, 291.5745, distance = 20, mapID = 1458 },
                  --加基森海盗洞
                  { -7805.9253, -4998.9248, distance = 50, mapID = 1446 },
                  --地狱火半岛
                  { 139.6259, 2668.5496, distance = 50, mapID = 1944 },
                  { -164.1416, 2516.4055, distance = 50, mapID = 1944 },
                  { -146.8090, 2619.0403, distance = 50, mapID = 1944 },
                  { -155.9017, 2662.7883, distance = 50, mapID = 1944 },
                  { -36.0416, 2673.1123, distance = 100, mapID = 1944 },
                  --湿地采集
                  { -3102.5791, -3259.7576, distance = 30, mapID = 1437 },
                  --荒芜之地采集
                  { -6475.7896, -2464.4644, distance = 30, mapID = 1418 },
                  --冬泉谷旅店
                  { 6717.5620, -4682.05717, distance = 25, mapID = 1452 },
                  --月光林地不上坐骑
                  { 7981.9111, -2576.7666, distance = 500, mapID = 1450 },
            },
            --设置间距
            agentRadiusPath = {
                  { 1341.9160, -4647.4360, distance = 40, agentRadius = 2, mapID = 1411 },
                  --幽暗
                  { 2064.0281, 270.0956, distance = 100, agentRadius = 1, mapID = 1420 },
                  { 1604.4379, 238.8718, -52.1473, distance = 2000, agentRadius = 1, mapID = 1458 },
                  { 1604.4379, 238.8718, -52.1473, distance = 2000, agentRadius = 1, mapID = 1420 },
                  --格罗姆高
                  { -12431.8154, 210.0732, distance = 100, agentRadius = 1, mapID = 1434 },
                  --奥格瑞玛
                  { 1673.8619, -4338.1714, distance = 2000, agentRadius = 1, mapID = 1454 },
                  { 1971.7612, -4659.5713, distance = 2000, agentRadius = 1, mapID = 1454 },
                  --暴风
                  { -8791.8115, 652.1405, distance = 3000, agentRadius = 1, mapID = 1453 },
                  --铁炉堡
                  { -4800.1255, -1106.3363, distance = 3000, agentRadius = 1, mapID = 1455 },
                  --乱风岗
                  { -5442.4072, -2429.4580, distance = 100, agentRadius = 0.7, mapID = 1441 },
                  --血精灵8级旅店
                  { 9477.5049, -6858.8687, distance = 40, agentRadius = 1, mapID = 1941 },
                  --暴风
                  { -8984.1797, 1031.3445, distance = 3000, agentRadius = 1, mapID = 1453 },
                  --夜色镇
                  { -10564.1055, -1163.6105, distance = 200, agentRadius = 1, mapID = 1431 },
                  --沙塔斯
                  { -1863.2314, 5429.2129, distance = 1000, agentRadius = 2, mapID = 1955 },
                  --塞尔萨马
                  { -5354.0601, -2952.9070, distance = 500, agentRadius = 1, mapID = 1432 },
                  --荣耀堡
                  { -679.5225, 2668.0742, distance = 500, agentRadius = 1, mapID = 1944 },
                  --冬泉谷
                  { 6715.5552, -4676.4077, distance = 40, agentRadius = 0.5, mapID = 1452 },
            },
      })
    
end

--猎人配置
function hunterSetting()

      
      if LT:GetPlayer().Class == 'HUNTER' then
            SetSettings({
                  FoodAmount = 40, --食物数量
                  DrinkAmount = 60, -- 饮料数量
                  AmmoAmountToGoToTown = 100,--当弹药数量少于多少时触发回城
                  AmmoAmount = 3200, --弹药购买数量
                  FoodPercent = {40, 90, }, --恢复生命值范围:从生命值%40开始吃食物到90%
                  DrinkPercent = {30, 90, }, --恢复法力值范围:从魔法值%40开始喝水到90%
            })
            if LT:GetPlayer().PetActive == true then 
                  print("设置宠物为被动型")
                  PetPassiveMode()
            end
      end
end

--加入脚本
Bot:AddQuest('text', text)
--加入脚本
Bot:AddQuest('text2', text2)
--设定第一个执行的脚本
Bot:SetFirstQuest('text')
Bot:SetStart(function()
      Config:Hide()
      --最先执行的地方，不会被自动化（吃喝穿装等）插队
      Log:System('=======================')
      Log:System("自定义打怪1029开始")
      Log:System("Custom Daguai 1029 starts")
      Log:System('=======================')
      Bot:SetPulse(Bot.QuestScriptPulse)
      SetPulseTime(0.1)
      --自动调整帧数
      SetCVar("maxFPS", 50)
      SetCVar("maxFPSBk", 50)
      SetDMWHUD('Rotation', true) --DMW

      commonSetting()
      hunterSetting()


end)

Bot:SetStop(function()
      Log:System('=======================')
      Log:System("自定义打怪1029")
      Log:System("Custom Daguai 1029 starts ")
      Log:System('=======================')
end)

return Bot
