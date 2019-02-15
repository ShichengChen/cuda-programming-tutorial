#include <vector>
#include <algorithm>
#include <cstdio>
#include <iostream>
#include <chrono>
#include <fstream>
#include <nvml.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
const long long tdelay=1000000LL;
#define SIZE  1
__global__ void dkern(){

    long long start = clock64();
    while(clock64() < start+tdelay);
}
using namespace std;

int main() {
    //freopen ("swapinout.txt","w",stdout);
//    {
//        int my_delay = 100;
//        for (int i = 0; ; i++){
//            dkern<<<1,1>>>();
//            usleep(my_delay);
//        }
//    }





    int nDevices;

    cudaGetDeviceCount(&nDevices);
    for (int i = 0; i < nDevices; i++) {
        cudaDeviceProp prop;
        cudaGetDeviceProperties(&prop, i);
        printf("Device Number: %d\n", i);
        printf("  Device name: %s\n", prop.name);
        printf("  Memory Clock Rate (KHz): %d\n",
               prop.memoryClockRate);
        printf("  Memory Bus Width (bits): %d\n",
               prop.memoryBusWidth);
        printf("  Peak Memory Bandwidth (GB/s): %f\n\n",
               2.0*prop.memoryClockRate*(prop.memoryBusWidth/8)/1.0e6);
        cout << " deviceOverlap: " << prop.deviceOverlap << endl;
        cout << " asyncEngineCount: " << prop.asyncEngineCount << endl;

    }


    while(true)
    {
        int s[] = {1,4718592,9437184};
        cout << "size,in,out" << endl;
        for (int i = 0;i < 2;i++){
            long long size = s[i];
            void *hostArray=(void*)0;
            cudaMallocHost(&hostArray,size);
            void *deviceArray=(void*)0;
            cudaMalloc((void**)&deviceArray,size);


            long long a0 = std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
            cudaMemcpy(deviceArray,hostArray,size,cudaMemcpyHostToDevice);
            long long b0 = std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
            cudaMemcpy(hostArray,deviceArray,size,cudaMemcpyDeviceToHost);
            long long c0 = std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
            cout <<s[i]<< ","<<b0-a0 << "," << c0-b0 << endl;

        }
        break;
    }




    return 0;
}