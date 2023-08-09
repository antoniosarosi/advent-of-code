#define MAX_OUTPUT_SIZE 256

typedef void (*Fn)(char*, char*[MAX_OUTPUT_SIZE]);

struct Solution {
    int year;
    int day;
    Fn fn;
};

Fn search_solution(int year, int day);
