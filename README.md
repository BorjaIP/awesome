# Awesome WM Custom

Welcome to my **Awesome WM Custom**, a personalized configuration of the [Awesome Window Manager](https://awesomewm.org/). This setup is designed to enhance productivity, aesthetics, and usability while maintaining the lightweight and highly customizable nature of Awesome WM.

---

## Features

- **Custom Keybindings**: Intuitive shortcuts for window management, launching applications, and more.
- **Theming**: A sleek, modern theme with custom widgets and color schemes.
- **Widgets**: Useful widgets for system monitoring (CPU, RAM, battery, etc.), weather, and more.
- **Multi-Monitor Support**: Optimized layouts for multi-monitor setups.
- **Autostart Applications**: Automatically launch essential applications on startup.
- **Dynamic Tagging**: Easily manage and switch between workspaces (tags).
- **Performance Optimizations**: Lightweight and fast, tailored for minimal resource usage.

---

## Installation

### Prerequisites

- **Awesome WM**: Ensure you have Awesome WM installed. Follow the [official installation guide](https://awesomewm.org/apidoc/documentation/07-my-first-awesome.md.html) for your distribution.
- **Dependencies**: Install the following tools and libraries:
  - `lua` (required for Awesome WM)
  - `dmenu` (application launcher)
  - `feh` (for setting wallpapers)
  - `xrandr` (for multi-monitor setups)
  - `freedesktop` (for menu and desktop icons)
  - `lain` (for layouts, widgets and utilities)
  - `base16` (default theme)
  - Any additional tools listed in the configuration files.

### Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/BorjaIP/awesome.git ~/.config/awesome
   ```

2. **Backup Existing Configuration**:
   If you already have an Awesome WM configuration, back it up:
   ```bash
   mv ~/.config/awesome ~/.config/awesome_backup
   ```

3. **Apply the New Configuration**:
   Copy the cloned repository to your Awesome WM configuration directory:
   ```bash
   cp -r awesome ~/.config/awesome
   ```

4. **Restart Awesome WM**:
   Press `Mod4` + `Ctrl` + `r` (default keybinding) to reload Awesome WM with the new configuration.

---

## Customization

Feel free to modify the configuration files to suit your preferences. Key files to explore:

- **`rc.lua`**: Main configuration file for Awesome WM.
- **`themes/custom/theme.lua`**: Customize colors, fonts, and other visual elements.
- **`widgets/`**: Add or modify widgets for system monitoring and other features.
- **`autostart.sh`**: Add applications to start automatically. (not included)

---

## Keybindings

Here are some of the default keybindings in this configuration:

| Key Combination         | Action                          |
|--------------------------|---------------------------------|
| `Mod4` + `Enter`         | Open terminal                  |
| `Mod4` + `space`         | Launch application (via `rofi`)|
| `Mod4` + `j/k`           | Focus next/previous window     |
| `Mod4` + `q`             | Close focused window           |
| `Mod4` + `Ctrl` + `r`    | Reload Awesome WM              |

For a full list of keybindings, check the `keys/` folder.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Acknowledgments

- [Awesome WM](https://awesomewm.org/)
- [Dmenu](https://tools.suckless.org/dmenu/)
- [Feh](https://feh.finalrewind.org/)
- [Base16](https://github.com/chriskempson/base16)
- Community contributors for inspiration and widgets.
