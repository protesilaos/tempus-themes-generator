# Changelog for Tempus Themes Generator

*Latest version is at the top. Versioning follows semver specs, with the date appended in the form of YYMMDD.*

*NOTE. No release tags are made available. While this script 'works' for my limited use case, it is not tested for widespread use.*

## 0.7.0.20180213

Initial support for Atom editor syntax theme packages. Not all `atom-*` templates expand generator variables. They are just located here to build a complete package from a single source. For a script that builds these packages refer to the `export-atom.sh` in the [tempus-themes-utils](https://github.com/protesilaos/tempus-themes-utils) repository.

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
