add_definitions(-fPIC)
add_library(spriteRenderer SHARED spriteRenderer.c)
set_target_properties(spriteRenderer
	PROPERTIES
	COMPILE_FLAGS "-m32"
	LINK_FLAGS "-m32"
	LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../../../Linux-i686/lib/squeak/5.0-3427)
