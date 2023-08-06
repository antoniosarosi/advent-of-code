#include "./year2022/day01.c"
#include "./year2022/day02.c"

#define MAX_OUTPUT_SIZE 256

typedef void (*Fn)(char*, char*[MAX_OUTPUT_SIZE]);

struct Solution {
    int year;
    int day;
    Fn fn;
};

struct Solution solutions[] = {
    {2022, 1, year2022_day01_solution},
    {2022, 2, year2022_day02_solution},
};

Fn search_solution(int year, int day) {
    for (int i = 0; i < sizeof(solutions) / sizeof(struct Solution); i++) {
        if (solutions[i].year == year && solutions[i].day == day) {
            return solutions[i].fn;
        }
    }

    return NULL;
}
