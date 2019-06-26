#coding: utf-8
import sys
import io
import optparse
import os
import os.path
import re
import string
import json
import codecs

def merge(source_filename,to_filename):
    encoding = "utf-8"
    src_lines = {}
    if os.path.getsize(source_filename) > 0:
        src_fd = codecs.open(source_filename,"rb",encoding)
        src_lines = json.load(src_fd,encoding=encoding)
        src_fd.close()
    basedir = os.path.dirname(to_filename)
    # new file if not exist
    if not os.path.exists(basedir):
        os.makedirs(basedir)
    if not os.path.isfile(to_filename):
        fd = codecs.open(to_filename,"wb",encoding)
        fd.close()
    to_lines = {}
    if os.path.getsize(to_filename):
        to_fd = codecs.open(to_filename,"rb",encoding)
        to_lines = json.load(to_fd,encoding=encoding)
        to_fd.close()
    for k,v in src_lines.iteritems():
        if v != "":
            to_lines[k] = v
    data = json.dumps(to_lines,indent=4,sort_keys=True,ensure_ascii=False,encoding=encoding) 
    to_fd = codecs.open(to_filename,"wb",encoding)
    to_fd.write(data)
    to_fd.close()

def main():
    usage = '''usage: python %prog [options]
    e.g: python %prog --source=languages/en_US_1.json --to=languages/en_US.json"
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
