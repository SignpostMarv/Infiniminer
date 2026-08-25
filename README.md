# Infiniminer

> [!IMPORTANT]
> This readme is currently out-of-date and is still being updated for
> contemporary development.

## Building

Building Infiniminer requires Visual Studio 2026 and/or a [devcontainer-supporting IDE](https://github.com/SignpostMarv/Infiniminer/tree/main).

You'll also need the fonts 04b03b and 04b08 from the following site:

http://www.dsg4.com/04/extra/bitmap/

### Content

The content pipeline was removed in favour of command-line usage.

Run `dotnet tool install -g dotnet-mgcb` to obtain mgcb.

The mgcb configs are currently split in two, because of a Windows dependency
in ensuring the shaders compile.

Attempts were made to get the shaders to cross-compile from Linux to Windows,
but these proved too frustrating to continue pursuing.

1. Load the project within a devcontainer-supporting IDE
2. run `make build--mgcb`
3. Switch to a Windows terminal and `cd` to the `mgcb` folder
4. run `.\shaders.bat`
5. You may now trigger builds in either your devcontainer or Visual Studio.


## Patcing and Issue Tracking

The official branch is maintained by Zach Barth of Zachtronics Industries.

Please push all patches and log all issues to the following branch:

http://github.com/krispykrem/Infiniminer/tree/master

http://www.zachtronicsindustries.com
