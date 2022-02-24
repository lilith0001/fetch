#! /usr/bin/env zsh
cpuPercent=$(top -l 1 | grep -E "^CPU" | grep -Eo '[^[:space:]]+%' | head -1)
echo "\n"
#curl -fsSl https://c.tenor.com/qmHZx7xIuwIAAAAC/anime-background.gif | ~/fetch/imgcat.sh
curl -fsSl https://c.tenor.com/pJTikhNW3UgAAAAd/art-spin.gif | ~/fetch/imgcat.sh
#curl -fsSl https://c.tenor.com/YB3M7ApTeMkAAAAC/skeleton-dance.gif | ~/fetch/imgcat.sh
#curl -fsSl https://c.tenor.com/-61MEtVWwlMAAAAC/touhou-bad-apple.gif | ~/fetch/imgcat.sh
###########
# cpu
cpu=$(sysctl -n machdep.cpu.brand_string)
echo -en "\033[15A\033[40C CPU:      ${cpu}    ${cpuPercent%.*}%"


# memory
pagesActive=$(vm_stat| grep "Pages active:"| awk '{print substr($3, 1, length($3)-1)}')
pagesWiredDown=$(vm_stat| grep "Pages wired down:"| awk '{print substr($4, 1, length($4)-1)}')
memUsed=$(( $pagesActive + $pagesWiredDown ))
memUsedMiB=$(( $memUsed * 16384 / $(( 1024 ** 2 )) ))
hwmemsize=$(sysctl -n hw.memsize)
ramSizeMiB=$(( $hwmemsize / $(( 1024 ** 2 )) ))
ramSizeGiB=$(( $hwmemsize / $(( 1024 ** 3 )) ))
memUsagePercent=$(( 100 * $memUsedMiB / $ramSizeMiB ))
echo -en "\n\033[40C Memory:   ${ramSizeGiB}gb        ${memUsagePercent}%"


# storage
dataDisk=$(df -h| grep /Data| grep -v "home")
dataSize=$(echo ${dataDisk}| awk '{print ($2)}')
dataSize=$(echo "${dataSize%G*}") 
dataUsed=$(echo ${dataDisk}| awk '{print ($5)}')
echo -en "\n\033[40C Storage:  ${dataSize}gb       ${dataUsed}"


# display
display=$(system_profiler SPDisplaysDataType | grep Resolution | grep -oE "[0-9]* x [0-9].*")
echo -en "\n\033[40C Display:  ${display}"


# window manager code from https://github.com/dylanaraps/neofetch/blob/master/neofetch
ps_line=$(ps -e | grep -o \
	-e "[S]pectacle" \
	-e "[A]methyst" \
	-e "[k]wm" \
	-e "[c]hun[k]wm" \
	-e "[y]abai" \
	-e "[R]ectangle")

case $ps_line in
	*chunkwm*)   wm=chunkwm ;;
	*kwm*)       wm=Kwm ;;
	*yabai*)     wm=yabai ;;
	*Amethyst*)  wm=Amethyst ;;
	*Spectacle*) wm=Spectacle ;;
	*Rectangle*) wm=Rectangle ;;
	*)           wm="Quartz Compositor" ;;
esac
# end code from https://github.com/dylanaraps/neofetch/blob/master/neofetch
echo -en "\n\033[40C WM:       ${wm}"


# operating system
os=$(sw_vers -productVersion)
echo -en "\n\033[40C macOS:    $os"


# kernel version
kernel=$(uname -r)
echo -en "\n\033[40C Kernel:   ${kernel}"


# uptime
uptime=$(uptime| sed -e 's/.*up\(.*\),.*users.*/\1/;s/:/ hours, /;s/hrs/hours,0/;s/$/ minutes/;'| tr -s " ")
uptimeDecimal=$(echo ${uptime} |awk '{printf "%.1f", $1 + ( $5 / 60 + $3)/24 }')
echo -en "\n\033[40C Uptime:   ${uptimeDecimal} days"


# brew
brewInfo=$(brew info)
echo -en "\n\033[40C Brew:     ${brewInfo}"

# shell
shellInfo=$($SHELL --version | grep -oE '.*\(' | sed 's/(//')
echo -en "\n\033[40C Shell:    ${shellInfo}"

echo -en "\033[6B"
echo "\n"
