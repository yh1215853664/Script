plus="+" 
slipt="_"
gps="gps"
gpx=".gpx"
csv=".csv"
mp4=".mp4"
jpg=".jpg"

mkdir -p ../工程/psc_task
mkdir -p ../结果
mkdir -p ../图像

for i in `ls | grep  00 | grep .insv`
do
name=$i
year_month_day=`echo $name | cut -d "." -f 1 | awk -F "_" '{ print $2 }'`
hour_minute_second=`echo $name | cut -d "." -f 1 | awk -F "_" '{ print $3 }'`
file_gps=$year_month_day$slipt$hour_minute_second$slipt$gps$csv
file_gpx=$year_month_day$slipt$hour_minute_second$gpx
name1=`echo $name | cut -d "." -f 1`
name_mp4=$name1$mp4

cat>gpx.fmt<<EOF
#------------------------------------------------------------------------------
# File:         gpx.fmt
#
# Description:  Example ExifTool print format file to generate a GPX track log
#
# Usage:        exiftool -p gpx.fmt -ee3 FILE [...] > out.gpx
#
# Requires:     ExifTool version 10.49 or later
#
# Revisions:    2010/02/05 - P. Harvey created
#               2018/01/04 - PH Added IF to be sure position exists
#               2018/01/06 - PH Use DateFmt function instead of -d option
#               2019/10/24 - PH Preserve sub-seconds in GPSDateTime value
#
# Notes:     1) Input file(s) must contain GPSLatitude and GPSLongitude.
#            2) The -ee3 option is to extract the full track from video files.
#            3) The -fileOrder option may be used to control the order of the
#               generated track points when processing multiple files.
#------------------------------------------------------------------------------
#[IF]  \$gpslatitude \$gpslongitude
#[BODY]\$gpslatitude# \$gpslongitude# \$gpsaltitude# \${gpsdatetime#;my (\$ss)=/\.\d+/g;DateFmt("%Y-%m-%d %H:%M:%SZ");s/Z/\${ss}Z/ if \$ss} \$gpsspeed#
EOF
cat>gpx_wpt.fmt<<EOF
#------------------------------------------------------------------------------
# File:         gpx_wpt.fmt
#
# Description:  Example ExifTool print format file to generate GPX waypoints
#               with pictures
#
# Usage:        exiftool -p gpx_wpt.fmt -ee3 FILE [...] > out.gpx
#
# Requires:     ExifTool version 10.49 or later
#
# Revisions:    2010/03/13 - Peter Grimm created
#               2018/01/04 - PH Added IF to be sure position exists
#               2018/01/06 - PH Use DateFmt function instead of -d option
#               2019/10/24 - PH Preserve sub-seconds in GPSDateTime value
#
# Notes:     1) Input file(s) must contain GPSLatitude and GPSLongitude.
#            2) The -ee3 option is to extract the full track from video files.
#            3) The -fileOrder option may be used to control the order of the
#               generated track points when processing multiple files.
#            4) Coordinates are written at full resolution.  To change this,
#               remove the "#" from the GPSLatitude/Longitude tag names below
#               and use the -c option to set the desired precision.
#------------------------------------------------------------------------------
#[HEAD]<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
#[HEAD]<gpx version="1.1"
#[HEAD] creator="ExifTool $ExifToolVersion"
#[HEAD] xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
#[HEAD] xmlns="http://www.topografix.com/GPX/1/1"
#[HEAD] xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
#[IF]  \$gpslatitude \$gpslongitude
#[BODY]<wpt lat="\$gpslatitude#" lon="\$gpslongitude#">
#[BODY]  <ele>\$gpsaltitude#</ele>
#[BODY]  <time>\${gpsdatetime#;my (\$ss)=/\.\d+/g;DateFmt("%Y-%m-%dT%H:%M:%SZ");s/Z/\${ss}Z/ if \$ss}</time>
#[BODY]  <name>\$filename</name>
#[BODY]  <link href="\$directory/\$filename"/>
#[BODY]  <sym>Scenic Area</sym>
#[BODY]  <extensions>
#[BODY]    <gpxx:WaypointExtension xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3">
#[BODY]      <gpxx:DisplayMode>SymbolAndName</gpxx:DisplayMode>
#[BODY]    </gpxx:WaypointExtension>
#[BODY]  </extensions>
#[BODY]</wpt>
#[TAIL]</gpx>
EOF

/usr/local/exiftool/exiftool -ee3 -api largefilesupport -p gpx.fmt $name > tmpfile
/usr/local/exiftool/exiftool -ee3 -api largefilesupport -p gpx_wpt.fmt $name > $file_gpx
cat tmpfile | uniq > $file_gps
rm -rf tmpfile gpx.fmt $file_gpx


mkdir -p ../图像/$year_month_day$slipt$hour_minute_second
ffmpeg -i $name_mp4 -f image2 -q:v 1 -r 1 ../图像/$year_month_day$slipt$hour_minute_second/%d.jpg
#ffmpeg -i $name_mp4 -f image2 -q:v 2 -r 9.6777478782860691368246739805422 ../图像/%d.jpg
#ffmpeg -i $name_mp4 -f image2 -q:v 2 -r 3.33 -vf vflip -y ../图像/20230506_120554/%d.jpg
for ((i=1;i<`cat $file_gps | wc -l`;i++))
do     
	line=`cat $file_gps | head -n ${plus}${i} | tail -n ${plus}${i}`;    
	lat=`echo $line | awk -F " " '{ print $1}'`;     
	lon=`echo $line | awk -F " " '{ print $2}'`;     
	alt=`echo $line | awk -F " " '{ print $3}'`;
	/usr/local/exiftool/exiftool -P -GPSLongitudeRef=E -GPSLongitude=$lon -GPSLatitudeRef=N -GPSLatitude=$lat -GPSAltitudeRef=Above -GPSAltitude=$alt ../图像/$year_month_day$slipt$hour_minute_second/${i}${jpg};
done
rm -rf ../图像/$year_month_day$slipt$hour_minute_second/*.jpg_original
mv $file_gps ../结果/.
mv $file_gpx ../结果/.
done
