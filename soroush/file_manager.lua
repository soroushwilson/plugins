--ex functions
local function plugin_enabled( name )
  for k,v in pairs(config.plugins) do
    if name == v then
      return k
    end
  end
  -- If not found
  return false
end
local function send_formated_file(chid,mid,file,type)
 if type == 'gif' then
  api.sendDocument(chid, file, mid)
  elseif type == 'text' then
  api.sendDocument(chid, file, mid)
  elseif type == 'image' then
   api.sendPhoto(chid, file, 'By @TiagFAS_bot', mid)
  elseif type == 'audio' then
  api.sendAudio(chid, file, mid,nil,'By @TiagFAS_bot')
  elseif type == 'video' then
  api.sendVideo(chid, file, mid,nil,'By @TiagFAS_bot')
  else
  api.sendDocument(chid, file, mid)
  end
end
-- list
local function files_list( )
  local text = 'File List Of *Tiago*:\n\n'
  local num = 0
  for k, v in pairs(scandir("cloud")) do
    -- Ends with .
    if (v:match("%.([%w_%-]+)$")) then
      num = num + 1
     text = text..num..'- '..v..'\n' 
    end
end
if num == 0 then
  text = text..'Not any file found'
end
  return text
end
-- search in name
local function files_search2(value)
  local num = 0
  local text = ''
  for k, v in pairs(scandir("cloud")) do
    -- Ends with .
    if (v:match("%.([%w_%-]+)$")) then
      if v:find(value) then
        num = num + 1
text = text..num..'- '..v..'\n'
end
    end
end
if num == 0 then
  text = text..'I serched for *'..value..'* in file names but *not* any matched file found'
  return text
end
text = 'I serched for *'..value..'* in file names and founded *'..num..'* matches:\n\n'..text
  return text
end
local function plugins_search2(value)
  local num = 0
  local text = ''
  for k, v in pairs(scandir("plugins")) do
    -- Ends with .
    if (v:match("%.([%w_%-]+)$")) then
      if v:find(value) then
        num = num + 1
text = text..num..'- '..v..'\n'
end
    end
end
if num == 0 then
  text = text..'I serched for *'..value..'* in plugin names but *not* any matched plugin found'
  return text
end
text = 'I serched for *'..value..'* in plugin names and founded *'..num..'* matches:\n\n'..text
  return text
end
-- search in conenet
local function files_search(value)
  local num = 0
  local text = ''
  for k, v in pairs(scandir("cloud")) do
    -- Ends with .
    if (v:match("%.([%w_%-]+)$")) then
        local infile = io.open('cloud/'..v, "r")
        local instr = infile:read("*a")
        infile:close()
      if instr:find(value) then
        num = num + 1
text = text..num..'- '..v..'\n'
end
    end
end
if num == 0 then
  text = text..'I serched for *'..value..'* in files but *not* any matched file found'
  return text
end
text = 'I serched for *'..value..'* in files and founded *'..num..'* matches:\n\n'..text
  return text
end
local function plugins_search(value)
  local num = 0
  local text = ''
  for k, v in pairs(scandir("plugins")) do
    -- Ends with .
    if (v:match("%.([%w_%-]+)$")) then
        local infile = io.open('plugins/'..v, "r")
        local instr = infile:read("*a")
        infile:close()
      if instr:find(value) then
        num = num + 1
text = text..num..'- '..v..'\n'
end
    end
end
if num == 0 then
  text = text..'I serched for *'..value..'* in plugins but *not* any matched plugin found'
  return text
end
text = 'I serched for *'..value..'* in plugins and founded *'..num..'* matches:\n\n'..text
  return text
end
-- rename
local function file_rename(lvalue,value)
  local num = 0
  local suc = 0
  local text = ''
  local text2
  for k, v in pairs(scandir("cloud")) do
    -- Ends with .
    if (v:match("%.([%w_%-]+)$")) then
    if (v == lvalue) then
      os.rename('cloud/'..v, 'cloud/'..value)
      suc = 1
    elseif v:find(lvalue) then
     num = num + 1
     text = text..num..'- '..v..'\n'
      end
      end
  end
  if suc == 0 then
  text2 = 'I tried to rename *'..lvalue..'* but it is not found'
  if num > 0 then
    text2 = text2..'\nBut i quess you are looking for one of this files (plz write full name) :\n\n'..text
  end
else
  text2 = 'I changed requested file name from *'..lvalue..'* to *'..value..'* '
end
return text2
end
local function plugin_rename(lvalue,value)
  local num = 0
  local suc = 0
  local text = ''
  local text2
  for k, v in pairs(scandir("plugins")) do
    -- Ends with .
    if (v:match("%.([%w_%-]+)$")) then
    if (v == lvalue) then
      os.rename('plugins/'..v, 'plugins/'..value)
      suc = 1
    elseif v:find(lvalue) then
     num = num + 1
     text = text..num..'- '..v:gsub('.lua','')..'\n'
      end
      end
  end
  if suc == 0 then
  text2 = 'I tried to rename *'..lvalue:gsub('.lua','')..'* but it is not found'
  if num > 0 then
    text2 = text2..'\nBut i quess you are looking for one of this plugins (plz write full name) :\n\n'..text
  end
else
  text2 = 'I changed requested plugin name from *'..lvalue:gsub('.lua','')..'* to *'..value:gsub('.lua','')..'* '
  local enab = plugin_enabled(lvalue)
  if enab then
    text2 = text2..'\nOh, i looked for config file and this plugin is there i renamed it there , dont worry'
    table.remove(config.plugins, enab)
    table.insert(config.plugins, value)
    serialize_to_file(config, './config.lua')
    bot_init(true)
    end
end
return text2
end
--delete
local function file_del(value)
  local num = 0
  local suc = 0
  local text = ''
  local text2
  for k, v in pairs(scandir("cloud")) do
    -- Ends with .
    if (v:match("%.([%w_%-]+)$")) then
    if (v == value) then
      os.remove('cloud/'..v)
      suc = 1
    elseif v:find(value) then
     num = num + 1
     text = text..num..'- '..v..'\n'
      end
      end
  end
  if suc == 0 then
  text2 = 'I tried to remove *'..value..'* but it is not found'
  if num > 0 then
    text2 = text2..'\nBut i quess you are looking for one of this files (plz write full name) :\n\n'..text
  end
else
  text2 = 'I removed requested file *'..value..'* '
end
return text2
end
local function plugin_del(value)
  local num = 0
  local suc = 0
  local text = ''
  local text2
  for k, v in pairs(scandir("plugins")) do
    -- Ends with .
    if (v:match("%.([%w_%-]+)$")) then
    if (v == value) then
      os.remove('plugins/'..v)
      suc = 1
    elseif v:find(value) then
     num = num + 1
     text = text..num..'- '..v:gsub('.lua','')..'\n'
      end
      end
  end
  if suc == 0 then
  text2 = 'I tried to remove *'..value:gsub('.lua','')..'* but it is not found'
  if num > 0 then
    text2 = text2..'\nBut i quess you are looking for one of this plugins (plz write full name) :\n\n'..text
  end
else
  text2 = 'I removed requested plugin *'..value:gsub('.lua','')..'* '
  local enab = plugin_enabled(value)
  if enab then
    text2 = text2..'\nOh, i looked for config file and this plugin is there i removed it from there , dont worry'
    table.remove(config.plugins, enab)
    serialize_to_file(config, './config.lua')
    bot_init(true)
    end
end
return text2
end
--get
local function file_get(chid,mid,value,type)
  local num = 0
  local suc = 0
  local err = 0
  local text = ''
  local text2
  for k, v in pairs(scandir("cloud")) do
    -- Ends with .
    if (v:match("%.([%w_%-]+)$")) then
    if (v == value) then
    if fsize('cloud/'..v) > 5 then
    err = 1
    break
    end
    send_formated_file(chid,mid,'cloud/'..v,type)
    suc = 1
    elseif v:find(value) then
     num = num + 1
     text = text..num..'- '..v..'\n'
      end
      end
  end
  if suc == 0 then
  if err > 0 then
  text2 = 'Oh,shit! file size is upper than 5 mb'
  api.sendMessage(chid,text2,mid)
  return
  end
  text2 = 'I tried to get *'..value..'* but it is not found'
  if num > 0 then
    text2 = text2..'\nBut i quess you are looking for one of this files (plz write full name) :\n\n'..text
  end
else
  text2 = 'I am uploading & sending requested file *'..value..'* '
end
api.sendMessage(chid,text2,mid)
end
local function plugin_get(chid,mid,value)
  local num = 0
  local suc = 0
  local err = 0
  local text = ''
  local text2
  for k, v in pairs(scandir("plugins")) do
    -- Ends with .
    if (v:match("%.([%w_%-]+)$")) then
    if (v == value) then
    if fsize('plugins/'..v) > 5 then
    err = 1
    break
    end
    api.sendDocument(chid, 'plugins/'..v, mid)
    suc = 1
    elseif v:find(value) then
     num = num + 1
     text = text..num..'- '..v:gsub('.lua','')..'\n'
      end
      end
  end
  if suc == 0 then
  if err > 0 then
  text2 = 'Oh,shit! plugin size is upper than 5 mb'
  api.sendMessage(chid,text2,mid)
  return
  end
  text2 = 'I tried to show *'..value:gsub('.lua','')..'* but it is not found'
  if num > 0 then
    text2 = text2..'\nBut i quess you are looking for one of this plugins (plz write full name) :\n\n'..text
  end
else
  text2 = 'I am uploading & sending requested plugin *'..value:gsub('.lua','')..'* '
end
api.sendMessage(chid,text2,mid)
end
--show
local function file_show(msg,value,type)
  local num = 0
  local suc = 0
  local err = 0
  local text = ''
  local text2
  for k, v in pairs(scandir("cloud")) do
    -- Ends with .
    if (v:match("%.([%w_%-]+)$")) then
    if (v == value) then
    if fsize('cloud/'..v) > 5 then
    err = 1
    break
  end
  if type ~= 'text' then
      err = 1
    break
  end 
    local file = io.open('cloud/'..v,'r')
    local ptext = file:read("*a")
  	local text_max = 4096
    local text_len = string.len(ptext)
    local num_msg = math.ceil(text_len / text_max)
    if num_msg <= 1 then
      api.sendReply(msg,ptext)
      suc = 1
    else
    err = 1
    break
    end
    elseif v:find(value) then
     num = num + 1
     text = text..num..'- '..v..'\n'
      end
      end
  end
  if suc == 0 then
  if err > 0 then
  text2 = 'Oh,shit! file size is upper than 5 mb or too long or no supported'
  return text2
  end
  text2 = 'I tried to get *'..value..'* but it is not found'
  if num > 0 then
    text2 = text2..'\nBut i quess you are looking for one of this files (plz write full name) :\n\n'..text
  end
else
  text2 = 'I am sending requested file *'..value..'* '
end
return text2
end
local action = function(msg,matches,ln)
  	if msg.from.id ~= config.admin then
		return 
	end
if matches[1] == 'flist' then
api.sendReply(msg,files_list(),true)
elseif matches[1] == 'fsearch2' then
api.sendReply(msg,files_search2(matches[2]))
elseif matches[1] == 'psearch2' then
api.sendReply(msg,plugins_search2(matches[2]))
elseif matches[1] == 'fsearch' then
api.sendReply(msg,files_search(matches[2])) 
elseif matches[1] == 'psearch' then
api.sendReply(msg,plugins_search(matches[2])) 
elseif matches[1] == 'frename' then
api.sendReply(msg,file_rename(matches[2],matches[3])) 
elseif matches[1] == 'prename' then
api.sendReply(msg,plugin_rename(matches[2]..'.lua',matches[3]..'.lua')) 
elseif matches[1] == 'fdel' then
api.sendReply(msg,file_del(matches[2])) 
elseif matches[1] == 'pdel' then
api.sendReply(msg,plugin_del(matches[2]..'.lua')) 
elseif matches[1] == 'fget' then
local type = matches[2]:match('.*%.(.*)')
if type == 'gif' then
file_get(msg.chat.id,msg.message_id,matches[2],'gif')
else
file_get(msg.chat.id,msg.message_id,matches[2],(mimetype.get_content_type_no_sub(type) or 'file'))
end
elseif matches[1] == 'pget' then
plugin_get(msg.chat.id,msg.message_id,matches[2]..'.lua')
elseif matches[1] == 'fshow' then
local type = matches[2]:match('.*%.(.*)')
api.sendReply(msg,file_show(msg,matches[2],(mimetype.get_content_type_no_sub(type) or 'file')))
elseif matches[1] == 'pshow' then
api.sendReply(msg,plugin_show(msg,matches[2]..'.lua')) 
end
elseif matches[1] == 'cfile' then
if msg.reply_to_message.id then
local filename = (msg.reply_to_message.document.file_name or '')
local fileid = (msg.reply_to_message.document.file_id or msg.reply_to_message.audio.file_id or msg.reply_to_message.sticker.file_id or msg.reply_to_message.video.file_id or msg.reply_to_message.voice.file_id or msg.reply_to_message.photo[1].file_id or '')
if file and 
api.sendReply(msg,plugin_show(msg,matches[2]..'.lua')) 
end
end
triggers =
{
'^[!/](flist)$',
'^[!/](fsearch) (.+)$',
'^[!/](psearch) (.*)$',
'^[!/](fsearch2) (.+)$',
'^[!/](psearch2) (.+)$',
'^[!/](frename) ([%w_%.%-]+) ([%w_%.%-]+)$',
'^[!/](prename) ([%w_%.%-]+) ([%w_%.%-]+)$',
'^[!/](fdel) ([%w_%.%-]+)$',
'^[!/](pdel) ([%w_%.%-]+)$',
'^[!/](fget) ([%w_%.%-]+)$',
'^[!/](pget) ([%w_%.%-]+)$',
'^[!/](fshow) ([%w_%.%-]+)$',
'^[!/](pshow) ([%w_%.%-]+)$',
'^[!/](cfile)$',
'^[!/](cfile) ([%w_%.%-]+)$',
'^[!/](cfile) ([%w_%.%-]+) ([%w_%.%-]+)$',
'^[!/](cplug)$',
'^[!/](cplug) ([%w_%.%-]+)$',
'^[!/](cplug) ([%w_%.%-]+) ([%w_%.%-]+)$',
'^[!/](backup) ([%w_%.%-]+)$',
'^[!/](backupall) ([%w_%.%-]+)$',
}
return {triggers = triggers,action=action}