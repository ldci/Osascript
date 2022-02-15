#! /usr/local/bin/r3
REBOL [
]

do %requestors.r
items: [
	"Red"
	"Red/System"
	"Rebol 3"
	"Rebol 2"
]

ret: osascript/request-list/title items "Your favored language"print ret
