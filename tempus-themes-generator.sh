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

# Tempus Themes Generator
# https://github.com/protesilaos/tempus-themes-generator

# Parses a data file through a defined template to output a Tempus Theme.
# Results are printed to stdout (standard terminal output).
# This makes it easy to use UNIX tools to create themes for the available programs.

# Example printing to stdout the `winter` scheme with the `vim` template
# ./tempus-themes-generator.sh winter vim

# Example similar to the above, using `>` redirection to create a new file with the generator's output
# ./tempus-themes-generator.sh winter vim > ~/tempus_winter.vim

# For instructions and the appropriate file name extensions --> README
# https://github.com/protesilaos/tempus-themes-generator/blob/master/README.md

# Tempus is a collection of themes for terminals and text editors.
# All themes comply, at minimum, with the WCAG AA accessibility standard for colour contrast.
# This practically means they are optimised for readability.
# No near-indecipherable colours. No interruptions in the 'rhythm' between contrast ratios.

# For more about the Tempus themes project, see https://protesilaos.com/tempus-themes

# GLOBAL VARIABLES
# ============================== 

# define path to the generator repo
# git clone --depth 1 https://github.com/protesilaos/tempus-themes-generator ~/tempus-themes-generator
tempus_themes_generator_dir="$HOME/tempus-themes-generator"

# define array with schemes
tempus_themes_schemes=$(printf "%s " $(ls $tempus_themes_generator_dir/schemes/ | sed -e 's/\([a-z]*\)/\1/g' ))

# define array with templates
tempus_themes_templates=$(printf "%s " $(ls $tempus_themes_generator_dir/templates/ | sed -e 's/\([a-z0-9-]*\)/\1/g'))


# rename the cli arguments, for readability
# (since functions also have their own $1 parameters)
generator_cli_scheme=$1
generator_cli_template=$2

# FUNCTIONS
# ============================== 

# print a help message if no argument is passed
tempus_generator_no_argument ()
{
    echo -e "
    \e[1mUsage:\e[0m
        $ \e[1;32m./tempus-themes-generator.sh [scheme] [template]\e[0m

    \e[1mCommands:\e[0m
        \e[1;33mls schemes\e[0m
        Prints a list with the available scheme names. Each name can be used as the \e[1;3;36mfirst argument\e[0m for executing the generator script.

        \e[1;33mls templates\e[0m\e[0m
        Prints a list with the available template names. A template name must be the \e[1;3;36msecond argument\e[0m for executing the generator script.

    \e[1mExamples:\e[0m
        # Must first be in the tempus-themes-generator directory
        \e[1;32mcd ~/tempus-themes-generator\e[0m

        # Shows a quick preview of the Tempus Winter colour palette
        $ \e[1;32m./tempus-themes-generator.sh winter\e[0m

        # Prints Tempus Winter for Vim to stdout (terminal standard output)
        $ \e[1;32m./tempus-themes-generator.sh winter vim\e[0m

        # Prints all available schemes
        $ \e[1;32mls schemes\e[0m

        # Prints all available templates
        $ \e[1;32mls templates\e[0m

\e[3m# For detailed instructions, refer to the README\e[0m
\e[3m# https://github.com/protesilaos/tempus-themes-generator/blob/master/README.md\e[0m
"
}

# extract the hex colour value from a definition
# eg: col0=202427 ==> 202427
# accepts a single parameter, so it can be invoked from another function
tempus_scheme_get_hex ()
{
    local hex_palette=$(cat "$tempus_themes_generator_dir/schemes/$generator_cli_scheme" | grep -o '^col[0-9]*=[0-9a-zA-Z]*')

    # XXX HELP can this be done better? i.e. not loop and break loop?
    for i in $hex_palette; do
        echo "$hex_palette" | grep "$1=" | sed -e 's/col[0-9]*=//g'
        break
    done
}

# reformat the hex value into its r/g/b channels
# this is not a conversion into decimal format (which is needed for rgb values)
# just adds a slash in between the hex colour value's three components
# for example 202427 ==> 20/24/27
# accepts a single parameter, so it can be invoked from another function
tempus_scheme_get_hex_as_rgb ()
{
    local hex_value=$(tempus_scheme_get_hex col${1})

    # XXX HELP can this be done better? i.e. not loop and break loop?
    # see ANNEX at the end of file on substring extraction
    for i in {0..15}; do
        printf "%b/%b/%b" ${hex_value:0:2} ${hex_value:2:2} ${hex_value:4:2}
        break
    done
}

# use ansi sequences to print a preview with the tempus scheme's palette
# works if the generator script is run only with a scheme argument
# the goal is to offer an idea of what the scheme is like
# the preview is possible by changing the values of col17..32
# these are available in all terminals with 256 colour support
# this range is selected because it is not normally used in a command prompt
# the point is not to mess up with the user's running terminal colours
# ultimately though, the colours are meant to reset with a timer
tempus_scheme_print_ansi ()
{
    # # The following comment presents a sample format
    # # printf '\e]4;17;rgb:ff/ff/00\a\e[38;5;17mThis is yellow\e[m\n'

    # break the command into more readable parts
    # NOTE further concat the `sequences` variable in the following loop?
    local concat1='\e]4;'
    local concat2='\a\e[38;5;'
    local concat3='m▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉'
    local concat4='\e[m\n'

    # define this to be incremented in the following loop into values 0..15
    # we need this to pass the right numbers to col{n}
    # since the i in the following loop runs from 17..32
    local a=-1

    # define empty string, to be incremented in the following loop
    local sequences=""

    # loop terminal colours 17..32
    # meanwhile $a is incremented from 0..15
    # we want to map the scheme cols 0..15 to termcols 17..32
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
# a hex colour is a concatenation of pairs of red-green-blue written in hexadecimal notation
# this function takes each r-g-b channel and reformats it into decimal notation
# accepts a single parameter, so it can be invoked from another function
# see ANNEX at the end of this file on more about hexadecimal to decimal
tempus_scheme_hex_rgb_conversion ()
{
    # a shortcut for running the function for hex value extraction
    local hex_value=$(tempus_scheme_get_hex col${1})

    # XXX HELP is there a better way than initiating and breaking the loop?
    # extract hex for col 0..15 and reformat it into rgb decimal notation
    # see ANNEX at the end of file on substring extraction
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

    # prepare an index for incrementation 0..15
    a=-1

    # the following is the table's header
    echo "TERMCOL == HEX VALUE == RGB VALUE"

    # print each rgb, together with its corresponding col{n} and hex value
    for i in $rgb_palette_clean; do
        ((a++))
        echo "col$a === $(tempus_scheme_get_hex col${a}) === $i"
    done
}

# group the functions for previewing a scheme's colour palette
tempus_scheme_print_col_specs ()
{
    tempus_scheme_print_ansi
    tempus_scheme_print_col_table
}

# check if an item is in the defined array
# used to check if cli arguments match schemes/templates
item_in_array ()
{
    local array=$2

    for i in ${array[*]}
    do
        if [[ "$i" == "$1" ]]; then
            return 0
        fi
    done
    return 1
}

# the actual processing of a scheme through a defined template
# XXX HELP is there a better way to parse a set of variables through a template?
# XXX NOTE the variables are not expanded in the template file itself, but in a tempfile
tempus_parse_template ()
{
    # check if scheme exists
    if item_in_array "$generator_cli_scheme" "${tempus_themes_schemes[*]}"; then
        # include scheme specs
        set -a
        . $tempus_themes_generator_dir/schemes/$generator_cli_scheme 
        set +a
    else
        # XXX HELP are these needed here?
        # the same check already happens in the conditional behaviour
        echo "ERROR: $generator_cli_scheme is not a scheme"
        echo "Run this script without arguments to get instructions"
        exit 1
    fi

    if item_in_array "$generator_cli_template" "${tempus_themes_templates[*]}"; then
        # specify path to template
        local template_path=$tempus_themes_generator_dir/templates/$generator_cli_template

        # create a temporary file where the variables are expanded
        tempfile=`mktemp`

        (
            echo 'cat <<END_OF_TEXT'
            cat "$template_path" | grep -v 'vi: ft='
            echo 'END_OF_TEXT'
        ) > $tempfile
        . $tempfile

        rm -f $tempfile # Clean up the temporary file
    else
        echo "ERROR: $generator_cli_template is not a template"
        echo "Run this script without arguments to get instructions"
        exit 1
    fi
}

# CONDITIONAL BEHAVIOUR
# ============================== 

# run functions depending on the number of arguments
# 0 = help; 1 = preview; 2 = parse template and print to stdout
if [[ -z $1 ]]; then
    # output help message
    tempus_generator_no_argument
elif [[ $# -eq 1 ]]; then
    if item_in_array "$generator_cli_scheme" "${tempus_themes_schemes[*]}"; then
        echo "Here are the colour specs for $generator_cli_scheme"
        echo "NOTE the colour preview will expire in about a minute"
        echo -e "For context, see this script's source code\n"
        tempus_scheme_print_col_specs
    else
        exit 1
    fi
elif [[ $# -eq 2 ]]; then
    tempus_parse_template $1 $2
else
    echo -e "ERROR: too many arguments.\nExecute the script without any arguments to get usage instructions."
    exit 1
fi


# ANNEX
# ============================

# hexadecimal to decimal
# ----------------------------
# formula
# X*16^Y where X is the number to convert and Y is its position from right to left (zero-based)
# X*(16^0) + X*(16^1) + X*(16^2) ...

# remember hex letters
# A = 10, B = 11, C = 12, D = 13, E = 14, F = 15

# when converting a hex colour value that consists of 6 digits, we first break it up into three
# 202427 ==> 20 24 27
# that is because we are not operating on the whole value, but on its red-green-blue components
# the first two reference the red channel, second pair is for the green, and third for the blue

# examples using 202427 hex colour

# BAD counting the whole 202427 from its right to left
# 7*(16^0) + 2*(16^1) + 4*(16^2) + 2*(16^3) + 0*(16^4) + 2*(16^5) = 2106407

# GOOD counting each of 202427 (20 24 27) three channels from its right to left 
# {0*(16^0) + 2*(16^1)} {4*(16^0) + 2*(16^1)} {7*(16^0) + 2*(16^1)} = 32 36 39

# substring extraction
# ----------------------------
# the syntax ${X:Y:Z} is ${VARIABLE:INDEX:LENGTH}
# e.g. 202427 = x, x:0:2 = 20, x0:2:2 = 24, x:4:2 = 27
