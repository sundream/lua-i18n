local i18n = {}

function i18n.init(option)
    -- auto translate to's language
	i18n.to_lang = option.to_lang
	i18n.translates = option.translates or {}
	i18n.alias = {}
end

function i18n.format(fmt,...)
    if i18n.to_lang then
        return i18n.translateto(i18n.to_lang,i18n.pack(fmt,...))
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
	if i18n.alias[raw] then
		raw = i18n.alias[raw]
	end
	local dict = i18n.translates[lang]
	if not dict then
		return raw
	end
	if not dict[raw] then
		return raw
	end
	return dict[raw]
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
			return args[id]
		end)
		return result
	else
		return fmt
	end
end

function i18n.set(alia,raw)
	i18n.alias[alia] = raw
end

return i18n
