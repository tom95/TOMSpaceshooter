cmake_minimum_required(VERSION 2.8)
project(controller)
add_definitions(-fPIC)
add_library(controller SHARED controller.c)
target_link_libraries(controller udev)
set_target_properties(controller
	PROPERTIES
	COMPILE_FLAGS "-m32"
	LINK_FLAGS "-m32"
	LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../../../Linux-i686/lib/squeak/5.0-3427)
