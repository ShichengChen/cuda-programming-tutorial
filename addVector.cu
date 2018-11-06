#include <stdio.h>

/* experiment with N */
/* how large can it be? */
#define N (2048*2048)
#define THREADS_PER_BLOCK 512


__global__ void vector_add(int *a, int *b, int *c)
{
    /* insert code to calculate the index properly using blockIdx.x, blockDim.x, threadIdx.x */
    int index = int(blockIdx.x) * int(blockDim.x) + int(threadIdx.x);
    //printf("block dim:%d,%d,blockid:%d,threadidx.x:%d\n",blockDim.x,blockDim.y,blockIdx.x,threadIdx.x);
    //printf("index:%d\n",index);
    c[index] = a[index] + b[index];
    if(index >= N - 1)
    {
        printf("%d\n",index);
        printf("%d,%d,%d\n",a[index],b[index],c[index]);
    }
}


int main()
{
    int *a, *b, *c;
    int *d_a, *d_b, *d_c;

    int size = N * sizeof( int );

    /* allocate space for device copies of a, b, c */
    cudaMalloc( (void **) &d_a, size );
    cudaMalloc( (void **) &d_b, size );
    cudaMalloc( (void **) &d_c, size );

    /* allocate space for host copies of a, b, c and setup input values */

    a = (int *)malloc( size );
    b = (int *)malloc( size );
    c = (int *)malloc( size );

    for( int i = 0; i < N; i++ )
    {
        a[i] = b[i] = i;
        c[i] = 0;
    }

    /* copy inputs to device */
    /* fix the parameters needed to copy data to the device */
    cudaMemcpy(d_a,a,size,cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,b,size,cudaMemcpyHostToDevice);

    /* launch the kernel on the GPU */
    /* insert the launch parameters to launch the kernel properly using blocks and threads */
    vector_add<<< N/THREADS_PER_BLOCK, THREADS_PER_BLOCK >>>( d_a, d_b, d_c );

    /* copy result back to host */
    /* fix the parameters needed to copy data back to the host */
    cudaMemcpy(c,d_c,size,cudaMemcpyDeviceToHost);


    printf( "c[0] = %d\n",c[0] );
    printf( "c[%d] = %d\n",N-1, c[N-1] );

    /* clean up */
    {
        cudaError_t cudaerr = cudaDeviceSynchronize();
        if (cudaerr != cudaSuccess)
            printf("kernel launch failed with error \"%s\".\n",
                   cudaGetErrorString(cudaerr));
    }

    free(a);
    free(b);
    free(c);
    cudaFree( d_a );
    cudaFree( d_b );
    cudaFree( d_c );

    return 0;
} /* end main */