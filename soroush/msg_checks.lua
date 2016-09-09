--Begin msg_checks.lua
--Begin pre_process function
local function pre_process(msg)
-- Begin 'RondoMsgChecks' text checks by @rondoozle
if is_chat_msg(msg) or is_super_group(msg) then
	if msg and not is_whitelisted(msg.from.id) then --if regular user
        if is_momod(msg) and not msg.service then return msg end
	local data = load_data(_config.moderation.data)
	local print_name = user_print_name(msg.from):gsub("‮", "") -- get rid of rtl in names
	local name_log = print_name:gsub("_", " ") -- name for log
	local to_chat = msg.to.type == 'chat'
        if not data[tostring(msg.to.id)] then return msg end
	if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] then
		settings = data[tostring(msg.to.id)]['settings']
	end
	local link_flood = "kick"
	if data[tostring(msg.to.id)]['settings']['link_flood'] then
    	link_flood = data[tostring(msg.to.id)]['settings']['link_flood']
    end
	if settings.mute_forward then
		mute_forward = settings.mute_forward
	else
		mute_forward = '🔓'
	end
		if settings.lock_arabic then
		lock_arabic = settings.lock_arabic
	else
		lock_arabic = '🔓'
	end
	if settings.lock_rtl then
		lock_rtl = settings.lock_rtl
	else
		lock_rtl = '🔓'
	end
	if settings.lock_rtl then
		mute_service = settings.mute_service
	else
		mute_rtl = '🔓'
	end
	if settings.lock_link then
		lock_link = settings.lock_link
	else
		lock_link = '🔓'
	end
	if settings.lock_member then
		lock_member = settings.lock_member
	else
		lock_member = '🔓'
	end
	if settings.lock_spam then
		lock_spam = settings.lock_spam
	else
		lock_spam = '🔓'
	end
	if settings.lock_sticker then
		lock_sticker = settings.lock_sticker
	else
		lock_sticker = '🔓'
	end
	if settings.lock_contacts then
		lock_contacts = settings.lock_contacts
	else
		lock_contacts = '🔓'
	end
	if settings.strict then
		strict = settings.strict
	else
		strict = '🔓'
	end
	if msg.from.username then
	   USERNAME = '@'..msg.from.username
	   else
	   USERNAME = msg.from.id
	 end
		if msg and not msg.service and is_muted(msg.to.id, 'All: yes') or is_muted_user(msg.to.id, msg.from.id) and not msg.service then
			delete_msg(msg.id, ok_cb, false)
			if to_chat then
			--	kick_user(msg.from.id, msg.to.id)
			end
		end
		if msg.text then -- msg.text checks
			local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
			 local _nl, real_digits = string.gsub(msg.text, '%d', '')
			if lock_spam == "🔐" and string.len(msg.text) > 2049 or ctrl_chars > 40 or real_digits > 2000 then
				delete_msg(msg.id, ok_cb, false)
				if strict == "🔐" or to_chat then
					delete_msg(msg.id, ok_cb, false)
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
			local is_bot = msg.text:match("?[Ss][Tt][Aa][Rr][Tt]=")
			if is_link_msg and lock_link == "🔐" and not is_bot then
				delete_msg(msg.id, ok_cb, false)
				if strict == "🔐" or to_chat then
					if link_flood == 'ban' then
					  send_msg("chat#id"..msg.to.id, 'کاربر ('..USERNAME..') به دلیل تبلیغ کردن اخراج شد (banned)',ok_cb,false)
					  ban_user(msg.from.id, msg.to.id)
					elseif link_flood == 'kick' then
					  send_msg("chat#id"..msg.to.id, 'کاربر ('..USERNAME..') به دلیل تبلیغ کردن اخراج شد (kicked)',ok_cb,false)
					  kick_user(msg.from.id, msg.to.id)
					end
				end
			end
			local is_squig_msg = msg.text:match("[\216-\219][\128-\191]")
			if is_squig_msg and lock_arabic == "🔐" then
				delete_msg(msg.id, ok_cb, false)
				if strict == "🔐" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local print_name = msg.from.print_name
			local is_rtl = print_name:match("‮") or msg.text:match("‮")
			if is_rtl and lock_rtl == "🔐" then
				delete_msg(msg.id, ok_cb, false)
				if strict == "🔐" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			if is_muted(msg.to.id, "Text: yes") and msg.text and not msg.media and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
		end
		if msg.media then -- msg.media checks
			if msg.media.title then
				local is_link_title = msg.media.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.media.title:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if is_link_title and lock_link == "🔐" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "🔐" or to_chat then
							if link_flood == 'ban' then
							  send_msg(get_receiver(msg), 'کاربر ('..USERNAME..') به دلیل تبلیغ کردن اخراج شد (banned)',ok_cb,false)
							  ban_user(msg.from.id, msg.to.id)
							elseif link_flood == 'kick' then
							  send_msg(get_receiver(msg), 'کاربر ('..USERNAME..') به دلیل تبلیغ کردن اخراج شد (kicked)',ok_cb,false)
							  kick_user(msg.from.id, msg.to.id)
							end
					end
				end
				local is_squig_title = msg.media.title:match("[\216-\219][\128-\191]")
				if is_squig_title and lock_arabic == "🔐" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "🔐" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
			end
			if msg.media.description then
				local is_link_desc = msg.media.description:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.media.description:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if is_link_desc and lock_link == "🔐" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "🔐" or to_chat then
							if link_flood == 'ban' then
							  send_msg(get_receiver(msg), 'کاربر ('..USERNAME..') به دلیل تبلیغ کردن اخراج شد (banned)',ok_cb,false)
							  ban_user(msg.from.id, msg.to.id)
							elseif link_flood == 'kick' then
							  send_msg(get_receiver(msg), 'کاربر ('..USERNAME..') به دلیل تبلیغ کردن اخراج شد (kicked)',ok_cb,false)
							  kick_user(msg.from.id, msg.to.id)
							end
					end
				end
				local is_squig_desc = msg.media.description:match("[\216-\219][\128-\191]")
				if is_squig_desc and lock_arabic == "🔐" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "🔐" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
			end
			if msg.media.caption then -- msg.media.caption checks
				local is_link_caption = msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if is_link_caption and lock_link == "🔐" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "🔐" or to_chat then
						if link_flood == 'ban' then
						  send_msg(get_receiver(msg), 'کاربر ('..USERNAME..') به دلیل تبلیغ کردن اخراج شد (banned)',ok_cb,false)
						  ban_user(msg.from.id, msg.to.id)
						elseif link_flood == 'kick' then
						  send_msg(get_receiver(msg), 'کاربر ('..USERNAME..') به دلیل تبلیغ کردن اخراج شد (kicked)',ok_cb,false)
						  kick_user(msg.from.id, msg.to.id)
						end
					end
				end
				local is_squig_caption = msg.media.caption:match("[\216-\219][\128-\191]")
					if is_squig_caption and lock_arabic == "🔐" then
						delete_msg(msg.id, ok_cb, false)
						if strict == "🔐" or to_chat then
							kick_user(msg.from.id, msg.to.id)
						end
					end
				local is_username_caption = msg.media.caption:match("^@[%a%d]")
				if is_username_caption and lock_link == "yes" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "🔐" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
				if lock_sticker == "🔐" and msg.media.caption:match("sticker.webp") then
					delete_msg(msg.id, ok_cb, false)
					if to_chat then
							  local user_id = msg.from.id
							  local chat_id = msg.to.id
							  local sticker_hash = 'sticker:'..chat_id..':'..user_id
							  local is_sticker_offender = redis:get(sticker_hash)
							  local group_sticker_lock = data[tostring(msg.to.id)]['settings']['lock_stickers']						 
							  if group_sticker_lock == '🔐' then
								  if is_sticker_offender then
									chat_del_user(get_receiver(msg), 'user#id'..user_id, ok_cb, true)
									redis:del(sticker_hash)
									send_msg("chat#id"..msg.to.id, 'به دلیل ارسال استیکر از گروه اخراج شد(kicked) !', ok_cb, false)
								  else
									redis:set(sticker_hash, true)
									send_msg("chat#id"..msg.to.id, 'شما به دلیل ارسال استیکر اخطار دریافت کردید \nدر صورت ارسال دوباره استیکر از گروه اخراج میشوید!(warn)', ok_cb, false)
								  end
							  end
					end
				end
			end
			if msg.media.type:match("contact") and lock_contacts == "yes" then
				delete_msg(msg.id, ok_cb, false)
				--if strict == "yes" or to_chat then
				--	kick_user(msg.from.id, msg.to.id)
				--end
			end
			local is_photo_caption =  msg.media.caption and msg.media.caption:match("photo")--".jpg",
			if is_muted(msg.to.id, 'Photo: yes') and msg.media.type:match("photo") or is_photo_caption and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "🔐" or to_chat then
					--	kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_gif_caption =  msg.media.caption and msg.media.caption:match(".mp4")
			if is_muted(msg.to.id, 'Gifs: yes') and is_gif_caption and msg.media.type:match("document") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "🔐" or to_chat then
					--	kick_user(msg.from.id, msg.to.id)
				end
			end
			if is_muted(msg.to.id, 'Audio: yes') and msg.media.type:match("audio") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "🔐" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_video_caption = msg.media.caption and msg.media.caption:lower(".mp4","video")
			if  is_muted(msg.to.id, 'Video: yes') and msg.media.type:match("video") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "yes" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			if is_muted(msg.to.id, 'Documents: yes') and msg.media.type:match("document") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "🔐" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
		end
		if msg.fwd_from then
			if msg.fwd_from.title then
				local is_link_title = msg.fwd_from.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.fwd_from.title:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if is_link_title and lock_link == "yes" then
					delete_msg(msg.id, ok_cb, false)

				end
			end
			if mute_forward == "yes" then
				delete_msg(msg.id,ok_cb,false)
			end
			if is_muted_user(msg.to.id, msg.fwd_from.peer_id) then
				delete_msg(msg.id, ok_cb, false)
			end
		end
		if msg.service then -- msg.service checks
		if mute_service == "yes" then
			delete_msg(msg.id, ok_cb, false)
		end
		local action = msg.action.type
			if action == 'chat_add_user_link' then
				local user_id = msg.from.id
				local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
				if string.len(msg.from.print_name) > 70 or ctrl_chars > 40 and lock_group_spam == 'yes' then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] joined and Service Msg deleted (#spam name)")
					delete_msg(msg.id, ok_cb, false)
					if strict == "🔐" or to_chat then
						savelog(msg.to.id, name_log.." ["..msg.from.id.."] joined and kicked (#spam name)")
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local print_name = msg.from.print_name
				local is_rtl_name = print_name:match("‮")
				if is_rtl_name and lock_rtl == "yes" then
					savelog(msg.to.id, name_log.." User ["..msg.from.id.."] joined and kicked (#RTL char in name)")
					kick_user(user_id, msg.to.id)
				end
				if lock_member == 'yes' then
					savelog(msg.to.id, name_log.." User ["..msg.from.id.."] joined and kicked (#lockmember)")
					kick_user(user_id, msg.to.id)
					delete_msg(msg.id, ok_cb, false)
				end
			end
			if action == 'chat_add_user' and not is_momod2(msg.from.id, msg.to.id) then
				local user_id = msg.action.user.id
				if string.len(msg.action.user.print_name) > 70 and lock_group_spam == 'yes' then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."]: Service Msg deleted (#spam name)")
					delete_msg(msg.id, ok_cb, false)
					if strict == "yes" or to_chat then
						savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."]: added user kicked (#spam name) ")
						delete_msg(msg.id, ok_cb, false)
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local print_name = msg.action.user.print_name
				local is_rtl_name = print_name:match("‮")
				if is_rtl_name and lock_rtl == "yes" then
					savelog(msg.to.id, name_log.." User ["..msg.from.id.."] added ["..user_id.."]: added user kicked (#RTL char in name)")
					kick_user(user_id, msg.to.id)
				end
				if msg.to.type == 'channel' and lock_member == 'yes' then
					savelog(msg.to.id, name_log.." User ["..msg.from.id.."] added ["..user_id.."]: added user kicked  (#lockmember)")
					kick_user(user_id, msg.to.id)
					delete_msg(msg.id, ok_cb, false)
				end
			end
		end
	end
end
if msg.text and not msg.service and is_muted(msg.to.id, 'All: yes') and not is_momod(msg) then return end
-- End 'RondoMsgChecks' text checks by @Rondoozle
	return msg
end
--End pre_process function
return {
	patterns = {},
	pre_process = pre_process
}
--End msg_checks.lua
--By @Rondoozle
