local Bot = TTOCInitScript("海妖之泪前置任务")
local Log = Bot.Log
local UI = Bot.UI
local Config = Bot.Config
local TTOC = ...
SC = TTOC
player = SC:GetPlayer()

local text = {
     {If = "player.mapName == '奥格瑞玛'", End = '奥格去北风苔原'},
        {Run='TPCheck(false)'},
        {Run='UseMount()'},
        {Log='Debug',Text="去北风苔原"},
        {MoveTo = {1171.4137, -4153.6914, 51.6459,true},},
        {UnitInteract = 26537},
        {Delay = 5},
        {Run='SelectGossipOption(1)'},
        {Delay = 10},
    {Loop = '奥格去北风苔原'},

    {If = "player.areaName == '战歌要塞'", End = '开战歌要塞鸟点'},
        {Log='Debug',Text="开战歌要塞鸟点"},
        {MoveTo = {2869.2615, 6215.2651, 104.2845},},
        {TakeTransport = 153, DownPath = {2901.7642, 6237.9883, 208.8468},},
        {MoveTo = {2919.5181, 6243.0615, 208.8024},},
        {UnitInteract = 25288},
        {Gossip = "taxi"},
        -- {Taxi = 24040},
        {Delay = 2},

        {If = "not UnitOnTaxi('player')", End = '下电梯'},
            {Log='Debug',Text="下电梯"},
            {MoveTo = {2901.7642, 6237.9883, 208.8468,true},},
            {TakeTransport = 153, DownPath = {2869.2615, 6215.2651, 104.2845},},
        {End = '下电梯'},
    {End = '开战歌要塞鸟点'},

    {If = "player.areaName ~= '博古洛克岗哨站' and player.areaName ~= '冬鳞避难所'and player.areaName ~= '冬鳞村' and player.areaName ~= '西部裂谷'", End = '开博古洛克岗哨站鸟点'},
        {Log='Debug',Text="开博古洛克岗哨站鸟点"},
        {MoveTo = {4474.2842, 5711.3008, 81.2724, true},},
        {UnitInteract = 26848},
        {Delay = 2},
    {End = '开博古洛克岗哨站鸟点'},

    {If = "not IsHasQuest(11571) and not IsCompletedQuest(11571)", End = '接任务国王姆嘎姆嘎'},
        {Log='Debug',Text="接任务国王姆嘎姆嘎"},
        {Quese = 'Get' , NPCId = 25197 , QuestId = 11571, 
        Path = {4361.0454, 6063.2378, 0.5227,true},
        },
    {End = '接任务国王姆嘎姆嘎'},

    {If = "IsHasQuest(11571) and not CanCompleteQuest(11571)", End = '做学习与沟通任务'},
        {Log='Debug',Text="做学习与沟通任务"},
        {MoveTo = {4321.7100, 6112.4395, -2.2797,true},},
        {GatherHerb = { 25226} , Count = 1 , 
        MoveTo = {
            {{  4265.0254, 6110.6060, -98.8667 },},
        }, Random = 1 ,
        },
        {Run = "RunMacroText('/target 斯卡德尔')"},
        {Run = "RunMacroText('/use 国王的空贝壳')"},
    {Loop = '做学习与沟通任务'},

    {If = "CanCompleteQuest(11571)", End = '交任务学习与沟通'},
        {Log='Info',Text="交任务学习与沟通"},
        {MoveTo = {4203.4727, 6085.2886, -89.9190,false},},
        {MoveTo = {4203.4727, 6085.2886, -71.7762,false},},
        {MoveTo = {4203.4727, 6085.2886, -59.4654,false},},
        {MoveTo = {4203.4727, 6085.2886, -45.2609,false},},
        {MoveTo = {4203.4727, 6085.2886, -29.5407,false},},
        {MoveTo = {4203.4727, 6085.2886, -16.5262,false},},
        {MoveTo = {4203.4727, 6085.2886, -0.2619,false},},
        {MoveTo = {4376.6807, 6092.4878, 0.3551,true},},
        {MoveTo = {4362.5386, 6064.2061, 0.4255,true},},
        {Quese = 'Complet' , NPCId = 25197 , QuestId =11571 , Path = {-600.1321, -4186.1938, 41.0892},
        },
    {End = '交任务学习与沟通'},

    {If = "not IsHasQuest(11559) and not IsCompletedQuest(11559)", End = '接任务冬鳞鱼人的贸易'},
        {Log='Debug',Text="接任务冬鳞鱼人的贸易"},
        {Quese = 'Get' , NPCId = 25197 , QuestId = 11559, 
        Path = {4361.0454, 6063.2378, 0.5227,true},
        },
    {End = '接任务冬鳞鱼人的贸易'},
    
    {If = "IsHasQuest(11559) and not CanCompleteQuest(11559)", End = '做冬鳞鱼人的贸易任务'},
        {Log='Debug',Text="做冬鳞鱼人的贸易任务"},
        {GatherHerb = {187367} , Count = 1 ,Distance = 10,
		MoveTo = {
            { { 4270.7437, 6194.5083, 0.4861 }, },
            { { 4297.6821, 6194.1895, 0.3576 }, },
            { { 4289.5386, 6204.7554, 0.6731 }, },
            { { 4295.7637, 6215.2500, 0.6988 }, },
            { { 4309.6265, 6209.2192, 0.4673 }, },
            { { 4290.5215, 6243.6152, 0.5979 }, },
            { { 4294.7310, 6260.1509, 0.6605 }, },
            { { 4290.7505, 6288.1646, 0.5576 }, },
            { { 4279.5713, 6290.9336, 0.2116 }, },
            { { 4278.5728, 6302.9287, 0.2176 }, },
            { { 4305.3540, 6307.5547, 0.5349 }, },
            { { 4318.8696, 6322.9150, 0.5349 }, },
            { { 4322.8931, 6322.2627, 0.5349 }, },
            { { 4314.3438, 6371.5557, 0.5670 }, },
            { { 4309.9751, 6406.6738, 0.5679 }, },
            { { 4294.9570, 6439.1938, 0.5568 }, },
            { { 4286.7480, 6410.1543, 0.5969 }, },
            { { 4280.3267, 6398.1592, 0.5671 }, },
            { { 4287.2354, 6364.0981, 0.5671 }, },
            { { 4273.8906, 6352.3135, 0.5671 }, },
            { { 4263.4468, 6342.8989, 0.5671 }, },
            { { 4260.4644, 6340.1338, 0.5671 }, },
            { { 4231.0469, 6290.8003, -0.8347 }, },
            { { 4248.5552, 6256.9561, 0.5675 }, },
            { { 4240.3433, 6229.6646, 0.5641 }, },
            { { 4235.0737, 6224.3564, 0.5625 }, },
            { { 4222.7661, 6223.8730, 1.3271 }, },
            { { 4216.4824, 6232.6328, 2.6672 }, },
            { { 4221.7778, 6241.4492, 8.7791 }, },
            { { 4198.1890, 6311.0098, 13.2303 }, },
            { { 4188.7915, 6307.5776, 13.2303 }, },
            { { 4151.2319, 6280.9795, 30.4905 }, },
            { { 4087.3438, 6282.2939, 27.4374 }, },
            { { 4080.7500, 6273.9644, 27.2913 }, },
            { { 4056.5251, 6266.2622, 21.8774 }, },
            { { 4017.7920, 6385.5566, 30.1225 }, },
            { { 4008.8875, 6393.7598, 29.1038 }, },
            { { 4146.9629, 6253.4146, 30.7153 }, },
               {{ 4172.0396, 6196.5103, 9.2521},},    
               {{4169.7939, 6181.6875, 9.2562},}, 
               {{4173.4604, 6173.0708, 9.2520},}, 
               {{4197.0918, 6170.2002, 1.4364},}, 
               {{4219.8506, 6177.3013, 1.2870},}, 
               {{4237.1089, 6178.7686, 0.0868},},      
               {{4250.0449, 6181.1831, 0.4391},},  
		}, Random = 0 ,FindPath =true,
		},
    {Loop = '做冬鳞鱼人的贸易任务'},
    
    {If = "CanCompleteQuest(11559)", End = '交任务学习与沟通'},
        {Log='Info',Text="交任务学习与沟通"},
        {Quese = 'Complet' , NPCId = 25206 , QuestId =11559 , Path = {4366.9658, 6089.8257, 0.6819},
        },
    {End = '交任务学习与沟通'},

    {Log='Debug',Text="任务结束"},
	
}


--加入脚本
Bot:AddQuest('text',text)

--设定第一个执行的脚本
Bot:SetFirstQuest('text')
Bot:SetStart(function()
    Config:Hide()
      Log:System('=======================')
      Log:System("海妖之泪前置任务开始")
      Log:System('=======================')
      Bot:SetPulse(Bot.QuestScriptPulse)
      SetPulseTime(0.1)
      --最先加载的线程初始化
      SetSettings({
      UseMountWhenNotattack = true,
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
      agentRadius = 5,
      --使用食物
      UseFood = true,
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
      GoHomeEvent = true,
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
      DoNotSellList = {'Rune of','传送','Hearthstone','炉石','Primal','源生','Mote of','微粒','Air','空气','基尔加丹印记',"Mark of Kil'jaeden"},
      --强制贩卖列表 {id,id,id
      ForceSellList = {'亚麻布','毛料','丝绸','魔纹布','符文布','硬肉干','清凉的泉水','血岩碎片','森林蘑菇','Linen Cloth','Wool Cloth','Silk Cloth','Mageweave Cloth','Runecloth','Tough Jerky','Refreshing Spring Water','Blood Shard','Forest Mushroom Cap',},
      --强制销毁
      ForceDeleteList = {'秘教的命令','Cabal Orders','OOX'},
      --是否反击
      Counterattack = true,
      --自动换装
      AutoEquip = true,
      --输出信息写入Log
      WriteLog = false,
      --复活距离
      RetrieveDis = 38,
      --购买最好
      Buybest = false,
      --食物数量
      FoodAmount = 0,
      --饮料数量
      DrinkAmount = 0,
      --副本出入口不传送
      TPExceptPath = {
            --黑暗之门
            { -11907.7051, -3209.1658, -14.5401},
            },

      })
end)

Bot:SetStop(function()
      Log:System('=======================')
      Log:System("海妖之泪前置任务结束")
      Log:System('=======================')
end)

return Bot