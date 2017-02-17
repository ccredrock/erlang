#!/bin/bash

# sh cmp_pct_ets.sh 100000
# pct1 add[10],  get[4],  mod[27],   del[7]
# pct2 add[952], get[65], mod[1079], del[858]
# ets  add[124], get[85], mod[77],   del[59]

# sh cmp_pct_ets.sh 10000
# pct1 add[3],  get[0], tra[932],  mod[0],  del[1]
# pct2 add[29], get[3], tra[8878], mod[18], del[15]
# ets  add[8],  get[3], tra[5561], mod[6],  del[4]

rm -rf cmp_pct_ets.beam 

erl -noshell \
    -eval "make:files([\"cmp_pct_ets.erl\"])" \
    -eval "cmp_pct_ets:pct1($1)" \
    -eval "timer:sleep(1000)" \
    -eval "cmp_pct_ets:pct2($1)" \
    -eval "timer:sleep(1000)" \
    -eval "cmp_pct_ets:ets($1)" \
    -eval "halt(0)"

