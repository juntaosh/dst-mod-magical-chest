name = "Magical Chest 2"
description = "A chest that can do plenty of things."

author = "[BSy]Jupiter and Kima"

version = "2.0.0"

api_version = 10
api_version_dst = 10
dst_compatible = true

forumthread = ""

icon_atlas = "modicon.xml"
icon = "modicon.tex"

all_clients_require_mod = true
client_only_mod = false

server_filter_tags = {"Magical chest"}

dont_starve_compatible = false

configuration_options =
{
	{
		name = "hovertext",
		label = "Tip For Every Button",
		hover = "Configure wherher you want to show the tip of every button.",
		options =	{
						{description = "Yes", data = 1, hover = ""},
						{description = "No", data = 0, hover = ""},
					},
		default = 1,
	},
	{
		name = "interest",
		label = "Interest Of Bank",
		hover = "Configure the insterest per day.",
		options =	{
						{description = "1%", data = 0.01, hover = ""},
						{description = "2%", data = 0.02, hover = ""},
						{description = "3%", data = 0.03, hover = ""},
						{description = "4%", data = 0.04, hover = ""},
						{description = "5%", data = 0.05, hover = ""},
						{description = "6%", data = 0.06, hover = ""},
						{description = "7%", data = 0.07, hover = ""},
						{description = "8%", data = 0.08, hover = ""},
						{description = "9%", data = 0.09, hover = ""},
						{description = "10%", data = 0.1, hover = ""},
					},
		default = 0.01,
	},
	{
		name = "max",
		label = "Max Amount Of Gold",
		hover = "Configure the max amount of gold stored in Magical Chest.",
		options =	{
						{description = "1000", data = 1000, hover = ""},
						{description = "2000", data = 2000, hover = ""},
						{description = "3000", data = 3000, hover = ""},
						{description = "4000", data = 4000, hover = ""},
						{description = "5000", data = 5000, hover = ""},
					},
		default = 3000,
	},
}