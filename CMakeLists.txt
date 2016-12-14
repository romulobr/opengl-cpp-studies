#----------------------------------------------------------------------
#
#----------------------------------------------------------------------
cmake_minimum_required(VERSION 2.8)


set(PROJ_NAME myapp)

project(${PROJ_NAME})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -v -stdlib=libc++")

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


# Find glfw library
find_library(GLFW_LIBRARIES glfw3 ${LIBRARY_SEARCH_PATH})

find_package(GLEW REQUIRED)
if (GLEW_FOUND)
    include_directories(${GLEW_INCLUDE_DIRS})
    link_libraries(${GLEW_LIBRARIES})
endif()


# Set additional libs
set( ADDITIONAL_LIBS
    -lGLEW -lglfw3 -lm -pthread -ldl
)


# Include directories for this project
set(INCLUDE_PATH
  ${OPENGL_INCLUDE_DIR}
  ${GLFW_INCLUDE_DIR}
)


# Libraries needed on all platforms for this project
set(LIBRARIES
  ${OPENGL_LIBRARIES}
  ${GLFW_LIBRARIES}
  ${X11_LIBRARIES}
  ${ADDITIONAL_LIBS}
)

if(UNIX AND NOT APPLE)
  set(LIBRARIES ${LIBRARIES} ${CMAKE_SOURCE_DIR}/lib/libsoil2-linux-debug.a)
  set( ADDITIONAL_LIBS
      -lGL -lX11 -lXi -lXrandr -lXxf86vm -lXinerama -lXcursor -lrt
  )
else()
  SET(CMAKE_EXE_LINKER_FLAGS "-bind_at_load -framework CoreFoundation -w")
  set(LIBRARIES ${LIBRARIES} ${CMAKE_SOURCE_DIR}/lib/libsoil2-apple-debug.a)
endif ()


# Windows and Linux need GLEW, the OpenGL Extension Wrangler
find_path(GLEW_INCLUDE_DIR GL/glew.h
    ${HEADER_SEARCH_PATH}
)


set(INCLUDE_PATH ${INCUDE_PATH}
    ${GLEW_INCLUDE_DIR}
)

 include_directories ("${PROJECT_SOURCE_DIR}/include")


file(GLOB SOURCES
    include/*.h
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
