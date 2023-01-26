######################################################
# Variables
######################################################

export $(grep -v '^#' .env | xargs) #loads variables from .env

PLUGINS=plugins
THEMES=themes
DEFAULT=default/wp-content
DEPLOY=deploy/wp-content

######################################################
# Functions 
######################################################

set +e
containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 1; done
  return 0
}

folderCleanup () {
    sourceFiles=($1)
    destinationFiles=($2)

    sourceFilesBase=()
    for f in "${sourceFiles[@]}"; do
        sourceFilesBase[${#sourceFilesBase[@]}]=$(basename $f)
    done
    
    for f in "${destinationFiles[@]}"; do
        p=$(basename $f)
        containsElement $p "${sourceFilesBase[@]}"
        [ $? -eq 0 ] && {
            rm -rf "$f"
        }
    done
}

declare -A checksums

folderChangeCheck (){
    folder=$1
    destination=$2
    default=$3
    emoji=$4
    label=$5
    
    checksum=`find $folder -type f -exec $MD5 {} \;`
    if [[ ${checksums[$folder]} != $checksum ]] ; then           
        if [ -n "${checksums[$folder]}" ]; then
            start=$(date +%s%N)
            echo "$emoji change spotted in $label folder"
            folderCleanup "$default/*" "$destination/*"
            cp -r $folder/* $destination > $LOGFILE 2> $LOGFILE
            
            end=$(date +%s%N)
            dur_n=$(($end-$start))
            dur_m=$(($dur_n/1000000))
            echo "✅ $label updated in $dur_m ms"
        fi
        checksums[$folder]=$checksum
    fi
}

listen (){
    while [[ true ]]
        do
            folderChangeCheck $PLUGINS $DEPLOY/plugins $DEFAULT/plugins "🔨" "plugins"
            folderChangeCheck $THEMES $DEPLOY/themes $DEFAULT/themes "👗" "themes"
            sleep .5
        done
}

######################################################
# Process
######################################################

# resetting the content of the deploy folder
LOGFILE=.logs/out.log
echo "🔥 Wellcome to the hot-reloaded Wordpress developer environment"

sleep .4

echo 
echo -n "🧹 Cleaning up..."

mkdir .logs > /dev/null 2> /dev/null
rm -rf $DEPLOY/* > $LOGFILE 2> $LOGFILE
rm $DEPLOY/.empty > $LOGFILE 2> $LOGFILE
cp -r $DEFAULT deploy/ > $LOGFILE 2> $LOGFILE
cp -r $PLUGINS/* deploy/wp-content/plugins > $LOGFILE 2> $LOGFILE
cp -r $THEMES/* deploy/wp-content/themes > $LOGFILE 2> $LOGFILE
echo " Done"

echo "🐳 It's Docker time"
echo
sleep .4

# starting docker
docker-compose -f compose.yml up -d

# listening for changed is the .wpdev folders
echo 
echo "🏃 WordPress is running at http://localhost:${PORT}/"
echo "🎧 Listening for file changes"
listen
