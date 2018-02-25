# Contributing to the Tempus themes project

*tl;dr: see [What contributions to make](#what-contributions-to-make)*

Thank you for your willingness to help! 

## Tempus project overview

First of all, an overview of this project's design to help you understand the workflow (and where you could do your part):

1. The `tempus-themes-generator` ([this repo](https://github.com/protesilaos/tempus-themes-generator)) is the tool that is used to build the Tempus themes. All contributions to the underlying code should be made here (more in the following sections).
2. The [Tempus Themes](https://github.com/protesilaos/tempus-themes) is the main end-user-facing repository. It contains all the files pertaining to the Tempus themes, as well as general information on the project as a whole.
3. For each of the available templates there is a dedicated repository on GitHub (exceptions are generic data files, such as YAML ports). Their naming convention follows this pattern: `tempus-themes-[NAME OF TEMPLATE]`. For example, `tempus-themes-xfce4-terminal` contains files specific to the `xfce4-terminal`. Where appropriate, these repositories also function as the source code for GNU/Linux distro packages. As an Arch Linux user myself, I [currently maintain](https://aur.archlinux.org/packages/?SeB=m&K=protesilaos) such packages on the Arch User Repository. Links to these repos are included in the [README.md](https://github.com/protesilaos/tempus-themes-generator/blob/master/README.md). 

## How the generator is designed

The `schemes` directory contains the data of each colour scheme, such as its name, description, palette, foreground and background values, etc.

The `templates` directory contains the files that parse the scheme data. Each template file is named after the program it is intended to work with. For example, the `templates/vim` corresponds to a theme for Vim.

The *generator* itself is a simple (aka "quick and dirty") script written in Bash. It is meant to be run with two arguments, the first being the scheme name and the second the template name. Example using the `schemes/winter` and `templates/urxvt`:

```sh
./tempus-themes-generator.sh winter urxvt
```

## What contributions to make

Prior notes: 

- The scheme files should always include all the data needed to build a theme. If new variables must be declared in a template, they should be defined in the schemes.
- The colour values should always meet the colour contrast ratio that each Tempus item strives for. For most cases, that means 4.50:1 *between foreground and background values* (WCAG AA rating). For example, Tempus Totus has such a contrast ratio of 7.00:1 (WCAG AAA rating). It should never fall below that.
    - Dark themes use colours 0 and 8 as backgrounds. Light themes use colours 7 and 15 as backgrounds. All other values are foregrounds.
    - Another thing to bear in mind regarding the contrast ratio, is that any accent value can be used as a background, such as colour 1 (red) for highlighting error codes, *provided that its foreground colour value is either of the base background values* (col0 or col8 for dark themes, col7 or col15 for light themes). This means, for instance, that the colour 15 (bright white) of a dark theme should not be used as a background colour for any other value other than colours 0 and 8. Otherwise the contrast ratio would fall below its intended target.

### Improving the schemes

Areas I have identified:

1. ~~The colour values are written in HEX. What would be the best way to [automatically] convert these to their corresponding value in another colour space? For example, HEX -> RGB. This operation would be needed to develop ports for programs that do not support HEX.~~ Done as of [0.9.0.20180225](https://github.com/protesilaos/tempus-themes-generator/blob/master/CHANGELOG.md#09020180225). Every item under `schemes` converts HEX colours to RGB using shell variable expansion.
2. The palettes consist of 16 colours. For most cases this is enough. There are however some programs where a wider palette would be more appropriate. Suggestions are welcome!

### Improving the templates

Areas where help is needed:

1. Improving existing templates. Maybe there are some styles that do not work properly, or things that could be done better.
2. Submit new templates! Some programs I have in mind are ~~Atom~~ (Atom is cancelled—see [CHANGELOG 0.7.1.20180213](https://github.com/protesilaos/tempus-themes-generator/blob/master/CHANGELOG.md#07120180213), VS Studio Code, Sublime Text, Emacs, GNOME Terminal, MATE Terminal, Kate, Kwrite.
    - Can we keep the same colour mapping as the Vim template? The idea is that themes should feel 'identical' when moving from one app to another (obviously that is not 100% possible due to the constraints or specific functionality of each program).
    - Complex templates are also welcome. For example, we may want to build a port for Atom, which would encompass its `package.json` and its main styling files. The naming pattern should be `templates/atom-[DIRECTORY if not root]-[FILE if there are multiple that are needed]`, such as `templates/atom-package`, `templates/atom-index`, `templates/atom-styles-base`, `templates/atom-styles-colors` (this point stands even though Atom itself is not part of the current plan, as per [CHANGELOG 0.7.1.20180213](https://github.com/protesilaos/tempus-themes-generator/blob/master/CHANGELOG.md#07120180213))
    - Merging into `master` will only be done once these have been thoroughly tested.

Regarding the addition of new complex templates, it may be better to create subdirectories inside `templates`, say, in the form of `templates/atom/[TEMPLATE FILES]`. Doing so would most probably require changes to the generator script (see next section).

### Improving the generator

The generator script is written in Bash. That is what I know best (with my very limited programming knowledge), while it is also easy to run on virtually every GNU/Linux distro, and use together with standard Unix tools.

There probably are much better ways to go about achieving the goals of the generator. Suggestions are most welcome. Note though, that while other approaches may be superior to what is currently in place, I will ultimately have to maintain any contributions. If I cannot competently work with the proposed code, I will have to turn it down in order to avoid a lock in effect. Hopefully you understand my predicament.
