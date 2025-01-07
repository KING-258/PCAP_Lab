#include<stdio.h>
#include<math.h>
#include"mpi.h"
int main(int argc, char* argv[]){
    int r, s, x;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &r);
    MPI_Comm_size(MPI_COMM_WORLD, &s);
    x = 3;
    printf("Value of Power of X with Rank : %d \n",pow(x,r));
    MPI_Finalize();
    return 0;
}