# coding:utf-8
import logging
import requests
import redis
import json
import os
import re
import pdb
import codecs
import time

from bs4 import BeautifulSoup



tag = u"热门  最新  经典  可播放  豆瓣高分  冷门佳片  华语  欧美  韩国  日本  动作 喜剧  爱情  科幻  悬疑  恐怖  文艺"
taglist = ",".join(tag.split()).split(",")

url = u"https://movie.douban.com/j/search_subjects?type=movie&tag={tag}&page_limit={page_limit}&page_start={page_start}"
sleep_tm = 60
timeout_tm = 5
cookie = {}
sub_url = u"https://movie.douban.com/subject/{}/"
fp = codecs.open("data.txt","a+",encoding = "utf-8")

class RedisManager():
    def __init__(self,host,port,prefix="douban_id"):
        try:
            self.conn = redis.StrictRedis(host=host, port=port, db=0)
            self.prefix = prefix
        except Exception as e:
            logging.exception(e)
            raise
    def get(self,id):
        try:
            return self.conn.get(self.prefix+id)
        except Exception as e:
            logging.exception(e)

    def delete(self,id):
        try:
            return self.conn.delete(self.prefix+id)
        except Exception as e:
            logging.exception(e)

    
    def set(self,id,value):
        try:
            if not self.get(self.prefix+id):
                return self.conn.set(self.prefix+id,value)
        except Exception as e:
            logging.exception(e)

rm = RedisManager("localhost",6379)
#rm.set("zhang","xaing")
#print rm.get("zhang")
#rm.delete("zhang")
#print rm.get("zhang")
#os._exit(-1)

def print_dict(parse_dict):
    for key in parse_dict:
        print u"{}:{}".format(key,parse_dict[key]).encode("utf-8")

def name_year(soup,parse_dict):
    content = soup.find(id="content")
    span = content.h1.find_all("span")
    parse_dict["name"] = span[0].string
    parse_dict["year"] = re.findall("(\d+)",span[1].string)[0]

def image_src(soup,parse_dict):
    content = soup.find(id="mainpic")
    parse_dict["image_url"] = content.a.img["src"]

def director(soup,parse_dict):
    content = soup.find_all("a",rel="v:directedBy")
    parse_dict["director"] = "|"
    for _content in content:
        parse_dict["director"] = parse_dict["director"] + _content.string + "|"

def scriptwriter(soup,parse_dict):
    content = soup.find("div",id="info").find_all("span")[3].find_all("a")
    #print "{}".format(soup.find("div",id="info").find_all("span")[3])
    parse_dict["scriptwriter"] = "|"
    for _content in content:
        parse_dict["scriptwriter"] = parse_dict["scriptwriter"] + _content.string + "|"

def actor(soup,parse_dict):
    content = soup.find_all(rel="v:starring")
    parse_dict["actor"] = "|"
    for _content in content:
        parse_dict["actor"] = parse_dict["actor"] + _content.string + "|"

def movie_type(soup,parse_dict):
    content = soup.find_all(property="v:genre")
    parse_dict["type"] = "|"
    for _content in content:
        parse_dict["type"] = parse_dict["type"] + _content.string + "|"

def area(soup,parse_dict):
    content = soup.find_all("span",text = "制片国家/地区:")[0]
    #print soup.find_all("span",text = "制片国家/地区:")[0].next_sibling.string
    parse_dict["area"] = content.next_sibling.string.strip(" ")


def language(soup,parse_dict):
    content = soup.find_all("span",text = "语言:")[0]
    #print soup.find_all("span",text = "制片国家/地区:")[0].next_sibling.string
    parse_dict["language"] = content.next_sibling.string.strip(" ")

def show_date(soup,parse_dict):
    content = soup.find_all(property="v:initialReleaseDate")
    parse_dict["show_date"] = "|"
    for _content in content:
        parse_dict["show_date"] = parse_dict["show_date"] + _content.string + "|"

def duration(soup,parse_dict):
    content = soup.find(property="v:runtime")
    parse_dict["duration"] = re.findall("(\d+)",content.string)[0]

def alais(soup,parse_dict):
    #pdb.set_trace()
    try:
        content = soup.find_all("span",text="又名:")[0].next_sibling.string
    except Exception as e:
        logging.exception(e)
        content = None
        parse_dict["alias"] = None
        return
    #print soup.find_all("span",text="又名:")[0].next_sibling.encode("utf-8")
    lst = content.split("/")
    parse_dict["alias"] = "|"
    for _lst in lst:
        parse_dict["alias"] = parse_dict["alias"] + _lst.strip(" ") + "|"

def imdb(soup,parse_dict):
    try:
        content = soup.find_all("span",text = "IMDb链接:")[0].next_sibling.next_sibling
    except Exception as e:
        logging.exception(e)
        content = None
        parse_dict["imdb"] = None
        return
    parse_dict["imdb"] = content["href"]

for tag in taglist:
    #print tag
    page_limit = 100
    page_start = 0
    flag = False
    _retry = 30
    while _retry != 0:
        try:
            req = requests.get(url.format(tag=tag,page_limit=page_limit,page_start=page_start),cookies=cookie,timeout = timeout_tm)
            page_start = page_start + page_limit
            if req.status_code != 200:
                time.sleep(50)
                cookie = {}
                logging.error("error,get status:{}\tmessage:{}".format(req.status_code,req.content))
                _retry = _retry - 1
                continue
            #print req.headers["set_cookie"]
            lst = json.loads(req.content)["subjects"]
            #print u"{}".format(url.format(tag=tag,page_limit=page_limit,page_start=page_start)).encode("utf-8")
            for _lst in lst:
                retry = 3
                while retry !=0:
                    try:
                        if rm.get(_lst["id"]):
                            print "id:{} have in redis".format(_lst["id"])
                            break
                        print "{}".format(sub_url.format(_lst["id"]))
                        sub_req = requests.get(sub_url.format(_lst["id"]),timeout = timeout_tm,cookies=cookie)
                        if sub_req.status_code != 200:
                            print "error get id:{}".format(_lst["id"])
                        parse_dict = {}
                        content = sub_req.content
                        soup = BeautifulSoup(content,"html.parser")
                        # name year
                        name_year(soup,parse_dict)
                        image_src(soup,parse_dict)
                        director(soup,parse_dict)
                        scriptwriter(soup,parse_dict)
                        actor(soup,parse_dict)
                        movie_type(soup,parse_dict)
                        area(soup,parse_dict)
                        language(soup,parse_dict)
                        show_date(soup,parse_dict)
                        duration(soup,parse_dict)
                        alais(soup,parse_dict)
                        imdb(soup,parse_dict)
                        fp.write(json.dumps(parse_dict).encode("utf-8")+"\n")
                        fp.flush()
                        rm.set(_lst["id"],"1")
                        time.sleep(sleep_tm)
                        break
                    except Exception as e:
                        logging.exception(e)
                        retry = retry - 1
                        time.sleep(sleep_tm)
        except Exception as e:
            time.sleep(50)
            logging.exception(e)
            _retry = _retry - 1
    fp.close()
