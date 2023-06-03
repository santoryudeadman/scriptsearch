#!/bin/bash

# Script version
VERSION="1.0"

# Function to display script usage
show_help() {
    echo "Usage: search [options] <engine> [query]"
    echo "Searches the specified search engine with the provided query."
    echo
    echo "Options:"
    echo "  -h, --help     Show help"
    echo "  -v, --version  Show version"
    echo
    echo "Available search engines:"
    echo "  google   Search on google.com"
    echo "  phind    Search on phind.com"
    echo "  perplex  Search on perplexity.ai"
    echo "  poe      Launch poe.com/Sage"
    echo
    echo "Example usage:"
    echo "  search google programming languages"
    echo "  search phind bst vs hashmap"
    echo "  search perplex who is yannic kilcher"
    echo "  search poe"
}

# Function to display script version
show_version() {
    echo "Script Version: $VERSION"
}

# Function to perform the search on Google
search_google() {
    query="$*"
    encoded_query=$(echo "$query" | sed 's/ /%20/g')
    search_url="https://www.google.com/search?q=${encoded_query}"
    xdg-open "$search_url"
}

# Function to perform the search on phind.com
search_phind() {
    query="$*"
    encoded_query=$(echo "$query" | sed 's/ /%20/g')
    search_url="https://www.phind.com/search?q=${encoded_query}&source=searchbox"
    xdg-open "$search_url"
}

# Function to perform the search on perplexity.ai
search_perplex() {
    query="$*"
    encoded_query=$(echo "$query" | sed 's/ /%20/g')
    search_url="https://www.perplexity.ai/search?q=${encoded_query}"
    xdg-open "$search_url"
}

# Function to launch poe.com/Sage URL
launch_poe() {
    url="https://poe.com/Sage"
    xdg-open "$url"
}

# Function for autocompletion
_search_complete() {
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ "$prev" == "search" ]]; then
        COMPREPLY=($(compgen -W "google phind perplex poe" -- "$cur"))
        return 0
    fi

    if [[ "$cur" == -* ]] ; then
        COMPREPLY=($(compgen -W "google phind perplex poe -h --help -v --version" -- "$cur"))
    fi
}

# Register the completion function
complete -F _search_complete search

# Get the search engine and query from the command line arguments
engine="$1"
query="${@:2}"

# Check if help option is provided
if [ "$engine" = "-h" ] || [ "$engine" = "--help" ]; then
    show_help
    exit 0
fi

# Check if version option is provided
if [ "$engine" = "-v" ] || [ "$engine" = "--version" ]; then
    show_version
    exit 0
fi

# Check if search engine is provided
if [ -z "$engine" ]; then
    echo "Please provide a search engine (google, phind, perplex, or poe)."
    exit 1
fi

# Perform the search or launch based on the chosen search engine
case "$engine" in
    google)
        search_google "$query"
        ;;
    phind)
        search_phind "$query"
        ;;
    perplex)
        search_perplex "$query"
        ;;
    poe)
        launch_poe
        ;;
    *)
        echo "Invalid search engine. Please choose either google, phind, perplex, or poe."
        exit 1
        ;;
esac
