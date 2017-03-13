-module(test).

-export([test/0,
         do_test/0,
         do_test3/1]).

-record(test, {a,b,c,d}).

test() ->
     
    lists:seq(1, 100),
    test:do_test(),
    do_test(),
    do_test1(),
    (fun() -> lists:seq() end)(),
    (fun do_test/0)(),
    (fun do_test1/0)().

do_test() -> lists:seq(1, 100).

do_test1() -> lists:seq(1, 100).

do_test3(X) ->
    is_record(X, test),
    do_test3(X#test.a),
    do_test3(element(#test.a, X)).
