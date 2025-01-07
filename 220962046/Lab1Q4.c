#include"mpi.h"
#include<stdio.h>
int main(int argc, char* argv[]){
    int r, s;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &r);
    MPI_Comm_size(MPI_COMM_WORLD, &s);
    char ans[5] = "HELLO";
    for(int i = 0; i < 6; i++) {
        if(ans[i] >= 'A' && ans[i] <= 'Z') {
            ans[i] += 32;
        }
    }
    printf("Final Ans : %s\n", ans);
    MPI_Finalize();
    return 0;
}