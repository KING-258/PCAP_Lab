#include <stdio.h>
#include <cuda_runtime.h>
__global__ void transformMatrix(int *a, int *b, int m, int n) {
    int row = blockIdx.x;     
    int col = threadIdx.x;   
    if (row < m && col < n) {
        int idx = row * n + col; 
        int rowSum = 0, colSum = 0;
        for (int i = 0; i < n; i++) {
            rowSum += a[row * n + i];
        }
        for (int j = 0; j < m; j++) {
            colSum += a[j * n + col];
        }
        if (a[idx] % 2 == 0) {
            b[idx] = rowSum;
        } else {
            b[idx] = colSum;
        }
    }
}
int main() {
    int m, n;
    printf("Enter the number of rows (m): ");
    scanf("%d", &m);
    printf("Enter the number of columns (n): ");
    scanf("%d", &n);
    int size = m * n * sizeof(int);
    int *h_a = (int*)malloc(size);
    int *h_b = (int*)malloc(size);
    printf("Enter the elements of matrix A (%d x %d): ", m, n);
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            scanf("%d", &h_a[i * n + j]);
        }
    }
    int *d_a, *d_b;
    cudaMalloc((void **)&d_a, size);
    cudaMalloc((void **)&d_b, size);
    cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);
    transformMatrix<<<m, n>>>(d_a, d_b, m, n);
    cudaMemcpy(h_b, d_b, size, cudaMemcpyDeviceToHost);
    printf("\nMatrix A:\n");
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            printf("%d ", h_a[i * n + j]);
        }
        printf("\n");
    }
    printf("\nMatrix B (Transformed):\n");
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            printf("%d ", h_b[i * n + j]);
        }
        printf("\n");
    }
    return 0;
}