/* dwmblocks — minimal status blocks with status2d colors
 * Each script outputs: ^c#COLOR^ICON TEXT^d^
 * Requires status2d patch in dwm
 */
static const Block blocks[] = {
    /* icon    command        interval  signal */
    { "",     "sb-volume",    0,        10 },
    { "",     "sb-battery",   30,       3  },
    { "",     "sb-clock",     60,       1  },
};

static char delim[] = " ";
static unsigned int delimLen = 1;
