#include <stdio.h>
#include <cuda_runtime.h>
__global__ void addVectors(int *A, int *B, int *C, int N) {
    int idx = threadIdx.x;
    if (idx < N) {
        C[idx] = A[idx] + B[idx];
    }
}
int main() {
    int N;
    printf("Enter Size of Vectors : ");
    scanf("%d",&N);
    int size = N * sizeof(int);
    int *h_A = (int*)malloc(size);
    int *h_B = (int*)malloc(size);
    int *h_C = (int*)malloc(size);
    for (int i = 0; i < N; i++) {
        h_A[i] = i;
        h_B[i] = i * 2;
    }
    printf("Initial Vector A:\n");
    for (int i = 0; i < N; i++) {
        printf("%d ", h_A[i]);
    }
    printf("\n");
    printf("Initial Vector B:\n");
    for (int i = 0; i < N; i++) {
        printf("%d ", h_B[i]);
    }
    printf("\n");
    int *d_A, *d_B, *d_C;
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_C, size);
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
    addVectors<<<1, N>>>(d_A, d_B, d_C, N);
    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);
    printf("Resulting Vector C (A + B):\n");
    for (int i = 0; i < N; i++) {
        printf("%d ", h_C[i]);
    }
    printf("\n");
    for (int i = 0; i < N; i++) {
        if (h_C[i] != h_A[i] + h_B[i]) {
            printf("Error at index %d: expected %d, got %d\n", i, h_A[i] + h_B[i], h_C[i]);
            break;
        }
    }
    printf("Vector addition successful!\n");
    return 0;
}