#include <cuda_runtime.h>
#include <stdio.h>
#include <stdlib.h>
__global__ void mulVec(int *row_ptr, int *col_idx, int *val, int *x, int *y, int n) {
    int r = blockIdx.x * blockDim.x + threadIdx.x;
    if (r < n) {
        int sum = 0;
        for (int j = row_ptr[r]; j < row_ptr[r + 1]; ++j) {
            sum += val[j] * x[col_idx[j]];
        }
        y[r] = sum;
    }
}
int main() {
    int n, val;
    printf("Enter number of rows (n): ");
    scanf("%d", &n);
    printf("Enter number of non-zero elements : ");
    scanf("%d", &val);
    int *r = (int *)malloc((n + 1) * sizeof(int));
    int *c = (int *)malloc(val * sizeof(int));
    int *h_val = (int *)malloc(val * sizeof(int));
    int *h_x = (int *)malloc(n * sizeof(int));
    int *h_y = (int *)malloc(n * sizeof(int));
    printf("Enter Row index: ");
    for (int i = 0; i <= n; ++i) {
        scanf("%d", &r[i]);
    }
    printf("Enter column index: ");
    for (int i = 0; i < val; ++i) {
        scanf("%d", &c[i]);
    }
    printf("Enter non-zero elements: ");
    for (int i = 0; i < val; ++i) {
        scanf("%d", &h_val[i]);
    }
    printf("Enter vector values: ");
    for (int i = 0; i < n; ++i) {
        scanf("%d", &h_x[i]);
    }
    int *d_row_ptr, *d_col_idx;
    int *d_val, *d_x, *d_y;
    cudaMalloc(&d_row_ptr, (n + 1) * sizeof(int));
    cudaMalloc(&d_col_idx, val * sizeof(int));
    cudaMalloc(&d_val, val * sizeof(int));
    cudaMalloc(&d_x, n * sizeof(int));
    cudaMalloc(&d_y, n * sizeof(int));
    cudaMemcpy(d_row_ptr, r, (n + 1) * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_col_idx, c, val * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_val, h_val, val * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_x, h_x, n * sizeof(int), cudaMemcpyHostToDevice);
    mulVec<<<(n + 255) / 256, 256>>>(d_row_ptr, d_col_idx, d_val, d_x, d_y, n);
    cudaMemcpy(h_y, d_y, n * sizeof(int), cudaMemcpyDeviceToHost);
    printf("Resulting vector y: ");
    for (int i = 0; i < n; ++i) {
        printf("%d ", h_y[i]);
    }
    printf("\n");
    return 0;
}