#! /usr/local/bin/r3
REBOL [
]

do %requestors.r
ret: split osascript/request-pass/title/prompt "Control" "Password" "," print [ret/1 ret/2]