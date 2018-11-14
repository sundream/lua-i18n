i18n = i18n or {}

function i18n.init(option)
	-- 原生语言
	i18n.lang = assert(option.lang)
	i18n.translate_table = option.translate_table or {}
	if option.mod then
		i18n.translate_table = {}
		i18n.mod = option.mod
		i18n._init_from_mod(option.mod,option.mod)
		--[[
		for lang,tbl in pairs(i18n.translate_table) do
			for k,v in pairs(tbl) do
				print(k,v)
			end
		end
		]]
	end
end

function i18n._init_from_mod(path,root)
	local lfs = require "lfs"
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".."  then
			local f = path .. "/" .. file
			local attr = lfs.attributes(f)
			if attr.mode == "directory" then
				i18n._init_from_mod(f,root)
			elseif attr.mode == "file" then
				f2 = f:gsub(root.."/","",1)
				lang = f2:match("^(.+)/.+$")
				assert(lang)
				if not i18n.translate_table[lang] then
					i18n.translate_table[lang] = {}
				end
				fd = io.open(f,"rb")
				for line in fd:lines() do
					raw,translate = line:match("^(.+)===(.+)$")
					if raw and translate then
						i18n.translate_table[lang][raw] = translate
					end
				end
				fd:close()
			end
		end
	end
end

function i18n.format(fmt,...)
	return i18n.packstring(fmt,...)
end

function i18n.translateto(lang,packstr)
	return i18n.unpackstring(lang,packstr)
end

-- 私有方法
function i18n.packstring(fmt,...)
	local args = {...}
	-- 字典参数
	if #args == 1 and
		type(args[1]) == "table" and
		not args[1]._i18n then
		args = args[1]
	end
	local pack_args = {}
	for k,arg in pairs(args) do
		if type(arg) == "table" and arg._i18n then
		else
			-- 无须翻译参数
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

function i18n.getstring(lang,str)
	-- 未翻译的字符串均原样返回
	local dict = i18n.translate_table[lang]
	if not dict then
		return str
	end
	if not dict[str] then
		return str
	end
	return dict[str]
end

function i18n.unpackstring(lang,packstr)
	-- 无须翻译字符串
	if type(packstr) == "string" then
		return packstr
	end
	local fmt = i18n.getstring(lang,packstr.fmt)
	local args = packstr.args
	if args and next(args) then
		for k,arg in pairs(args) do
			args[k] = i18n.unpackstring(lang,arg)
		end
		local result = string.gsub(fmt,"{(%w+)}",function (id)
			return args[id]
		end)
		return result
	else
		return fmt
	end
end

return i18n
