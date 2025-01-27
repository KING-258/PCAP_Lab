#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
int factorial(int n) {
    int r = 1;
    for(int i=1; i<=n; i++) {
        r *= i;
    }
    return r;
}
int main(int argc, char *argv[]) {
    int r, s, n, ans = 0, res = 0;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &r);
    MPI_Comm_size(MPI_COMM_WORLD, &s);
    if (r == 0) {
        printf("Enter the value of N: ");
        scanf("%d", &n);
    }
    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
    for (int i = r + 1; i <= n; i += s) {
        ans += factorial(i);
    }
    MPI_Scan(&ans, &res, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
    if(r == s - 1){
        printf("The sum of factorials is: %d\n", res);
    }
    MPI_Finalize();
    return 0;
}