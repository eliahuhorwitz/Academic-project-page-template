for NAME in rt1_ur5_cloth.mp4 ours_ur5_cloth.mp4 rt1_ur5_tiger.mp4 ours_ur5_tiger.mp4 rpt_octo.mp4 rpt_vc1.mp4 rpt_scratch.mp4 rt1_bridge.mov rpt.mp4 bridge.mov cmu.mov iliad.mov fmb.mov ur5.mp4; do
    if [[ $NAME == *".mov" ]] && [[ $NAME != "cmu.mov" ]]; then
        if [[ $NAME == "iliad.mov" ]]; then
            VF="setpts=PTS/2,zscale=t=linear:npl=110,tonemap=tonemap=hable:desat=0,format=yuv420p"
        else
            VF="setpts=PTS/2,zscale=t=linear:npl=105,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p"
        fi
    else
        VF="setpts=PTS/2,format=yuv420p"
    fi

    if [[ $NAME == *"rpt_"* ]]; then
        ffmpeg -i $NAME -s 360x640 -aspect 360:640 -an -vf "$VF" -crf 28 -vcodec libx264 out_${NAME%%.*}.mp4
    else
        ffmpeg -i $NAME -s 640x360 -aspect 640:360 -an -vf "$VF" -crf 28 -vcodec libx264 out_${NAME%%.*}.mp4
    fi
    ffmpeg -i out_${NAME%%.*}.mp4 -vf "select=eq(n\,0)" -q:v 5 out_${NAME%%.*}.jpg
done
