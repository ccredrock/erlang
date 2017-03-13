#gen_server里有趣设计

##debug
* 入口 start && enter_loop && system
* 回调 sys:handle_system_msg sys:handle_debug
* 调用 get_state: sys -> gen_server -> sys -> gen_server
* 功能 trace log statistics log_to_file install suspend

##terminate
* `exit(proc, _s)` 不会调用terminate

##gen:call
* monitor
