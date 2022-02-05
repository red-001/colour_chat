local modstorage = core.get_mod_storage()

local register_on_message = core.register_on_sending_chat_message
if core.register_on_sending_chat_messages then
	register_on_message = core.register_on_sending_chat_messages
end

local function rgb_to_hex(rgb)
	local hexadecimal = '#'

	for key, value in pairs(rgb) do
		local hex = ''

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end

		if(string.len(hex) == 0)then
			hex = '00'

		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end

		hexadecimal = hexadecimal .. hex
	end

	return hexadecimal
end

local function color_from_hue(hue)
	local h = hue / 60
	local c = 255
	local x = (1 - math.abs(h%2 - 1)) * 255

  	local i = math.floor(h);
  	if (i == 0) then
		return rgb_to_hex({c, x, 0})
  	elseif (i == 1) then 
		return rgb_to_hex({x, c, 0})
  	elseif (i == 2) then 
		return rgb_to_hex({0, c, x})
	elseif (i == 3) then
		return rgb_to_hex({0, x, c});
	elseif (i == 4) then
		return rgb_to_hex({x, 0, c});
	else 
		return rgb_to_hex({c, 0, x});
	end
end

local function canTalk()
	if core.get_privilege_list then
		return core.get_privilege_list().shout
	else
		return true
	end
end

local function say(message)
	if not canTalk() then
		minetest.display_chat_message("You need 'shout' in order to talk.")
		return
	end
	minetest.send_chat_message(message)
	if minetest.get_server_info().protocol_version < 29 then
		local name = minetest.localplayer:get_name()
		minetest.display_chat_message("<"..name.."> " .. message)
	end
end

register_on_message(function(message)
	if message:sub(1,1) == "/" or modstorage:get_string("colour") == "" or modstorage:get_string("colour") == "white" then
		return false
	end
-- using commit https://github.com/red-001/colour_chat/pull/3/files from Lejo1
      local atname, msg=string.match(message, "^@([^%s:]*)[%s:](.*)")
  if atname and msg then message = msg end
	if modstorage:get_string("colour") == "rainbow" then
		local step = 360 / message:len()
 		local hue = 0
     		 -- iterate the whole 360 degrees
		local output = ""
      		for i = 1, message:len() do
			local char = message:sub(i,i)
			if char:match("%s") then
				output = output .. char
			else
        			output = output  .. core.get_color_escape_sequence(color_from_hue(hue)) .. char
			end
        		hue = hue + step
		end
    if atname and msg then
		  say("@"..atname .." ".. output)
    else say(output)
    end
	elseif atname and msg then
		say("@"..atname .." ".. core.colorize(modstorage:get_string("colour"), message))
	else
		say(core.get_color_escape_sequence(modstorage:get_string("colour")) .. message)
	end
	return true
end)

core.register_chatcommand("set_colour", {
	description = core.gettext("Change default session sent chat colour."),
	func = function(colour)
		modstorage:set_string("colour", colour)
		return true, "Chat colour changed."
	end,
})

core.register_chatcommand("rainbow", {
	description = core.gettext("Abrupt rainbow text transition."),
	func = function(param)
		if not canTalk() then
			return false, "You need 'shout' in order to use this command."
		end
		local step = 360 / param:len()
 		local hue = 0
     		 -- iterate the whole 360 degrees
		local output = ""
      		for i = 1, param:len() do
			local char = param:sub(i,i)
			if char:match("%s") then
				output = output .. char
			else
        			output = output  .. core.get_color_escape_sequence(color_from_hue(hue)) .. char 
			end
        		hue = hue + step
		end
		say(output)
		return true
end,
})

core.register_chatcommand("rainbow_smooth", {
	description = core.gettext("Smooth rainbow text from red."),
	func = function(param)
		if not canTalk() then
			return false, "You need 'shout' in order to use this command."
		end
		local step = 90 / param:len()
 		local hue = 0
     		 -- iterate 1/4 of 360 degrees (default 360)
		local output = ""
      		for i = 1, param:len() do
			local char = param:sub(i,i)
			if char:match("%s") then
				output = output .. char
			else
        			output = output  .. core.get_color_escape_sequence(color_from_hue(hue)) .. char
			end
        		hue = hue + step
		end
		say(output)
		return true
end,
})

core.register_chatcommand("rainbow_smooth_yellow", {
	description = core.gettext("Smooth rainbow text from yellow."),
	func = function(param)
		if not canTalk() then
			return false, "You need 'shout' in order to use this command."
		end
		local step = 90 / param:len()
 		local hue = 60
     		 -- iterate 1/4 of 360 degrees
		local output = ""
      		for i = 1, param:len() do
			local char = param:sub(i,i)
			if char:match("%s") then
				output = output .. char
			else
        			output = output  .. core.get_color_escape_sequence(color_from_hue(hue)) .. char
			end
        		hue = hue + step
		end
		say(output)
		return true
end,
})

core.register_chatcommand("rainbow_smooth_green", {
	description = core.gettext("Smooth rainbow text from green."),
	func = function(param)
		if not canTalk() then
			return false, "You need 'shout' in order to use this command."
		end
		local step = 90 / param:len()
 		local hue = 120
     		 -- iterate 1/4 of 360 degrees
		local output = ""
      		for i = 1, param:len() do
			local char = param:sub(i,i)
			if char:match("%s") then
				output = output .. char
			else
        			output = output  .. core.get_color_escape_sequence(color_from_hue(hue)) .. char
			end
        		hue = hue + step
		end
		say(output)
		return true
end,
})

core.register_chatcommand("rainbow_smooth_cyan", {
	description = core.gettext("Smooth rainbow text from cyan."),
	func = function(param)
		if not canTalk() then
			return false, "You need 'shout' in order to use this command."
		end
		local step = 90 / param:len()
 		local hue = 170
     		 -- iterate 1/4 of 360 degrees
		local output = ""
      		for i = 1, param:len() do
			local char = param:sub(i,i)
			if char:match("%s") then
				output = output .. char
			else
        			output = output  .. core.get_color_escape_sequence(color_from_hue(hue)) .. char
			end
        		hue = hue + step
		end
		say(output)
		return true
end,
})

core.register_chatcommand("rainbow_smooth_blue", {
	description = core.gettext("Smooth rainbow text from blue."),
	func = function(param)
		if not canTalk() then
			return false, "You need 'shout' in order to use this command."
		end
		local step = 90 / param:len()
 		local hue = 240
     		 -- iterate 1/4 of 360 degrees
		local output = ""
      		for i = 1, param:len() do
			local char = param:sub(i,i)
			if char:match("%s") then
				output = output .. char
			else
        			output = output  .. core.get_color_escape_sequence(color_from_hue(hue)) .. char
			end
        		hue = hue + step
		end
		say(output)
		return true
end,
})

core.register_chatcommand("rainbow_smooth_purple", {
	description = core.gettext("Smooth rainbow text from purple/pink."),
	func = function(param)
		if not canTalk() then
			return false, "You need 'shout' in order to use this command."
		end
		local step = 90 / param:len()
 		local hue = 300
     		 -- iterate 1/4 of 360 degrees
		local output = ""
      		for i = 1, param:len() do
			local char = param:sub(i,i)
			if char:match("%s") then
				output = output .. char
			else
        			output = output  .. core.get_color_escape_sequence(color_from_hue(hue)) .. char
			end
        		hue = hue + step
		end
		say(output)
		return true
end,
})

core.register_chatcommand("say", {
	description = core.gettext("Send text without configured color characters appended."),
	func = function(text)
		say(text)
		return true
	end,
})
