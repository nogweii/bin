#!/bin/sh

cd $HOME

echo "# find mail -name cur | sed 's@/cur@@; s@mail/@mailboxes =@' | sort" > ~/.mutt/mailboxes
echo "### Made by mailboxes.sh ###" >> ~/.mutt/mailboxes

find mail -name cur | sed 's@/cur@@; s@mail/@mailboxes =@' | sort >> ~/.mutt/mailboxes

echo -n "# vim" >> ~/.mutt/mailboxes
echo ": set syntax=muttrc:" >> ~/.mutt/mailboxes

echo "Regenerated ~/.mutt/mailboxes"
