/* dwmblocks — status blocks with status2d colors
 * Each script outputs: ^c#COLOR^ICON TEXT^d^
 * Requires status2d patch in dwm
 */
static const Block blocks[] = {
    /* icon    command         interval  signal */
    { "",     "sb-music",      0,        11 },
    { "",     "sb-network",    0,        4  },
    { "",     "sb-nettraf",    1,        0  },
    { "",     "sb-cpu",        5,        0  },
    { "",     "sb-memory",     10,       0  },
    { "",     "sb-temp",       10,       0  },
    { "",     "sb-volume",     0,        10 },
    { "",     "sb-brightness", 0,        12 },
    { "",     "sb-battery",    30,       3  },
    { "",     "sb-clock",      60,       1  },
};

static char delim[] = " ";
static unsigned int delimLen = 1;
