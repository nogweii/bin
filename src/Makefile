all:
	gcc `pkg-config --cflags --libs gnome-keyring-1 glib-2.0` -o ../gnome-keyring-lock gnome-keyring-lock.c
	gcc -o ../xdark -Wall xdark.c -L/usr/X11R6/lib -lm -lX11 -lXxf86vm
	gcc -o ../RunningX RunningX.c -lX11

clean:
	rm ../gnome-keyring-lock
	rm ../xdark
	rm ../RunningX
