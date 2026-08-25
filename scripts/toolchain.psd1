# The build toolchain, pinned. THE one place to edit when upgrading.
#
# scripts\fetch-jdk.ps1 and scripts\fetch-flutter.ps1 both read this file, and
# .gitlab-ci.yml calls those two scripts, so changing a version here is the whole
# upgrade: CI follows on the next pipeline with nothing else to touch.
#
# Everything is an exact version, never a channel head or "latest". A moving pin would
# let the toolchain change under a commit that has nothing to do with it - and for the
# JDK it decides the LICENCE of the runtime we ship (see fetch-jdk.ps1), so "whatever
# was current that day" is not an acceptable answer to what is inside an installer.
#
# Read with Import-PowerShellDataFile, so this file may contain data only - no code.

@{
    # ── Eclipse Temurin JDK ───────────────────────────────────────────────────
    # Upgrading: pick the release, then copy the archive name and its published
    # SHA256 from the same page. The checksum is not optional - it is what makes an
    # automated download safe to compile and ship from.
    #   https://github.com/adoptium/temurin25-binaries/releases
    Jdk = @{
        Version = '25.0.4.1+1'
        DirName = 'jdk-25.0.4.1+1'   # the directory name inside the archive
        Archive = 'OpenJDK25U-jdk_x64_windows_hotspot_25.0.4.1_1.zip'
        Sha256  = '00c847d804f4a78e9f04f2683faf14fed898535b177b7fc704486cb0284e9283'
        BaseUrl = 'https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.4.1%2B1'
    }

    # ── Flutter SDK ───────────────────────────────────────────────────────────
    # Version is a git tag on flutter/flutter, which is what pins it; Dart is not
    # fetched separately, it ships inside the SDK. DartVersion is recorded so a
    # mismatch is visible rather than silent, and is not used to fetch anything.
    #   https://docs.flutter.dev/release/archive
    Flutter = @{
        Version     = '3.44.8'
        Channel     = 'stable'
        DartVersion = '3.12.2'
        Repo        = 'https://github.com/flutter/flutter.git'
    }
}
