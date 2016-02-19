#link_directories(${CMAKE_CURRENT_SOURCE_DIR}/fmodstudioapi10706linux/api/lowlevel/lib/x86)
#include_directories(${CMAKE_CURRENT_SOURCE_DIR}/fmodstudioapi10706linux/api/lowlevel/inc)
#add_definitions(-fPIC)

#add_library(fmod SHARED libfmod.c)
#add_executable(fmod libfmod.c)

#set_target_properties(fmod
#PROPERTIES
#COMPILE_FLAGS "-m32"
#LINK_FLAGS "-m32"
#LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../../../Linux-i686/lib/squeak/5.0-3427)
#target_link_libraries(fmod libfmodL.so)

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/fmodstudioapi10706linux/api/lowlevel/lib/x86
	DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/../../../Linux-i686/lib/squeak/5.0-3427)
