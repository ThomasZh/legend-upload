# _*_ coding: utf-8_*_
#
# genral application route config:
# simplify the router config by dinamic load class
# by lwz7512
# @2016/05/17

import tornado.web

from foo import comm
from foo.api import api_upload
from foo.demo import demo


def map():

    config = [

        ('/upload/video', getattr(api_upload, 'UploadVideoXHR')),
        ('/upload/image', getattr(api_upload, 'UploadImageXHR')),

        ('/demo/upload/index', getattr(demo, 'DemoUploadIndexXHR')),

    ]

    return config
