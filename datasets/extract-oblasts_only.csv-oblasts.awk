#!/usr/bin/awk -f

BEGIN {
	FS = ",";
}

NR > 1 && !SEEN[$1]++ {
	print $1;
}
