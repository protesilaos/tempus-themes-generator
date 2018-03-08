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

# GLOBAL VARIABLES
# ============================== 

# define path to the generator repo
# git clone --depth 1 https://github.com/protesilaos/tempus-themes-generator ~/tempus-themes-generator
tempus_themes_generator_dir="$HOME/tempus-themes-generator"

# define array with schemes
tempus_themes_schemes=($(ls -m $tempus_themes_generator_dir/schemes/ | sed -e 's/,//g'))

# define array with templates
tempus_themes_templates=($(ls -m $tempus_themes_generator_dir/templates/ | sed -e 's/,//g'))

# rename the cli arguments, for readability
# (since functions also have their own $1 parameters)
generator_cli_scheme=$1
generator_cli_template=$2

# FUNCTIONS
# ============================== 

tempus_generator_no_argument ()
{
    echo -e "
    \e[1mUsage:\e[0m
        $ \e[1m\e[34m./tempus-themes-generator.sh [scheme] [template]\e[0m

    \e[1mCommands:\e[0m
        \e[1m\e[35mls schemes\e[0m\e[0m
        Prints a list with the available scheme names. Each name can be used as the first argument of the generator script. 

        \e[1m\e[35mls templates\e[0m\e[0m
        Prints a list with the available template names. A template name must be the second argument to running the generator script.

    \e[1mExamples:\e[0m
        \e[3m(must first be in the tempus-themes-generator directory)\e[0m
        \e[1m\e[34mcd tempus-themes-generator\e[0m

        # Shows a quick preview of the Tempus Winter colour palette
        $ \e[1m\e[34m./tempus-themes-generator.sh winter\e[0m

        # Prints Tempus Winter for Vim to the terminals stdout (standard output)
        $ \e[1m\e[34m./tempus-themes-generator.sh winter vim\e[0m

        # Prints all available schemes
        $ \e[1m\e[34mls schemes\e[0m

        # Prints all available templates
        $ \e[1m\e[34mls templates\e[0m
"
}

# extract the hex colour value from a single definition
# eg: col0=202427 ==> 202427
# accepts a single parameter, so it can be invoked from another function
# the param is used to extract the hex value of each definition on demand
# in practice this is done through loops in subsequent functions
tempus_scheme_get_hex ()
{
    local hex_palette=$(cat "$tempus_themes_generator_dir/schemes/$generator_cli_scheme" | grep -o '^col[0-9]*=[0-9a-zA-Z]*')

    # XXX HELP can this be done better? i.e. not loop and break loop?
    for i in $hex_palette; do
        echo "$hex_palette" | grep "$1=" | sed -e 's/col[0-9]*=//g'
        break
    done
}

# reformat the hex value into its r/g/b components
# this is not a conversion into decimal format (which is for rgb values)
# just add a slash in between the hex colour value's three components
# for example 202427 ==> 20/24/27
# accepts a single parameter, so it can be invoked from another function
tempus_scheme_get_hex_as_rgb ()
{
    local hex_value=$(tempus_scheme_get_hex col${1})

    # XXX HELP can this be done better? i.e. not loop and break loop?
    for i in {0..15}; do
        printf "%b/%b/%b" ${hex_value:0:2} ${hex_value:2:2} ${hex_value:4:2}
        break
    done
}

# use ansi sequences to print a preview with the tempus scheme's palette
# works if the generator script is run only with a scheme argument
# the idea is to provide an idea of what the scheme is like
# the preview is possible by changing the values of cols17-32
# these are available in all terminals with 256 colour support
# this range is selected because it is not normally used in a command prompt
# the idea is not to mess up with the user's running terminal colours
# ultimately though, the colours are set to reset with a timer
tempus_scheme_print_ansi ()
{
    # The following comment presents a sample format
    # printf '\e]4;17;rgb:ff/ff/00\a\e[38;5;17mThis is yellow\e[m\n'

    # break the command into more readable parts
    # NOTE further concat the `sequences` variable in the following loop?
    local concat1='\e]4;'
    local concat2='\a\e[38;5;'
    local concat3='m▉▉▉▉▉▉▉▉▉▉▉▉'
    local concat4='\e[m\n'

    # define this to be incremented in the following loop into values 0-15
    local a=-1

    # define empty string, to be incremented in the following loop
    local sequences=""

    # loop terminal colours 17-32
    # meanwhile $a is incremented from 0-15
    # we want to map the scheme cols 0-15 to termcols 17-32
    for i in {17..32}; do
        ((a++))
        sequences+="${concat1}${i};rgb:$(tempus_scheme_get_hex_as_rgb ${a})${concat2}${i}${concat3} col${a}${concat4}"
    done

    printf "$sequences"

    # reset the preview colours to the running terminal's defaults
    # XXX HELP for usability, a better `sleep` value to reset colours?
    bash -c "sleep 60; printf '\e]104\a'" &
}

# convert the palette's hex values into rgb
# hex is, of course, hexadecimal, while rgb is decimal
# a hex colour is a composite of red-green-blue written in hexadecimal notation
# e.g. #ff0000 is pure red, because it has 16*16 red and 0 of green and blue
# this function takes each r-g-b component and reformats it into decimal notation
# so #ff0000 becomes 255/0/0
# ff = 16 * 16 = 255 (256 - 1 because decimal is zero-based)
# accepts a single parameter, so it can be invoked from another function
tempus_scheme_hex_rgb_conversion ()
{
    # a shortcut for running the function for hex value extraction
    local hex_value=$(tempus_scheme_get_hex col${1})

    # XXX HELP is there a better way that looping and breaking the loop?
    # extract hex for cols0-15 and reformat it into rgb decimal notation
    for i in {0..15}; do
        printf "%d/%d/%d" 0x${hex_value:0:2} 0x${hex_value:2:2} 0x${hex_value:4:2}
        break
    done
}

# extract the rgb value itself
# accepts a single parameter, so it can be invoked from another function
tempus_scheme_get_rgb_value ()
{
    tempus_scheme_get_rgb_palette | grep -e "col${1:0:1} =" | sed -e 's/col[0-9]* == //g'
}

# have a table with the colour palette
# rows for colours
# columns showing termcol index, hex value, rgb value
# calculate rgb values for all colours of a scheme
# this is needed because the schemes do not have rgb values hardcoded
# XXX HELP should something like this or `tempus_scheme_hex_rgb_conversion` be used in the schemes directly?
# XXX HELP or does that make it more difficult to work with?
tempus_scheme_print_col_table ()
{
    # define an empty array to be incremented
    local rgb_palette=""

    # convert each hex into rgb
    for i in {0..15}; do
        rgb_palette+="$(tempus_scheme_hex_rgb_conversion ${i})\n"
    done

    # grab that loop's result
    local rgb_palette_clean=$(echo -e "$rgb_palette")

    # prepare an index for incrementation 0-15
    a=-1

    # the following is the table's header
    echo "TERMCOL == HEX VALUE == RGB VALUE"

    # print each rgb, together with its corresponding col[n] and hex value
    for i in $rgb_palette_clean; do
        ((a++))
        echo "col$a === $(tempus_scheme_get_hex col${a}) === $i"
    done
}

# group the major functions for previewing a scheme's colour palette
tempus_scheme_print_col_specs ()
{
    tempus_scheme_print_ansi
    tempus_scheme_print_col_table
}

# the actual processing of a scheme through a defined template
# TODO write some more here of what is going on
tempus_parse_template ()
{
    # TODO check if scheme exists
    # TODO check if template exists
    # TODO review if paths to cli args are already simpler (see intro vars)

    # include scheme specs
    set -a
    . $tempus_themes_generator_dir/schemes/$generator_cli_scheme 
    set +a

	template_path=$tempus_themes_generator_dir/templates/$generator_cli_template

    # create a temporary file where the variables are expanded
    tempfile=`mktemp`

    (
        echo 'cat <<END_OF_TEXT'
        cat "$template_path" | grep -v 'vi: ft='
        echo 'END_OF_TEXT'
    ) > $tempfile
    . $tempfile

    rm -f $tempfile # Clean up the temporary file
}

# CONDITIONAL BEHAVIOUR
# ============================== 

# run functions depending on the number of arguments
# 0 = help; 1 = preview; 2 = parse template and print to stdout
if [[ -z $1 ]]; then
    # output help message
    tempus_generator_no_argument
    # TODO improve logic for matching argument to array
elif [[ $# -eq 1 ]]; then
    if [[ " ${tempus_themes_schemes[*]} " == *"$generator_cli_scheme"* ]]; then
        tempus_scheme_print_col_specs
    else
        echo "ERROR: $generator_cli_scheme is not a scheme"
    fi
elif [[ $# -eq 2 ]]; then
    tempus_parse_template $1 $2
else
    echo '
    ERROR: too many arguments.
    Execute the script without any arguments to get usage instructions.'
    # TODO what is the right exit status?
    # TODO check this throughout the script.
    exit 1
fi
