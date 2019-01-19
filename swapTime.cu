#include <vector>
#include <algorithm>
#include <cstdio>
#include <iostream>
#include <chrono>
#include <fstream>
#define SIZE  1
using namespace std;

int main() {
    int *a,*b,*c;
    long long a0 = std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
    cudaMallocManaged(&a, SIZE * sizeof(int));
    long long b0 = std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
    cudaMallocManaged(&b, SIZE * sizeof(int));
    long long c0 = std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
    cudaMallocManaged(&c, SIZE * sizeof(int));
    long long d0 = std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
    cout<<"d-c:" << d0-c0<< endl;
    cudaFree(a);
    cudaFree(b);
    cudaFree(c);
    return 0;
}