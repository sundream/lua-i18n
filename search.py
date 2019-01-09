#coding: utf-8
import sys
import io
import optparse
import os
import os.path
import re
import string

def _genModFile(filename,patten):
    # i18n.format("搜索的内容")
    # i18n.format('搜索的内容')
    patten = r"%s\w*?\((\"|\')(.+?)\1" % patten
    lines = {}
    patten = re.compile(patten,re.S)
    try:
        fd = open(filename,"rb")
        content = fd.read()
        if not content:
            return
        for hit in patten.finditer(content):
            msg = hit.group(2)
            if not lines.has_key(msg):
                lines[msg] = True
    finally:
        fd.close()
    return lines

def genModFile(files,patten,exts,output):
    fd = open(output,"wb")
    lines = {}
    for path in iter(files):
        if os.path.isfile(path):
            filename = path
            _,ext = os.path.splitext(filename)
            if ext not in exts:
                continue
            lines.update(_genModFile(filename,patten))
        else:
            for root,dirs,filenames in os.walk(path):
                for filename in iter(filenames):
                    _,ext = os.path.splitext(filename)
                    if ext not in exts:
                        continue
                    filename = os.path.join(root,filename)
                    lines.update(_genModFile(filename,patten))
    lines = [k for k in lines] 
    lines.sort()
    data = string.join(lines,"\n")
    fd.write(data)
    fd.close()

def main():
    usage = u'''usage: python %prog [options]
    e.g: python %prog 文件/目录
    e.g: python %prog --output=mod.txt --ext=.lua --patten=i18n.format 文件/目录
    '''
    parser = optparse.OptionParser(usage=usage,version="%prog 0.0.1")
    parser.add_option("-o","--output",help=u"[optional] 输出文件",default="mod.txt")
    parser.add_option("-e","--ext",help=u"[optional] 搜索文件的扩展名",default=".lua")
    parser.add_option("-p","--patten",help=u"[optional] 匹配模式",default="i18n.format")
    options,args = parser.parse_args()
    files = args
    if len(files) == 0:
        print("no input file")
        exit(0)
    output = options.output
    ext = options.ext
    exts = string.split(ext,",")
    patten = options.patten
    genModFile(files,patten,exts,output)

if __name__ == "__main__":
    main()
