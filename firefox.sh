# Have to do this, as the malloc() calls in preloaded libraries results in a
# deadlock in Firefox's libjemalloc. Sucks.
#
# See mozilla bug 497117
#export LD_PRELOAD=""
export FIREFOX_DSP="aoss"
firefox $@ 1>/dev/null
