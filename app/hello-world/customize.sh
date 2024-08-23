#!/bin/bash

# Use this to easily modify the source to use different version and css colors
# Run like this:
#./customize.sh v1.0.0 red blue

# sed = Stream Editor
sed -i '/^const semver =/c\const semver = "'$1'";' src/index.js
sed -i '/^const style =/c\const style = "body {color: '$2'; background-color: '$3';}";
' src/index.js