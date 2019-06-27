local languages = {
	en_US = {
		["这是中文,参数1:{1},参数2:{2}"] = "this is chinese,parameter 2:{2},parameter 1:{1}",
		["测试字典参数,目标={target},npc={npc}"] = "test dictionary parameter,target={target},npc={npc}",
	},
}

local function test()
	local i18n = require "i18n"
	i18n.init({
		languages = languages,
	})
    local readfile = function (filename)
        local cjson = require "cjson"
        local fd = io.open(filename,"rb")
        local data = fd:read("*a")
        fd:close()
        return cjson.decode(data)
    end
    i18n.languages["en_US"] = readfile("languages/en_US.json")
	local packstr = i18n.format("这是中文,参数1:{1},参数2:{2}","名字",1)
	local str = i18n.translateto("zh_CN",packstr)
	print(str)
	local str = i18n.translateto("en_US",packstr)
	print(str)
	local packstr = i18n.format("{1}",
						"参数不用i18n.format括住表示无须翻译")
	local str = i18n.translateto("en_US",packstr)
	print(str)
	local packstr = i18n.format("{1}:原样保留",
						i18n.format("忘记翻译的语句"))
	local str = i18n.translateto("en_US",packstr)
	print(str)

	local packstr = i18n.format('未写格式化串的参数会被忽略',string.format('参数1'),i18n.format('参数2'))
	local str = i18n.translateto("en_US",packstr)
	print(str)

	-- 翻译两个相同串
	local packstr = i18n.format("这是中文,参数1:{1},参数2:{2}",
						i18n.format("这是中文,参数1:{1},参数2:{2}"),1)
	local str = i18n.translateto("en_US",packstr)
	print(str)

	-- 传递字典参数进行翻译
	local packstr = i18n.format("测试字典参数,目标={target},npc={npc}",{target="目标",npc="npc90001"})
	local str = i18n.translateto("en_US",packstr)
	print(str)
    -- 如果设置了default_language字段,i18n.format将自动翻译
    i18n.default_language = "zh_CN"
	local packstr = i18n.format("测试字典参数,目标={target},npc={npc}",{target="目标",npc="npc90001"})
    print(packstr)
end

-- enter i18n directory
-- test by: lua i18n/test.lua
test()
