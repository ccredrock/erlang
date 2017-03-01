%%% -*- coding: utf-8 -*-
%%%-----------------------------------------------------------------------------
%%% @author     ccredrock@gmail.com
%%% @copyright  2017/03/01
%%% @doc
%%%             IP解析 from www.ipip.net
%%% @end
%%%-----------------------------------------------------------------------------
-module(ipip).

-export([read/0, find/2, parse/1]).

%% =============================================================================
%% @doc define
%% =============================================================================
-define(READ_PATH, "./17monipdb.dat").
-define(WRITE_PATH, "17monipdb.erl").

-define(IP_MAX, 255).
-define(SHOW_PER, 100).

-define(B2IU(B),
        ((binary:at(B, 3) band 16#FF)
         bor ((binary:at(B, 2) bsl 8) band 16#FF00)
         bor ((binary:at(B, 1) bsl 16) band 16#FF0000)
         bor ((binary:at(B, 0) bsl 24) band 16#FF000000))).

-define(B2IL(B),
        ((binary:at(B, 0) band 16#FF)
         bor ((binary:at(B, 1) bsl 8) band 16#FF00)
         bor ((binary:at(B, 2) bsl 16) band 16#FF0000)
         bor ((binary:at(B, 3) bsl 24) band 16#FF000000))).

%% 保留地址
-define(BLDZ, <<228,191,157,231,149,153,229,156,176,229,157,128, _/binary>>).

%% 中国
-define(ZG, <<228,184,173,229,155,189, _/binary>>).

%% 数据中心
-define(SJZX, <<228,184,173,229,155,189,9,228,184,173,229,155,189,9,9>>).

%% =============================================================================
%% @doc interface
%% =============================================================================
%% ----------------- data ----------------
%% ------ index ----- ------ string ------
%% -- falg -------------------------------
read() ->
    {ok, Data} = file:read_file(?READ_PATH), Data.

%% =============================================================================
%% IP:<<123,123,123,123>>
find(Data, IP) ->
    Prefix = binary:at(IP, 0),
    Value = ?B2IU(IP),
    Start = flag32i(Prefix, Data),
    loop_find(Start * 8 + 1024, Data, Value).

loop_find(Start, Data, Value) ->
    case ?B2IU(index32b(Start, Data)) >= Value of
        false -> loop_find(Start + 8, Data, Value);
        true -> find_result(Start, Data)
    end.

find_result(Start, Data) ->
    Offset = ?B2IL(index32b(Start + 4, Data)) band 16#00FFFFFF,
    Length = index8(Start + 7, Data),
    string(Offset - 1024, Length, Data).

flag32i(N, Data) ->
    <<_:32, _:N/unit:32, V:32/integer-unsigned-little, _/bits>> = Data, V.

index32b(N, Data) ->
    <<_:32, _:N/unit:8, V:4/binary, _/bits>> = Data, V.

index8(N, Data) ->
    <<_:32, _:N/unit:8, V:8/integer-unsigned, _/bits>> = Data, V.

string(N, Len, Data) ->
    Length = ?B2IU(Data) + N,
    <<_:Length/unit:8, V:Len/binary, _/bits>> = Data, V.

%% =============================================================================
parse(Data) ->
    io:format("start parse =>~n"),
    {ok, File} = file:open(?WRITE_PATH, [write]),
    loop_spawn(Data, ?IP_MAX),
    Len = ?IP_MAX * ?IP_MAX * ?IP_MAX,
    Result = wait(0, Len, []),
    io:format(File, "~p", [Result]),
    io:format("~nparse ok ~n").

loop_spawn(_Data, 0) -> skip;
loop_spawn(Data, 10) -> loop_spawn(Data, 10 - 1);
loop_spawn(Data, 127) -> loop_spawn(Data, 127 - 1);
loop_spawn(Data, P1) ->
    Parent = self(),
    spawn(fun() -> start_parse(Parent, Data, P1) end),
    loop_spawn(Data, P1 - 1).

start_parse(Parent, Data, P1) ->
    List = [<<P1, P2, P3, 0>> || P2 <- lists:seq(0, ?IP_MAX), P3 <- lists:seq(0, ?IP_MAX)],
    loop_parse(Parent, Data, List).

loop_parse(Parent, Data, [IP | T]) ->
    Result = find(Data, IP),
    Parent ! {IP, Result},
    loop_parse(Parent, Data, T);
loop_parse(_Parent, _Data, []) -> skip.

wait(Len, Len, Acc) -> Acc;
wait(Cur, Len, Acc) ->
    Cur rem (Len div 100) =:= 0 andalso io:format("="),
    receive
        {_IP, ?SJZX} ->
            wait(Cur + 1, Len, Acc);
        {IP, ?ZG = Result} ->
            case binary:split(Result, [<<"\t">>, <<" ">>], [global, trim]) of
                [] -> wait(Cur + 1, Len, Acc);
                List -> wait(Cur + 1, Len, [[IP, lists:last(List)] | Acc])
            end;
        _ ->
            wait(Cur + 1, Len, Acc)
    end.

