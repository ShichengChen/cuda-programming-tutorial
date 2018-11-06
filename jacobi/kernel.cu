#include "definitions.cuh"
#include "stdio.h"
#define RADIUS 1
//Performs CFD calculation on global memory. This code does not use any advance optimization technique on GPU
// But still acheives many fold performance gain
__global__ void calculateCFD_V1( float* input,  float* output, unsigned int Ni, unsigned int Nj,
								 float h)
{
	unsigned int i = blockDim.x * blockIdx.x + threadIdx.x; // Y - ID
	unsigned int j = blockDim.y * blockIdx.y + threadIdx.y; // X - ID

	unsigned int iPrev = i-1; // Previous Y element
	unsigned int iNext = i+1; // Next Y element

	unsigned int jPrev = j-1; //Previous X element
	unsigned int jNext = j+1; // Next X element


	unsigned int index = i * Nj + j;

	if( i > 0 && j > 0 && i < (Ni-1) && j <(Nj-1))
		output[index] = 0.25f * (input[iPrev * Nj + j] + input[iNext* Nj + j] + input[i * Nj+ jPrev]
								 + input[i* Nj + jNext] - 4*h*h);
}

//This version of Kernel uses optimization by copying the data into shared memory and hence results in better performance
__global__ void calculateCFD_V2( float* input,  float* output, unsigned int Ni, unsigned int Nj, 
								   float h){

	//printf("\nthread_per_block:x:%d,y:%d\n",blockDim.x,blockDim.y);
	//32,16
	//Current Global ID
	unsigned int i = blockDim.x * blockIdx.x + threadIdx.x; // Y - ID
	unsigned int j = blockDim.y * blockIdx.y + threadIdx.y; // X - ID

	unsigned int xlindex = threadIdx.x+RADIUS;
	unsigned int ylindex = threadIdx.y+RADIUS;
	// Fill the size of shared memory
	__shared__ float sData [2*RADIUS+THREADS_PER_BLOCK_X][2*RADIUS+THREADS_PER_BLOCK_Y];

    unsigned int index = (i)* Nj + (j) ;
    sData[xlindex][ylindex] = input[index];

	if (threadIdx.x < RADIUS) {
		if(blockIdx.x > 0)
			sData[xlindex - RADIUS][ylindex] = input[index-Ni*RADIUS];
		if(blockIdx.x < (gridDim.x-1))
			sData[xlindex + THREADS_PER_BLOCK_X][ylindex] = input[index + THREADS_PER_BLOCK_X*Ni];
	}
	if (threadIdx.y < RADIUS)
	{
        if(blockIdx.y > 0)
	        sData[xlindex][ylindex - RADIUS] = input[index - RADIUS];
        if(blockIdx.y < (gridDim.y - 1))
        sData[xlindex][ylindex + THREADS_PER_BLOCK_Y] = input[index + THREADS_PER_BLOCK_Y];
	}



	__syncthreads();
	//Add synchronization. Guess Why?

	if( i > 0 && j > 0 && i < (Ni-1) && j <(Nj-1))
		output[index] = 0.25f * (sData[xlindex-1][ylindex] + sData[xlindex+1][ylindex] + sData[xlindex][ylindex-1]
			+ sData[xlindex][ylindex+1] - 4*h*h);

}

/*
 __global__ void calculateCFD_V2( float* input,  float* output, unsigned int Ni, unsigned int Nj,
								   float h){

	//printf("\nthread_per_block:x:%d,y:%d\n",blockDim.x,blockDim.y);
	//32,16
	//Current Global ID
	unsigned int j = blockDim.x * blockIdx.x + threadIdx.x; // Y - ID
	unsigned int i = blockDim.y * blockIdx.y + threadIdx.y; // X - ID

	unsigned int xlindex = threadIdx.x+RADIUS;
	unsigned int ylindex = threadIdx.y+RADIUS;
	// Fill the size of shared memory
	__shared__ float sData [2*RADIUS+THREADS_PER_BLOCK_Y][2*RADIUS+THREADS_PER_BLOCK_X];

    unsigned int index = (i)* Nj + (j) ;
    sData[ylindex][xlindex] = input[index];

	if (threadIdx.x < RADIUS) {
		if(blockIdx.x > 0)
			sData[ylindex][xlindex - RADIUS] = input[index-RADIUS];
		if(blockIdx.x < (gridDim.x-1))
			sData[ylindex][xlindex + THREADS_PER_BLOCK_X] = input[index + THREADS_PER_BLOCK_X];
	}
	if (threadIdx.y < RADIUS)
	{
        if(blockIdx.y > 0)
	        sData[ylindex - RADIUS][xlindex] = input[index - RADIUS*Ni];
        if(blockIdx.y < (gridDim.y - 1))
            sData[ylindex + THREADS_PER_BLOCK_Y][xlindex] = input[index + THREADS_PER_BLOCK_Y*Ni];
	}



	__syncthreads();
	//Add synchronization. Guess Why?

	if( i > 0 && j > 0 && i < (Ni-1) && j <(Nj-1))
		output[index] = 0.25f * (sData[ylindex-1][xlindex] + sData[ylindex+1][xlindex] + sData[ylindex][xlindex-1]
			+ sData[ylindex][xlindex+1] - 4*h*h);

}
 */