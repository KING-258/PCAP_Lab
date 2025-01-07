#include"mpi.h"
#include<stdio.h>
int Fact(int n){
    int ans = 1;
    while(n != 1){
        ans *= n;
        n--;
    }
    return ans;
}
void fib(int n){
    int t1=0, t2=1;
    for(int i=2; i<n; i++){
        printf("%d ", (t1+t2));
        int a = t1+t2;
        t1 = t2;
        t2 = a;
    }
    printf("\n");
}
int main(int argc, char* argv[]){
    int r, s;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &r);
    MPI_Comm_size(MPI_COMM_WORLD, &s);
    if(r%2 == 0){
        printf("Ans for %d is : %d\n",r, Fact(r));
    }
    else{
        printf("Ans for %d is : \n",r);
        fib(r);
    }
    MPI_Finalize();
    return 0;
}