# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /usr/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /gpfs/home/pgersberg/libeigen

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /gpfs/home/pgersberg/libeigen/buikd_dir

# Include any dependencies generated for this target.
include test/CMakeFiles/vectorwiseop_5.dir/depend.make

# Include the progress variables for this target.
include test/CMakeFiles/vectorwiseop_5.dir/progress.make

# Include the compile flags for this target's objects.
include test/CMakeFiles/vectorwiseop_5.dir/flags.make

test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o: test/CMakeFiles/vectorwiseop_5.dir/flags.make
test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o: ../test/vectorwiseop.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /gpfs/home/pgersberg/libeigen/buikd_dir/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o"
	cd /gpfs/home/pgersberg/libeigen/buikd_dir/test && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o -c /gpfs/home/pgersberg/libeigen/test/vectorwiseop.cpp

test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.i"
	cd /gpfs/home/pgersberg/libeigen/buikd_dir/test && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /gpfs/home/pgersberg/libeigen/test/vectorwiseop.cpp > CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.i

test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.s"
	cd /gpfs/home/pgersberg/libeigen/buikd_dir/test && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /gpfs/home/pgersberg/libeigen/test/vectorwiseop.cpp -o CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.s

test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o.requires:
.PHONY : test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o.requires

test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o.provides: test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o.requires
	$(MAKE) -f test/CMakeFiles/vectorwiseop_5.dir/build.make test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o.provides.build
.PHONY : test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o.provides

test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o.provides.build: test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o

# Object files for target vectorwiseop_5
vectorwiseop_5_OBJECTS = \
"CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o"

# External object files for target vectorwiseop_5
vectorwiseop_5_EXTERNAL_OBJECTS =

test/vectorwiseop_5: test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o
test/vectorwiseop_5: test/CMakeFiles/vectorwiseop_5.dir/build.make
test/vectorwiseop_5: test/CMakeFiles/vectorwiseop_5.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable vectorwiseop_5"
	cd /gpfs/home/pgersberg/libeigen/buikd_dir/test && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/vectorwiseop_5.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
test/CMakeFiles/vectorwiseop_5.dir/build: test/vectorwiseop_5
.PHONY : test/CMakeFiles/vectorwiseop_5.dir/build

test/CMakeFiles/vectorwiseop_5.dir/requires: test/CMakeFiles/vectorwiseop_5.dir/vectorwiseop.cpp.o.requires
.PHONY : test/CMakeFiles/vectorwiseop_5.dir/requires

test/CMakeFiles/vectorwiseop_5.dir/clean:
	cd /gpfs/home/pgersberg/libeigen/buikd_dir/test && $(CMAKE_COMMAND) -P CMakeFiles/vectorwiseop_5.dir/cmake_clean.cmake
.PHONY : test/CMakeFiles/vectorwiseop_5.dir/clean

test/CMakeFiles/vectorwiseop_5.dir/depend:
	cd /gpfs/home/pgersberg/libeigen/buikd_dir && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /gpfs/home/pgersberg/libeigen /gpfs/home/pgersberg/libeigen/test /gpfs/home/pgersberg/libeigen/buikd_dir /gpfs/home/pgersberg/libeigen/buikd_dir/test /gpfs/home/pgersberg/libeigen/buikd_dir/test/CMakeFiles/vectorwiseop_5.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : test/CMakeFiles/vectorwiseop_5.dir/depend
