#include <mpi.h>
#include <stdio.h>
int main(int argc, char *argv[]) {
    MPI_Init(&argc, &argv);
    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    int arr[100];
    int element;
    MPI_Buffer_attach(malloc(size * sizeof(int)), size * sizeof(int));
    if(rank == 0){
        printf("Enter %d elements of the array: ", size);
        for(int i = 0; i < size; i++){
            scanf("%d", &arr[i]);
            MPI_Bsend(&arr[i], 1, MPI_INT, i, 0, MPI_COMM_WORLD);
        }
    }
    else{
        MPI_Recv(&element, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        if (rank % 2 == 0){
            printf("Process %d: Square = %d\n", rank, element * element);
        }
        else{
            printf("Process %d: Cube = %d\n", rank, element * element * element);
        }
    }
    MPI_Finalize();
    return 0;
}