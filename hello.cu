#include <stdio.h>

__device__ const char *STR = "HELLO WORLD!";
const char STR_LENGTH = 12;

__global__ void hello()
{
	
	printf("calling kernel\n");
	printf("%c\n", STR[threadIdx.x % STR_LENGTH]);
	printf("kernel called\n");
}

int main(void)
{
	int num_threads = STR_LENGTH;
	int num_blocks = 1;
	printf("before hello\n");
	hello<<<num_blocks,num_threads>>>();
	printf("after hello\n");
	cudaDeviceSynchronize();


{
    cudaError_t cudaerr = cudaDeviceSynchronize();
    if (cudaerr != cudaSuccess)
        printf("kernel launch failed with error \"%s\".\n",
               cudaGetErrorString(cudaerr));
}

	return 0;
}
