# Tempus Themes Generator

A nimble tool to automate the process of exporting the [Tempus colour schemes](https://github.com/protesilaos/tempus-themes) into a variety of file formats.

*Tempus* is a collection of themes for Vim, text editors, and terminal emulators that are *at minimum* compliant with the WCAG AA accessibility standard for colour contrast.

The generator consists of a bash script which parses the sets of variables of each scheme through templates and outputs the result to the terminal (stdout).

## Contents

- Usage
    - Examples
    - File type extensions
- Applying the themes
    - Template-specific repos
    - GTK 3 Source View
    - URxvt (Rxvt-Unicode)
    - Xterm
    - Xfce4 terminal
    - Vim
- Roadmap
- Changelog
- Additional resources
- License

## Usage

Start by cloning the repo:

```sh
git clone https://github.com/protesilaos/tempus-themes-generator.git --depth 1
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

These are the commands for finding the available arguments:

```sh
# List `scheme` options
ls schemes

# List `template options
ls templates
```

### Examples

Print the `winter` theme for `vim` to the terminal output:

```sh
./tempus-themes-generator.sh winter vim
```

Directly create a new file containing the output and place it on the `~/Desktop`:

```sh
./tempus-themes-generator.sh winter vim > ~/Desktop/tempus_winter.vim
```

### File type extensions for each template

```
gtksourceview3 (.xml)
urvxt (.Xcolors, .Xresources, .Xdefaults)
vim = .vim
xcolors = (.Xcolors, .Xresources, .Xdefaults)
xfce4-terminal = .theme
xterm = (.Xcolors, .Xresources, .Xdefaults)
yaml = .yml, .yaml
```

**NOTE.** Styling options read by the X session can omit the file type extension. Not recommended.

## Applying the themes

Each application uses a different set of conventions. Below are some tried and tested examples that I have run on Arch Linux as well as the latest version of Debian and Debian-based distros (Ubuntu and Linux Mint).

### Template-specific repositories

Before trying to do things manually, you may want to check out the following repos with pre-built ports. Some of these even have packages for Arch Linux (through the Arch User Repository).

- [Tempus themes **gtksourceview3**](https://github.com/protesilaos/tempus-themes-gtksourceview3)
- [Tempus themes **urxvt**](https://github.com/protesilaos/tempus-themes-urxvt)
- [Tempus themes **vim plugin**](https://github.com/protesilaos/tempus-themes-vim)
- [Tempus themes **xfce4-terminal**](https://github.com/protesilaos/tempus-themes-xfce4-terminal)
- [Tempus themes **xterm**](https://github.com/protesilaos/tempus-themes-xterm)

### GTK 3 Source View

This is the file used by GTK3 programs to highlight code syntax. Typically implemented by text editors. Some of the popular choices are Gedit (default GNOME), Pluma (default MATE), and Xed (default Linux Mint Cinnamon).

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

### URxvt (RXVT-Unicode)

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

- Refine the code.
- Improve documentation.
- Improve templates where possible.
- Produce templates for other popular apps (Termite, Tilix, etc.).
- Anything else?

## Changelog

Refer to the [CHANGELOG.md](https://github.com/protesilaos/tempus-themes-generator/gblob/master/CHANGELOG.md)

## Additional resources

For all available ports, refer to the main [Tempus themes repo](https://github.com/protesilaos/tempus-themes).

## License

GNU General Public License Version 3. 

See [LICENSE](https://github.com/protesilaos/tempus-themes-generator/gblob/master/LICENSE)
