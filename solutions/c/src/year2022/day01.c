#include <stdlib.h>
#include <stdio.h>

void year2022_day01_solution(char *input, int output[2]) {
    int top_three[] = {0, 0, 0};

    while (input[0] != '\0') {
        int elf = 0;
        while (input[0] != '\0' && input[0] != '\n') {
            elf += strtol(input, &input, 10);
            if (input[0] != '\0') {
                input++;
            }
        }

        for (int i = 0; i < 3; i ++) {
            if (elf > top_three[i]) {
                for (int j = 2; j > 0; j--) {
                    top_three[j] = top_three[j - 1];
                }
                top_three[i] = elf;
                break;
            }
        }

        if (input[0] == '\n') {
            input++;
        }
    }

    output[0] = top_three[0];
    output[1] = top_three[0] + top_three[1] + top_three[2];
}
