# Have to do this, as the malloc() calls in preloaded libraries results in a
# deadlock in Firefox's libjemalloc. Sucks.
#
# See mozilla bug 497117
unset LD_PRELOAD
export FIREFOX_DSP="aoss"

firefox $@
