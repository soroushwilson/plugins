local function run(msg, matches)
local bot_id = 198434641
   if msg.service and msg.action.type == "chat_add_user" and msg.action.user.id == tonumber(bot_id) then
return reply_msg(msg.id,"سلام @"..msg.from.username.." 😃\nمرسی که منو به گروه "..msg.to.title.." دعوت کردی⛏😐\nبرای دیدن راهنمام تو پیوی /help بفرست😋",ok_cb,false)
end
end

return {
  patterns = {
    "^!!tgservice (.+)$",
  },
  run = run
}
