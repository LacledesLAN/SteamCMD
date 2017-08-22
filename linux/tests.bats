@test "Verify dependency bzip2 is installed" {
    run bzip2 --help
    [ $status = 0 ]
}

@test "Verify dependency curl is installed" {
    run curl --help
    [ $status = 0 ]
}

@test "Verify dependency git is installed" {
    run git help
    [ $status = 0 ]
}

@test "Verify dependency tar is installed" {
    run tar --help
    [ $status = 0 ]
}

@test "Verify dependency wget is installed" {
    run wget --help
    [ $status = 0 ]
}

@test "Verify SteamCMD runs" {
    run /app/steamcmd.sh +quit;
    [ $status = 0 ]
}
