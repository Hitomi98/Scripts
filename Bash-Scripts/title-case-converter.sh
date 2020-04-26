#!/bin/bash

# xsel must be installed for this script to work!
# sudo apt-get install xsel

# Step 1: Grab contents of clipboard
clip="$(xsel -ob)"

# Step 2: Convert contents to title case
TitleCaseConverter () {
    sed 's/.*/\L&/; s/[a-z]*/\u&/g' <<<"$1"    
}
clipPascal="$(TitleCaseConverter "$clip")"

# Step 3: Send contents to clipboard
echo "$clipPascal" | xsel -b
