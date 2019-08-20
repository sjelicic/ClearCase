echo "choose the integration stream"




MIG_STREAM_TO_MIGRATE="Linux_R5910_ints@/vobs/N_Bravo_pvob"
MIG_STREAM_NAME=`echo $MIG_STREAM_TO_MIGRATE | cut -d "@" -f1`
MIG_STREAM_PVOB=`echo $MIG_STREAM_TO_MIGRATE | cut -d "@" -f2`



Identify name of the recommended baseline set on the project integration stream (which is also foundation baseline of our new child stream) and save it for further use
MIG_BL_SELECTOR=`ct lsstream -fmt "%[rec_bls]Xp" ${MIG_STREAM_TO_MIGRATE}` 			<- treba cleartool



cleartool: Error: Name "stream:Linux_R5910_ints_migration" already exists.
cleartool: Error: Unable to create stream "Linux_R5910_ints_migration@/vobs/N_Bravo_pvob".
./loop.sh: line 99: Created: command not found
Vim: Warning: Output is not to a terminal


echo "*******************************"
echo "$MIG_MIGRATION_STREAM_PARENT"
echo "$MIG_BL_NAME"
echo "$MIG_STREAM_NAME"
echo "$MIG_STREAM_PVOB"
echo "*******************************"
echo "$MIG_STREAM_NAME"




*******************************
GCSS_Linux_R5910_ints@/vobs/N_Bravo_pvob
LINUX-MASTER-R5910.0.0.20180517@/vobs/N_Bravo_pvob
Linux_R5910_ints
/vobs/N_Bravo_pvob
*******************************
Linux_R5910_ints



`cleartool mkstream -in ${MIG_MIGRATION_STREAM_PARENT} -baseline ${MIG_BL_NAME} ${MIG_STREAM_NAME}_migration@${MIG_STREAM_PVOB}`

`cleartool mkview -snapshot -tag ${MIG_STREAM_NAME}_migration_view -stream ${MIG_STREAM_NAME}_migration@${MIG_STREAM_PVOB} -vws 
${MIG_STREAM_NAME}_migration.vws /u01/"${MIG_STREAM_NAME}_migration"`


slobodanj@scrbalwdk004237:/u01/slobodanj % ct mkstream -in GCSS_Linux_R5910_ints@/vobs/N_Bravo_pvob -baseline \
> LINUX-MASTER-R5910.0.0.20180517@/vobs/N_Bravo_pvob Linux_R5910_ints_migration@/vobs/N_Bravo_pvob
Created stream "Linux_R5910_ints_migration".t mkstream -in GCSS_Linux_R5910_ints@/vobs/N_Bravo_pvob -baseline LINUX-MASTER-R59

ct mkview -snapshot -tag Linux_R5910_ints_migration_view -stream Linux_R5910_ints_migration@/vobs/N_Bravo_pvob -vws 
Linux_R5910_ints_migration_view.vws /u01/Linux_R5910_ints_migration
Created view.
Host-local path: scrbalwdk004237:/u01/slobodanj/Linux_R5910_ints_migration_view.vws
Global path:     /u01/slobodanj/Linux_R5910_ints_migration_view.vws
It has the following rights:
User : slobodanj : rwx
Group: slobodanj : ---
Other:          : ---
Created snapshot view directory "/u01/Linux_R5910_ints_migration".

#UCMCustomElemBegin - DO NOT REMOVE - ADD CUSTOM ELEMENT RULES AFTER THIS LINE

 find . -type f -not -empty -exec file -i '{}' \; | grep 'charset=binary' | sed -e 's/\:.*//'

git config --global user.email "slobodan.jelicic@maersk.com"
git config --global user.name "Slobodan Jelicic"
















