#!/bin/bash

	# Tempus Themes Generator --- Prints ports of the themes to stdout.
	# Upstream: https://gitlab.com/protesilaos/tempus-themes-generator

	# Copyright (c) 2019 Protesilaos Stavrou <info@protesilaos.com>

	# This program is free software: you can redistribute it and/or modify
	# it under the terms of the GNU General Public License as published by
	# the Free Software Foundation, either version 3 of the License, or
	# (at your option) any later version.

	# This program is distributed in the hope that it will be useful,
	# but WITHOUT ANY WARRANTY; without even the implied warranty of
	# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	# GNU General Public License for more details.

	# You should have received a copy of the GNU General Public License
	# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# THIS IS NOT BULLETPROFF, but it at least guarantees that this script
# is run from within a directory matching the string in the following
# condition.  We need this to point to the relative paths.
#
# For more on this problem, see: http://mywiki.wooledge.org/BashFAQ/028
[ "${PWD##*/}" == 'tempus-themes-generator' ] || { echo "ERROR.  This script must be run from the root of the 'tempus-themes-generator' directory." ; exit 1; }

# This script requires exactly two arguments.  The first is the name of
# the schemes, the second is the template.
[ ! "$#" -eq 2 ] && { echo "ERROR.  Must run with [scheme] [template] arguments."; exit 1; }

# Rename the arguments that are passed to this script, for the sake of
# readability.
_scheme="$1"
_template="$2"

# Define the array with all the available schemes
schemes=()
while IFS=  read -r -d $'\0' item; do
	schemes+=("${item##*/}")
done < <(find schemes -type f ! -name '*.swp' -print0)

# Same as above, but for templates
templates=()
while IFS=  read -r -d $'\0' item; do
	templates+=("${item##*/}")
done < <(find templates -type f -print0)

# Checks if the item $1 is part of the array $2
_item_in_array() {
	local item array
	item="$1"
	array="$2"

	for i in ${array[*]}; do
		if [ "$i" == "$item" ]; then
			return 0
		fi
	done
	return 1
}

# Check if the arguments we pass to this script are part of their
# respective array.
_item_in_array "$_scheme" "${schemes[*]}" || { echo "ERROR. «$_scheme» is not a valid scheme"; exit 1; }
_item_in_array "$_template" "${templates[*]}" || { echo "ERROR. «$_template» is not a valid template"; exit 1; }

# Check if the given scheme is a "light" or a "dark" theme, in order to
# load the appropriate preset.

light_themes=()
while read -r -d $'\n' item; do
	light_themes+=("${item##*/}")
done < <(find schemes -type f -exec grep -lw light {} \;)

if _item_in_array "$_scheme" "${light_themes[*]}"; then
	_preset='light_theme'
else
	_preset='dark_theme'
fi

source "schemes/$_scheme"
source "presets/base"
source "presets/$_preset"

# create a temporary file where the variables are expanded
tempfile="$(mktemp)"

(
	echo 'cat <<END_OF_TEXT'
	cat "templates/$_template" | grep -v 'vi: ft='
	echo 'END_OF_TEXT'
) > "$tempfile" && source "$tempfile" && rm -f "$tempfile"

