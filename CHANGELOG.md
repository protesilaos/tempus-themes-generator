# Changelog for Tempus Themes Generator

*Latest version is at the top. Versioning follows semver specs, with the date appended in the form of YYMMDD.*

*NOTE. No release tags are made available. While this script 'works' for my limited use case, it is not tested for widespread use.*

## 0.9.0.20180225

Add template for Konsole, the default KDE terminal. Update README accordingly.

## 0.8.1.20180224

Add template for shell variables. There are no instructions for this, just as with the `yaml` template. The idea is that this generates a generic file that can be used in some custom setup. For a working example, see my dmenu* wrapper scripts from [my dotfiles](https://github.com/protesilaos/fotfiles) (search them under `bin` and then follow the path they reference).

## 0.8.0.20180224

Added Tempus Rift (dark theme, WCAG AA compliant). Its design is similar to Tempus Warp and Tempus Fugit, i.e. base values have a 4.50:1 contrast, while bright values have a 5.50:1. Tempus Rift is making more liberal use of the green value. Every colour has a higher dose of green, thus resulting in a subdued, moderately green-ish palette.

## 0.7.3.20180216

The generator script is now configured to omit any line that specifies the Vi filetype in the source files. This is done by using a reverse grep pipe. That content is not needed by applications that use the output files.

About vi filetype declarations: I use that option to tell Vim what syntax highlighting to apply on an extensionless file (all the files under `schemes` and `templates`. Knowledge of the filetype is also needed to use the appropriate comment format with Vim's commenter plugin.

## 0.7.2.20180214

General refinements to the Vim template. Some notes:
- The 'popup' menu for autocompletion has better colours for foreground, background, and selection. Their font attributes have also been adjusted. List items are italicised, while the selection is bold.
- The `Title` construct now has the main background value specified as its bg. In the editor this should not be visible. Where it appears is on the tab list, specifically when the tab is active, and has multiple buffers. The active tab use the default foreground colour as its backdrop, which would normally obscure the `Title`. With this tweak, the `Title` will still be visible as it will be drawn on the default bg.

## 0.7.1.20180213

Upon further testing it appears that Atom does not behave as one would expect of text editors. For instance, one cannot change the colour of the foreground in a selected region, because that is a different div (Atom is a text editor based on Electron, which is basically a highly configured web browser). The cursor behaves similarly.

Some online source make reference to some shadow DOM but they are under-documented. 

Workarounds would require creating new colours and/or violating the contrast ratio of each scheme (for example a semi-transparent selection background). That is outside the scope of the Tempus Themes project. An accessible theme should be accessible throughout.

Furthermore, and unlike Vim, Atom's code construct definitions leave something to be desired. A case in point: in my last test, the definition of shell variables was not being picked up, so that in the case of `some_definition=some_value` the `some_definition` could only be styled as generic shell source. But passing styles to that would affect all shell source text, which is not desired.

Ultimately, styling Atom is a rather inelegant, tedious piece of work. For the time being, the Atom-related template files are being removed from the Tempus Themes generator. Atom will only be reconsidered once its theming is stabilised and well documented.

## 0.7.0.20180213

~~Initial support for Atom editor syntax theme packages. Not all `atom-*` templates expand generator variables. They are just located here to build a complete package from a single source. For a script that builds these packages refer to the `export-atom.sh` in the [tempus-themes-utils](https://github.com/protesilaos/tempus-themes-utils) repository.~~

Remove support for Atom. See version `0.7.1.20180213`.

## 0.6.1.20180213

Each theme now has a meta data definition for its WCAG compliance.

Theme variant (light or dark) is now part of meta data section. The previous approach was to declare this in the "base" defaults.

Templates have been adapted to the new theme variant variable.

## 0.6.0.20180211

Added Tempus Fugit (light theme, WCAG AA compliant). Its design is similar to Tempus Warp, i.e. base values have a 4.50:1 contrast, while bright values have a 5.50:1.

## 0.5.2.20180211

The YAML template now includes more information about the theme.

## 0.5.1.20180210

All templates now make better use of each scheme's meta data.

Define scheme name slug with an underscore instead of just with a hyphen (for cases where a hyphen is not appropriate).

## 0.5.0.20180209

Added template for Tilix (formerly Terminix). This is a modern terminal emulator, targetted at GNOME users.

## 0.4.0.20180206

Added a template for gtksourceview-3.0. This is the tool that is used by applications running on the GTK3 widget toolkit to highlight code syntax. Some common apps are Gedit (GNOME default), Pluma (MATE default), and Xed (Linux Mint Cinnamon default).

All schemes now contain a set of variables that contain their meta data, such as full name, description, etc.

## 0.3.0.20180121

Added Tempus Warp (dark theme, WCAG AA compliant)

URxvt now uses a colour for the text under the cursor block.

Vim's search results and incremental search highlighting have been improved. It is now easier to distinguish the cursor from highlighted searches.

## 0.2.0.20171216

Added two new schemes:
- Tempus Future (dark theme, WCAG AAA compliant)
- Tempus Past (light theme, WCAG AA compliant)

## 0.1.0.20171119

Available themes:

```
autumn  spring  summer  totus  winter
```

Available templates:

```
urxvt  vim  xfce4-terminal  xterm  yaml
```
