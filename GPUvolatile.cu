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
    {
        int my_delay = 100;
        for (int i = 0;i<100 ; i++){
            dkern<<<1,1>>>();
            usleep(my_delay);
        }
    }





    return 0;
}