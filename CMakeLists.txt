cmake_minimum_required(VERSION 3.12)
project(cudaProgram C)

set(CMAKE_C_STANDARD 99)
enable_language(CUDA)
project(swapTime.cu CUDA CXX)
add_executable(cudaProgram coutVector.cpp)
#add_executable(cudaProgram main.c ConstVector.cpp coutVector.cpp)