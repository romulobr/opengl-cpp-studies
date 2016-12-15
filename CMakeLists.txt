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


# Libraries needed on all platforms for this project
set(LIBRARIES
  ${OPENGL_LIBRARIES}
  ${ADDITIONAL_LIBS}
)

if(UNIX)
  find_path(GLEW_INCLUDE_DIR GL/glew.h ${HEADER_SEARCH_PATH})
  set(INCLUDE_PATH ${INCUDE_PATH} ${GLEW_INCLUDE_DIR})
  find_library(GLFW_LIBRARIES glfw3 ${LIBRARY_SEARCH_PATH})
  set( ADDITIONAL_LIBS -lGLEW -lglfw3 -lm -pthread -ldl)
endif()

if(UNIX AND NOT APPLE)
  set(LIBRARIES ${LIBRARIES} ${GLFW_LIBRARIES} ${X11_LIBRARIES} ${CMAKE_SOURCE_DIR}/lib/libsoil2-linux-debug.a -lGL -lX11 -lXi -lXrandr -lXxf86vm -lXinerama -lXcursor -lrt)
elseif(APPLE)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -v -stdlib=libc++")
  set(CMAKE_EXE_LINKER_FLAGS "-bind_at_load -framework CoreFoundation -w")
  set(LIBRARIES ${LIBRARIES} ${GLFW_LIBRARIES} ${X11_LIBRARIES} ${CMAKE_SOURCE_DIR}/lib/libsoil2-windows-debug.a)
else()

endif ()


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

target_compile_features(${PROJ_NAME} PRIVATE cxx_range_for)
