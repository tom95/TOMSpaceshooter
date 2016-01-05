cmake_minimum_required(VERSION 2.8)
project(spriteRenderer)
add_definitions(-fPIC)
add_library(spriteRenderer SHARED spriteRenderer.c)
set_target_properties(spriteRenderer
	PROPERTIES
	COMPILE_FLAGS "-m32"
	LINK_FLAGS "-m32")
