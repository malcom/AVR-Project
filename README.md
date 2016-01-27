## AVR project template for Visual Studio IDE

This is a simple empty project template for creating AVR software on Visual
Studio IDE.

The project is based on standard VS *Makefile Project* and uses **GNU Makefile**
for managing all built process steps. So other 'nix tools like collection of
basic file, shell and text manipulation utilities may be required. You can use
a package from **GnuWin32**, **MinGW**, **MSYS** or **Cygwin** project.
The `build.cmd` script also requires `sed` to converts GCC warning/error message
style to the format used by Visual Studio, to correct interpretations by the IDE.

Of course, most of all, the **AVR-GCC** toolchain and **GNU binutils** is
required, I recommend [Atmel AVR Toolchain for Windows](http://www.atmel.com/tools/ATMELAVRTOOLCHAINFORWINDOWS.aspx),
and they must be visible in the system (corresponding entries in the `PATH`
system variable).

To make use of full VS and *IntelliSense* possibilities, it is necessary to set
the system variable `AVR_TOOLCHAIN_INCLUDE` to the dirs with headers from
**AVR-GCC** toolchains or to change directly the `Include Directories` project
settings. Every include paths (`INC_PATH`) and macro definitions (`DEFS`) from
`Makefile` should be also added to the corresponding items in project settings.

The `Makefile` from this project can be used independently in other projects,
and based on tools from the GNU project, also without any problem on other
platforms.

The best options of installation is to clone the repo directly to the place
where Visual Studio keeps the templates. In most cases they are in user
documents dir, you can find out where exactly in the settings of your
installation.

```
git clone https://github.com/malcom/AVR-Project.git \
	"%USERPROFILE%\Documents\Visual Studio 20XX\Templates\ProjectTemplates\AVR-Project"
```

The `Makefile` is only a skeleton, it contains base settings and definitions
used in most projects. It will be updated when every other stuff will be needed.

Released under the [MIT License](http://opensource.org/licenses/MIT).
