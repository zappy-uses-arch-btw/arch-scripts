#!/bin/bash
# CORRECT WALLUST V3 SETUP
# Uses the proper syntax from wallust v3

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Setting up wallust v3 with CORRECT syntax...${NC}"
echo ""

# Backup old config
if [ -f ~/.config/wallust/wallust.toml ]; then
    cp ~/.config/wallust/wallust.toml ~/.config/wallust/wallust.toml.backup
    echo -e "${GREEN}✓${NC} Backed up old config"
fi

# Create templates directory
mkdir -p ~/.config/wallust/templates
mkdir -p ~/.config/bspwm
mkdir -p ~/.config/polybar
mkdir -p ~/.config/rofi
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/dunst

# Create template files
echo -e "${BLUE}Creating template files...${NC}"

# 1. colors.sh
cat > ~/.config/wallust/templates/colors.sh << 'EOF'
#!/bin/bash
export background="{{background}}"
export foreground="{{foreground}}"
export cursor="{{cursor}}"
export color0="{{color0}}"
export color1="{{color1}}"
export color2="{{color2}}"
export color3="{{color3}}"
export color4="{{color4}}"
export color5="{{color5}}"
export color6="{{color6}}"
export color7="{{color7}}"
export color8="{{color8}}"
export color9="{{color9}}"
export color10="{{color10}}"
export color11="{{color11}}"
export color12="{{color12}}"
export color13="{{color13}}"
export color14="{{color14}}"
export color15="{{color15}}"
EOF
echo -e "${GREEN}✓${NC} colors.sh"

# 2. bspwm
cat > ~/.config/wallust/templates/bspwm.sh << 'EOF'
#!/bin/bash
bspc config normal_border_color "{{color0}}"
bspc config active_border_color "{{color2}}"
bspc config focused_border_color "{{color4}}"
bspc config presel_feedback_color "{{color1}}"
EOF
echo -e "${GREEN}✓${NC} bspwm.sh"

# 3. polybar
cat > ~/.config/wallust/templates/polybar.ini << 'EOF'
[colors]
background = {{background}}
foreground = {{foreground}}
primary = {{color4}}
secondary = {{color2}}
alert = {{color1}}
disabled = {{color8}}
EOF
echo -e "${GREEN}✓${NC} polybar.ini"

# 4. rofi
cat > ~/.config/wallust/templates/rofi.rasi << 'EOF'
* {
    bg: {{background}};
    fg: {{foreground}};
    accent: {{color4}};
    background: {{background}};
    foreground: {{foreground}};
    selected: {{color4}};
}
EOF
echo -e "${GREEN}✓${NC} rofi.rasi"

# 5. alacritty
cat > ~/.config/wallust/templates/alacritty.toml << 'EOF'
[colors.primary]
background = "{{background}}"
foreground = "{{foreground}}"

[colors.normal]
black   = "{{color0}}"
red     = "{{color1}}"
green   = "{{color2}}"
yellow  = "{{color3}}"
blue    = "{{color4}}"
magenta = "{{color5}}"
cyan    = "{{color6}}"
white   = "{{color7}}"

[colors.bright]
black   = "{{color8}}"
red     = "{{color9}}"
green   = "{{color10}}"
yellow  = "{{color11}}"
blue    = "{{color12}}"
magenta = "{{color13}}"
cyan    = "{{color14}}"
white   = "{{color15}}"
EOF
echo -e "${GREEN}✓${NC} alacritty.toml"

# 6. dunst
cat > ~/.config/wallust/templates/dunst << 'EOF'
[global]
frame_color = "{{color4}}"

[urgency_low]
background = "{{background}}"
foreground = "{{foreground}}"

[urgency_normal]
background = "{{background}}"
foreground = "{{foreground}}"

[urgency_critical]
background = "{{color1}}"
foreground = "{{background}}"
EOF
echo -e "${GREEN}✓${NC} dunst"

echo ""
echo -e "${BLUE}Creating wallust.toml with CORRECT v3 syntax...${NC}"

# Create wallust.toml with the CORRECT v3 format
cat > ~/.config/wallust/wallust.toml << 'EOF'
backend = "resized"
color_space = "lab"
threshold = 1

[templates]
colors = { template = 'colors.sh', target = '~/.config/wallust/colors.sh' }
bspwm = { template = 'bspwm.sh', target = '~/.config/bspwm/colors.sh' }
polybar = { template = 'polybar.ini', target = '~/.config/polybar/colors.ini' }
rofi = { template = 'rofi.rasi', target = '~/.config/rofi/colors.rasi' }
alacritty = { template = 'alacritty.toml', target = '~/.config/alacritty/colors.toml' }
dunst = { template = 'dunst', target = '~/.config/dunst/dunstrc' }
EOF

echo -e "${GREEN}✓${NC} wallust.toml created with v3 syntax"
echo ""

# Show the config
echo -e "${YELLOW}Your wallust.toml:${NC}"
cat ~/.config/wallust/wallust.toml
echo ""

# Verify templates
echo -e "${YELLOW}Templates in ~/.config/wallust/templates/:${NC}"
ls -lh ~/.config/wallust/templates/
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}SETUP COMPLETE!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Now test with:${NC}"
echo "  wallust run ~/Pictures/Wallpapers/ALLqk82.png"
echo ""
echo -e "${YELLOW}Check generated files:${NC}"
echo "  ls -la ~/.config/wallust/colors.sh"
echo "  ls -la ~/.config/bspwm/colors.sh"
echo "  ls -la ~/.config/polybar/colors.ini"
echo "  ls -la ~/.config/alacritty/colors.toml"
echo ""
