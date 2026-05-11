hl = hl

mainMod = "SUPER"

hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm-app waybar")
end)

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto"
})

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
	general = {
		allow_tearing = true
	},

	xwayland = {
		force_zero_scaling = true
	},

	misc = {
		disable_xdg_env_checks = true
	}
})


-- Input
hl.config({
	input = {
   		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
    	follow_mouse = 2,
		sensitivity = 0,
		accel_profile = "flat",
    	touchpad = {
        	natural_scroll = true
    	}
	}
})

-- Style
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 4,
		border_size = 1,

		col = {
			active_border = "rgba(ffffffee)",
			inactive_border = "rgba(ffffff00)"
		}
	},

	decoration = {
		shadow = {
			enabled = false
		},

		blur = {
			enabled = true,
			size = 4,
			passes = 1,
		}
	},

	animations = {
		enabled = true
	},

	misc = {
		force_default_wallpaper = true,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		disable_autoreload = true
	}
})
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("uwsm-app kitty"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + Backspace", hl.dsp.exec_cmd("uwsm stop"))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.window_rule({
	name = "enable-steam-tearing",
	match = { class = "^(steam_app_[0-9]+)$" },
	immediate = true
})

hl.config({
	general = {
		layout = "scrolling",

		-- Prevents wrapping focus around the screen when at the edge
		no_focus_fallback = true,
		resize_on_border = false
	},

	scrolling = {
		direction = "right"
	},

	binds = {
		window_direction_monitor_fallback = false
		-- Prevents moving focus to another monitor when at the edge
	}
})

hl.bind(mainMod .. " + H", hl.dsp.layout("focus left"))
hl.bind(mainMod .. " + J", hl.dsp.layout("focus down"))
hl.bind(mainMod .. " + K", hl.dsp.layout("focus up"))
hl.bind(mainMod .. " + L", hl.dsp.layout("focus right"))

hl.bind(mainMod .. " + left", hl.dsp.layout("focus left"))
hl.bind(mainMod .. " + down", hl.dsp.layout("focus down"))
hl.bind(mainMod .. " + up", hl.dsp.layout("focus up"))
hl.bind(mainMod .. " + right", hl.dsp.layout("focus right"))

hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ direction = "right" }))

hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))


local function move_workspaces(next, window)
	local monitor = hl.get_active_monitor()

	local workspaces = hl.get_workspaces("m[" .. monitor.name .. "]")

	local current_workspace = hl.get_active_workspace()

	local index = -1
	for i = 1, #(workspaces) do
		if workspaces[i].id ~= current_workspace.id then goto continue end
		
		index = i
		break
		::continue::
	end

	if index == -1 then return end

	local dispatcher = window and hl.dsp.window.move or hl.dsp.focus
	if next then
		if index == #(workspaces) then
			hl.dispatch(dispatcher({ workspace = "emptynm" }))
		else
			hl.dispatch(dispatcher({ workspace = workspaces[index+1].id }))
		end
	else
		if index > 1 then
			hl.dispatch(dispatcher({ workspace = workspaces[index-1].id }))
		end
	end
end

hl.bind(mainMod .. " + SHIFT + J", function() move_workspaces(true, false) end)
hl.bind(mainMod .. " + SHIFT + K", function() move_workspaces(false, false) end)
hl.bind(mainMod .. " + SHIFT + CTRL + J", function() move_workspaces(true, true) end)
hl.bind(mainMod .. " + SHIFT + CTRL + K", function() move_workspaces(false, true) end)

hl.bind(mainMod .. " + SHIFT + down", function() move_workspaces(true, false) end)
hl.bind(mainMod .. " + SHIFT + up", function() move_workspaces(false, false) end)
hl.bind(mainMod .. " + SHIFT + CTRL + down", function() move_workspaces(true, true) end)
hl.bind(mainMod .. " + SHIFT + CTRL + up", function() move_workspaces(false, true) end)

hl.curve("easeOutExpo", { type="bezier", points = { {0.16, 1}, {.3, 1}}})
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier="easeOutExpo", style="slidevert"})
hl.animation({ leaf = "global", enabled = true, speed = 3, bezier="easeOutExpo" })
