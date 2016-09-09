local action = function(msg, matches)
	if matches[1] == 'italic' then
	local italic = '_'..matches[2]..'_'
		api.sendReply(msg,italic,true)
	end -- end of italic
	
	if matches[1] == 'bold' then
	local bold = '*'..matches[2]..'*'
		api.sendReply(msg,bold,true)
	end -- end of bold
	
	if matches[1] == 'code' then
	local code = '`'..matches[2]..'`'
		api.sendReply(msg,code,true)
	end -- end of code
	
	if matches[1] == 'link' then
	local link = '['..matches[2]..']('..matches[3]..')'
		api.sendReply(msg,link,true)
	end -- end of link
	
	       end -- end of function

return {
	action = action,
	triggers = {
	'^/(bold) (.*)$',
	'^/(italic) (.*)$',
	'^/(code) (.*)$',
	'^/(link) (.*) (.*)$',
     }
}