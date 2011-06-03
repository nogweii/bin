// cc -o xdark -Wall xdark.c -L/usr/X11R6/lib -lm -lX11 -lXxf86vm && exec ./xdark "$@"; exit

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <X11/Xlib.h>
#include <X11/extensions/xf86vmode.h>

/*

xdark is like xgamma it changes the brightness of your display in software.
It can make it dark, invert the display colours, etc.

apt-get install libxxf86vm-dev
(or apt-get install xorg-dev)

cc -o xdark -Wall -lm -lX11 -lXxf86vm xdark.c 

Sam Watkins, 2008

*/

Display *display;
int screen;
int size;
double from, to;

unsigned short r[256];
unsigned short g[256];
unsigned short b[256];

void get_brightness(double *from, double *to)
{
	XF86VidModeGetGammaRamp(display, screen, size, r, g, b);
	*from = floor(g[0] / 65535.0 * 100 + .5) / 100;
	*to = floor(g[size-1] / 65535.0 * 100 + .5) / 100;
}

void set_brightness(double from, double to)
{
	int i;
	for(i=0; i<size; ++i) {
		unsigned short val = (unsigned short)(65535 * (i * (to-from) / (size-1) + from));
		r[i] = val;
		g[i] = val;
		b[i] = val;
	}

	XF86VidModeSetGammaRamp(display, screen, size, r, g, b);
}

int main(int argc, char **argv) {
	int invert = argc == 2 && strcmp(argv[1], "-i") == 0;
	if((argc <1 || argc >3) || (!invert && argc == 2 && argv[1][0] == '-')) {
		fprintf(stderr, "usage: xdark [-i] [[from-brightness] to-brightness]\n");
		fprintf(stderr, "  without args, it reads the values\n");
		fprintf(stderr, "  brightness should be between 0.0 (dark) to 1.0 (bright)\n");
		fprintf(stderr, "  -i invert\n");
		fprintf(stderr, "try:\n");
		fprintf(stderr, "  xdark 0.5\n");
		fprintf(stderr, "  xdark\n");
		fprintf(stderr, "  xdark 1 0\n");
		fprintf(stderr, "  xdark 0.5 0\n");
		fprintf(stderr, "  xdark 1\n");
		exit(1);
	}

	if((display = XOpenDisplay(NULL)) == NULL) {
		fprintf(stderr, "failed: XOpenDisplay\n");
		exit(1);
	}

	screen = DefaultScreen(display);

	XF86VidModeGetGammaRampSize(display, screen, &size);

	if (size > 256) {
		fprintf(stderr, "gamma ramp size is unexpectedly large: %d\n", size);
		exit(1);
	}

	if (invert) {
		double tmp;
		get_brightness(&from, &to);
		tmp = from;
		from = to;
		to = tmp;
		set_brightness(from, to);
	} else if (argc == 1) {
		get_brightness(&from, &to);
		printf("%0.02f %0.02f\n", from, to);
	} else {
		if (argc == 3) {
			from = atof(argv[1]);
			to = atof(argv[2]);
		} else {
			from = 0;
			to = atof(argv[1]);
		}
		if((from < 0) || (from > 1) || (to < 0) || (to > 1)) {
			fprintf(stderr, "brightness should be between 0.0 (dark) to 1.0 (bright)\n");
			exit(1);
		}

		set_brightness(from, to);
	}

	XCloseDisplay(display);

	exit(0);
}
