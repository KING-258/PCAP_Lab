#include <iostream>
#include <cmath>
#include <cuda_runtime.h>
const int ARRAY_SIZE = 1024;
const int BLOCK_SIZE = 256;
__global__ void computeSine(float *d_angles, float *d_sines, int n) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    
    if (idx < n) {
        d_sines[idx] = sinf(d_angles[idx]);
    }
}
int main() {
    float h_angles[ARRAY_SIZE];
    float h_sines[ARRAY_SIZE];
    for (int i = 0; i < ARRAY_SIZE; i++) {
        h_angles[i] = (i * 3.14159f) / 180.0f;
    }
    float *d_angles, *d_sines;
    cudaMalloc((void**)&d_angles, ARRAY_SIZE * sizeof(float));
    cudaMalloc((void**)&d_sines, ARRAY_SIZE * sizeof(float));
    cudaMemcpy(d_angles, h_angles, ARRAY_SIZE * sizeof(float), cudaMemcpyHostToDevice);
    int numBlocks = (ARRAY_SIZE + BLOCK_SIZE - 1) / BLOCK_SIZE;
    computeSine<<<numBlocks, BLOCK_SIZE>>>(d_angles, d_sines, ARRAY_SIZE);
    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) {
        std::cerr << "CUDA error: " << cudaGetErrorString(err) << std::endl;
        return -1;
    }
    cudaMemcpy(h_sines, d_sines, ARRAY_SIZE * sizeof(float), cudaMemcpyDeviceToHost);
    std::cout << "First 10 sine values of the angles in radians:" << std::endl;
    for (int i = 0; i < 10; i++) {
        std::cout << "sin(" << h_angles[i] << ") = " << h_sines[i] << std::endl;
    }
    return 0;
}