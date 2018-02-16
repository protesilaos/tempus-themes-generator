#!/bin/bash

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

# The `tempus-themes-generator` reads a data file with the colour values, parses it through a defined template to output a theme, which can be applied to the relevant program.

# Git repo <https://github.com/protesilaos/tempus-themes-generator>
# By Protesilaos Stavrou <https://protesilaos.com>

# require exactly two command line arguments
if [ "$#" -ne 2 ]
then
    echo -e "ERROR Exactly 2 arguments expected"
    echo "Exiting..."
    echo -e "SOLUTION execute the script with ./tempus-themes-generator.sh [scheme] [template]"
    echo -e "Type \`ls schemes\` and \`ls templates\` for the available options"
    echo -e "EXAMPLE ./tempus-themes-generator.sh summer vim"
    exit 1
fi

# set parent directory
parent_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_dir"

# accept shell arguments (1) scheme, (2) template
# example:`summer vim`
scheme="$1"  
template="$2"

# define array with colour schemes
array=$(ls $parent_dir/schemes/)

# argument `scheme` should match item in array
# note this works only with single words
# technically not a problem since all scheme names are single words
match=$(echo "${array[@]:0}" | grep -o ${scheme})  

# include scheme specs
set -a
. $parent_dir/schemes/${scheme}
set +a

# Parse template
template_path=$parent_dir/templates/$template

tempfile=`mktemp` # Let the shell create a temporary file
trap 'rm -f $tempfile' 0 1 2 3 15 # Clean up the temporary file

(
  echo 'cat <<END_OF_TEXT'
  cat "$template_path" | grep -v 'vi: ft='
  echo 'END_OF_TEXT'
) > $tempfile
. $tempfile
