local modstorage = core.get_mod_storage()
if modstorage:get_string("setup") == "" then
	modstorage:set_string("colour","#FFFFFF")
	modstorage:set_string("setup","finished")
end

minetest.register_on_sending_chat_messages(function(message)
	if message:sub(1,1) == "/" then
		return false
	end
	message = core.get_color_escape_sequence(modstorage:get_string("colour")) .. message
	minetest.send_chat_message(message)
	if minetest.get_server_info().protocol_version < 29 then
		minetest.display_chat_message(message)
	end
	return true
end)

core.register_chatcommand("set_colour", {
	description = core.gettext("Change chat colour"),
	func = function(colour)
		modstorage:set_string("colour", colour)
	return true, "Chat colour changed."
	end,
})
