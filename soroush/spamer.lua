local function run(msg, matches)

  local receiver = get_receiver(msg)
    if matches[1]:lower() == "spam" and is_sudo(msg) then
    local num = matches[2]:lower()
     local text = matches[3]:lower()
        for i=1,num do
            send_large_msg(receiver, text)
        end
  end
end
 
return {
  patterns = {
  "^(spam) (%d+) (.*)$",
  },
  run = run,
}