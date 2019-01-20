nvcc  -arch=sm_61 -std=c++11 -o a.out "$1"
CUDA_VISIBLE_DEVICES=2 ./a.out
