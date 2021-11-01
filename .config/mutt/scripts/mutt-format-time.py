#!/usr/bin/python2
"""mutt format date

Prints different index_format strings for mutt according to a
messages age.

The single command line argument should be a unix timestamp
giving the message's date (%{}, etc. in Mutt).
"""

import sys
from datetime import datetime

INDEX_FORMAT = "%Z {} %?X?(%X)&   ? %-22.22F  %.100s %> %5c%"

def age_fmt(msg_date, now):
    # use iso date for messages of the previous year and before
    if msg_date.date().year < now.date().year:
        return '%[%Y-%m-%d]'

    # use "Month Day" for messages of this year
    if msg_date.date() < now.date():
        return '%10[%b %e]'

    # if a message appears to come from the future
    if msg_date > now:
        return '  b0rken'

    # use only the time for messages that arrived today
    return '%10[%H:%m]'

if __name__ == '__main__':
    msg_date = datetime.fromtimestamp(int(sys.argv[1]))
    now = datetime.now()
    print INDEX_FORMAT.format(age_fmt(msg_date, now))
