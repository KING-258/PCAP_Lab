#include <cuda_runtime.h>
#include <stdio.h>
#include <stdlib.h>
__global__ void not_border(int *a, int *b, int m, int n) {
    int r = blockIdx.x * blockDim.x + threadIdx.x;
    int c = blockIdx.y * blockDim.y + threadIdx.y;
    if (r < m && c < n) {
        int idx = r * n + c;
        if (r > 0 && r < m - 1 && c > 0 && c < n - 1) {
            b[idx] = ~(a[idx]);
        } else {
            b[idx] = a[idx];
        }
    }
}
int main() {
    int m, n;
    printf("Enter number of rows (m): ");
    scanf("%d", &m);
    printf("Enter number of columns (n): ");
    scanf("%d", &n);
    int *h_a = (int *)malloc(m * n * sizeof(int));
    int *h_b = (int *)malloc(m * n * sizeof(int));
    printf("Enter matrix A (m*n values): ");
    for (int i = 0; i < m * n; ++i) {
        scanf("%d", &h_a[i]);
    }
    int *d_a, *d_b;
    cudaMalloc(&d_a, m * n * sizeof(int));
    cudaMalloc(&d_b, m * n * sizeof(int));
    cudaMemcpy(d_a, h_a, m * n * sizeof(int), cudaMemcpyHostToDevice);
    dim3 blockDim(16, 16);
    dim3 gridDim((m + blockDim.x - 1) / blockDim.x, (n + blockDim.y - 1) / blockDim.y);
    not_border<<<gridDim, blockDim>>>(d_a, d_b, m, n);
    cudaMemcpy(h_b, d_b, m * n * sizeof(int), cudaMemcpyDeviceToHost);
    printf("Modified matrix B:\n");
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            printf("%d ", h_b[i * n + j]);
        }
        printf("\n");
    }
    return 0;
}