#!/usr/local/bin/red
Red [
]

#include %requestors.red

items: [
	"Red"
	"Red/System"
	"Rebol 3"
	"Rebol 2"
]
ret: osascript/request-list items print ret
