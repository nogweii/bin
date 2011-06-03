# Have to do this, as the malloc() calls in preloaded libraries results in a
# deadlock in Firefox's libjemalloc. Sucks.
#
# See mozilla bug 497117, which was marked as a dupe of:
# https://bugzilla.mozilla.org/show_bug.cgi?id=435683
#
# ... now it's to prevent a seg fault!
export LD_PRELOAD=""
export FIREFOX_DSP="aoss"
firefox $@ 1>/dev/null
