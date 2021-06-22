if [ $1 ] && [ $2 ]; then 
    INPUT_FILE=$1
    OUTPUT_FILE=$2
    INPUT_FILE_NAME=$(echo "$INPUT_FILE" | cut -f 1 -d '.')

    i=0
    while true; do
        if [ ! -d "frames$i" ]; then
            mkdir -p frames$i
            break
        fi
        i=$((i+1))
    done
    #ffmpeg -i $INPUT_FILE -vcodec libx265 -crf 28 $INPUT_FILE # UNCOMMENT TO COMPRESS
    python3 main.py "frames$i" $INPUT_FILE $INPUT_FILE_NAME
    mkdir -p temp
    fps=`ffmpeg -i klip.mp4 2>&1 | sed -n "s/.*, \(.*\) tbr.*/\1/p"`
    ffmpeg -r $fps -i frames$i/$INPUT_FILE_NAME%d.jpg temp/video_temp.mp4 # VIDEO FROM FRAMES
    ffmpeg -i $INPUT_FILE -vn -acodec copy temp/audio_temp.aac # AUDIO FROM VIDEO
    ffmpeg -i temp/video_temp.mp4 -i temp/audio_temp.aac -c:v copy -c:a aac $OUTPUT_FILE # ADD AUDIO TO VIDEO
    #ffmpeg -ss 7 -t 7 -i $OUTPUT_FILE -vf "fps=$fps,scale=250:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 output.gif # CONVERT TO GIF
    rm -r temp
    rm -r frames$i
else
    echo 'Please add input file and output name'
fi



