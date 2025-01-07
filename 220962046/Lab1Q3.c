#include<stdio.h>
#include"mpi.h"
int main(int argc, char* argv[]){
    int r, s, a = 0, b = 0;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &r);
    MPI_Comm_size(MPI_COMM_WORLD, &s);
    if(r == 0){
        printf("Process 1 is '+'\n");
        printf("Enter 1st Number : ");
        scanf("%d",&a);
        printf("Enter 2nd Number : ");
        scanf("%d",&b);
    }
    MPI_Bcast(&a, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&b, 1, MPI_INT, 0, MPI_COMM_WORLD);
    switch(r){
        case 0:
            printf("Process 1 is '+'\n");
            printf("Result is %d\n", (a+b));
        case 1:
            printf("Process 2 is '-'\n");
            printf("Result is %d\n", (a-b));
        case 2:
            printf("Process 3 is '*'\n");
            printf("Result is %d\n", (a*b));
        case 3:
            printf("Process 4 is '/'\n");
            printf("Result is %d\n", (a/b));
        default:
            printf("Nothing Done\n");
    }
    MPI_Finalize();
    return 0;
}