#include <stdio.h>
#include <cuda.h>
__device__ int convertToOctal(int num) {
    int octal = 0, place = 1;
    while (num > 0) {
        octal += (num % 8) * place;
        num /= 8;
        place *= 10;
    }
    return octal;
}
__global__ void convertArrayToOctal(int *input, int *output, int n) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if (idx < n) {
        output[idx] = convertToOctal(input[idx]);
    }
}
int main() {
    int n;
    printf("Enter number of integers: ");
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
    convertArrayToOctal<<<(n+255)/256, 256>>>(d_input, d_output, n);
    cudaMemcpy(h_output, d_output, n * sizeof(int), cudaMemcpyDeviceToHost);
    printf("Octal values: ");
    for (int i=0; i<n; i++){
        printf("%d ", h_output[i]);
    }
    printf("\n");
    return 0;
}