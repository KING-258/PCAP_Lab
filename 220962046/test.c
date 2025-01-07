#include"mpi.h"
#include<stdio.h>
int main(int argc, char* argv[]){
    int r, s;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &r);
    MPI_Comm_size(MPI_COMM_WORLD, &s);
    printf("Rank : %d Size : %d\n",r,s);
    MPI_Finalize();
    return 0;
}