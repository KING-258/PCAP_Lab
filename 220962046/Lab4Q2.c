#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char *argv[]) {
    int r, s, arr[3][3], search_element, local_count = 0, total_count = 0;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &r);
    MPI_Comm_size(MPI_COMM_WORLD, &s);
    if(r == 0){
        printf("Enter a 3x3 Matrix:\n");
        for (int i=0; i<3; i++) {
            for(int j=0; j<3; j++){
                scanf("%d", &arr[i][j]);
            }
        }
        printf("Enter the element to search: ");
        scanf("%d", &search_element);
    }
    MPI_Bcast(arr, 9, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&search_element, 1, MPI_INT, 0, MPI_COMM_WORLD);
    for (int i = r; i < 9; i += s) {
        if (arr[i / 3][i % 3] == search_element) {
            local_count++;
        }
    }
    MPI_Reduce(&local_count, &total_count, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
    if(r == 0){
        printf("The element %d occurs %d times.\n", search_element, total_count);
    }
    MPI_Finalize();
    return 0;
}