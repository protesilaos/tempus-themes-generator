# Tempus Themes Generator

A nimble tool to automate the process of exporting the [Tempus colour schemes](https://gitlab.com/protesilaos/tempus-themes) into a variety of file formats.

*Tempus* is a collection of themes for Vim, text editors, and terminal emulators that are *at minimum* compliant with the WCAG AA accessibility standard for colour contrast.

The generator consists of a bash script which parses the sets of variables of each scheme through templates and outputs the result to the terminal (stdout).

#### Table of Contents

- [Usage](#usage)
    - [Examples](#examples)
    - [File type extensions](#file-type-extensions)
- [Applying the themes](#applying-the-themes)
    - [Template-specific repositories](#template-specific-repositories)
    - [GTK3 Source View](#gtk3-source-view)
    - [GTK4 Source View](#gtk4-source-view)
    - [Kitty](#kitty)
    - [Konsole](#konsole)
    - [Tilix](#tilix)
    - [URxvt (Rxvt-Unicode)](#urxvt-rxvt-unicode)
    - [Xterm](#xterm)
    - [Xfce4 terminal](#xfce4-terminal)
    - [Vim](#vim)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Changelog](#changelog)
- [Additional resources](#additional-resources)
- [License](#license)
- [Meta](#meta)
- [Donations](#donations)

## Usage

Start by cloning the repo:

```sh
git clone https://gitlab.com/protesilaos/tempus-themes-generator.git --depth 1
```

Then enter the directory:

```sh
cd tempus-themes-generator
```

**NOTE all subsequent commands assume you are working within the `tempus-themes-generator` directory.**

Run the script with the necessary arguments:

```sh
./tempus-themes-generator.sh [scheme] [template]
```

These are the commands for finding the available arguments (lines starting with `#` are comments):

```sh
# List `scheme` options
ls schemes

# List `template` options
ls templates
```

Tips:

- Running the script without an argument will print a detailed help message.
- Passing a scheme name as the sole argument will print a timed preview of the scheme's palette.

### Examples

Print the `winter` theme for `vim` to the terminal output:

```sh
./tempus-themes-generator.sh winter vim
```

Directly create a new file named `tempus_winter.vim` containing the output and place it on the `~/Desktop`:

```sh
./tempus-themes-generator.sh winter vim > ~/Desktop/tempus_winter.vim
```

### File type extensions

When exporting to a new file, make sure to use the appropriate file type extension.

```
gtksourceview3 = .xml
konsole = .colorscheme
tilix = .json
urvxt = .Xcolors, .Xresources, .Xdefaults
vim = .vim
xcolors = .Xcolors, .Xresources, .Xdefaults
xfce4-terminal = .theme
xterm = .Xcolors, .Xresources, .Xdefaults
yaml = .yml, .yaml
```

**NOTE.** Styling options read by the X session can omit the file type extension. Not recommended.

## Applying the themes

Each application uses a different set of conventions. Below are some tried and tested examples that I have run on Arch Linux as well as the latest version of Debian and Debian-based distros (Ubuntu and Linux Mint).

### Template-specific repositories

Before trying to do things manually, you may want to check out the following repos with pre-built ports.

- [Tempus themes **GTK3 Source View**](https://gitlab.com/protesilaos/tempus-themes-gtksourceview3)
- [Tempus themes **GTK4 Source View**](https://gitlab.com/protesilaos/tempus-themes-gtksourceview4)
- [Tempus themes **Kitty**](https://gitlab.com/protesilaos/tempus-themes-kitty)
- [Tempus themes **Konsole**](https://gitlab.com/protesilaos/tempus-themes-konsole)
- [Tempus themes **Tilix**](https://gitlab.com/protesilaos/tempus-themes-tilix)
- [Tempus themes **URxvt**](https://gitlab.com/protesilaos/tempus-themes-urxvt)
- [Tempus themes **Vim plugin**](https://gitlab.com/protesilaos/tempus-themes-vim)
- [Tempus themes **Xfce4 terminal**](https://gitlab.com/protesilaos/tempus-themes-xfce4-terminal)
- [Tempus themes **Xterm**](https://gitlab.com/protesilaos/tempus-themes-xterm)

### GTK3 Source View

This is the file used by GTK3 programs to highlight code syntax. Typically implemented by text editors. Some of the popular choices are Gedit (default GNOME), Pluma (default MATE), Mousepad (default Xfce), and Xed (default Linux Mint Cinnamon).

The theme files can be located in either of two places:

- At `/usr/share/gtksourceview-3.0/styles/` which makes them accessible to all users (requires root privileges).
- Or `~/.local/share/gtksourceview-3.0/styles/` for use by the current user (directory path needs to be created if it does not already exist).

Choose whatever option suits your needs. The following commands use the latter as an example.

```sh
# Create destination directory if it does not already exist
mkdir -p ~/.local/share/gtksourceview-3.0/styles/

# Generate the theme and place it in the created directory
./tempus-themes-generator.sh winter gtksourceview3 > ~/.local/share/gtksourceview-3.0/styles/tempus_winter.xml
```

The theme will then be available from the supported app's preferences window.

### GTK4 Source View

This is the file used by GTK4 programs to highlight code syntax (GNOME Builder is the first known editor to support it). Typically implemented by text editors. Some of the popular choices are Gedit (default GNOME), Pluma (default MATE), Mousepad (default Xfce), and Xed (default Linux Mint Cinnamon).

The theme files can be located in either of two places:

- At `/usr/share/gtksourceview-4/styles/` which makes them accessible to all users (requires root privileges).
- Or `~/.local/share/gtksourceview-4/styles/` for use by the current user (directory path needs to be created if it does not already exist).

Choose whatever option suits your needs. The following commands use the latter as an example.

```sh
# Create destination directory if it does not already exist
mkdir -p ~/.local/share/gtksourceview-4/styles/

# Generate the theme and place it in the created directory
./tempus-themes-generator.sh winter gtksourceview4 > ~/.local/share/gtksourceview-4/styles/tempus_winter.xml
```

The theme will then be available from the supported app's preferences window.

### Kitty

By default all of Kitty's theme-releated options are defined in a single
configuration file.  As such, I recommend you read the
[tempus-themes-kitty
README](https://gitlab.com/protesilaos/tempus-themes-kitty/blob/master/README.md)
and adapt accordingly.

### Konsole

Konsole is the default terminal for KDE. Its theme files can be located in either of two places:

- At `/usr/share/konsole/` which makes them accessible to all users (requires root privileges).
- Or `~/.local/share/konsole/` for use by the current user (directory path needs to be created if it does not already exist).

Choose whatever option suits your needs. The following commands use the latter as an example.

```sh
# Create destination directory if it does not already exist
mkdir -p ~/.local/share/konsole/

# Generate the theme and place it in the created directory
./tempus-themes-generator.sh winter konsole > ~/.local/share/konsole/tempus_winter.colorscheme
```

The theme will then be available from the profile preferences window under the "Appearance" tab.

### Tilix

Tilix theme files can be located in either of two places:

- At `/usr/share/tilix/schemes/` which makes them accessible to all users (requires root privileges).
- Or `~/.config/tilix/schemes/` for use by the current user (directory path needs to be created if it does not already exist).

Choose whatever option suits your needs. The following commands use the latter as an example.

```sh
# Create destination directory if it does not already exist
mkdir -p ~/.config/tilix/schemes/

# Generate the theme and place it in the created directory
./tempus-themes-generator.sh winter tilix > ~/.config/tilix/schemes/tempus_winter.json
```

The theme will then be available from the application's preferences window, in the profiles' section (under the colours tab).

### URxvt (Rxvt-Unicode)

URxvt saves colour values in either of two places. The most common use case is within the `~/.Xresources`. Since that file can contain all sorts of configurations, it is best to *append* the output of the `tempus-themes-generator.sh` rather than overwrite its contents.

As such, run the following command:

```sh
./tempus-themes-generator.sh winter urxvt >> ~/.Xresources
```

Notice the use of `>>`. It is what appends the output to the file. If your `.Xresources` is empty (or does not exist), then just run the following instead (notice the single `>`):

```sh
./tempus-themes-generator.sh winter urxvt > ~/.Xresources
```

The other approach to having colour values for URxvt is to source an `.Xcolors` file from within the `.Xresources`. The file can be located anywhere. For the purposes of this tutorial, it is assumed you have created a hidden directory `~/.urxvt-themes/`:

```sh
# Create directory for urxvt Xcolors
mkdir ~/.urxvt-themes

# Generate the desired theme and place it in the new directory
./tempus-themes-generator.sh winter urxvt > ~/.urxvt-themes/tempus_winter.Xcolors
```

Then source that file from within the `.Xresources` with the following line (note that comments in `.Xresources` start with a `!`, not an `#`):

```
#include </home/YOUR-USERNAME/.urxvt-themes/tempus_winter.Xcolors>
```

Whatever method you use, do not forget to reload the configurations, with `xrdb -merge ~/.Xresources` (may need to close all terminals and re-open them).

### Xterm

Much like URxvt, Xterm stores its configurations in `~/.Xresources`. Append the theme of your choice to the existing configs with the following:

```sh
./tempus-themes-generator.sh winter xterm >> ~./Xresources
```

### Xfce4-terminal

The theme files can be located in either of two places:

- At `/usr/share/xfce4/terminal/colorschemes/` which makes them accessible to all users (requires root privileges).
- Or `~/.local/share/xfce4/terminal/colorschemes/` for use by the current user (directory path needs to be created if it does not already exist).

Choose whatever option suits your needs, modifying the following command accordingly:

```sh
# Create directory if it does not already exist (ONLY for the .local option)
mkdir -p ~/.local/share/xfce4/terminal/colorschemes/

# Generate the theme and place it in the created directory
./tempus-themes-generator.sh winter xfce4-terminal > ~/.local/share/xfce4/terminal/colorschemes/tempus_winter.theme
```

The theme will then be available from the terminal's preferences window. Specifically, open the Xfce4 Terminal, navigate to `Preferences` > `Colours`. The themes should be available in the `Presets` section, named as "Tempus [scheme name]" (e.g Tempus winter).

### Vim

The theme files can be copied manually or installed as a bundle with a plugin.

The manual method requires you to copy the file to `~/.vim/colors/`. Run the following command:

```sh
# Create path to colors directory if it does not already exist
mkdir -p ~/.vim/colors/

# Generate theme and place it in the newly created directory
# NOTE the output file has a full name of tempus_winter.vim
./tempus-themes-generator.sh winter vim > ~/.vim/colors/tempus_winter.vim
```

As for the plugin, you can use your favourite plugin manager. With [vim-plug](https://github.com/junegunn/vim-plug) add the following line to your `.vimrc`:

```vim
Plug 'protesilaos/tempus-themes-vim'
```

Then execute the plugin manager's command to update the plugin files.

Once available, the theme is declared with the following options inside the `.vimrc`:

```vim
" Theme
syntax enable
colorscheme tempus_winter
```

**IMPORTANT.** Note that `tempus_winter` is the full name of the `winter` scheme as outputted by the generator. To avoid conflicts with any other themes that may exist, it is recommended that all Tempus schemes are declared in vim with `tempus_` prepended to their name.

## Roadmap (help is much appreciated)

- Refine the code where necessary.
- Improve the templates where possible.
- Produce templates for other popular apps.

## Contributing

See [CONTRIBUTING.md](https://gitlab.com/protesilaos/tempus-themes-generator/blob/master/CONTRIBUTING.md)

## Changelog

Refer to the [CHANGELOG](https://gitlab.com/protesilaos/tempus-themes-generator/blob/master/CHANGELOG)

## Additional resources

For a hub with all available ports, see the main [Tempus themes repo](https://gitlab.com/protesilaos/tempus-themes).

## License

GNU General Public License Version 3.

See [LICENSE](https://gitlab.com/protesilaos/tempus-themes-generator/gblob/master/LICENSE)

## Donations

If you appreciate this work, consider [donating via PayPal](https://www.paypal.me/protesilaos).
