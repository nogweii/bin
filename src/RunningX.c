/*********************************************************************
 * RunningX v1.0
 *   Brandon Long (blong@uiuc.edu)
 *
 * This program uses an X call to determine if X is running.  I use it
 * to determine which type of content viewer I use for viewing attachments.
 * It returns 0 if we are running X, 1 if not.
 *
 * The rfc1524 format for mailcap files would use the following to view 
 * an HTML attachment with Netscape if we are running X, or with Lynx
 * if we are not.
 * text/html; netscape -remote 'openURL(%s)'; test=/usr/local/bin/RunningX
 * text/html; lynx %s
 *
 * If you use any command line parameters, it will return a message on
 * stdout that if you are running X or not.
 *
 * To compile, you need to link with libX11, so something like the following:
 * gcc -o RunningX RunningX.c -lX11
 */

#include <stdio.h>
#include <stdlib.h>
#include <X11/Xlib.h>

/* From Brian Swetland (swetland@uiuc.edu)
 * returns non-zero in the presence of the
 *    windowing system we all know and love */

int RunningX(void)
{
  return((long) XOpenDisplay(getenv("DISPLAY")));
}

int main(int argc, char *argv[])
{
  int x;

  x = RunningX();

  if (argc>1)
    printf("Running X?  %s\n", x ? "Yes!" : "No!");

  exit(!x);
}
