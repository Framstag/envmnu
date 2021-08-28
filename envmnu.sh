envmenu_main() {
    drawMenu() {
        local CONFIGPATH="$1"
        local idx=1
        for entry in $CONFIGPATH/*.mnu; do
            local NAME=$(basename -s .mnu "$entry")
            NAME=${NAME:4}
            echo "$idx) $NAME"

            idx=$((idx+1))
        done

        echo "$idx) CANCEL"
    } 

    getMenuCommand() {
        local CONFIGPATH="$1"
        local idx=1
        for entry in $CONFIGPATH/*.mnu; do
            if [ "$idx" = "$INPUT" ]; then
                ENVMNU_NEW_CHOICE="$entry"
                break;
            fi

            idx=$((idx+1))
        done
    }

    unsetLastMenuEntry() {
        if [ -n "$ENVMNU_LAST_CHOICE" ]; then
            local NAME=$(basename -s .mnu "$ENVMNU_LAST_CHOICE")
            NAME=${NAME:4}
            local COMMAND="$(dirname "$ENVMNU_LAST_CHOICE")/$NAME.stop"

            echo "* Disabling '$NAME'..."
            if [ -f "$COMMAND" ]; then
                echo "  * Executing '$COMMAND'..."
                . "$COMMAND"
                echo "  * done."
            fi

            unset ENVMNU_LAST_CHOICE
        fi
    }

    setNewMenuEntry() {
        local NAME=$(basename -s .mnu "$ENVMNU_NEW_CHOICE")
        NAME=${NAME:4}
        local COMMAND="$(dirname "$ENVMNU_NEW_CHOICE")/$NAME.start"

        echo "* Enabling '$NAME'..."
        if [ -f "$COMMAND" ]; then
            echo "  * Executing '$COMMAND'..."
            . "$COMMAND"
            echo "  * done."
        fi

        export ENVMNU_LAST_CHOICE="$ENVMNU_NEW_CHOICE"
        unset ENVMNU_NEW_CHOICE
    }

    logScript() {
        echo "    * $1"
    }

    removeFromPath() {
        local pathToRemove=":$1:"
        local before="$PATH"
        
        for (( ; ; )); do
            local newPath=":$before:"
            newPath="${newPath//$pathToRemove/:}"
            newPath="${newPath/#:/}"
            newPath="${newPath/%:/}"

            if [ "$before" = "$newPath" ]; then
            export PATH="$newPath"
            return
            fi  

            before="$newPath"
        done
    }

    local CONFIGPATH="$1"
    drawMenu "$CONFIGPATH"

    echo -n "Your choice: "
    read INPUT

    getMenuCommand "$CONFIGPATH"

    if [ -n "$ENVMNU_NEW_CHOICE" ]; then
        unsetLastMenuEntry
        setNewMenuEntry
    else 
        echo "No change."    
    fi

    unset drawMenu
    unset getMenuCommand
    unset unsetLastMenuEntry
    unset setNewMenuEntry
    unset logScript
    unset removeFromPath
}

if [ $# -ne 1 ]; then
    echo "envmenu <configuration path>"
    return
fi

envmenu_main "$1"

unset envmenu_main
