#!/usr/bin/env escript
%% escript -n ipip.escript

main([]) ->
    io:setopts([{encoding, utf8}]),
    c:c(ipip),
    ipip:parse(ipip:read()).

