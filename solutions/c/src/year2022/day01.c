#include <stdlib.h>
#include <stdio.h>

void year2022_day01_solution(char *input, char **output) {
    int top_three[] = {0, 0, 0};

    while (*input != '\0') {
        int elf = 0;
        while (*input != '\0' && *input != '\n') {
            elf += strtol(input, &input, 10);
            if (*input != '\0') {
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

        if (*input == '\n') {
            input++;
        }
    }

    sprintf(output[0], "%d", top_three[0]);
    sprintf(output[1], "%d", top_three[0] + top_three[1] + top_three[2]);
}
