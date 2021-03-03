nvcc  -arch=sm_61 -std=c++11 -o a.out GPUvolatile.cu
./a.out
#nvcc  -arch=sm_61 -std=c++11 -o a.out swapTime.cu
#nvprof --print-gpu-trace ./a.out

#GPUvolatile.cu
