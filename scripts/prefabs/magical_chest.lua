require "prefabutil"
require "scheduler"
require "simutil"
require "behaviours/doaction"

local assets =
{
	Asset("ANIM", "anim/MagicalChest.zip"),
	Asset("ATLAS", "images/inventoryimages/magical_chest.xml"),
	Asset("IMAGE", "images/inventoryimages/magical_chest.tex")

}


local function onopen(inst) 
	inst.AnimState:PlayAnimation("open") 
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")		
end 

local function onclose(inst) 
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

local function EditContainer(inst)
    local self
    if TheWorld.ismastersim then
        self = inst.components.container
    else
        self = inst.replica.container
    end

    self:WidgetSetup("magical_chest")

    local function respawnfn(inst)
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.RESPAWN):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.RESPAWN.code, inst, ACTIONS.RESPAWN.mod_name)
        end
    end

    local respawn_buttoninfo = {
        text = "Respawn",
        position = Vector3(0, -195, 0),
        fn = respawnfn,
        helpstring = "Change character, consume a Telltale Heart.",
    }

	local function sacrificefn(inst)
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.SACRIFICE):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.SACRIFICE.code, inst, ACTIONS.SACRIFICE.mod_name)
        end
	end

	local sacrifice_buttoninfo = {
		text = "Sacrifice",
		position = Vector3(0, -250, 0),
		fn = sacrificefn,
        helpstring = "Give 5 gold at the cost of 50 sanity and 100 health.",
    }

	local function sellfn(inst)
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.SELL):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.SELL.code, inst, ACTIONS.SELL.mod_name)
        end
	end

	local sell_buttoninfo = {
		text = "Sell",
		position = Vector3(-100, -250, 0),
		fn = sellfn,
        helpstring = "Sell lot of things and behave like pigking.",
    }

	local function recyclefn(inst)
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.RECYCLE):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.RECYCLE.code, inst, ACTIONS.RECYCLE.mod_name)
        end
	end

	local recycle_buttoninfo = {
		text = "Recycle",
		position = Vector3(100, -250, 0),
		fn = recyclefn,
        helpstring = "Destroy all things in Magical Chest.",
    }

    local function displayfn(inst)
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.DISPLAY):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.DISPLAY.code, inst, ACTIONS.DISPLAY.mod_name)
        end
    end

    local display_buttoninfo = {
        text = "Display",
        position = Vector3(-100, -305, 0),
        fn = displayfn,
        helpstring = "Show the number of gold in Magical Chest.",
    }

    local function storesfn(inst)
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.STORES):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.STORES.code, inst, ACTIONS.STORES.mod_name)
        end
    end

    local stores_buttoninfo = {
        text = "Store",
        position = Vector3(0, -305, 0),
        fn = storesfn,
        helpstring = "Store your gold in Magical Chest.",
    }

    local function withdrawfn(inst)
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.WITHDRAW):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.WITHDRAW.code, inst, ACTIONS.WITHDRAW.mod_name)
        end
    end

    local withdraw_buttoninfo = {
        text = "Withdraw",
        position = Vector3(100, -305, 0),
        fn = withdrawfn,
        helpstring = "Withdraw your gold from Magical Chest.",
    }

--1,1
    local function grassfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.GRASS):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.GRASS.code, inst, ACTIONS.GRASS.mod_name)
        end
    end

    local grass_buttoninfo = {
		text = "grass",
		position = Vector3(210, 110, 0),
		fn = grassfn,
        helpstring = "10 grass for 1 gold",
	}

--1,2
    local function twigfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.TWIG):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.TWIG.code, inst, ACTIONS.TWIG.mod_name)
        end
    end

    local twig_buttoninfo = {
		text = "twig",
		position = Vector3(310, 110, 0),
		fn = twigfn,
        helpstring = "10 twigs for 1 gold",
	}

--1,3
	local function logfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.LOG):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.LOG.code, inst, ACTIONS.LOG.mod_name)
        end
    end

    local log_buttoninfo = {
		text = "log",
		position = Vector3(410, 110, 0),
		fn = logfn,
        helpstring = "5 log for 1 gold",
	}

--1,4
	local function rockfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.ROCK):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.ROCK.code, inst, ACTIONS.ROCK.mod_name)
        end
    end

    local rock_buttoninfo = {
		text = "rock",
		position = Vector3(510, 110, 0),
		fn = rockfn,
        helpstring = "5 rocks for 1 gold",
	}

--1,5
	local function flintfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.FLINT):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.FLINT.code, inst, ACTIONS.FLINT.mod_name)
        end
    end

    local flint_buttoninfo = {
		text = "flint",
		position = Vector3(610, 110, 0),
		fn = flintfn,
        helpstring = "5 flint for 1 gold",
	}

--2,1
	local function minesfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.MINES):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.MINES.code, inst, ACTIONS.MINES.mod_name)
        end
    end

    local mines_buttoninfo = {
		text = "mine",
		position = Vector3(210, 55, 0),
		fn = minesfn,
        helpstring = "Day: 5 marbel for 1 gold\nDusk/Night: 5 nitre for 1 gold",
	}

--2,2
	local function reedfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.REED):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.REED.code, inst, ACTIONS.REED.mod_name)
        end
    end

    local reed_buttoninfo = {
		text = "reed",
		position = Vector3(310, 55, 0),
		fn = reedfn,
        helpstring = "5 reeds for 1 gold",
	}

--2,3
	local function cavefuelfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.CAVEFUEL):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.CAVEFUEL.code, inst, ACTIONS.CAVEFUEL.mod_name)
        end
    end

    local cavefuel_buttoninfo = {
		text = "cavefuel",
		position = Vector3(410, 55, 0),
		fn = cavefuelfn,
        helpstring = "Day: 1 lightbulb for 1 gold\nDusk: 1 wormlight for 2 gold\nNight: 1 firefly for 3 gold",
	}
--2,4
	local function gem1fn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.GEM1):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.GEM1.code, inst, ACTIONS.GEM1.mod_name)
        end
    end

    local gem1_buttoninfo = {
		text = "gem1",
		position = Vector3(510, 55, 0),
		fn = gem1fn,
        helpstring = "Day: 1 red gem for 5 gold\nDusk: 1 blue gem for 5 gold\nNight: 1 purple gem for 8 gold",
	}

--2,5
	local function gem2fn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.GEM2):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.GEM2.code, inst, ACTIONS.GEM2.mod_name)
        end
    end

    local gem2_buttoninfo = {
		text = "gem2",
		position = Vector3(610, 55, 0),
		fn = gem2fn,
        helpstring = "Day: 1 yellow gem for 3 gold \nDusk: 1 orange gem for 3 gold\nNight: 1 green gem for 3 gold",
	}

--3,1
	local function toothfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.TOOTH):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.TOOTH.code, inst, ACTIONS.TOOTH.mod_name)
        end
    end

    local tooth_buttoninfo = {
		text = "tooth",
		position = Vector3(210, 0, 0),
		fn = toothfn,
        helpstring = "1 hound tooth for 3 gold",
	}

--3,2
	local function skinfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.SKIN):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.SKIN.code, inst, ACTIONS.SKIN.mod_name)
        end
    end

    local skin_buttoninfo = {
		text = "skin",
		position = Vector3(310, 0, 0),
		fn = skinfn,
        helpstring = "Day: 1 pig skin for 4 gold\nDusk/Night: 1 bunnyman tail for 4 gold",
	}

--3,3
	local function hairfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.HAIR):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.HAIR.code, inst, ACTIONS.HAIR.mod_name)
        end
    end

    local hair_buttoninfo = {
		text = "hair",
		position = Vector3(410, 0, 0),
		fn = hairfn,
        helpstring = "Day: 3 beard for 1 gold\nDusk: 2 silk for 1 gold\nNight: 4 beefalo wool for 1 gold",
	}

--3,4
	local function gearfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.GEAR):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.GEAR.code, inst, ACTIONS.GEAR.mod_name)
        end
    end

    local gear_buttoninfo = {
		text = "gear",
		position = Vector3(510, 0, 0),
		fn = gearfn,
        helpstring = "1 gear for 10 gold",
	}

--3,5
	local function walrusfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.WALRUS):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.WALRUS.code, inst, ACTIONS.WALRUS.mod_name)
        end
    end

    local walrus_buttoninfo = {
		text = "walrus",
		position = Vector3(610, 0, 0),
		fn = walrusfn,
        helpstring = "Day: 1 cane for 10 gold\nDusk/Night: 1 walrus hat for 15 gold",
	}

--4,1
	local function weaponfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.WEAPON):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.WEAPON.code, inst, ACTIONS.WEAPON.mod_name)
        end
    end

    local weapon_buttoninfo = {
		text = "weapon",
		position = Vector3(210, -55, 0),
		fn = weaponfn,
        helpstring = "1 weapon for 5 gold",
	}

--4,2
	local function helmetfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.HELMET):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.HELMET.code, inst, ACTIONS.HELMET.mod_name)
        end
    end

    local helmet_buttoninfo = {
		text = "helmet",
		position = Vector3(310, -55, 0),
		fn = helmetfn,
        helpstring = "1 helmet for 4 gold",
	}

--4,3
	local function armorfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.ARMOR):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.ARMOR.code, inst, ACTIONS.ARMOR.mod_name)
        end
    end

    local armor_buttoninfo = {
		text = "armor",
		position = Vector3(410, -55, 0),
		fn = armorfn,
        helpstring = "1 armor for 5 gold",
	}

--4,4
	local function vegfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.VEG):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.VEG.code, inst, ACTIONS.VEG.mod_name)
        end
    end

    local veg_buttoninfo = {
		text = "veg",
		position = Vector3(510, -55, 0),
		fn = vegfn,
        helpstring = "1 veg for 1 gold",
	}

--4,5
	local function fruitfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.FRUIT):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.FRUIT.code, inst, ACTIONS.FRUIT.mod_name)
        end
    end

    local fruit_buttoninfo = {
		text = "fruit",
		position = Vector3(610, -55, 0),
		fn = fruitfn,
        helpstring = "3 fruit for 1 gold",
	}

--5,1
	local function meatfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.MEAT):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.MEAT.code, inst, ACTIONS.MEAT.mod_name)
        end
    end

    local meat_buttoninfo = {
		text = "meat",
		position = Vector3(210, -110, 0),
		fn = meatfn,
        helpstring = "1 meat for 2 gold",
	}

--5,2
	local function fishsfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.FISHS):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.FISHS.code, inst, ACTIONS.FISHS.mod_name)
        end
    end

    local fishs_buttoninfo = {
		text = "fish",
		position = Vector3(310, -110, 0),
		fn = fishsfn,
        helpstring = "1 fish for 2 gold",
	}

--5,3
	local function rarefn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.RARE):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.RARE.code, inst, ACTIONS.RARE.mod_name)
        end
    end

    local rare_buttoninfo = {
		text = "rare",
		position = Vector3(410, -110, 0),
		fn = rarefn,
        helpstring = "1 rare thing(tallbird egg, butter, goat milk and mandrake) for 15 gold",
	}

--5,4
	local function krampusfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.KRAMPUS):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.KRAMPUS.code, inst, ACTIONS.KRAMPUS.mod_name)
        end
    end

    local krampus_buttoninfo = {
		text = "krampus",
		position = Vector3(510, -110, 0),
		fn = krampusfn,
        helpstring = "1 krampus sack for 100 gold",
	}

--5,5
	local function mercenaryfn( inst )
        if TheWorld.ismastersim then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.MERCENARY):Do()
        else
            SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.MERCENARY.code, inst, ACTIONS.MERCENARY.mod_name)
        end
    end

    local mercenary_buttoninfo = {
		text = "mercenary",
		position = Vector3(610, -110, 0),
		fn = mercenaryfn,
        helpstring = "Day: 1 pigman for 5 gold\nDusk/Night: 1 bunnyman for 5 gold",
	}

	-- One buttoninfo per button
	self.widget.magic_buttons = {
		respawn_buttoninfo,
		sacrifice_buttoninfo,
		sell_buttoninfo,
		recycle_buttoninfo,
        display_buttoninfo,
        stores_buttoninfo,
        withdraw_buttoninfo,
		grass_buttoninfo,
		twig_buttoninfo,
		log_buttoninfo,
		rock_buttoninfo,
		flint_buttoninfo,
		mines_buttoninfo,
		reed_buttoninfo,
		cavefuel_buttoninfo,
		gem1_buttoninfo,
		gem2_buttoninfo,
		tooth_buttoninfo,
		skin_buttoninfo,
		hair_buttoninfo,
		gear_buttoninfo,
		walrus_buttoninfo,
		weapon_buttoninfo,
		helmet_buttoninfo,
		armor_buttoninfo,
		veg_buttoninfo,
		fruit_buttoninfo,
		meat_buttoninfo,
		fishs_buttoninfo,
		rare_buttoninfo,
		krampus_buttoninfo,
		mercenary_buttoninfo,
	}
end

local function itemtest(inst, item, slot)  
    --[[
    if item.components.stackable then
		return true
	else
		return false
	end]]
	return true
end

local function TriggerEvent(inst, phase)
    if phase == "day" and inst.x_gold < TUNING.MC_MAX then
        inst.x_gold = inst.x_gold + math.floor( inst.x_gold * TUNING.INTEREST )
        if inst.x_gold > TUNING.MC_MAX then
            inst.x_gold = TUNING.MC_MAX
        end
    end
end

local function fn(Sim)
	local inst = CreateEntity()

	inst:AddTag("structure")

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("magical_chest.tex")

	inst.AnimState:SetBank("chest")
	inst.AnimState:SetBuild("MagicalChest")
	inst.AnimState:PlayAnimation("closed")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        local _OnEntityReplicated = inst.OnEntityReplicated
        inst.OnEntityReplicated = function(inst)
            if _OnEntityReplicated then
                _OnEntityReplicated(inst)
            end
            EditContainer(inst)
        end
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("container")
	inst.components.container.itemtestfn = itemtest    ----
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    EditContainer(inst)

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
