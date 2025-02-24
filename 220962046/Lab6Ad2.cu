#include <stdio.h>
#include <cuda.h>
__global__ void onesComplement(int *input, int *output, int n) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if (idx < n) {
        output[idx] = ~input[idx] & 1;
    }
}
int main() {
    int n;
    printf("Enter number of binary numbers: ");
    scanf("%d", &n);
    int h_input[n], h_output[n];
    printf("Enter elements of the Array : ");
    for(int i=0; i<n; i++){
        scanf("%d", &h_input[i]);
    }
    int *d_input, *d_output;
    cudaMalloc((void**)&d_input, n * sizeof(int));
    cudaMalloc((void**)&d_output, n * sizeof(int));
    cudaMemcpy(d_input, h_input, n * sizeof(int), cudaMemcpyHostToDevice);
    onesComplement<<<(n+255)/256, 256>>>(d_input, d_output, n);
    cudaMemcpy(h_output, d_output, n * sizeof(int), cudaMemcpyDeviceToHost);
    printf("One's complement: ");
    for (int i=0; i<n; i++){
        printf("%d ", h_output[i]);
    }
    printf("\n");
    return 0;
}