i18n
=====

国际化 lua版实现

## 介绍
i18n是一个用纯lua实现的国际化解决方案,大概只用了100行lua代码,具体见i18n.lua

## 用法
1. 将所有需要翻译的语句用i18n.format格式化,如
	```
	string.format("这是中文,参数1:%s,参数2:%s","名字",1) ==> i18n.format("这是中文,参数1:{1},参数2:{2}","名字",1)
	"需要翻译的语句" ==> i18n.format("需要翻译的语句")
	string.format("%s %s","需要翻译的参数","不需要翻译的参数") ==> i18n.format("{1} {2}",i18n.format("需要翻译的参数"),"不需要翻译的参数")
	-- i18n.format还支持格式化字典,如
	i18n.format("测试字典参数,目标={target},npc={npc}",{target="目标",npc="npc90001"})
	```
2. 搜索并生成待翻译的语句
	```
        	python search.py -h
		e.g:
		python search.py --output=mod.txt test.lua benchmark.lua
	```

3. 合并最新待翻译文件和已翻译文件
	```
        	python merge.py -h
		e.g:
		python merge.py --source=mod.txt --to=mod/en_US/mod001.txt
	```

4. 将待翻译文件交由专业人员翻译,原始文本和翻译文本必须用"==="隔开
	如:
	这是中文,参数1:{1},参数2:{2}===this is chinese,parameter 2:{2},parameter 1:{1}

5. 使用已翻译文本
	```
		语言编码采用iso-639-1,国家地区编码采用iso-3166-1
		mod目录构成
		mod
			+zh_CN			// 汉语大陆地区
				+mod001.txt
			+zh_TW			// 汉语台湾地区
			+en_US			// 英语美国地区

		-- 执行以下语句即可初始化
		i18n.init({
				lang = "zh_CN",	-- 原生语言
				mod = "./mod",	-- 翻译文本所在目录
		})
	```
