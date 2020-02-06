
#include "common.h"
#include "timer.h"

void grav_cpu(float m0, float* m, float* r, float* F, int numBodies) {
    for(unsigned int i = 0; i < numBodies; ++i) {
        F[i] = G*m0*m[i]/(r[i]*r[i]);
    }
}

int main(int argc, char**argv) {

    cudaDeviceSynchronize();

    // Allocate memory and initialize data
    Timer timer;
    float m0 = rand();
    unsigned int numBodies = (argc > 1)?(atoi(argv[1])):1048576;
    float* m = (float*) malloc(numBodies*sizeof(float));
    float* r = (float*) malloc(numBodies*sizeof(float));
    float* F_cpu = (float*) malloc(numBodies*sizeof(float));
    float* F_gpu = (float*) malloc(numBodies*sizeof(float));
    for (unsigned int i = 0; i < numBodies; ++i) {
        m[i] = rand();
        r[i] = rand();
    }

    // Compute on CPU
    startTime(&timer);
    grav_cpu(m0, m, r, F_cpu, numBodies);
    stopTime(&timer);
    printElapsedTime(timer, "CPU time");

    // Compute on GPU
    startTime(&timer);
    grav_gpu(m0, m, r, F_gpu, numBodies);
    stopTime(&timer);
    printElapsedTime(timer, "GPU time");

    // Verify result
    for(unsigned int i = 0; i < numBodies; ++i) {
        float diff = (F_cpu[i] - F_gpu[i])/F_cpu[i];
        const float tolerance = 0.00001;
        if(diff > tolerance || diff < -tolerance) {
            printf("Mismatch at index %u (CPU result = %e, GPU result = %e)\n", i, F_cpu[i], F_gpu[i]);
            exit(0);
        }
    }

    // Free memory
    free(m);
    free(r);
    free(F_cpu);
    free(F_gpu);

    return 0;

}

