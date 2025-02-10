#include <iostream>
#include <vector>
#include <cuda_runtime.h>
const int THREADS_PER_BLOCK = 256;
__global__ void vector_add(const int *A, const int *B, int *C, int N) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < N) {
        C[idx] = A[idx] + B[idx];
    }
}
void init_vector(std::vector<int>& vec, int value, int N) {
    for (int i = 0; i < N; ++i) {
        vec[i] = value;
        value++;
    }
}
int main() {
    int N;
    std::cout << "Enter the length of the vectors: ";
    std::cin >> N;
    std::vector<int> A(N), B(N), C(N);
    init_vector(A, 1, N);
    init_vector(B, 2, N);
    int *d_A, *d_B, *d_C;
    cudaMalloc(&d_A, N * sizeof(int));
    cudaMalloc(&d_B, N * sizeof(int));
    cudaMalloc(&d_C, N * sizeof(int));
    cudaMemcpy(d_A, A.data(), N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B.data(), N * sizeof(int), cudaMemcpyHostToDevice);
    int blocks = (N + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK;
    vector_add<<<blocks, THREADS_PER_BLOCK>>>(d_A, d_B, d_C, N);
    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) {
        std::cerr << "CUDA error: " << cudaGetErrorString(err) << std::endl;
        return -1;
    }
    cudaMemcpy(C.data(), d_C, N * sizeof(int), cudaMemcpyDeviceToHost);
    std::cout << "Resulting vector C (first 10 elements): ";
    for (int i = 0; i < N; ++i){
        std::cout << C[i] << " ";
    }
    std::cout << std::endl;
    return 0;
}