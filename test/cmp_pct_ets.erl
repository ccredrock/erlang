-module(cmp_pct_ets).

-export([pct1/1, pct2/1, ets/1]).

%% ====================================================================
pct1(N) ->
    List = do_make_kv(N),
    List1 = do_make_kv1(N),
    statistics(wall_clock),
    [do_pct1_add(K, V) || {K, V} <- List],
    {_, T1} = statistics(wall_clock),
    [do_pct1_get(K) || {K, _V} <- List],
    {_, T2} = statistics(wall_clock),
    [do_pct1_tra(V) || {_K, V} <- List],
    {_, T3} = statistics(wall_clock),
    [do_pct1_mod(K, V) || {K, V} <- List1],
    {_, T4} = statistics(wall_clock),
    [do_pct1_del(K) || {K, _V} <- List],
    {_, T5} = statistics(wall_clock),
    io:format("pct1 add[~p], get[~p], tra[~p] mod[~p], del[~p] ~n", [T1, T2, T3, T4, T5]).

do_make_kv(N) ->
    [{K, K} || K <- lists:seq(1, N)].

do_make_kv1(N) ->
    [{K, K + 1} || K <- lists:seq(1, N)].

do_pct1_add(K, V) -> erlang:put(K, V).
do_pct1_get(K)    -> erlang:get(K).
do_pct1_tra(V)    -> List = erlang:get(), lists:keyfind(V, 2, List).
do_pct1_mod(K, V) -> erlang:put(K, V).
do_pct1_del(K)    -> erlang:erase(K).

%% ====================================================================
pct2(N) ->
    Dct = dict:new(),
    erlang:put(cmp, Dct),
    List = do_make_kv(N),
    List1 = do_make_kv1(N),
    statistics(wall_clock),
    [do_pct2_add(K, V) || {K, V} <- List],
    {_, T1} = statistics(wall_clock),
    [do_pct2_get(K) || {K, _V} <- List],
    {_, T2} = statistics(wall_clock),
    [do_pct2_tra(V) || {_K, V} <- List],
    {_, T3} = statistics(wall_clock),
    [do_pct2_mod(K, V) || {K, V} <- List1],
    {_, T4} = statistics(wall_clock),
    [do_pct2_del(K) || {K, _V} <- List],
    {_, T5} = statistics(wall_clock),
    io:format("pct2 add[~p], get[~p], tra[~p] mod[~p], del[~p] ~n", [T1, T2, T3, T4, T5]).

do_pct2_add(K, V) -> 
    Dct = erlang:get(cmp), 
    Dct1 = dict:append(K, V, Dct),
    erlang:put(cmp, Dct1).

do_pct2_get(K) -> 
    Dct = erlang:get(cmp), 
    dict:find(K, Dct).

do_pct2_tra(V) -> 
    Dct = erlang:get(cmp), 
    Fun = fun(DK, DV, Acc) ->
                  case V =:= DV of
                      true -> {DK, DV};
                      false -> Acc
                  end
          end,
    dict:fold(Fun, [], Dct).

do_pct2_mod(K, V) -> 
    Dct = erlang:get(cmp), 
    Dct1 = dict:store(K, V, Dct),
    erlang:put(cmp, Dct1).

do_pct2_del(K) -> 
    Dct = erlang:get(cmp), 
    Dct1 = dict:erase(K, Dct),
    erlang:put(cmp, Dct1).

%% ====================================================================
ets(N) ->
    ets:new(cmp, [set, private, named_table]),
    List = do_make_kv(N),
    List1 = do_make_kv1(N),
    statistics(wall_clock),
    [do_ets_add(K, V) || {K, V} <- List],
    {_, T1} = statistics(wall_clock),
    [do_ets_get(K) || {K, _V} <- List],
    {_, T2} = statistics(wall_clock),
    [do_ets_tra(V) || {_K, V} <- List],
    {_, T3} = statistics(wall_clock),
    [do_ets_mod(K, V) || {K, V} <- List1],
    {_, T4} = statistics(wall_clock),
    [do_ets_del(K) || {K, _V} <- List],
    {_, T5} = statistics(wall_clock),
    io:format("ets add[~p], get[~p], tra[~p] mod[~p], del[~p] ~n", [T1, T2, T3, T4, T5]).

do_ets_add(K, V) -> ets:insert(cmp, {K, V}).
do_ets_get(K) -> ets:lookup(cmp, K).
do_ets_tra(V) -> ets:match_object(cmp, {'$1', V}).
do_ets_mod(K, V) -> ets:insert(cmp, {K, V}).
do_ets_del(K) -> ets:delete(cmp, K).
