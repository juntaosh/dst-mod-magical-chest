PrefabFiles = {
	"magical_chest",
}

Assets = 
{
    Asset( "IMAGE", "images/inventoryimages/magical_chest.tex" ),
    Asset("ATLAS", "images/inventoryimages/magical_chest.xml"),
}

GLOBAL.TUNING.INTEREST = GetModConfigData("interest")
GLOBAL.TUNING.MC_MAX = GetModConfigData("max")

	STRINGS = GLOBAL.STRINGS
	RECIPETABS = GLOBAL.RECIPETABS
    Recipe = GLOBAL.Recipe
    Ingredient = GLOBAL.Ingredient
    TECH = GLOBAL.TECH

    GLOBAL.STRINGS.NAMES.MAGICAL_CHEST = "Magical Chest"

    STRINGS.RECIPE_DESC.MAGICAL_CHEST = "Oh, it's magic!"

    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAGICAL_CHEST = "I fancy magical things!"


  local magical_chest = AddRecipe("magical_chest",
    { 
    Ingredient("purplegem", 2), 
    Ingredient("livinglog", 4),
    Ingredient("nightmarefuel",6)
    },  
    GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.MAGIC_THREE, "magical_chest_placer", 1, nil, nil, nil, "images/inventoryimages/magical_chest.xml" )

AddMinimapAtlas("images/inventoryimages/magical_chest.xml")



-- Override that loads magic buttons!
-- Now with helpstrings!
AddClassPostConstruct("widgets/containerwidget", function(self)
	local _Open = self.Open
	self.Open = function(self, container, doer)
		_Open(self, container, doer)

		local widget = container.replica.container:GetWidget()

		if widget == nil or widget.magic_buttons == nil then
			return
		end

		local ImageButton = GLOBAL.require "widgets/imagebutton"

		self.magic_buttons = {}

		for id, buttoninfo in pairs(widget.magic_buttons) do
			self.magic_buttons[id] = self:AddChild(ImageButton("images/ui.xml", "button_small.tex", "button_small_over.tex", "button_small_disabled.tex", nil, nil, {1,1}, {0,0}))
			self.magic_buttons[id].image:SetScale(1.07)
			self.magic_buttons[id].text:SetPosition(2,-2)
			self.magic_buttons[id]:SetPosition(buttoninfo.position)
			self.magic_buttons[id]:SetText(buttoninfo.text)
			if buttoninfo.fn ~= nil then
				self.magic_buttons[id]:SetOnClick(function()
					if doer ~= nil then
						if doer:HasTag("busy") then
							--Ignore button click when doer is busy
							return
						elseif doer.components.playercontroller ~= nil then
							local iscontrolsenabled, ishudblocking = doer.components.playercontroller:IsEnabled()
							if not (iscontrolsenabled or ishudblocking) then
								--Ignore button click when controls are disabled
								--but not just because of the HUD blocking input
								return
							end
						end
					end
					buttoninfo.fn(container, doer)
				end)
			end
			self.magic_buttons[id]:SetFont(GLOBAL.BUTTONFONT)
			self.magic_buttons[id]:SetDisabledFont(GLOBAL.BUTTONFONT)
			self.magic_buttons[id]:SetTextSize(33)
			self.magic_buttons[id].text:SetVAlign(GLOBAL.ANCHOR_MIDDLE)
			self.magic_buttons[id].text:SetColour(0, 0, 0, 1)

			if buttoninfo.validfn ~= nil then
				if buttoninfo.validfn(container) then
					self.magic_buttons[id]:Enable()
				else
					self.magic_buttons[id]:Disable()
				end
			end

			if GLOBAL.TheInput:ControllerAttached() then
				self.magic_buttons[id]:Hide()
			end

			self.magic_buttons[id].inst:ListenForEvent("continuefrompause", function()
				if GLOBAL.TheInput:ControllerAttached() then
					self.magic_buttons[id]:Hide()
				else
					self.magic_buttons[id]:Show()
				end
			end, GLOBAL.TheWorld)
			--hover text
			if GetModConfigData("hovertext") == 1 then
				self.magic_buttons[id]:SetHoverText(buttoninfo.helpstring, { offset_y = 60 }) -- offset_y = 40
			end
		end
	end
end)

local function RespawnFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local inv_doer = act.doer.components.inventory
		local con_target = act.target.components.container
		if con_target:Has("reviver",1) then
			con_target:ConsumeByName("reviver", 1)
			inv_doer:DropEverything(false,false) 
			GLOBAL.TheWorld:PushEvent("ms_playerdespawnanddelete", act.doer)
		else
			act.doer.components.talker:Say("Please put the Telltale Heart in Magical Chest.")
		end
	end
end
AddAction("RESPAWN", "Respawn", RespawnFn)

local list = {
	{ name = "cutgrass", value = 0.05},
	{ name = "twigs", value = 0.05},
	{ name = "log", value = 0.1},
	{ name = "charcoal", value = 0.1},
	{ name = "ash", value = 0.05},
	{ name = "cutreeds", value = 0.1},
	{ name = "lightbulb", value = 0.2},
	{ name = "petals", value = 0.2},
	{ name = "petals_evil", value = 0.2},
	{ name = "foliage", value = 0.2},
	{ name = "pinecone", value = 0.3},
	{ name = "cutlichen", value = 0.1},
	{ name = "wormlight", value = 1},
	{ name = "lureplantbulb", value = 3},
	{ name = "flint", value = 0.1},
	{ name = "nitre", value = 0.1},
	{ name = "redgem", value = 3},
	{ name = "bluegem", value = 3},
	{ name = "purplegem", value = 6},
	{ name = "greengem", value = 1.5},
	{ name = "orangegem", value = 1.5},
	{ name = "yellowgem", value = 1.5},
	{ name = "rocks", value = 0.1},
	{ name = "thulecite", value = 3},
	{ name = "thulecite_pieces", value = 0.5},
	{ name = "rope", value = 0.15},
	{ name = "boards", value = 0.4},
	{ name = "cutstone", value = 0.3},
	{ name = "papyrus", value = 0.4},
	{ name = "houndstooth", value = 2},
	{ name = "silk", value = 0.25},
	{ name = "spidergland", value = 0.1},
	{ name = "spidereggsack", value = 5},
	{ name = "beardhair", value = 0.3},
	{ name = "beefalowool", value = 0.2},
	{ name = "honeycomb", value = 3},
	{ name = "stinger", value = 0.1},
	{ name = "walrus_tusk", value = 5},
	{ name = "feather_crow", value = 0.5},
	{ name = "feather_robin", value = 0.7},
	{ name = "feather_robin_winter", value = 0.7},
	{ name = "horn", value = 2},
	{ name = "tentaclespots", value = 1.5},
	{ name = "trunk_summer", value = 3},
	{ name = "trunk_winter", value = 5},
	{ name = "slurtleslime", value = 0.5},
	{ name = "slurtle_shellpieces", value = 0.3},
	{ name = "butterflywings", value = 0.4},
	{ name = "mosquitosack", value = 0.15},
	{ name = "slurper_pelt", value = 0.75},
	{ name = "minotaurhorn", value = 10},
	{ name = "deerclops_eyeball", value = 10},
	{ name = "lightninggoathorn", value = 4},
	{ name = "glommerwings", value = 5},
	{ name = "glommerflower", value = 5},
	{ name = "glommerfuel", value = 3},
	{ name = "livinglog", value = 2},
	{ name = "nightmarefuel", value = 0.8},
	{ name = "gears", value = 8},
	{ name = "transistor", value = 2},
	{ name = "marble", value = 0.1},
	{ name = "boneshard", value = 1},
	{ name = "ice", value = 0.2},
	{ name = "poop", value = 0.1},
	{ name = "guano", value = 0.2},
	{ name = "dragon_scales", value = 30},
	{ name = "goose_feather", value = 3},
	{ name = "coontail", value = 2},
	{ name = "bearger_fur", value = 10},
	{ name = "webberskull", value = 5},
}

local function SellFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		local num_found = 0
        for k,v in pairs(act.target.components.container.slots) do
            if v and v.components.tradable then
            	if v.components.tradable.goldvalue >0 then
                	num_found = num_found + v.components.stackable:StackSize() * v.components.tradable.goldvalue
                end
            end
            for a,b in pairs(list) do
            	if v and v.prefab == b.name then
            		if v.components.stackable then
            			num_found = num_found + v.components.stackable:StackSize() * b.value
            		else
            			num_found = num_found + b.value
            		end
            	end
            end
        end
		if num_found >0 then
			--con_target:DestroyContents()
			for k,v in pairs(act.target.components.container.slots) do
				if v and v.components.tradable then
					if v.components.tradable.goldvalue > 0 then
						con_target:ConsumeByName(v.prefab, v.components.stackable:StackSize())
					end
				end
				for a,b in pairs(list) do
					if v and v.prefab == b.name then
						if v.components.stackable then
							con_target:ConsumeByName(v.prefab, v.components.stackable:StackSize())
						else
							con_target:ConsumeByName(v.prefab, 1)
						end
					end
				end
			end
			for k = 1, num_found do con_target:GiveItem(GLOBAL.SpawnPrefab("goldnugget")) end
		else
			act.doer.components.talker:Say("There is nothing tradable in Magical Chest.")
		end
	end
end
AddAction("SELL", "Sell", SellFn)

local function SacrificeFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if act.doer.components.health.currenthealth > 100 and act.doer.components.sanity.current > 50 then
			act.doer.components.health:DoDelta(-100)
			act.doer.components.sanity:DoDelta(-50)
			for i = 1, 5 do con_target:GiveItem(GLOBAL.SpawnPrefab("goldnugget")) end
		else
			act.doer.components.talker:Say("The health or sanity is too low to sacrifice.")
		end
	end
end
AddAction("SACRIFICE", "Sacrifice", SacrificeFn)

local function RecycleFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if con_target:NumItems() >= 1 then
			act.doer.components.sanity:DoDelta(1)
			con_target:DestroyContents()
			act.target.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		else
			act.doer.components.talker:Say("There is nothing in Magical Chest to recycle.")
		end
	end
end
AddAction("RECYCLE", "Recycle", RecycleFn)

local function DisplayFn( act )
	if act.doer and act.target then
		if act.target.x_gold == 0 then
			act.doer.components.talker:Say("There is no gold nugget in Magical Chest.")
		elseif act.target.x_gold <= 1 then
			act.doer.components.talker:Say("There is only one gold nugget in Magical Chest.")
		else
			act.doer.components.talker:Say("There are "..string.format(act.target.x_gold).." gold nuggets in Magical Chest.")
		end
	end
end
AddAction("DISPLAY", "Display", DisplayFn)

local function StoresFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local inv_doer = act.doer.components.inventory
		local con_target = act.target.components.container
		local num_found = 0
        for k,v in pairs(act.target.components.container.slots) do
            if v and v.prefab == "goldnugget" and v.components.stackable then
                num_found = num_found + v.components.stackable:StackSize()
            end
        end
		if num_found > 0 then
			if act.target.x_gold < TUNING.MC_MAX and act.target.x_gold + num_found <= TUNING.MC_MAX then
				act.target.x_gold = act.target.x_gold +num_found
				con_target:ConsumeByName("goldnugget", num_found)
			elseif act.target.x_gold < TUNING.MC_MAX and act.target.x_gold + num_found > TUNING.MC_MAX then
				local num_consume = TUNING.MC_MAX - act.target.x_gold
				act.target.x_gold = TUNING.MC_MAX
				con_target:ConsumeByName("goldnugget", num_consume)
			else
				act.doer.components.talker:Say("The bank is full of gold nuggets.")
			end
		elseif num_found == 0 then
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("STORES", "Stores", StoresFn)

local function WithdrawFn( act )
	local con_target = act.target.components.container
	if act.doer and act.target then
		if act.target.x_gold == 0 then
			act.doer.components.talker:Say("There is no gold nugget in Magical Chest.")
		elseif act.target.x_gold <= 20 then 
			for i = 1, act.target.x_gold do con_target:GiveItem(GLOBAL.SpawnPrefab("goldnugget")) end
			act.target.x_gold = 0
		elseif act.target.x_gold >20 then
			for i =1, 20 do con_target:GiveItem(GLOBAL.SpawnPrefab("goldnugget")) end
			act.target.x_gold = act.target.x_gold -20
		end
	end
end
AddAction("WITHDRAW", "Withdraw", WithdrawFn)

local function GrassFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if con_target:Has("goldnugget",1) then
			con_target:ConsumeByName("goldnugget", 1)
			for i = 1, 10 do con_target:GiveItem(GLOBAL.SpawnPrefab("cutgrass")) end
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("GRASS", "Grade", GrassFn)

local function TwigFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if con_target:Has("goldnugget",1) then
			con_target:ConsumeByName("goldnugget", 1)
			for i = 1, 10 do con_target:GiveItem(GLOBAL.SpawnPrefab("twigs")) end
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("TWIG", "Twig", TwigFn)

local function LogFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if con_target:Has("goldnugget",1) then
			con_target:ConsumeByName("goldnugget", 1)
			for i = 1, 5 do con_target:GiveItem(GLOBAL.SpawnPrefab("log")) end
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("LOG", "Log", LogFn)

local function RockFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if con_target:Has("goldnugget",1) then
			con_target:ConsumeByName("goldnugget", 1)
			for i = 1, 5 do con_target:GiveItem(GLOBAL.SpawnPrefab("rocks")) end
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("ROCK", "Rock", RockFn)

local function FlintFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if con_target:Has("goldnugget",1) then
			con_target:ConsumeByName("goldnugget", 1)
			for i = 1, 5 do con_target:GiveItem(GLOBAL.SpawnPrefab("flint")) end
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("FLINT", "Flint", FlintFn)

local function MinesFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if con_target:Has("goldnugget",1) then
			if GLOBAL.TheWorld.state.isday then
				con_target:ConsumeByName("goldnugget", 1)
				for i = 1, 5 do con_target:GiveItem(GLOBAL.SpawnPrefab("marble")) end
			else
				con_target:ConsumeByName("goldnugget", 1)
				for i = 1, 5 do con_target:GiveItem(GLOBAL.SpawnPrefab("nitre")) end
			end
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("MINES", "Mines", MinesFn)

local function ReedFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if con_target:Has("goldnugget",1) then
			con_target:ConsumeByName("goldnugget", 1)
			for i = 1, 5 do con_target:GiveItem(GLOBAL.SpawnPrefab("cutreeds")) end
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("REED", "Reed", ReedFn)

local function CavefuelFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if GLOBAL.TheWorld.state.isday then
			if con_target:Has("goldnugget",1) then
				con_target:ConsumeByName("goldnugget", 1)
				con_target:GiveItem(GLOBAL.SpawnPrefab("lightbulb"))
			else
				act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
			end
		end
		if GLOBAL.TheWorld.state.isdusk then
			if con_target:Has("goldnugget",2) then
				con_target:ConsumeByName("goldnugget", 2)
				con_target:GiveItem(GLOBAL.SpawnPrefab("wormlight"))
			else
				act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
			end
		end
		if GLOBAL.TheWorld.state.isnight then
			if con_target:Has("goldnugget",3) then
				con_target:ConsumeByName("goldnugget", 3)
				con_target:GiveItem(GLOBAL.SpawnPrefab("fireflies"))
			else
				act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
			end
		end
	end
end
AddAction("CAVEFUEL", "Cavefuel", CavefuelFn)

local function Gem1Fn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if GLOBAL.TheWorld.state.isday then
			if con_target:Has("goldnugget",5) then
				con_target:ConsumeByName("goldnugget", 5)
				con_target:GiveItem(GLOBAL.SpawnPrefab("redgem"))
			else
				act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
			end
		end
		if GLOBAL.TheWorld.state.isdusk then
			if con_target:Has("goldnugget",5) then
				con_target:ConsumeByName("goldnugget", 5)
				con_target:GiveItem(GLOBAL.SpawnPrefab("bluegem"))
			else
				act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
			end
		end
		if GLOBAL.TheWorld.state.isnight then
			if con_target:Has("goldnugget",8) then
				con_target:ConsumeByName("goldnugget", 8)
				con_target:GiveItem(GLOBAL.SpawnPrefab("purplegem"))
			else
				act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
			end
		end
	end
end
AddAction("GEM1", "Gem1", Gem1Fn)

local function Gem2Fn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if con_target:Has("goldnugget",3) then
			if GLOBAL.TheWorld.state.isday then
				con_target:ConsumeByName("goldnugget", 3)
				con_target:GiveItem(GLOBAL.SpawnPrefab("yellowgem"))
			elseif GLOBAL.TheWorld.state.isdusk then
				con_target:ConsumeByName("goldnugget", 3)
				con_target:GiveItem(GLOBAL.SpawnPrefab("orangegem"))
			else
				con_target:ConsumeByName("goldnugget", 3)
				con_target:GiveItem(GLOBAL.SpawnPrefab("greengem"))
			end
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("GEM2", "Gem2", Gem2Fn)

local function ToothFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if con_target:Has("goldnugget",3) then
			con_target:ConsumeByName("goldnugget", 3)
			con_target:GiveItem(GLOBAL.SpawnPrefab("houndstooth"))
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("TOOTH", "Tooth", ToothFn)

local function SkinFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if con_target:Has("goldnugget",4) then
			if GLOBAL.TheWorld.state.isday then
				con_target:ConsumeByName("goldnugget", 4)
				con_target:GiveItem(GLOBAL.SpawnPrefab("pigskin"))
			else
				con_target:ConsumeByName("goldnugget", 4)
				con_target:GiveItem(GLOBAL.SpawnPrefab("manrabbit_tail"))
			end
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("SKIN", "Skin", SkinFn)

local function HairFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if con_target:Has("goldnugget",1) then
			if GLOBAL.TheWorld.state.isday then
				con_target:ConsumeByName("goldnugget", 1)
				for i = 1, 3 do con_target:GiveItem(GLOBAL.SpawnPrefab("beardhair")) end
		    elseif GLOBAL.TheWorld.state.isdusk then
				con_target:ConsumeByName("goldnugget", 1)
				for i = 1, 2 do con_target:GiveItem(GLOBAL.SpawnPrefab("silk")) end
			else
				con_target:ConsumeByName("goldnugget", 1)
				for i = 1, 4 do con_target:GiveItem(GLOBAL.SpawnPrefab("beefalowool")) end
			end
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("HAIR", "Hair", HairFn)

local function GearFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if con_target:Has("goldnugget",10) then
			con_target:ConsumeByName("goldnugget", 10)
			con_target:GiveItem(GLOBAL.SpawnPrefab("gears"))
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("GEAR", "Gear", GearFn)

local function WalrusFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		if GLOBAL.TheWorld.state.isday then
			if con_target:Has("goldnugget",10) then
				con_target:ConsumeByName("goldnugget", 10)
				con_target:GiveItem(GLOBAL.SpawnPrefab("cane"))
			else
				act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
			end
		end
		if not GLOBAL.TheWorld.state.isday then
			if con_target:Has("goldnugget",15) then
				con_target:ConsumeByName("goldnugget", 15)
				con_target:GiveItem(GLOBAL.SpawnPrefab("walrushat"))
			else
				act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
			end
		end
	end
end
AddAction("WALRUS", "Walrus", WalrusFn)

local function WeaponFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		local names = {
			"spear_wathgrithr", "spear_wathgrithr", "spear_wathgrithr", "spear_wathgrithr", "spear_wathgrithr", 
			"hambat",
			"batbat",
			"tentaclespike",
			"ruins_bat",
			"staff_tornado",
		}
		local name = names[math.random(#names)]
		if con_target:Has("goldnugget",5) then
			con_target:ConsumeByName("goldnugget", 5)
			con_target:GiveItem(GLOBAL.SpawnPrefab(name))
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("WEAPON", "Weapon", WeaponFn)

local function HelmetFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		local names = {
			"footballhat", "footballhat", "footballhat", "footballhat",
			"wathgrithrhat", "wathgrithrhat", "wathgrithrhat", "wathgrithrhat",
			"slurtlehat",
			"ruinshat",
		}
		local name = names[math.random(#names)]
		if con_target:Has("goldnugget",4) then
			con_target:ConsumeByName("goldnugget", 4)
			con_target:GiveItem(GLOBAL.SpawnPrefab(name))
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("HELMET", "Helmet", HelmetFn)

local function ArmorFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		local names = {
			"armorwood", "armorwood", "armorwood", "armorwood", "armorwood", 
			"armormarble",
			"armorsnurtleshell",
			"armordragonfly",
			"armorruins", "armorruins",
		}
		local name = names[math.random(#names)]
		if con_target:Has("goldnugget",4) then
			con_target:ConsumeByName("goldnugget", 4)
			con_target:GiveItem(GLOBAL.SpawnPrefab(name))
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("ARMOR", "Armor", ArmorFn)

local function VegFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		local names = {
			"carrot", "carrot", "carrot", "carrot", "carrot",
			"pumpkin", "pumpkin", "pumpkin", 
			"corn", "corn", "corn",
			"eggplant", "eggplant", "eggplant", 
			"red_cap", "red_cap", "red_cap", "red_cap",
			"green_cap",
			"blue_cap",
		}
		local name = names[math.random(#names)]
		if con_target:Has("goldnugget",1) then
			con_target:ConsumeByName("goldnugget", 1)
			con_target:GiveItem(GLOBAL.SpawnPrefab(name))
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("VEG", "Veg", VegFn)

local function FruitFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		local names = {
			"berries", "berries", "berries", "berries", "berries", "berries",
			"dragonfruit",
			"pomegranate",
			"cave_banana",
			"watermelon",
		}
		local name = names[math.random(#names)]
		if con_target:Has("goldnugget",1) then
			con_target:ConsumeByName("goldnugget", 1)
			for i = 1, 3 do con_target:GiveItem(GLOBAL.SpawnPrefab(name)) end
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("FRUIT", "Fruit", FruitFn)

local function MeatFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		local names = {
			"smallmeat", "smallmeat", "smallmeat", "smallmeat", 
			"meat", "meat", "meat", "meat", 
			"drumstick", "drumstick", "drumstick", "drumstick", 
			"monstermeat", "monstermeat", "monstermeat", "monstermeat", "monstermeat",
			"froglegs", "froglegs", "froglegs", 
			"batwing", "batwing", "batwing", 
			"trunk_winter",
			"trunk_summer",
		}
		local name = names[math.random(#names)]
		if con_target:Has("goldnugget",2) then
			con_target:ConsumeByName("goldnugget", 2)
			con_target:GiveItem(GLOBAL.SpawnPrefab(name))
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("MEAT", "Meat", MeatFn)

local function FishsFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		local names = {
			"fish", "fish", "fish", "fish", "fish", "fish", "fish", "fish", "fish", 
			"eel",
		}
		local name = names[math.random(#names)]
		if con_target:Has("goldnugget",2) then
			con_target:ConsumeByName("goldnugget", 2)
			con_target:GiveItem(GLOBAL.SpawnPrefab(name))
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("FISHS", "Fishs", FishsFn)

local function KrampusFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		local pt = GLOBAL.Vector3(act.target.Transform:GetWorldPosition()) + GLOBAL.Vector3(1, 0, 1)
		if con_target:Has("goldnugget",100) then
			con_target:ConsumeByName("goldnugget", 100)
			GLOBAL.SpawnPrefab("krampus_sack").Transform:SetPosition(pt:Get())
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("KRAMPUS", "Krampus", KrampusFn)

local function RareFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		local names = {
			"tallbirdegg", "tallbirdegg", "tallbirdegg", "tallbirdegg", "tallbirdegg", 
			"butter", "butter", 
			"goatmilk", "goatmilk", 
			"mandrake",
		}
		local name = names[math.random(#names)]
		if con_target:Has("goldnugget",15) then
			con_target:ConsumeByName("goldnugget", 15)
			con_target:GiveItem(GLOBAL.SpawnPrefab(name))
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("RARE", "Rare", RareFn)

local function MercenaryFn( act )
	if act.doer and act.doer.components.inventory and act.target then
		local con_target = act.target.components.container
		local pt = GLOBAL.Vector3(act.target.Transform:GetWorldPosition()) + GLOBAL.Vector3(1, 0, 1)
		if con_target:Has("goldnugget",5) then
			if GLOBAL.TheWorld.state.isday then
				con_target:ConsumeByName("goldnugget", 5)
				GLOBAL.SpawnPrefab("pigman").Transform:SetPosition(pt:Get())
			else
				con_target:ConsumeByName("goldnugget", 5)
				GLOBAL.SpawnPrefab("bunnyman").Transform:SetPosition(pt:Get())
			end
		else
			act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction("MERCENARY", "Mercenary", MercenaryFn)




-- container.widgetsetup, because people suck
local magical_chest =
{
	widget =
	{
		slotpos = {},
		animbank = "ui_chest_3x3",
		animbuild = "ui_chest_3x3",
		pos = GLOBAL.Vector3(0, 200, 0),
		side_align_tip = 160,
	},
	type = "chest",
}

for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(magical_chest.widget.slotpos, GLOBAL.Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
	end
end

local containers = GLOBAL.require("containers")
containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, magical_chest.widget.slotpos ~= nil and #magical_chest.widget.slotpos or 0)

local _widgetsetup = containers.widgetsetup
function containers.widgetsetup(container, prefab, data)
	local pref = prefab or container.inst.prefab
	if pref == "magical_chest" then
		for k, v in pairs(magical_chest) do
			container[k] = v
		end
		container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
	else
		return _widgetsetup(container, prefab, data)
	end
end
