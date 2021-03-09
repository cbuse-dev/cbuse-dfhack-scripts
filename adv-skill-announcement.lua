

[[--

ADV-SKILL-ANNOUNCEMENT
Goal: Display an announcement each time you level up in a skill.

Issues: Announces nonsense whenever a new skill is added to the soul. Need to compare each of the same item in the list instead of comparing each index.

--]] 

local repeatUtil = require 'repeat-util'
local utils = require 'utils'

local job_name = '__advskillannouncement'

-- I know full damn well there's a better way to do this somewhere
-- but I also can't find enum usage in dfhack's documentation nor in any default scripts.
local shittySkills = {
    [-1] = "None",
	[0] = "Mining",
	[1] = "Woodcutting",
	[2] = "Carpentry",
	[3] = "Stone Detailing",
	[3] = "Masonry",
	[4] = "Animal Training",
	[5] = "Animal Care",
	[6] = "Fish Dissection",
	[7] = "Vermin Dissection",
	[8] = "Fish Processing",
	[9] = "Butchering",
	[10] = "Trapping",
	[11] = "Tanning",
	[12] = "Weaving",
	[13] = "Brewing",
	[14] = "Alchemy",
	[15] = "Clothesmaking",
	[16] = "Milling",
	[17] = "Plant Processing",
	[18] = "Cheesemaking",
	[19] = "Milking",
	[20] = "Cooking",
	[21] = "Planting",
	[22] = "Herbalism",
	[23] = "Fishing",
	[24] = "Smelting",
	[25] = "Strand Extracting",
	[26] = "Weaponsmithing",
	[27] = "Armorsmithing",
	[28] = "Blacksmithing",
	[29] = "Gemcutting",
	[30] = "Gemsetting",
	[31] = "Wood Crafting",
	[32] = "Stone Crafting",
	[33] = "Metal Crafting",
	[34] = "Glassmaking",
	[35] = "Leatherworking",
	[36] = "Bonecarving",
	[37] = "Axes",
	[38] = "Swords",
	[39] = "Daggers",
	[40] = "Maces",
	[41] = "Hammers",
	[42] = "Spears",
	[43] = "Crossbows",
	[44] = "Shields",
	[45] = "Armor",
	[46] = "Siege Crafting",
	[47] = "Siege Operating",
	[48] = "Bowyer",
	[49] = "Pikes",
	[50] = "Whips",
	[51] = "Bows",
	[52] = "Blowguns",
	[53] = "Throwing",
	[54] = "Mechanics",
	[55] = "Druidry",
	[56] = "Stealth",
	[57] = "Building Designing",
	[58] = "Wound Dressing",
	[59] = "Diagnosing",
	[60] = "Surgery",
	[61] = "Bone Setting",
	[62] = "Suturing",
	[63] = "Crutchwalking",
	[64] = "Wood Burning",
	[66] = "Lye Making",
	[67] = "Soapmaking",
	[68] = "Potash Making",
	[69] = "Dying",
	[70] = "Pump Operating",
	[71] = "Swimming",
	[72] = "Persuasion",
	[73] = "Negotiation",
	[74] = "Intent Judging",
	[75] = "Appraising",
	[76] = "Organizing",
	[77] = "Record-keeping",
	[78] = "Lying",
	[79] = "Intimidation",
	[81] = "Coversation",
	[82] = "Comedy",
	[83] = "Flattering",
	[84] = "Pacifying",
	[85] = "Tracking",
	[86] = "Student",
	[87] = "Concentration",
	[88] = "Discipline",
	[89] = "Situational Awareness",
	[90] = "Writing",
	[91] = "Wordsmithing",
	[92] = "Poetry",
	[93] = "Reading",
	[94] = "Speaking",
	[95] = "Coordination",
	[96] = "Balance",
	[97] = "Leadership",
	[98] = "Teaching",
	[99] = "Melee Combat",
	[100] = "Ranged Combat",
	[101] = "Wrestling",
	[102] = "Bite",
	[103] = "Punching",
	[104] = "Kicking",
	[105] = "Dodging",
	[106] = "Unusual Weapons",
	[107] = "Knapping",
	[108] = "Tactics",
	[109] = "Shearing",
	[110] = "Spinning",
	[111] = "Pottery",
	[112] = "Glazing",
	[113] = "Pressing",
	[114] = "Beekeeping",
	[115] = "Waxworking",
	[116] = "Climbing",
	[117] = "Gelding",
	[118] = "Dancing",
	[119] = "Music Making",
	[120] = "Singing Performance",
	[121] = "Keyboard Performance",
	[122] = "String Performance",
	[123] = "Wind Performance",
	[124] = "Percussion Performance",
	[125] = "Critical Thinking",
	[126] = "Logic",
	[127] = "Mathematics",
	[128] = "Astronomy",
	[129] = "Chemistry",
	[130] = "Geography",
	[131] = "Optics Engineering",
	[132] = "Fluid Engineering",
	[133] = "Papermaking",
	[134] = "Bookbinding",
	[135] = "Intrigue",
	[136] = "Riding"
}
local function doSkills(lastTickSkills)
	-- if you're in adventure mode and gametype is adventure mode
	if df.global.gamemode == 1 and df.global.gametype == 1 then
		if dfhack.isMapLoaded() then
			-- as far as I can tell, wold.units.active[0] is always the adventurer.
			-- status.souls[0] stores the skills for the adventurer, but now I'm wondering: can a creature have multiple souls in vanilla gameplay?
			local adventurer = df.global.world.units.active[0].status.souls[0]
			
			-- we can't use adventurer.skills on its own to compare it to the last tick's skills,
			-- the two won't be in the same order, which causes problems that I don't want to fix right now.
			local curskills = {}
			for k,v in ipairs(adventurer.skills) do
				curskills[k+1] = {v.rating,v.id}
			end
			
			if lastTickSkills ~= nil  then
				-- [ TODO ] improve these variable names.
				for k,lastSkill in ipairs(lastTickSkills) do
					if curskills[k][1] > lastSkill[1] then
						skill = shittySkills[lastSkill[2]]
						skill_level = lastSkill[1]
						dfhack.gui.showAnnouncement("You have grown stronger. Your "..skill.." is now "..skill_level..".",COLOR_BLUE,true)
					end
				end
			end
			
			local returned = {}
			for k,v in ipairs(adventurer.skills) do
				returned[k+1] = {v.rating,v.id}
			end
			return returned
		end
	else
		qerror("You aren't in adventure mode!")
	end
end

local function help()
    print('syntax: adv-skill-announcement [start|stop]')
end

local function stop()
    repeatUtil.cancel(job_name)
    print('Disabled skill announcements.')
end

local function start()
	-- [ TODO ] check repeatUtil for a time interval of 1 adventurer action. There probably isn't since it can vary a lot, but still worth a look
	local last = nil
    local doSkillsEachTick = function()
		last = doSkills(last)
	end
    repeatUtil.scheduleEvery(job_name, '1', 'ticks', doSkillsEachTick)
    print('Enabled skill announcements.')
end

local action_switch = {
    start=start,
    stop=stop,
}
setmetatable(action_switch, {__index=function() return help end})


local args = {...}
action_switch[args[1] or 'help']()
