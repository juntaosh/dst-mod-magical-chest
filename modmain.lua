GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

PrefabFiles = {
	"magical_chest",
}

Assets = 
{
    Asset("IMAGE", "images/inventoryimages/magical_chest.tex" ),
    Asset("ATLAS", "images/inventoryimages/magical_chest.xml"),
}

GLOBAL.TUNING.INTEREST = GetModConfigData("interest")
GLOBAL.TUNING.MC_MAX = GetModConfigData("max")

STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH

GLOBAL.STRINGS.NAMES.MAGICAL_CHEST = "Magical Chest 2.0"

STRINGS.RECIPE_DESC.MAGICAL_CHEST = "Your favorite bank!"

GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAGICAL_CHEST = "Damn that's useful!"


  local magical_chest = AddRecipe("magical_chest",
    { 
    Ingredient("purplegem", 2), 
    Ingredient("livinglog", 4),
    Ingredient("nightmarefuel",6)
    },  
    GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.MAGIC_THREE, "magical_chest_placer", 1, nil, nil, nil, "images/inventoryimages/magical_chest.xml" )

AddMinimapAtlas("images/inventoryimages/magical_chest.xml")

local function import(t)
	for _,v in ipairs(t)do modimport("main/"..v) end
end

import{	'actions' }

-- By Kima
local containers = require "containers"
local params = containers.params

params.magical_chest = 
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
		table.insert(params.magical_chest.widget.slotpos, GLOBAL.Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
	end
end

local function exchangefn(inst, doer)
	if TheWorld.ismastersim then
		BufferedAction(doer, inst, ACTIONS.EXCHANGE):Do()
	elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
		SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.EXCHANGE.code, inst, ACTIONS.EXCHANGE.mod_name)
	end
end

params.magical_chest.widget.buttoninfo = {
	text = "Exchange",
    position = Vector3(0, -200, 0),
    fn = exchangefn,
    helpstring = "Exchange some useful stuff with gold in the bank!"
}


for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end