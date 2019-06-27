#!/usr/bin/env bash

usage(){
    cat << EOF
Usage:
    $( basename $0) --img-folder=IMG_FOLDER  \ 
                    --ann-folder=ANN_FOLDER  \ 
		    --predefined-classes=PREDEFINED_CLASSES

    Launches labelImg annotation tool in a docker image
    Requires "make qt4py2" to already have been run in 
        the root folder of this repo

Required flags:
    --img-folder 	    Path to the folder containing the images to annotate
    --ann-folder	    Path to the folder containing the annotations 
    --predefined-classes    Path to the *.txt file containing the predefined 
                            classes to use for annotation
EOF
}

ensure_is_folder(){
    if [[ ! -d $1 ]];
    then
        echo "$1 is not a valid folder"
        echo 
        usage
        exit 1
    fi
}

ensure_is_file(){
    if [[ ! -f $1 ]];
    then
        echo "$1 id not a valid file"
        echo
        usage
        exit 1
    fi
}


# Parse flags
while [ "$#" -gt 0 ]; do
 case "$1" in
   # ${1#*=} is the flag's value after the equal
   # Example: --db=tesco would be 'tesco'
   --img-folder=*)
       IMG_FOLDER="${1#*=}"
       shift 1;;

   --ann-folder=*)
       ANN_FOLDER="${1#*=}";
       shift 1;;

   --predefined-classes=*)
       PREDEFINED_CLASSES="${1#*=}"
       shift 1;;

   --help | -h=*)
       usage
       exit 0;
       shift 1;;

   *)
       echo "Unknown option: $1";
       usage
       exit 1;;
 esac
done


# Check flags
ensure_is_folder ${IMG_FOLDER}
ensure_is_folder ${ANN_FOLDER}
ensure_is_file ${PREDEFINED_CLASSES}


# Run annotation tool from docker image

docker run -it --rm \
    --user $(id -u) \
    -e DISPLAY=unix$DISPLAY \
    --workdir=$(pwd) \
    --volume="/home/$USER:/home/$USER" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /media:/media \
    tzutalin/py2qt4 \
    ./labelImg.py ${IMG_FOLDER} ${PREDEFINED_CLASSES} ${ANN_FOLDER}
