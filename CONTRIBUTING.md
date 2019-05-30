# Contributing to the Tempus themes project

Thank you for your willingness to help! 

## Tempus project overview

First of all, an overview of this project's design to help you
understand the workflow (and where you could do your part):

1. The `tempus-themes-generator` repo is the tool that is used to build
   the Tempus themes.  All contributions to the underlying code should
   be made here (more in the following sections).
2. The [Tempus Themes](https://gitlab.com/protesilaos/tempus-themes) is
   the main user-facing repository.  It contains all the files
   pertaining to the Tempus themes, as well as general information on
   the project as a whole.
3. For each of the available templates there is a dedicated repository
   on GitLab (exceptions are generic data files, such as YAML ports).
   Their naming convention follows this pattern: `tempus-themes-[NAME OF
   TEMPLATE]`. For example, `tempus-themes-xfce4-terminal` contains
   files specific to the `xfce4-terminal`. Where appropriate, these
   repositories also function as the source code for GNU/Linux distro
   packages.

## How the generator is designed

The `schemes` directory contains the data of each colour scheme, such as
its name, description, palette, foreground and background values, etc.

The `presets` are complementary to the scheme files.  They parse the
base colours to produce more variants of them, such as converting
hexadecimal colour notation to decimal.  These new variables are then
used in the appropriate templates.

The `templates` directory contains the files that parse the data.  Each
template file is named after the program it is intended to work with.
For example, the `templates/vim` corresponds to a theme for Vim.

The *generator* itself is a shell script written in Bash. It is meant to
be run with two arguments, the first being the scheme name and the
second the template name. Example using the `schemes/winter` and
`templates/urxvt`:

	./tempus-themes-generator.sh winter urxvt

## What contributions to make

Background knowledge: 

* The scheme files should always include all the data needed to build
  a theme. If new variables must be declared in a template, they should
  be defined in the schemes.
* The colour values should always meet the colour contrast ratio that
  each Tempus item strives for. For most cases, that means 4.50:1
  *between foreground and background values* (WCAG AA rating). For
  example, Tempus Totus has a contrast ratio of >= 7.00:1 (WCAG AAA
  rating). It should never fall below that.

Rules for deriving the palette:

* Dark themes use colours 0 and 8 as base backgrounds.  Colour 0 is the
  main background, while 8 is its alternative (used in special
  circumstances).  Colours 0 and 8 correspond to the "black" and "bright
  black" variants respectively.  The base foregrounds for dark themes
  are colours 15 and 7 ("bright white" and "white"), with the former
  being the main foreground while the latter is its alternative (again,
  used in specific circumstances).
* Light themes are the inverse of the dark ones: bgs are 15 (main) and
  7 (alt), fgs are 0 (main) and 8 (alt).
* All remaining colours are called "accent values".  These are
  subdivided in two groups.  Colours 2-6 are the main accents while 8-14
  are their bright equivalents.
* Any accent value can be used as a background, such as colour 1 (red)
  for highlighting error codes, *provided that its foreground colour
  value is either of the base background values* (col0 or col8 for dark
  themes, col7 or col15 for light themes).  This means, for instance,
  that the colour 15 (bright white) of a dark theme **should not be used
  as a background colour for any other value other than colours 0 and
  8.** Otherwise the contrast ratio would fall below its intended
  target.

### Improving the schemes

* The palettes consist of 16 colours.  For most cases this is enough.
  There are however some programs where a wider palette would be more
  appropriate.
* Other ideas are welcome!

### Improving the templates

* Suggest fixes for existing themes.
* Submit new templates.
