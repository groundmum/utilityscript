#!/bin/bash

file=$(Xdialog --title "please select voice file" --stdout --fselect  $HOME 0 0)
length_ms=$(mediainfo -f $file  | grep Duration | head -1 | cut -f2 -d ':' )
length_sec=$((length_ms/1000))
info=$(Xdialog  --stdout --title "get info" --3inputsbox "please fill this form"  0 0 "skip sec from begining file" 0 "lenght of pieces(sec)" 5 "end sec of file" "$length_sec")
skip_sec=$(echo $info | cut -f1 -d '/') 
len_pices=$(echo $info | cut -f2 -d '/')
end_sec=$(echo $info | cut -f3 -d '/')
echo "
read -n1 f
for (( i=$skip_sec ; i<= $end_sec ; i+=$len_pices ))
do
mplayer -ss \$i -endpos $len_pices \"$file\"
read -n1 foo
if  [ \$foo == 'r' ]
then
while [ \$foo == 'r' ]
do
mplayer -ss \$i -endpos $len_pices \"$file\"
read -n1 foo
done
fi
done" > /tmp/voice.tmp
chmod +x /tmp/voice.tmp
xfce4-terminal -x /tmp/voice.tmp &
Xdialog --infobox "please selct Xterm window" 0 0 4000
wid=$(xdotool selectwindow)
Xdialog --infobox "now you must bind the shortcut key for running '/tmp/nextplay.voice' and '/tmp/replay.voice'" 0 0 4000
echo "xdotool type --window $wid n " > /tmp/nextplay.voice
echo "xdotool type --window $wid r " > /tmp/replay.voice
chmod +x /tmp/nextplay.voice /tmp/replay.voice