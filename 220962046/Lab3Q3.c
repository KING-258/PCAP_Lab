#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
int is_vowel(char c) {
    c = tolower(c);
    return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u';
}
int main(int argc, char** argv) {
    int r, s, len, local_count = 0, total_count = 0;
    char* str = NULL;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &r);
    MPI_Comm_size(MPI_COMM_WORLD, &s);
    if(r == 0){
        char input[1000];
        scanf("%s", input);
        len = strlen(input);
        str = input;
    }
    MPI_Bcast(&len, 1, MPI_INT, 0, MPI_COMM_WORLD);
    int chunk = len / s;
    char* local_str = (char*)malloc((chunk + 1) * sizeof(char));
    MPI_Scatter(str, chunk, MPI_CHAR, local_str, chunk, MPI_CHAR, 0, MPI_COMM_WORLD);
    local_str[chunk] = '\0';
    for(int i = 0; i < chunk; i++){
        if (!is_vowel(local_str[i])) local_count++;
    }
    MPI_Reduce(&local_count, &total_count, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
    if(r == 0){
        printf("%d\n", total_count);
    }
    MPI_Finalize();
    return 0;
}