#! /usr/local/bin/r3
REBOL [
]

do %requestors.r
ret: split osascript/request-text "," print second ret
ret: osascript/request/caution "Save this file?" print ret