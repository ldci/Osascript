#! /usr/local/bin/red
Red [
]

#include %requestors.red
ret: split osascript/request-pass/title/prompt "Control" "Password" "," print [ret/1 ret/2]