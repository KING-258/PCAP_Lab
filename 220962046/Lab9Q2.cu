#include <cuda_runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
__global__ void change(int *a, int m, int n) {
    int r = blockIdx.x * blockDim.x + threadIdx.x;
    int c = blockIdx.y * blockDim.y + threadIdx.y;
    if (r < m && c < n) {
        int idx = r * n + c;
        a[idx] = pow(a[idx], r + 1);
    }
}
int main() {
    int m, n;
    printf("Enter number of rows (m): ");
    scanf("%d", &m);
    printf("Enter number of columns (n): ");
    scanf("%d", &n);
    int *h_a = (int *)malloc(m * n * sizeof(int));
    printf("Enter matrix A (m*n values): ");
    for (int i = 0; i < m * n; ++i) {
        scanf("%d", &h_a[i]);
    }
    int *d_a;
    cudaMalloc(&d_a, m * n * sizeof(int));
    cudaMemcpy(d_a, h_a, m * n * sizeof(int), cudaMemcpyHostToDevice);
    dim3 blockDim(16, 16);
    dim3 gridDim((m + blockDim.x - 1) / blockDim.x, (n + blockDim.y - 1) / blockDim.y);
    change<<<gridDim, blockDim>>>(d_a, m, n);
    cudaMemcpy(h_a, d_a, m * n * sizeof(int), cudaMemcpyDeviceToHost);
    printf("Modified matrix A:\n");
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            printf("%d ", h_a[i * n + j]);
        }
        printf("\n");
    }
    return 0;
}