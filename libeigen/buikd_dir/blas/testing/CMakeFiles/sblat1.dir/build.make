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
include blas/testing/CMakeFiles/sblat1.dir/depend.make

# Include the progress variables for this target.
include blas/testing/CMakeFiles/sblat1.dir/progress.make

# Include the compile flags for this target's objects.
include blas/testing/CMakeFiles/sblat1.dir/flags.make

blas/testing/CMakeFiles/sblat1.dir/sblat1.f.o: blas/testing/CMakeFiles/sblat1.dir/flags.make
blas/testing/CMakeFiles/sblat1.dir/sblat1.f.o: ../blas/testing/sblat1.f
	$(CMAKE_COMMAND) -E cmake_progress_report /gpfs/home/pgersberg/libeigen/buikd_dir/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building Fortran object blas/testing/CMakeFiles/sblat1.dir/sblat1.f.o"
	cd /gpfs/home/pgersberg/libeigen/buikd_dir/blas/testing && /usr/bin/gfortran  $(Fortran_DEFINES) $(Fortran_FLAGS) -c /gpfs/home/pgersberg/libeigen/blas/testing/sblat1.f -o CMakeFiles/sblat1.dir/sblat1.f.o

blas/testing/CMakeFiles/sblat1.dir/sblat1.f.o.requires:
.PHONY : blas/testing/CMakeFiles/sblat1.dir/sblat1.f.o.requires

blas/testing/CMakeFiles/sblat1.dir/sblat1.f.o.provides: blas/testing/CMakeFiles/sblat1.dir/sblat1.f.o.requires
	$(MAKE) -f blas/testing/CMakeFiles/sblat1.dir/build.make blas/testing/CMakeFiles/sblat1.dir/sblat1.f.o.provides.build
.PHONY : blas/testing/CMakeFiles/sblat1.dir/sblat1.f.o.provides

blas/testing/CMakeFiles/sblat1.dir/sblat1.f.o.provides.build: blas/testing/CMakeFiles/sblat1.dir/sblat1.f.o

# Object files for target sblat1
sblat1_OBJECTS = \
"CMakeFiles/sblat1.dir/sblat1.f.o"

# External object files for target sblat1
sblat1_EXTERNAL_OBJECTS =

blas/testing/sblat1: blas/testing/CMakeFiles/sblat1.dir/sblat1.f.o
blas/testing/sblat1: blas/testing/CMakeFiles/sblat1.dir/build.make
blas/testing/sblat1: blas/libeigen_blas.so
blas/testing/sblat1: blas/testing/CMakeFiles/sblat1.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking Fortran executable sblat1"
	cd /gpfs/home/pgersberg/libeigen/buikd_dir/blas/testing && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/sblat1.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
blas/testing/CMakeFiles/sblat1.dir/build: blas/testing/sblat1
.PHONY : blas/testing/CMakeFiles/sblat1.dir/build

blas/testing/CMakeFiles/sblat1.dir/requires: blas/testing/CMakeFiles/sblat1.dir/sblat1.f.o.requires
.PHONY : blas/testing/CMakeFiles/sblat1.dir/requires

blas/testing/CMakeFiles/sblat1.dir/clean:
	cd /gpfs/home/pgersberg/libeigen/buikd_dir/blas/testing && $(CMAKE_COMMAND) -P CMakeFiles/sblat1.dir/cmake_clean.cmake
.PHONY : blas/testing/CMakeFiles/sblat1.dir/clean

blas/testing/CMakeFiles/sblat1.dir/depend:
	cd /gpfs/home/pgersberg/libeigen/buikd_dir && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /gpfs/home/pgersberg/libeigen /gpfs/home/pgersberg/libeigen/blas/testing /gpfs/home/pgersberg/libeigen/buikd_dir /gpfs/home/pgersberg/libeigen/buikd_dir/blas/testing /gpfs/home/pgersberg/libeigen/buikd_dir/blas/testing/CMakeFiles/sblat1.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : blas/testing/CMakeFiles/sblat1.dir/depend
