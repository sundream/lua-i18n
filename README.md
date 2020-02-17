i18n
=====

国际化 lua版实现

## 介绍
i18n是一个用纯lua实现的国际化解决方案,大概只用了100行lua代码,具体见i18n.lua

## 用法
1. 将所有需要翻译的语句用i18n.format格式化,如
	```
	string.format("这是中文,参数1:%s,参数2:%s","名字",1) ==> i18n.format("这是中文,参数1:{0},参数2:{1}","名字",1)
	"需要翻译的语句" ==> i18n.format("需要翻译的语句")
	string.format("%s %s","需要翻译的参数","不需要翻译的参数") ==> i18n.format("{0} {1}",i18n.format("需要翻译的参数"),"不需要翻译的参数")
	-- i18n.format还支持格式化字典,如
	i18n.format("测试字典参数,目标={target},npc={npc}",{target="目标",npc="npc90001"})
	```
2. 搜索并生成待翻译的语句
	```
        	python search.py -h
		e.g:
		python search.py --output=languages/en_US.json .
	```

3. 合并最新待翻译文件和已翻译文件
	```
        	python merge.py -h
		e.g:
		python merge.py --source=languages/en_US_1.json --to=languages/en_US.json
	```

4. 将待翻译文件交由专业人员翻译,原始文本和翻译文本必须用"单个字表符"隔开
	如:
	这是中文,参数1:{0},参数2:{1}	this is chinese,parameter 2:{1},parameter 1:{0}

5. 使用已翻译文本
	```
		语言编码采用iso-639-1,国家地区编码采用iso-3166-1
		目录构成
		languages
			+zh_CN.json			// 汉语大陆地区
			+zh_TW.json			// 汉语台湾地区
			+en_US.json         // 英语美国地区

	-- 执行以下语句即可初始化
	local en_US = readfile("languages/en_US.json")
	languages = {}
	for k,v in pairs(en_US) do
		languages[k] = {en_US = v}	
	end
	local zh_CN = readfile("languages/zh_CN.json")
	for k,v in pairs(zh_CN) do
		if v and v ~= "" then
			i18n.alias(k,v)
		end
	end
	i18n.init({
		languages = languages,
	})
	```
6. 用法
```
    mkdir languages
    lua test.lua
```
