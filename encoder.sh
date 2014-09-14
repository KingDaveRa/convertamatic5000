#!/bin/bash

function encAnimation {
	# Reset the incoming variables to something more meaningful
	infile=$1
	outfile=$2
	echo $outfile

	# Check the file, see how many audio tracks it has
	audiotracks=`mediainfo --Inform="General;%AudioCount%" $infile`

	# Depending on how many tracks there are, we'll do something
	if [ "$audiotracks" = "1" ]; then
		# Encode for one track
		echo "Encoding animation with 1 audio track"
		echo "" | HandBrakeCLI -i "$infile" -t 1 --angle 1 -c 1-5 -o "$outfile"  -f mkv -4  --decomb -w 720 --loose-anamorphic  --modulus 2 -e x264 -q 20 --vfr -a 1 -E copy:ac3 -6 auto -R Auto -B 0 -D 0 --gain 0 --aname="English" --audio-fallback ffac3 --subtitle 1 --x264-profile=high  --x264-tune="animation"  --h264-level="4.1"  --verbose=1
	elif [ "$audiotracks" = "2" ]; then
		# Assume track 2 is a commentary
		echo "Encoding animation with 2 audio tracks"
		echo "" | HandBrakeCLI -i "$infile" -t 1 --angle 1 -c 1-5 -o "$outfile"  -f mkv -4  --decomb -w 720 --loose-anamorphic  --modulus 2 -e x264 -q 20 --vfr -a 1,2 -E copy:ac3,ffac3 -6 auto,stereo -R Auto,Auto -B 0,96 -D 0,0 --gain 0,0 --aname="English","Commentary" --audio-fallback ffac3 --subtitle 1 --x264-profile=high  --x264-tune="animation"  --h264-level="4.1"  --verbose=1
	fi
}

# Check the directory for any files created or moved into it
inotifywait -qm /root/encoder/in -e create -e moved_to --format %f |
    while read f; do
	# Now we do something with it
        echo "Found new file $f"
	# Run the encoder
	encAnimation /root/encoder/in/$f /root/encoder/out/$f
    done
