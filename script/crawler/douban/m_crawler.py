# coding:utf-8
import logging
import requests
import json
import redis
import bs 

tag = u"热门  最新  经典  可播放  豆瓣高分  冷门佳片  华语  欧美  韩国  日本  动作 喜剧  爱情  科幻  悬疑  恐怖  文艺"
taglist = ",".join(tag.split()).split(",")

url = u"https://movie.douban.com/j/search_subjects?type=movie&tag={tag}&page_limit={page_limit}&page_start={page_start}"
sleep_tm = 5
cookie = {}



print taglist

for tag in taglist:
	print tag
	page_limit = 100
	page_start = 0
	flag = False
	try:
		while not flag:
			req = requests.get(url.format(tag=tag,page_limit=page_limit,page_start=page_start),cookies=cookie)
			if req.status_code != 200:
				sleep(50)
				cookie = {}
				logging.info("error,get status:{}\tmessage:{}".format(req.status_code,r.content))
				continue
			print req.headers
			lst = json.loads(req.content)["subjects"]
			for _lst in lst:
				print _lst["id"]

			break
		break
	except Exception as e:
		logging.exception(e)

