#include <mpi.h>
#include <stdio.h>
#include <string.h>
int main(int argc, char *argv[]) {
    MPI_Init(&argc, &argv);
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    char word[100];
    MPI_Status status;
    if(rank == 0){
        printf("Enter a word: ");
        scanf("%s", word);
        MPI_Ssend(word, strlen(word) + 1, MPI_CHAR, 1, 0, MPI_COMM_WORLD);
        MPI_Recv(word, 100, MPI_CHAR, 1, 0, MPI_COMM_WORLD, &status);
        printf("Toggled word: %s\n", word);
    }
    else if(rank == 1){
        MPI_Recv(word, 100, MPI_CHAR, 0, 0, MPI_COMM_WORLD, &status);
        for(int i = 0; word[i] != '\0'; i++){
            if(word[i] >= 'a' && word[i] <= 'z'){
                word[i] -= 32;
            }
            else if(word[i] >= 'A' && word[i] <= 'Z'){
                word[i] += 32;
            }
        }
        MPI_Ssend(word, strlen(word) + 1, MPI_CHAR, 0, 0, MPI_COMM_WORLD);
    }
    MPI_Finalize();
    return 0;
}