-- Constants -------------------------------------------------------------------
MOTA_NAME    = "MarkOfTheAfflicted"
MOTA_VERSION = "1.0.0"
MOTA_WEBSITE = "http://www.esoui.com/downloads/info1670-Scholar.html"

-- Local variables -------------------------------------------------------------
local MotA = ZO_Object:New()

-- Hotkey definition -----------------------------------------------------------
ZO_CreateStringId("SI_BINDING_NAME_MOTA_TITLE", GetString(MOTA_TITLE))
ZO_CreateStringId("SI_BINDING_NAME_MOTA_TOGGLE_TIMERS", GetString(MOTA_KEYBIND_TOGGLE))

-- Utilities -------------------------------------------------------------------
function MotA:SwapSavedVars(useAccountWide)
	if useAccountWide then
		if self.savedAccount == self.defaults then
			self.savedAccount = self.savedCharacter
		end

		self.savedVariables = self.savedAccount
	else
		self.savedVariables = self.savedCharacter
	end
end

-- Initialization --------------------------------------------------------------
function MotA:New()
	local norm                     = ZO_NORMAL_TEXT
	self.FONT_COLOR_NORMAL_DEFAULT = {norm.r, norm.g, norm.b, norm.a}

	self.defaults = {
		enable = {
			timers = true
		},
		timers = {
			position = {
				point    = LEFT,
				relPoint = LEFT,
				x        = 0,
				y        = 0
			},
			hideInCombat          = true,
			notifications         = GetString(MOTA_OPTION_NONE),
			notificationSound     = "Smithing_Finish_Research",
			type                  = GetString(MOTA_TIMERS_TYPE_TIME),
			labelFont             = GetString(MOTA_OPTION_BOLD),
			labelOutline          = GetString(MOTA_OPTION_SOFT_THICK_SHADOW),
			labelSize             = 16,
			timeFont              = GetString(MOTA_OPTION_MEDIUM),
			timeOutline           = GetString(MOTA_OPTION_THICK_OUTLINE),
			timeSize              = 14,
			labelColor            = self.FONT_COLOR_NORMAL_DEFAULT,
			timeColor             = {1, 1, 1, 1},
			vaBackgroundColor     = {0.310, 0.200, 0.424, 1},
			vaGlossColor          = {1, 1, 1, 1},
			wwBackgroundColor     = {0.851, 0.451, 0.145, 1},
			wwGlossColor          = {1, 1, 1, 1},
			labelAlignment        = GetString(MOTA_OPTION_LEFT),
			timerAction           = GetString(MOTA_OPTION_FILL),
			sort                  = GetString(MOTA_OPTION_DESCENDING),
			lockUI                = false,
			scale                 = 0.7,
			spacing               = 50
		}
	}

	self.defaultTimers = {
		timers = {}
	}

	self.savedVariables = {}
	self.savedAccount   = ZO_SavedVars:NewAccountWide("MotA_SavedVariables", 1.9, nil, self.defaults)
	self.savedCharacter = ZO_SavedVars:New("MotA_SavedVariables", 1.9, nil, self.defaults)
	self.savedTimers    = ZO_SavedVars:NewAccountWide("MotA_SavedTimers", 1.9, nil, self.defaultTimers)
	self:SwapSavedVars(self.savedAccount.accountWide)

	self:Initialize()

	return self
end

function MotA:Initialize()
	MotA_Settings:CreateMenu(self)
	MotA_Slash_Commands:Initialize(self)

	if self.savedVariables.enable.timers then
		MotA_Timers:Initialize(self)
	end
end

local function MotAOnAddonLoaded(event, addonName)
	if addonName == MOTA_NAME then
		MOTA = MotA:New()
	end
end
EVENT_MANAGER:RegisterForEvent(MOTA_NAME, EVENT_ADD_ON_LOADED, MotAOnAddonLoaded)
