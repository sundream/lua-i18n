local i18n = {}

function i18n.init(option)
	i18n.lang = assert(option.lang)
	i18n.translates = option.translates or {}
	i18n.alias = {}
end

function i18n.load_file(lang,filename,readfile)
	if not i18n.translates[lang] then
		i18n.translates[lang] = {}
	end
    local tbl = readfile(filename)
    i18n.translates[lang] = tbl
end

function i18n.format(fmt,...)
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
