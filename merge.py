#coding: utf-8
import sys
import io
import optparse
import os
import os.path
import re
import string

def merge(source_filename,to_filename):
    src_fd = open(source_filename,"rb")
    src_lines = src_fd.readlines()
    src_fd.close()
    basedir = os.path.dirname(to_filename)
    # new file if not exist
    if not os.path.exists(basedir):
        os.makedirs(basedir)
    if not os.path.isfile(to_filename):
        fd = open(to_filename,"wb")
        fd.close()
    to_fd = open(to_filename,"rb")
    to_lines = to_fd.readlines()
    to_fd.close()
    src_dict = {}
    to_dict = {}
    sep = "\t"
    for src_line in iter(src_lines):
        src_line = src_line.strip()
        if src_line == "":
            continue
        src_lst = src_line.split(sep)
        src_lst = [text for text in src_lst if text != ""]
        src_raw = src_lst[0]
        src_translate = ""
        if len(src_lst) >= 2:
            src_translate = src_lst[1]
        src_dict[src_raw] = src_translate
    for to_line in iter(to_lines):
        to_line = to_line.strip()
        if to_line == "":
            continue
        to_lst = to_line.split(sep)
        to_lst = [text for text in to_lst if text != ""]
        to_raw = to_lst[0]
        to_translate = ""
        if len(to_lst) >= 2:
            to_translate = to_lst[1]
        to_dict[to_raw] = to_translate

    src_dict.update(to_dict)
    lines = []
    for k,v in src_dict.iteritems():
        if v == "":
            lines.append(k)
        else:
            lines.append("%s%s%s" % (k,sep,v))
    lines.sort()
    data = string.join(lines,"\n")
    to_fd = open(to_filename,"wb")
    to_fd.write(data)
    to_fd.close()

def main():
    usage = '''usage: python %prog [options]
    e.g: python %prog --source=mod.txt --to=mod/en_US/mod.txt"
    '''
    parser = optparse.OptionParser(usage=usage,version="%prog 0.0.1")
    parser.add_option("-f","--source",help=u"[required] 来源文件")
    parser.add_option("-t","--to",help=u"[required] 目标文件")
    options,args = parser.parse_args()
    required = ["source","to"]
    for r in required:
        if options.__dict__.get(r) is None:
            parser.error("option '%s' required" % r)
    source_filename = options.source
    to_filename = options.to
    merge(source_filename,to_filename)

if __name__ == "__main__":
    main()
