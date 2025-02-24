#include <stdio.h>
#include <cuda.h>
__global__ void conv1D(int *N, int *M, int *P, int s, int c) {
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    int radius = c / 2;   
    if (i < s) {
        int result = 0;
        for (int j = -radius; j <= radius; j++) {
            int idx = i + j;
            if (idx >= 0 && idx < s) {
                result += N[idx] * M[j + radius];
            }
        }
        P[i] = result;
    }
}
int main() {
    int s, c;
    printf("Enter size of input array: ");
    scanf("%d", &s);
    printf("Enter size of Mask : ");
    scanf("%d",&c);
    int h_N[s], h_M[c], h_P[s];
    printf("Enter elements of input array: ");
    for(int i=0; i<s; i++){
        scanf("%d", &h_N[i]);
    }
    printf("Enter elements of mask array (size %d): ", c);
    for (int i=0; i<c; i++) scanf("%d", &h_M[i]);
    int *d_N, *d_M, *d_P;
    cudaMalloc((void**)&d_N, s * sizeof(int));
    cudaMalloc((void**)&d_M, c * sizeof(int));
    cudaMalloc((void**)&d_P, s * sizeof(int));
    cudaMemcpy(d_N, h_N, s * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_M, h_M, c * sizeof(int), cudaMemcpyHostToDevice);
    conv1D<<<(s+255)/256, 256>>>(d_N, d_M, d_P, s, c);
    cudaMemcpy(h_P, d_P, s * sizeof(int), cudaMemcpyDeviceToHost);
    printf("Convolution Output: ");
    for(int i = 0; i < s; i++){
        printf("%d ", h_P[i]);
    }
    printf("\n");
    return 0;
}