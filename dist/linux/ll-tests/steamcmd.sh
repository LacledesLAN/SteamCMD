#!/bin/bash

echo -e "\n{{Running image tests for 'SteamCMD'}}";

echo "[Verifying builder image utilities are installed]";

{ bzip2 --version; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: Builder utility 'bzip2' must be installed";
    exit 1;
fi;

{ curl --version; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: Builder utility 'curl' must be installed";
    exit 1;
fi;

{ tar --version; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: Builder utility 'tar' must be installed";
    exit 1;
fi;

{ wget --version; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: Builder utility 'wget' must be installed";
    exit 1;
fi;

echo "OK";

echo -e "\n[Verifying SteamCMD dependencies are installed]";
{ dpkg -s ca-certificates; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: SteamCMD dependency 'ca-certificates' must be installed";
    exit 1;
fi;

{ dpkg -s lib32gcc1; } &> /dev/null;
if [ $? -ne 0 ]; then
    echo "ERROR: SteamCMD dependency 'lib32gcc1' must be installed";
    exit 1;
fi;
echo "OK";

echo -e "\n[Verifying that SteamCMD executes properly]";
{ timeout 12 /app/steamcmd.sh +quit; } &> /dev/null;

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
echo "OK"

echo -e "\n[Verifying /output directory exists]";
[ ! -d /output/ ] && echo "/output directory doesn't exist" && exit 1;
echo "OK"

echo -e "\n[Verifying that user can create files in the /output directory]";
touch /output/test1 /output/test2 /output/test3
[ ! -f /output/test1 ] && echo "/output/test1 does not exist" && exit 1;
[ ! -f /output/test2 ] && echo "/output/test2 does not exist" && exit 1;
[ ! -f /output/test3 ] && echo "/output/test3 does not exist" && exit 1;
echo "OK"

echo -e "\n[Verifying that user can delete files from /output directory]";
rm /output/test1 /output/test2 /output/test3
[ -f /output/test1 ] && echo "/output/test1 wasn't deleted" && exit 1;
[ -f /output/test2 ] && echo "/output/test2 wasn't deleted" && exit 1;
[ -f /output/test3 ] && echo "/output/test3 wasn't deleted" && exit 1;
echo "OK"

echo -e "ALL TESTS PASSED\nOK\n";
