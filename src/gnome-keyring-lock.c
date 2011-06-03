/*
 * How to compile:
 * gcc `pkg-config --cflags --libs gnome-keyring-1 glib-2.0` \
 *   -o gnome-keyring-lock gnome-keyring-lock.c
 *
 * Copyright (C) 2011 Colin Shea <colin@evaryont.me>
 * Licensed under the GPL
 */
#include <stdlib.h>
#include <stdio.h>

#include <glib.h>
#include "gnome-keyring.h"

int main ()
{
  g_set_application_name("gnome-keyring-lock");

  GnomeKeyringResult result;
  result = gnome_keyring_lock_all_sync();
  if (result == GNOME_KEYRING_RESULT_OK) {
    return 0;
  }

  return 1;
}
