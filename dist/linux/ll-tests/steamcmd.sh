#!/bin/bash

echo -e "\n[[ Running lacledeslan/SteamCMD tests ]]\n";

echo -e "Verifying utilities are installed...";

{ bzip2 --version; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: Utility 'bzip2' should be installed";
    exit 1;
fi;

{ curl --version; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: Utility 'curl' should be installed";
    exit 1;
fi;

{ tar --version; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: Utility 'tar' should be installed";
    exit 1;
fi;

{ wget --version; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: Utility 'wget' should be installed";
    exit 1;
fi;

{ xz --version; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: Utility 'xz-utils' should be installed";
    exit 1;
fi;

echo -e "OK\n";

echo -e "Verifying SteamCMD dependencies are installed...";
{ dpkg -s ca-certificates; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: SteamCMD dependency 'ca-certificates' must be installed";
    exit 1;
fi;

{ dpkg -s lib32gcc-s1; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: SteamCMD dependency 'lib32gcc1' must be installed";
    exit 1;
fi;

{ dpkg -s locales; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: SteamCMD dependency 'locales' must be installed";
    exit 1;
fi;

echo -e "OK\n";

echo -e "Verifying SteamCMD executes properly...";
declare outfile="/app/ll-tests/teststeamcmd-$(date '+%H%M%S').txt"

{ timeout 14 /app/steamcmd.sh +quit; } &> "$outfile";

if [ $? -ne 0 ] ; then
    if [ $? -eq 124 ] ; then
        echo -e "\nERROR: SteamCMD timed out.\n\n";
        echo "If you are running Docker for Mac/Windows and SteamCMD indiciates connectivity problems this is likely due to a Docker configuration issue. Check your MobyLinuxVM's network adapter settings."
        echo -e "\n\n"
    else
        echo -e "\nERROR: SteamCMD exited with error code $?";
    fi;

    exit 1;
fi;

[ ! -f "$outfile" ] && { echo "Testing error: $0 steamcmd output file not found."; exit 2; }

if grep -i -q "International characters may not work." "$outfile"; then
    echo -e "\nERROR: SteamCMD can't find character encoding locale.\n\n";
    cat "$outfile"
    exit 1;
fi;

echo -e "OK\n";

echo -e "Verifying /output directory settings...";

[ ! -d /output/ ] && echo "/output directory doesn't exist" && exit 1;

touch /output/test1 /output/test2 /output/test3
[ ! -f /output/test1 ] && echo "Test file /output/test1 was not created" && exit 1;
[ ! -f /output/test2 ] && echo "Test file /output/test2 was not created" && exit 1;
[ ! -f /output/test3 ] && echo "Test file /output/test3 was not created" && exit 1;

rm /output/test1 /output/test2 /output/test3
[ -f /output/test1 ] && echo "Test file /output/test1 wasn't deleted" && exit 1;
[ -f /output/test2 ] && echo "Test file /output/test2 wasn't deleted" && exit 1;
[ -f /output/test3 ] && echo "Test file /output/test3 wasn't deleted" && exit 1;

echo -e "OK\n";

cat "$outfile";

echo -e "\n[ALL TESTS PASSED]\n";
