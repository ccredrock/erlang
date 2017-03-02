#!/usr/bin/env escript
%% escript -n ipip.escript

main([]) ->
    c:c(ipip),
    rand:seed(exsplus, {erlang:monotonic_time(),
                        erlang:time_offset(),
                        erlang:unique_integer()}),
    Data = ipip:read(),
    io:setopts([{encoding, unicode}]),
    List = [begin
                IP1 = rand:uniform(255 + 1) - 1,
                IP2 = rand:uniform(255 + 1) - 1,
                IP3 = rand:uniform(255 + 1) - 1,
                IP4 = rand:uniform(255 + 1) - 1,
                IP = <<IP1, IP2, IP3, IP4>>,
                Result = ipip:find_city(Data, IP),
                io:format("~w\t~ts~n", [IP, Result])
            end || _ <- lists:seq(1, 100)].

