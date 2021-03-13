declare-option -hidden line-specs bookmarks

declare-user-mode bookmarks

map global bookmarks b '<esc>: bookmarks-menu<ret>' -docstring "Jump to a bookmark"
map global bookmarks d '<esc>: bookmarks-delete<ret>' -docstring "Delete a bookmark"
map global bookmarks a '<esc>: bookmarks-add<ret>' -docstring "Bookmark current cursor position"

define-command bookmarks-enable %{
    map window user b '<esc>: enter-user-mode bookmarks<ret>' -docstring "Bookmarks mode"
} -docstring "Enables bookmarks user mode"

define-command bookmarks-disable %{
    unmap window user b '<esc>: enter-user-mode bookmarks<ret>'
} -docstring "Disables bookmarks user mode"

define-command bookmarks-add %{
    prompt "Bookmark name:" %{
        update-option window bookmarks
        set-option -add window bookmarks "%val{cursor_line}|%val{text}"       
    }
}

define-command bookmarks-menu %{
    bookmarks-menu-command bookmarks-jump-id
}

define-command bookmarks-delete %{
    bookmarks-menu-command bookmarks-delete-id
}

define-command -params 1 bookmarks-menu-command %{ evaluate-commands %sh{
    arg=$1
    eval set -- ${kak_quoted_opt_bookmarks}
    shift

    if [ $# -eq 0 ] ; then
    	printf "fail 'Bookmarks list is empty'\n"
    	exit
    fi


    # Start the menu
    printf 'menu '

    # Iterate over bookmarks
    i=1
    for bookmark; do
    	#printf 'echo -debug "bookmark %i: %s"\n' $i "$bookmark"
        name=$(printf "$bookmark" | cut -s -d '|' -f 2)

	# Print the menu entry
    	printf "'%s' '%s %i' " "$name" "$arg" $i

    	i=$((i+1))
    done
}}

define-command -params 1 bookmarks-jump-id %{
    update-option window bookmarks
    evaluate-commands %sh{
    arg=$1
    eval set -- ${kak_quoted_opt_bookmarks}
    shift $arg
    line=$(printf "$1" | cut -s -d '|' -f 1)
    name=$(printf "$1" | cut -s -d '|' -f 2)
    if [ -z "$line" -o -z "$name"]; then
    	printf 'fail "Invalid bookmark number: %s"\n' "$arg"
    else
        printf "execute-keys '%ig'\n" "$line"
        printf "echo 'bookmark arg $arg line $line name $name'\n"
        printf "info 'Went to bookmark \"$name\"'"
    fi
}}

define-command -params 1 bookmarks-delete-id %{
    update-option window bookmarks
    evaluate-commands %sh{
        arg="$1"
        eval set -- ${kak_quoted_opt_bookmarks}
        shift
        printf 'set-option window bookmarks %%val{timestamp}'
        i=1
        for bookmark; do
            if [ $i -ne "$arg" ] ; then
            	printf " '%s'" "$bookmark"
            fi
    	    i=$((i+1))
    	done
    }
}

