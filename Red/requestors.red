Red [
]

;--based on Ashley Truter's rebol 2 code'
;--http://www.rebol.org/view-script.r?script=mac-requestors.r

comment [
	usage: 
	osascript/alert text [string!]
    	"Flashes an alert message to the user. Waits for a user response."
    
    osascript/say text [string!]
    	"Speaks text."
    	/using voice [string!]
    
    osascript/request text [string!]
		"Requests an answer to a simple question."
		/title title-text [string!]
		/buttons labels [block!]
		/default label [string!]
		/stop /note /caution
	
	osascript/request-color
		"Requests a color value."
		/default color [tuple!]
	
	osascript/request-dir
		"Requests a directory."
	
	osascript/request-file
		"Requests a directory."
	
	osascript/request-list items [block!]
		"Requests a selection from a list."
		/title title-text [string!]
		/prompt prompt-text [string!]
		/default val [any-type!]
	
	osascript/request-pass
		"Requests a password."
		/title title-text [string!]
		/prompt prompt-text [string!]
	
    osascript/request-text
		"Requests a text string be entered."
		/title title-text [string!]
		/prompt prompt-text [string!]
		/default string [string!]
]

;--This object can be extended
osascript: object [
	;--Single argument calls
	alert: func [
        "Flashes an alert message to the user. Waits for a user response."
        text [string!]
    ][
    	call rejoin [
            {osascript -e 'tell app "System Events" to activate & display alert }
            mold text
            {'}
        ] 
        true
    ]
    
    say: func [
        "Speaks text."
        text [string!]
        /using voice [string!]
    ] [
        call rejoin [
            {osascript -e 'say }
            mold text
            either using [rejoin [{ using } mold voice {'}]] [{'}]
        ]
        true
    ]
    
    ;--Helper functions'
    *script: func [
        cmd [string!]
        /local v 
    ] [
    	prog: {osascript -e 'tell app "System Events"' -e 'activate' -e '}
    	append prog (cmd)
    	append prog {' -e 'end'}
        ;call/output/error prog v: copy "" err: copy ""
        call/output prog v: copy ""
        trim/lines v
    ]
    
    *list: func [
        block [block!]
        /local v
    ] [
        v: copy "{"
        foreach item block [
            insert tail v mold item 
            insert tail v ","
        ]
        head change back tail v "}"
    ]
    
    ;--Tell calls
    request: func [
        "Requests an answer to a simple question."
        text [string!]
        /title title-text [string!]
        /buttons labels [block!]
        /default label [string!]
        /stop /note /caution
        /local v
    ] [
        v: rejoin [
            "display dialog " mold text
            "with title " mold any [title-text ""]
        ]
        all [buttons insert tail v rejoin " buttons " *list labels]
        all [default insert tail v rejoin " default button " mold label]
        case [
            stop    [insert tail v " with icon stop"]
            note    [insert tail v " with icon note"]
            caution [insert tail v " with icon caution"]
        ]
        either empty? v: *script v [none] [a: copy skip v 16]
    ]
    
    request-color: func [
        "Requests a color value."
        /default color [tuple!]
        /local v vv
    ] [
        v: copy "choose color"
        all [
            default
            insert tail v rejoin [
                " default color"
                *list reduce [256 * first color 256 * second color 256 * third color]
            ]
        ]
        v: split *script v ","
        foreach vv v [vv: trim/all vv]
        either empty? v [none] [
            to tuple! reduce [
                (to integer! first v) / 256
                (to integer! second v) / 256
                (to integer! third v) / 256
            ]
        ]
    ]
    
    request-dir: func [
        "Requests a directory."
        /local v
    ] [
        either empty? v: *script "choose folder" [none] [dirize to file! replace/all find next v ":" ":" "/"]
    ]
    
     request-file: function [
        "Requests a directory."
        /local v
    ] [
        either empty? v: *script "choose file" [none] [dirize to file! replace/all find next v ":" ":" "/"]
    ]
    
    request-list: function [
        "Requests a selection from a list."
        items [block!]
        /title title-text [string!]
        /prompt prompt-text [string!]
        /default val [any-type!]
        /local v
    ] [
        v: rejoin [
            "choose from list " *list items
            "with title" mold any [title-text ""]
            "with prompt" mold any [prompt-text "Please make your selection:"]
        ]
        all [default insert tail v rejoin " default items " *list to block! val]
        either "false" = v: *script v [none] [v]
    ]
    
    request-pass: function [
        "Requests a password."
        /title title-text [string!]
        /prompt prompt-text [string!]
        /local v
    ] [
        v: rejoin [
            "display dialog" mold any [prompt-text "Enter password:"]
            {hidden answer true default answer "" with title} mold any [title-text ""]
        ]
        either empty? v: *script v [none] [v]
    ]
    
    request-text: function [
        "Requests a text string be entered."
        /title title-text [string!]
        /prompt prompt-text [string!]
        /default string [string!]
        /local v
    ] [
        v: rejoin [
            "display dialog" mold any [prompt-text "Enter text below:"]
            "default answer" mold any [string ""]
            "with title" mold any [title-text ""]
        ]
        either empty? v: *script v [none] [v]
    ]
]



