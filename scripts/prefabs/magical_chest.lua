require "prefabutil"
require "scheduler"
require "simutil"
require "behaviours/doaction"
require "bufferedaction"
require "actions"
require "containers"

local assets =
{
    Asset("ANIM", "anim/MagicalChest.zip"),
    Asset("ATLAS", "images/inventoryimages/magical_chest.xml"),
    Asset("IMAGE", "images/inventoryimages/magical_chest.tex")

}


local function onopen(inst, doer)
    inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")     
end 

local function onclose(inst, doer)
    BufferedAction(doer, inst, ACTIONS.SELL):Do()
    BufferedAction(doer, inst, ACTIONS.STORES):Do()
    BufferedAction(doer, inst, ACTIONS.DISPLAY):Do()
    inst.AnimState:PlayAnimation("close") 
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")        
end 

local function onsave(inst, data)
    data.x_gold = inst.x_gold
end
 
local function onload(inst, data)
    if data then
        inst.x_gold = data.x_gold or 0
    end
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.components.container:DropEverything()
    inst.AnimState:PushAnimation("closed", false)
    inst.components.container:Close()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
end

local function TriggerEvent(inst, phase)
    if phase == "day" and inst.x_gold < TUNING.MC_MAX then
        inst.x_gold = inst.x_gold + math.floor(inst.x_gold * TUNING.INTEREST )
        if inst.x_gold > TUNING.MC_MAX then
            inst.x_gold = TUNING.MC_MAX
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst:AddTag("structure")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("magical_chest.tex")

    inst.AnimState:SetBank("chest")
    inst.AnimState:SetBuild("MagicalChest")
    inst.AnimState:PlayAnimation("closed")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("magical_chest")

    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 
        
    inst:ListenForEvent( "onbuilt", onbuilt)
    MakeSnowCovered(inst, .01)  

    inst.x_gold = 0

    inst.OnSave = onsave
    inst.OnLoad = onload
    
    inst:WatchWorldState("phase", TriggerEvent)
    TriggerEvent(inst, TheWorld.state.phase)

    return inst
end


return Prefab( "common/magical_chest", fn, assets), 
        MakePlacer("common/magical_chest_placer", "chest", "MagicalChest", "closed")
