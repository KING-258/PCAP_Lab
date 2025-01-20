#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char** argv) {
    int r, s, n, m, *arr = NULL, local_sum = 0, total_sum = 0, total_avg = 0;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &r);
    MPI_Comm_size(MPI_COMM_WORLD, &s);
    if(r == 0){
        scanf("%d %d", &n, &m);
        arr = (int*)malloc(n * m * sizeof(int));
        for(int i = 0; i < n * m; i++){
            scanf("%d", &arr[i]);
        }
    }
    MPI_Bcast(&m, 1, MPI_INT, 0, MPI_COMM_WORLD);
    int* local_arr = (int*)malloc(m * sizeof(int));
    MPI_Scatter(arr, m, MPI_INT, local_arr, m, MPI_INT, 0, MPI_COMM_WORLD);
    for(int i = 0; i < m; i++){
        local_sum += local_arr[i];
    }
    MPI_Reduce(&local_sum, &total_sum, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
    if(r == 0){
        total_avg = total_sum / s;
        printf("%d\n", total_avg);
    }
    MPI_Finalize();
    return 0;
}