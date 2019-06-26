local languages = {
	en_US = {
		["这是中文,参数1:{1},参数2:{2}"] = "this is english,parameter 2:{2},parameter 1:{1}",
		["测试字典参数,目标={target},npc={npc}"] = "test dictionary parameter,target={target},npc={npc}",
	},
}

local function benchmark(cnt)
	local i18n = require "i18n"
	i18n.init({
		languages = languages,
	})
	local time = os.clock()
	for i=1,cnt do
		local packstr = i18n.format("这是中文,参数1:{1},参数2:{2}","名字",1)
		local str = i18n.translateto("en_US",packstr)
	end
	local sum = os.clock() - time
	print(string.format("case=列表参数 cnt=%d sum=%fs avg=%fs",cnt,sum,sum/cnt))

	local time = os.clock()
	for i=1,cnt do
		local packstr = i18n.format("测试字典参数,目标={target},npc={npc}",{target="目标",npc="npc90001"})
		local str = i18n.translateto("en_US",packstr)
	end
	local sum = os.clock() - time
	print(string.format("case=字典参数 cnt=%d sum=%fs avg=%fs",cnt,sum,sum/cnt))
end

local cnt = ...
cnt = tonumber(cnt) or 1000000
benchmark(cnt)

