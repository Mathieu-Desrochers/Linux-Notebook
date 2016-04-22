Modifications to the wizard generated configuration
---------------------------------------------------
Apply the following changes.

    ---- bindsym $mod+Return exec i3-sensible-terminal
    ++++ bindsym $mod+Return exec uxterm

    ---- bindsym Left resize shrink width 10 px or 10 ppt
    ---- bindsym Down resize grow height 10 px or 10 ppt
    ---- bindsym Up resize shrink height 10 px or 10 ppt
    ---- bindsym Right resize grow width 10 px or 10 ppt

    ++++ bindsym Left resize shrink width 1 px or 1 ppt
    ++++ bindsym Down resize grow height 1 px or 1 ppt
    ++++ bindsym Up resize shrink height 1 px or 1 ppt
    ++++ bindsym Right resize grow width 1 px or 1 ppt
