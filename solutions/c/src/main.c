#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#include "solutions.h"

#ifndef INPUTS_DIR
#define INPUTS_DIR "../../inputs"
#endif

void fail(const char *format, ...) {
    va_list args;
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);
    exit(1);
}

void *mem_alloc_or_fail(size_t bytes) {
    void *ptr = malloc(bytes);

    if (ptr == NULL) {
        fail("Error: Out of memory\n");
    }

    return ptr;
}

char *read_input(char *path) {
    FILE *file = fopen(path, "rb");
    if (file == NULL) {
        fail("Could not open file: %s\n", path);
    }

    fseek(file, 0, SEEK_END);
    long length = ftell(file);
    rewind(file);

    char *input = mem_alloc_or_fail(length + 1);
    fread(input, length, 1, file);
    fclose(file);

    input[length] = 0;

    return input;
}

int main(int argc, char **argv) {
    if (argc < 3 || argc > 4) {
        fail("Usage: %s YEAR DAY [path/to/alternate/input.txt]\n", argv[0]);
    }

    int year = strtol(argv[1], NULL, 10);
    if (year == 0) {
        fail("Cannot parse year: '%s'\n", argv[1]);
    }

    int day = strtol(argv[2], NULL, 10);
    if (day == 0) {
        fail("Cannot parse day: '%s'\n", argv[2]);
    }

    char *path = NULL;
    if (argc == 4) {
        path = argv[3];
    } else {
        path = mem_alloc_or_fail(snprintf(NULL, 0, "%s/%d/day%02d.txt", INPUTS_DIR, year, day));
        sprintf(path, "%s/%d/day%02d.txt", INPUTS_DIR, year, day);
    }

    Fn solution = search_solution(year, day);
    if (solution == NULL) {
        fail("Solution for year %d day %d is no implemented or registered\n", year, day);
    }

    char *input = read_input(path);
    char output[2][MAX_OUTPUT_SIZE] = {"Not Implemented", "Not Implemented"};

    solution(input, (char*[]){output[0], output[1]});

    printf("%s\n%s\n", output[0], output[1]);

    free(input);

    if (argc == 3) {
        free(path);
    }

    return 0;
}
