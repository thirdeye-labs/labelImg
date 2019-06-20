#/bin/bash

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
    ./labelImg.py /media/data_vic_place/datasets/watford/corr_substitution/watford_v1_ch07/ONIONREDLSE \
        /media/data_vic_place/datasets/watford/corr_substitution/predefined_classes.txt \
        /media/data_vic_place/datasets/watford/corr_substitution/watford_v2_all_annotations_onionredlse
