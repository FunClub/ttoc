local addonName, addon = ...
local profileId = 'AzsharaGatherProfile'


local CurrentState = 1

local ProfileConfig = {

    -- ==============================
    -- 脚本配置信息
    -- ==============================

    Name = '[建峰]卡利姆多采集',
    Version = '1.0.0',
    Author = 'JF',
    Description = '卡利姆多采集',
    DescURL = 'http://www.xxx.com',

    -- ==============================
    -- 设置界面
    -- ==============================
    Settings = {
        Title = '设置',
        Items = {
            {'header', '基本设置'},
            {'toggle', '鸟点', '坐鸟点去线上',true,false,function(value)
                if value then
                    systemLog('开启坐鸟点上线')
                else
                    systemLog('关闭坐鸟点上线')
                end
            end},
            {'toggle', '炉石', '使用炉石到加基森',true,false,function(value)
                if value then
                    systemLog('开启使用炉石到加基森')
                else
                    systemLog('关闭使用炉石到加基森')
                end
            end},
            {'toggle', '传送', '使用传送到奥格瑞玛',true,false,function(value)
                if value then
                    systemLog('开启使用传送到奥格瑞玛')
                else
                    systemLog('关闭使用传送到奥格瑞玛')
                end
            end},
            {'toggle', '蚌壳', '开蚌壳',true,false,function(value)
                if value then
                    systemLog('开启开蚌壳')
                    systemLog('开启自动拾取')
                    LWA.CurrentSettings.AutoLoot = true
                else
                    systemLog('关闭开蚌壳')
                    systemLog('关闭自动拾取')
                    LWA.CurrentSettings.AutoLoot = false
                end
            end},
            {'toggle', '跳跃', '随机跳跃',true,false,function(value)
                if value then
                    systemLog('开启随机跳跃')
                else
                    systemLog('关闭随机跳跃')
                end
            end},
            {'toggle', '风蛇', '使用美味风蛇',true,false,function(value)
                if value then
                    systemLog('开启使用美味风蛇')
                else
                    systemLog('关闭使用美味风蛇')
                end
            end},
            {'toggle', '防绿', '传送后继续去线上',true,false,function(value)
                if value then
                    systemLog('开启传送后继续去线上')
                else
                    systemLog('关闭传送后继续去线上')
                end
            end},
            {'input','艾费环采集黑名单','以逗号分隔',function(value) 
                initBlackList()
            end   
            ,true,100
            },
        
            {'header', '采集策略'},
            {'dropdown','采集模式', '单路径模式和循环路径模式', {'循环', '艾萨拉','费伍德','环形山'}, 1,true},
            {'range','艾萨拉轮数', '刷多少轮',0,20,1,3,true},
            {'range','费伍德轮数', '刷多少轮',0,20,1,3,true},
            {'range','环形山轮数', '刷多少轮',0,20,1,3,true},
            {'header', '跳跃设置'},
            {'range','跳跃频率','数值越大跳跃的可能性越高',1,10,1,5,true}
        }
    },

    -- ================================
    -- 事件
    -- ================================

    -- 启动脚本事件
    OnStart = function()
      
    end,
    
    --关闭脚本事件
    OnStop = function()
       
    end,

    -- ==============================
    -- 参数设置
    -- ==============================

    ['Attack.Mode'] = 'Active', --攻击模式(Active:主动攻击,Passive:被动攻击,Defense:防御)
    ['IgnoreCombat'] = false, --忽略战斗
    ['IgnoreGotoTown'] = true,
    ['IgnoreHunterPetLogic'] = false, --忽略猎人宠物逻辑
    ['NotAttackWhenGoToTown'] = true, --回程不反击
    ['Range.Attack'] = 15, --攻击范围
    ['GatherIds'] = {}, --采集物品的id
    ['MobIds'] = { }, --怪物id列表
    
    -- ================================
    -- 主逻辑
    -- ================================

    Logic = function()
       
        print(AirPano)
    end,

    -- ================================
    -- 后台逻辑方法
    -- ================================
    BackgroundLogic = function()

    end
}

addon:RegisterProfile(ProfileConfig)