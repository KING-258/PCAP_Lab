#include<stdio.h>
#include"mpi.h"
int main(int argc, char* argv[]){
    int r, s;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &r);
    MPI_Comm_size(MPI_COMM_WORLD, &s);
    if(r % 2 == 1){
        printf("World\n");
    }
    else{
        printf("Hello\n");
    }
    MPI_Finalize();
    return 0;
}