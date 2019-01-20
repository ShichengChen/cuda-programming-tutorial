#include <vector>
#include <algorithm>
#include <cstdio>
#include <iostream>
#include <chrono>
#include <fstream>
#define SIZE  1
using namespace std;

int main() {
    freopen ("swapinout.txt","w",stdout);
    int s[] = {1228800 ,26214400, 26214400, 26214400, 26214400, 26214400 ,26214400  ,6553600,
               13107200, 13107200, 13107200, 13107200 ,13107200 ,13107200 , 3276800 , 1179648,
               6553600 , 6553600 , 6553600 , 2359296 , 6553600 , 6553600 , 6553600 , 2359296,
               6553600 , 6553600 , 6553600 , 1638400 , 4718592 , 3276800 , 3276800 , 3276800,
               9437184 , 3276800 , 3276800 , 1048576 , 1048576 , 9437184 , 9437184 , 9437184,
               9437184 , 9437184 , 9437184 , 9437184 , 3276800 , 9437184 , 3276800};
    cout << "size,in,out" << endl;
    for (int i = 0;i < 47;i++){
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



    return 0;
}