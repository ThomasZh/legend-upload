#!/usr/bin/env python
# _*_ coding: utf-8_*_
#
# Copyright 2016 7x24hs.com
# thomas@7x24hs.com
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.


import tornado.web
import logging
import time
import sys
import os
import uuid
import smtplib
import hashlib
import json as JSON # 启用别名，不会跟方法里的局部变量混淆
from bson import json_util
import requests

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "../"))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "../dao"))

from tornado.escape import json_encode, json_decode
from tornado.httpclient import *
from tornado.httputil import url_concat
from bson import json_util
import qcloud_video

from comm import *
from global_const import *


# /api/upload/video
class UploadVideoXHR(tornado.web.RequestHandler):
    # 上传视频文件
    @tornado.web.asynchronous
    @tornado.gen.coroutine
    def post(self):
        logging.info(self.request)

        name = self.get_argument("files[].name","")
        logging.info("got name=[%r]", name)
        content_type = self.get_argument("files[].content_type","")
        logging.info("got content_type=[%r]", content_type)
        oldpath = self.get_argument("files[].path","")
        logging.info("got oldpath=[%r]", oldpath)
        size = self.get_argument("files[].size","")
        logging.info("got size=[%r]", size)
        md5 = self.get_argument("files[].md5","")
        logging.info("got md5=[%r]", md5)

        size = os.path.getsize(oldpath)
        logging.info("got size=[%r]", size)

        # upload to qcloud_video
        appid = "10070962"
        secret_id = "AKIDk2B9NPwaSDpGVYr1VmlaElBRYXKvcYZO"
        secret_key = "lLj0iJiuuskQyQBqKeCbsxufEbnmbFhy"
        bucket_name = "legend"
        video = qcloud_video.Video(appid, secret_id, secret_key)
        upload_filename = generate_uuid_str()
        logging.info("got upload_filename %r", upload_filename)
        result = video.upload(oldpath, bucket_name, 'demo/'+upload_filename+'.mp4', 'http://video-cover.jpg', 'title', 'desc')
        logging.info("got result %r", result)

        files = []
        files.append({"name":name,"type":content_type,"size":size})
        ret = {"files":files}
        logging.info("got ret=[%r]", ret)

        self.write(tornado.escape.json_encode(ret))


# /api/upload/image
class UploadImageXHR(tornado.web.RequestHandler):
    # 上传图片文件
    @tornado.web.asynchronous
    @tornado.gen.coroutine
    def post(self):
        logging.info(self.request)

        access_token = self.get_access_token()
        my_account_id = self.get_account_id(access_token)
        # TODO 校验是否有权限
