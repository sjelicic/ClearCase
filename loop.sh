#list all integration streams for the N_Bravo_pvob
mapfile ARRAY -t < <(cleartool lsstream -s -invob /vobs/N_Bravo_pvob/ | grep ^Linux_R\.*_ints$)


echo "+++++++++"
echo "Main Menu"
echo "+++++++++"
echo ""

COUNT=0
for INDEX in ${ARRAY[@]};
do
echo "$COUNT)   ${ARRAY[COUNT]}"
COUNT="`expr $COUNT + 1`"
done

echo "+++++++++++++++++++++++++++++++++++++++++++"
echo "Please choose the integration stream above:"
echo "+++++++++++++++++++++++++++++++++++++++++++"
read -r CHOICE

# removes the trailing whitespaces
BRE=$(echo "${ARRAY[CHOICE]}")

MIG_STREAM_TO_MIGRATE=""$BRE"@/vobs/N_Bravo_pvob"

MIG_STREAM_NAME=`echo $MIG_STREAM_TO_MIGRATE | cut -d "@" -f1`
MIG_STREAM_PVOB=`echo $MIG_STREAM_TO_MIGRATE | cut -d "@" -f2`


#list all development streams for the chosen integration stream
mapfile ARRAY1 -t < <(cleartool lsstream -long stream:"$MIG_STREAM_TO_MIGRATE" | grep -i -A 4 'development streams:' | sed 1d | cut -d "@" -f1)
#clearcase specific: ct lsstream -fmt "%[dstreams]CXp" Linux_R5910_ints@/vobs/N_Bravo_pvob

COUNT1=0
for INDEX1 in ${ARRAY1[@]};
do
echo "$COUNT1)  ${ARRAY1[COUNT1]}"
COUNT1="`expr $COUNT1 + 1 `"
done

echo ""
echo "+++++++++++++++++++++++++++++++++++"
echo "Choose the development stream above"
echo "+++++++++++++++++++++++++++++++++++"
read -r CHOICE1

#removes the leading/trailing whitespaces
BRE1=$(echo "${ARRAY1[CHOICE1]}" | xargs)
MIG_MIGRATION_STREAM_PARENT=""$BRE1"@/vobs/N_Bravo_pvob"


MIG_BL_SELECTOR=`cleartool lsstream -fmt "%[rec_bls]Xp" ${MIG_STREAM_TO_MIGRATE}`
MIG_BL_NAME=`echo ${MIG_BL_SELECTOR} | cut -d ":" -f2`
MIG_BL_SHORT_NAME=`echo ${MIG_BL_NAME} | cut -d "@" -f1`


MIG_UCM_PROJ=`cleartool lsstream -fmt "%[project]p" ${MIG_STREAM_TO_MIGRATE}`
MIG_ALL_BLS=`cleartool lsbl -fmt "\n%[depends_on_closure]p" ${MIG_BL_SELECTOR}`


#create the stream
`cleartool mkstream -in ${MIG_MIGRATION_STREAM_PARENT} -baseline ${MIG_BL_NAME} ${MIG_STREAM_NAME}_migration@${MIG_STREAM_PVOB}`

cd /u01

#create the snapshot 
`cleartool mkview -snapshot -tag ${MIG_STREAM_NAME}_migration_view -stream ${MIG_STREAM_NAME}_migration@${MIG_STREAM_PVOB} -vws ${MIG_STREAM_NAME}_migration.vws /u01/"${MIG_STREAM_NAME}_migration"`

cd "${MIG_STREAM_NAME}_migration"

#write the default config_spec to a file
`cleartool catcs > edcs_template.txt`

#write all the needed VOBs to the config_spec
for BL in $MIG_ALL_BLS; do
   MIG_COMP=`cleartool lsbl -fmt "%[component]Xp" $BL`
   MIG_VOB=`cleartool lscomp -fmt "%[root_dir]p" $MIG_COMP`
   sed -i "/#UCMCustomElemBegin - DO NOT REMOVE - ADD CUSTOM ELEMENT RULES AFTER THIS LINE/a\ load ${MIG_VOB}" edcs_template.txt
done

#set the modified file as the config_spec
`cleartool setcs edcs_template.txt`


mv vobs/* .
rmdir vobs

rm -rf */lost+found
rm -f .view.dat update.*.updt


#git config --global user.email "slobodan.jelicic@maersk.com"
#git config --global user.name "Slobodan Jelicic"


`git init`

#####identifikacija binarnih fajlova
#####stevan
#find . -type f -not -empty | perl -lne 'print if -B' | xargs git lfs track {}
#####moi
#find . -type f -not -empty -exec file -i '{}' \; | grep 'charset=binary' | sed -e 's/\:.*//' > /u01/slobodanj/success.txt | xargs git lfs track {}

`git add .`
`git commit -m "ClearCase project: ${MIG_UCM_PROJ}, BL: ${MIG_BL_SHORT_NAME}"`

`git tag -a "${MIG_BL_SHORT_NAME}" -m "ClearCase project: ${MIG_UCM_PROJ}"`

`git reflog expire --expire-unreachable=now --all`
`git gc --prune=now`











