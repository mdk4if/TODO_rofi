#!/bin/bash
if  ! which rofi; then
    echo "This script requires rofi"
    exit 0
fi
todoFile="/home/$USER/.local/todo.txt"
doneFile="/home/$USER/.local/done.txt"
touch $todoFile
touch $doneFile

ad_del_note=$(while read line; do
    if grep -Fxq "$line" $doneFile
    then
        continue
    else
        echo $line
    fi

done<$todoFile | rofi -i -dmenu -p "TODO" -mesg "<b><u>add</u></b> note1,note2,note3.... | <b><u>Press [Enter] to delete</u></b>")
if [[ $ad_del_note = "" ]]; then
    exit 0
fi
Addnote ()
{
    oldstr="add "
    newstr=""
    addnote=$(echo $ad_del_note | sed "s/$oldstr/$newstr/g")
    IFS=','
    read -ra notes_arr <<< $addnote
    for i in "${notes_arr[@]}";
    do 
        echo -e ""`date "+%B %d"`" $i" >> $todoFile
    done
}

Delnote() {
    deLnote=$(echo -e "YES\nNO" | rofi -i -dmenu -p "DELETE NOTE")
    if [[ $deLnote = "YES" ]]; then
        echo $ad_del_note >> $doneFile
    fi
}
index=$(echo $ad_del_note | cut -d" " -f1)
if [[ $index = "add" ]]; then
    Addnote
else
    Delnote
fi

