local DISPLAY = Action({priority = 1})
DISPLAY.id = "DISPLAY"
DISPLAY.str = "Display"
DISPLAY.fn = function ( act )
	print("DEBUG: In display function...")
	if act.doer and act.target then
		if act.target.x_gold == 0 then
			act.doer.components.talker:Say("There is no gold nugget in Magical Chest.")
		elseif act.target.x_gold <= 1 then
			act.doer.components.talker:Say("There is only one gold nugget in Magical Chest.")
		else
			act.doer.components.talker:Say("There are " .. string.format(act.target.x_gold) .. " gold nuggets in Magical Chest.")
		end
	end
end 
AddAction(DISPLAY)

local EXCHANGE = Action({priority = 1})
EXCHANGE.id = "EXCHANGE"
EXCHANGE.str = "Exchange"
EXCHANGE.fn = function (act)
	-- try to do some exchange here
	if act.doer and act.target then
		if act.target.x_gold >= 13 then
			act.doer.components.talker:Say("EXCHANGE!!!!!")
			-- Give weapon here
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
			act.target.x_gold = act.target.x_gold - 5
			con_target:GiveItem(GLOBAL.SpawnPrefab(name))

			-- Give helmet here
			con_target = act.target.components.container
			names = {
				"footballhat", "footballhat", "footballhat", "footballhat",
				"wathgrithrhat", "wathgrithrhat", "wathgrithrhat", "wathgrithrhat",
				"slurtlehat",
				"ruinshat",
			}
			name = names[math.random(#names)]
			act.target.x_gold = act.target.x_gold - 4
			con_target:GiveItem(GLOBAL.SpawnPrefab(name))

			-- Give armor here
			con_target = act.target.components.container
			names = {
				"armorwood", "armorwood", "armorwood", "armorwood", "armorwood", 
				"armormarble",
				"armorsnurtleshell",
				"armordragonfly",
				"armorruins", "armorruins",
			}
			name = names[math.random(#names)]
			act.target.x_gold = act.target.x_gold - 4
			con_target:GiveItem(GLOBAL.SpawnPrefab(name))
			-- if you have more gold
			if act.target.x_gold >= 2 then
				-- Give some gem here
				names = {"greengem", "orangegem", "yellowgem"
				}
				name = names[math.random(#names)]
				act.target.x_gold = act.target.x_gold - 2
				con_target:GiveItem(GLOBAL.SpawnPrefab(name))
			end
			if act.target.x_gold >= 4 then
				-- Give some purple gem here
				act.target.x_gold = act.target.x_gold - 4
				con_target:GiveItem(GLOBAL.SpawnPrefab("purplegem"))
			end
			-- finally return some gold in case you want to withdraw
			if act.target.x_gold <= 20 then 
				for i = 1, act.target.x_gold do con_target:GiveItem(GLOBAL.SpawnPrefab("goldnugget")) end
				act.target.x_gold = 0
			elseif act.target.x_gold >20 then
				for i =1, 20 do con_target:GiveItem(GLOBAL.SpawnPrefab("goldnugget")) end
				act.target.x_gold = act.target.x_gold -20
			end
		else
			act.doer.components.talker:Say("There are not enough gold nuggets in Magical Chest.")
		end

	end
end
AddAction(EXCHANGE)

local STORES = Action({priority = 1})
STORES.id = "STORES"
STORES.str = "Stores"
STORES.fn = function ( act )
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
			-- do nothing if no gold was found
			-- act.doer.components.talker:Say("Please put some gold nuggets in Magical Chest.")
		end
	end
end
AddAction(STORES)


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
	{ name = "goldnugget", value = 1},
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
			-- act.doer.components.talker:Say("There is nothing tradable in Magical Chest.")
		end
	end
end
AddAction("SELL", "Sell", SellFn)