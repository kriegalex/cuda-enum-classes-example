cmake_minimum_required(VERSION 3.9)
project(cuda_enum_classes_example CXX CUDA)

# Only to help your IDE, compiler doesn't need it
include_directories(${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES})
set(SOURCE_FILES main.cu managed.h enum.h cuda_helper.h dummy.cpp)
add_executable(cuda_enum_classes_example ${SOURCE_FILES})

# Request to be built with -std=c++11
# As this is a public compile feature anything that links to
# it will also build with -std=c++11
target_compile_features(cuda_enum_classes_example PUBLIC cxx_std_11)