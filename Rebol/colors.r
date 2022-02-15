#! /usr/local/bin/r3
REBOL [
]

do %requestors.r
ret: osascript/request-color/default blue print ret
