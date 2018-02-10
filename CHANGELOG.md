# Changelog for Tempus Themes Generator

*Latest version is at the top. Versioning follows semver specs, with the date appended in the form of YYMMDD.*

*NOTE. No release tags are made available. While this script 'works' for my limited use case, it is not tested for widespread use.*

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
