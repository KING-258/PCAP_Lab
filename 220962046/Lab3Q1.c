#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
int fact(int n) {
    int f = 1;
    for (int i = 1; i <= n; i++) {
        f *= i;
    }
    return f;
}
int main(int argc, char** argv) {
    int r, s;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &r);
    MPI_Comm_size(MPI_COMM_WORLD, &s);
    int n, *arr = NULL;
    int local_fact, sum = 0;
    if(r == 0){
        printf("Enter the number of values (n): ");
        scanf("%d", &n);
        arr = (int*)malloc(n * sizeof(int));
        printf("Enter %d values:\n", n);
        for(int i = 0; i < n; i++){
            scanf("%d", &arr[i]);
        }
    }
    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
    int val;
    MPI_Scatter(arr, 1, MPI_INT, &val, 1, MPI_INT, 0, MPI_COMM_WORLD);
    local_fact = fact(val);
    int* facts = NULL;
    if(r == 0){
        facts = (int*)malloc(s * sizeof(int));
    }
    MPI_Gather(&local_fact, 1, MPI_INT, facts, 1, MPI_INT, 0, MPI_COMM_WORLD);
    if(r == 0){
        for(int i = 0; i < s; i++){
            sum += facts[i];
        }
        printf("The sum of factorials is: %d\n", sum);
    }
    MPI_Finalize();
    return 0;
}