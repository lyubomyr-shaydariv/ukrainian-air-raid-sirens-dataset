#!/usr/bin/awk -f

function iso8601_to_ics(iso8601) {
	gsub(/ /, "T", iso8601);
	gsub(/[-:]/, "", iso8601);
	return iso8601;
}

BEGIN {
	if ( OBLAST == "" ) {
		print "fatal: no oblast key provided" > "/dev/stderr";
		EXIT_CODE = 1;
		exit 1;
	}
	FS = ",";
	print "BEGIN:VCALENDAR";
	print "PRODID:-//ukrainian-air-raid-sirens-dataset//ukrainian-air-raid-sirens-dataset//EN";
	print "VERSION:2.0";
	print "CALSCALE:GREGORIAN";
	print "METHOD:PUBLISH";
	print "X-WR-CALNAME:" OBLAST;
	# TODO Is this timezone name already recognized as `Europe/Kyiv`?
	print "X-WR-TIMEZONE:Europe/Kiev";
	print "X-WR-CALDESC:" OBLAST ", ukrainian-air-raid-sirens-dataset";
}

NR > 1 && $1 == OBLAST {
	DTSTART = iso8601_to_ics($2);
	DTEND = iso8601_to_ics($3);
	UID = DTSTART DTEND;
	print "BEGIN:VEVENT";
	print "DTSTART:" DTSTART;
	print "DTEND:" DTEND;
	print "UID:" UID;
	print "SUMMARY:🚀" OBLAST;
	print "END:VEVENT";
}

END {
	if ( EXIT_CODE ) {
		exit EXIT_CODE;
	}
	print "END:VCALENDAR";
}
