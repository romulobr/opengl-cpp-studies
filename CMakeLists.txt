#----------------------------------------------------------------------
#
#----------------------------------------------------------------------
cmake_minimum_required(VERSION 2.8)

set(CMAKE_CXX_COMPILER "g++")
set(PROJ_NAME myapp)

project(${PROJ_NAME})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

#set up linux search paths
set(LIBRARY_SEARCH_PATH
  /usr/local
  /opt/local
  /usr
  /opt
)

set(HEADER_SEARCH_PATH
  /usr/local
  /opt/local
  /usr
  /opt
)

# Find OpenGL
find_package(OpenGL)
find_package(X11)


# Find glfw header
find_path(GLFW_INCLUDE_DIR GLFW/glfw3.h ${HEADER_SEARCH_PATH})

# Include directories for this project
set(INCLUDE_PATH
  ${OPENGL_INCLUDE_DIR}
  ${GLFW_INCLUDE_DIR}
)


if(UNIX)
  find_path(GLEW_INCLUDE_DIR GL/glew.h ${HEADER_SEARCH_PATH})
  set(INCLUDE_PATH ${INCUDE_PATH} ${GLEW_INCLUDE_DIR})
  find_library(GLFW_LIBRARIES glfw3 ${LIBRARY_SEARCH_PATH})
endif()

if(UNIX AND NOT APPLE)
  set(LIBRARIES
  ${OPENGL_LIBRARIES}
  ${GLFW_LIBRARIES}
  ${X11_LIBRARIES}
  ${CMAKE_SOURCE_DIR}/lib/linux/libsoil2-linux-debug.a
  -lGL
  -lX11
  -lXi
  -lXrandr
  -lXxf86vm
  -lXinerama
  -lXcursor
  -lrt
  -lGLEW
  -lglfw3
  -lm
  -pthread
  -ldl)
endif(UNIX AND NOT APPLE)

if(APPLE)
  set(LIBRARIES
  ${OPENGL_LIBRARIES}
  ${GLFW_LIBRARIES}
  ${CMAKE_SOURCE_DIR}/lib/apple/libsoil2-apple-debug.a
  -lGLEW
  -lglfw3
  -lm
  -pthread
  -ldl
  -lgsl
  "-framework CoreFoundation")
endif(APPLE)

include_directories ("${PROJECT_SOURCE_DIR}/include")


file(GLOB SOURCES
    include/*.h
    include/**/*.h
    src/*.cpp
    src/*.c
)

# Add a target executable
add_executable(${PROJ_NAME}
  ${SOURCES}
)

# Libraries to be linked
target_link_libraries(${PROJ_NAME}
  ${LIBRARIES}
)

link_directories(${CMAKE_SOURCE_DIR}/lib)

target_compile_features(${PROJ_NAME} PRIVATE cxx_range_for)
