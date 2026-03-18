# @luaily's gradient name@host combo maker, do not download and set as your ~/.zshrc, copy and paste it instead.
## ".sh" at the end to make the color syntax on github, no other purpose.
### make sure you have 256 color support pls
get_gradient() {
    # this will run the python file below
    python3 -c "
import sys
text = '$1'
startHex = '$2'.lstrip('#')
endHex = '$3'.lstrip('#')
s_rgb = [int(startHex[i:i+2], 16) for i in (0, 2, 4)] # start RGB values
e_rgb = [int(endHex[i:i+2], 16) for i in (0, 2, 4)] # end RGB values
n = len(text)
output = ''
for i, char in enumerate(text): # do math to figure out the values of each color between start and end
    ratio = i / (n - 1) if n > 1 else 0
    r = int(s_rgb[0] + (e_rgb[0] - s_rgb[0]) * ratio)
    g = int(s_rgb[1] + (e_rgb[1] - s_rgb[1]) * ratio)
    b = int(s_rgb[2] + (e_rgb[2] - s_rgb[2]) * ratio)
    output += f'%{{\x1b[38;2;{r};{g};{b}m%}}{char}' # set the color for each character
print(output + '%{\x1b[0m%}', end='')
"
}

# this function now runs before every new command line is drawn
set_gradient_prompt() {
    local userPart=$(whoami) # get the username
    local hostPart=$(hostname -s) # get the hostname
    local pathPart=$(print -P '%~') # expand the current path

    # 1. sets gradients for each piece, left to right, replace FFFFFF with start color and 000000 with end color.
    USER_GRADIENT=$(get_gradient "$userPart" "FFFFFF" "000000") ## USER GRADIENT
    HOST_GRADIENT=$(get_gradient "$hostPart" "FFFFFF" "000000") ## HOST GRADIENT
    PATH_GRADIENT=$(get_gradient "$pathPart" "FFFFFF" "000000") ## PATH GRADIENT

    # 2. assemble
    # %B starts bold, %b ends bold. %F{n} is the adaptive text, it resets back to the default color.
    PROMPT="%B${USER_GRADIENT}%b%F{n}@%f%B${HOST_GRADIENT}%b ${PATH_GRADIENT} %B%#%b " 
    ## the end has a full reset, do not delete it or the trailing space
}

# tell zsh to run this function before every prompt refresh
autoload -Uz add-zsh-hook ## THIS IS REQUIRED so it doesn't error out
add-zsh-hook precmd set_gradient_prompt ## this runs it
