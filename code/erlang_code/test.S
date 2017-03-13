{module, test}.  %% version = 0

{exports, [{do_test,0},{do_test3,1},{module_info,0},{module_info,1},{test,0}]}.

{attributes, []}.

{labels, 17}.


{function, test, 0, 2}.
  {label,1}.
    {line,[{location,"test.erl",9}]}.
    {func_info,{atom,test},{atom,test},0}.
  {label,2}.
    {allocate,0,0}.
    {move,{integer,100},{x,1}}.
    {move,{integer,1},{x,0}}.
    {line,[{location,"test.erl",11}]}.
    {call_ext,2,{extfunc,lists,seq,2}}.
    {line,[{location,"test.erl",12}]}.
    {call_ext,0,{extfunc,test,do_test,0}}.
    {line,[{location,"test.erl",13}]}.
    {call,0,{f,4}}.
    {line,[{location,"test.erl",14}]}.
    {call,0,{f,6}}.
    {make_fun2,{f,16},0,0,0}.
    {line,[{location,"test.erl",15}]}.
    {call_fun,0}.
    {line,[{location,"test.erl",16}]}.
    {call,0,{f,4}}.
    {call_last,0,{f,6},0}.


{function, do_test, 0, 4}.
  {label,3}.
    {line,[{location,"test.erl",19}]}.
    {func_info,{atom,test},{atom,do_test},0}.
  {label,4}.
    {move,{integer,100},{x,1}}.
    {move,{integer,1},{x,0}}.
    {line,[{location,"test.erl",19}]}.
    {call_ext_only,2,{extfunc,lists,seq,2}}.


{function, do_test1, 0, 6}.
  {label,5}.
    {line,[{location,"test.erl",21}]}.
    {func_info,{atom,test},{atom,do_test1},0}.
  {label,6}.
    {move,{integer,100},{x,1}}.
    {move,{integer,1},{x,0}}.
    {line,[{location,"test.erl",21}]}.
    {call_ext_only,2,{extfunc,lists,seq,2}}.


{function, do_test3, 1, 8}.
  {label,7}.
    {line,[{location,"test.erl",23}]}.
    {func_info,{atom,test},{atom,do_test3},1}.
  {label,8}.
    {allocate_zero,1,1}.
    {line,[{location,"test.erl",24}]}.
    {test,is_tuple,{f,10},[{x,0}]}.
    {test,test_arity,{f,9},[{x,0},5]}.
    {get_tuple_element,{x,0},0,{x,1}}.
    {test,is_eq_exact,{f,9},[{x,1},{atom,test}]}.
  {label,9}.
    {test,is_tuple,{f,10},[{x,0}]}.
    {test,test_arity,{f,10},[{x,0},5]}.
    {get_tuple_element,{x,0},0,{x,1}}.
    {test,is_eq_exact,{f,10},[{x,1},{atom,test}]}.
    {get_tuple_element,{x,0},1,{x,0}}.
    {move,{x,0},{y,0}}.
    {line,[{location,"test.erl",25}]}.
    {call,1,{f,8}}.
    {move,{y,0},{x,0}}.
    {call_last,1,{f,8},1}.
  {label,10}.
    {move,{literal,{badrecord,test}},{x,0}}.
    {line,[{location,"test.erl",25}]}.
    {call_ext,1,{extfunc,erlang,error,1}}.


{function, module_info, 0, 12}.
  {label,11}.
    {line,[]}.
    {func_info,{atom,test},{atom,module_info},0}.
  {label,12}.
    {move,{atom,test},{x,0}}.
    {line,[]}.
    {call_ext_only,1,{extfunc,erlang,get_module_info,1}}.


{function, module_info, 1, 14}.
  {label,13}.
    {line,[]}.
    {func_info,{atom,test},{atom,module_info},1}.
  {label,14}.
    {move,{x,0},{x,1}}.
    {move,{atom,test},{x,0}}.
    {line,[]}.
    {call_ext_only,2,{extfunc,erlang,get_module_info,2}}.


{function, '-test/0-fun-0-', 0, 16}.
  {label,15}.
    {line,[{location,"test.erl",15}]}.
    {func_info,{atom,test},{atom,'-test/0-fun-0-'},0}.
  {label,16}.
    {line,[{location,"test.erl",15}]}.
    {call_ext_only,0,{extfunc,lists,seq,0}}.
