#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#define DAY (time_t)86400
#define YESTERDAY (time_t)172800
#define WEEK (time_t)604800
#define YEAR (time_t)31556926

int main(int argc, const char *argv[]) {
    time_t current_time;
    time_t message_time;
    struct tm *tm;

    const char *old, *recent, *today, *week, *yesterday;
    const char *format;

    current_time = time(NULL);

    if (argc!=8) {
        printf("Usage: %s old recent today format timestamp\n", argv[0]);
        return 2;
    }

    old = argv[1];          // 01.12.1993
    recent = argv[2];       // Mon, 21 Oct
    week = argv[3];         // Mon, 21:21
    yesterday = argv[4];    // Yesterday, 21:21
    today = argv[5];        // 21:11

    format = argv[6];

    message_time = atoi(argv[7]);

    if ((tm = localtime (&current_time)) == NULL) {
        printf("Error\n");
        return 1;
    }

    unsigned int TODAY = tm->tm_mday*3600 + tm->tm_hour*60 + tm->tm_sec;

    if ((current_time - message_time) < TODAY) {
        printf(format, today);
    } else if ((current_time - message_time) < DAY+TODAY) {
        printf(format, yesterday);
    } else if ((current_time - message_time) < WEEK) {
        printf(format, week);
    } else if ((current_time - message_time) < YEAR) {
        printf(format, recent);
    } else {
        printf(format, old);
    }
    return 0;
}
