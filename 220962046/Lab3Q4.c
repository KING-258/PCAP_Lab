#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char** argv) {
    int r, s, len;
    char *s1 = NULL, *s2 = NULL;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &r);
    MPI_Comm_size(MPI_COMM_WORLD, &s);
    if (r == 0) {
        char input1[1000], input2[1000];
        scanf("%s %s", input1, input2);
        len = strlen(input1);
        s1 = input1;
        s2 = input2;
    }
    MPI_Bcast(&len, 1, MPI_INT, 0, MPI_COMM_WORLD);
    int chunk = len / s;
    char* local_s1 = (char*)malloc((chunk + 1) * sizeof(char));
    char* local_s2 = (char*)malloc((chunk + 1) * sizeof(char));
    char* local_result = (char*)malloc((chunk * 2 + 1) * sizeof(char));
    MPI_Scatter(s1, chunk, MPI_CHAR, local_s1, chunk, MPI_CHAR, 0, MPI_COMM_WORLD);
    MPI_Scatter(s2, chunk, MPI_CHAR, local_s2, chunk, MPI_CHAR, 0, MPI_COMM_WORLD);
    for (int i = 0; i < chunk; i++) {
        local_result[2 * i] = local_s1[i];
        local_result[2 * i + 1] = local_s2[i];
    }
    local_result[chunk * 2] = '\0';
    char* final_result = NULL;
    if (r == 0) {
        final_result = (char*)malloc((len * 2 + 1) * sizeof(char));
    }
    MPI_Gather(local_result, chunk * 2, MPI_CHAR, final_result, chunk * 2, MPI_CHAR, 0, MPI_COMM_WORLD);
    if (r == 0) {
        final_result[len * 2] = '\0';
        printf("%s\n", final_result);
    }
    MPI_Finalize();
    return 0;
}