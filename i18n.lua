local i18n = {}

function i18n.init(option)
	-- auto translate to's language
	i18n.default_language = option.default_language
	i18n.diff_index = 1
	-- raw => {zh_CN=xxx,zh_TW=xxx,en_US=xxx}
	i18n.languages = option.languages or {}
end

function i18n.format(fmt,...)
	if i18n.default_language then
		return i18n.translateto(i18n.default_language,i18n.pack(fmt,...))
	end
	return i18n.pack(fmt,...)
end

function i18n.translateto(lang,packstr)
	return i18n.unpack(lang,packstr)
end

function i18n.pack(fmt,...)
	local args = {...}
	if #args == 1 and
		type(args[1]) == "table" and
		not args[1]._i18n then
		args = args[1]
	end
	local pack_args = {}
	for k,arg in pairs(args) do
		if type(arg) == "table" and arg._i18n then
		else
			arg = tostring(arg)
		end
		pack_args[tostring(k)] = arg
	end
	return {
		fmt = fmt,
		args = pack_args,
		_i18n = true,
	}
end

function i18n.text(lang,raw)
	local dict = i18n.languages[raw]
	if not dict then
		return raw
	end
	if not dict[lang] then
		return raw
	end
	return dict[lang]
end

function i18n.unpack(lang,packstr)
	if type(packstr) == "string" then
		return packstr
	end
	local fmt = i18n.text(lang,packstr.fmt)
	local args = packstr.args
	if args and next(args) then
		for k,arg in pairs(args) do
			args[k] = i18n.unpack(lang,arg)
		end
		local result = string.gsub(fmt,"{(%w+)}",function (id)
                        local number= tonumber(id)
			if number then
				id = tostring(number + i18n.diff_index)
			end
			return args[id]
		end)
		return result
	else
		return fmt
	end
end

function i18n.alias(raw,alias)
	i18n.languages[alias] = i18n.languages[raw]
end

return i18n
