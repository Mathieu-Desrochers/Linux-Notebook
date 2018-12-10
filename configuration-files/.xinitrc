xrandr --newmode "1280x720_60.00" 74.50 1280 1344 1472 1664  720 723 728 748 -hsync +vsync
xrandr --addmode eDP-1 1280x720_60.00
xrandr --output eDP-1 --mode 1280x720_60.00
xrdb -merge ~/.Xresources
exec i3
