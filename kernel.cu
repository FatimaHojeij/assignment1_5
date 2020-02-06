
#include "common.h"
#include "timer.h"

__global__ void grav_kernel(float m0, float* m, float* r, float* F, int numBodies) {

    // TODO
	int i = blockDim.m*blockIdx.m + threadIdx.m;
	if(i<N){
		F[i] = G*m0*m[i]/(r[i]*r[i]);
	}
		
    




}

void grav_gpu(float m0, float* m, float* r, float* F, int numBodies) {

    Timer timer;

    // Allocate GPU memory
    startTime(&timer);

    // TODO
	float *m_d, *r_d, *F_d;
	cudaMalloc((void**) &m_d, numBodies*sizeof(float));
	cudaMalloc((void**) &r_d, numBodies*sizeof(float));
	cudaMalloc((void**) &F_d, numBodies*sizeof(float));





    cudaDeviceSynchronize();
    stopTime(&timer);
    printElapsedTime(timer, "Allocation time");

    // Copy data to GPU
    startTime(&timer);

    // TODO
	
	cudaMemcpy(m_d, m, numBodies*sizeof(float), cudaMemcpyHostToDevice); 
	cudaMemcpy(r_d, r, numBodies*sizeof(float), cudaMemcpyHostToDevice);



    cudaDeviceSynchronize();
    stopTime(&timer);
    printElapsedTime(timer, "Copy to GPU time");

    // Call kernel
    startTime(&timer);

    // TODO

	grav_kernel(m0, m, r, F, numBodies);




    cudaDeviceSynchronize();
    stopTime(&timer);
    printElapsedTime(timer, "Kernel time");

    // Copy data from GPU
    startTime(&timer);

    // TODO
	cudaMemcpy(F, F_d, numBodies*sizeof(float), cudaMemcpyDeviceToHost);





    cudaDeviceSynchronize();
    stopTime(&timer);
    printElapsedTime(timer, "Copy from GPU time");

    // Free GPU memory
    startTime(&timer);

    // TODO

	cudaFree(m_d); 
	cudaFree(r_d); 
	cudaFree(F_d);




    cudaDeviceSynchronize();
    stopTime(&timer);
    printElapsedTime(timer, "Deallocation time");

}

