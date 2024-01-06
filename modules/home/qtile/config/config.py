import os
import subprocess
from libqtile import hook
from libqtile import bar
from libqtile.config import Click, Drag, Match, Screen
from libqtile.layout.columns import Columns
from libqtile.layout.floating import Floating
from libqtile.layout.max import Max
from libqtile.layout.xmonad import MonadWide
from libqtile.lazy import lazy
from libqtile.widget.backlight import Backlight
from libqtile.widget.battery import Battery, BatteryIcon
from libqtile.widget.clock import Clock
from libqtile.widget.currentlayout import CurrentLayout
from libqtile.widget.groupbox import GroupBox
from libqtile.widget.prompt import Prompt
from libqtile.widget.pulse_volume import PulseVolume
from libqtile.widget.systray import Systray
from libqtile.widget.wallpaper import Wallpaper
from libqtile.widget.windowname import WindowName

# pylint: disable=E0401,W0611
from display import watch_display  # pyright: ignore[reportMissingImports]
from settings.keys import keys, mod  # pyright: ignore  # noqa: F401
from settings.groups import groups  # pyright: ignore  # noqa: F401


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    # pylint: disable=R1732
    subprocess.Popen([home])


layouts = [
    Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = {
    "font": "FiraCode Nerd Font Mono",
    "fontsize": 16,
    "highlight_method": "block",
    "padding": 3,
}

extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                GroupBox(),
                Prompt(),
                WindowName(),
                CurrentLayout(),
                Backlight(
                    fmt=" {}",
                    backlight_name=watch_display,
                ),
                PulseVolume(
                    emoji=True,
                    emoji_list=["󰝟", "󰕿", "󰖀", "󰕾"],
                    limit_max_volume=True,
                    step=5,
                ),
                BatteryIcon(),
                Battery(format="{percent:2.0%}"),
                Systray(),
                Clock(format="%Y-%m-%d %a %I:%M %p"),
                Wallpaper(
                    directory="~/wallpapers",
                    max_chars=0,
                    fmt="",
                    random_selection=True,
                ),
            ],
            30,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = Floating(
    float_rules=[
        # Run the utility of `xprop` to see
        # the wm class and name of an X client.
        *Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# pylint: disable=W0511
# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
