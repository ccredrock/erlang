# erlang 代码机制

## 代码编译 compile:options()
* 源代码:     test.erl
* 核心代码:   compile:file(test, to_core) -> test.core
* 汇编代码:   compile:file(test, to_asm)  -> test.asm
* 虚拟机代码: compile:file(test)          -> test.beam
* 本地代码:   compile:file(test, native)  -> test.beam
* 运行时代码: erts_debug:df(test)         -> test.dis

## 代码加载
* code_ix

## 代码运行
* export_tables
* moudle_tables
* erts_atom_table

## 代码热更新
* prepare
* kill(cur && old)
* complete

## 跳转表
* goto label

## 链接
* [分析erlang热更新实现机制](http://blog.csdn.net/mycwq/article/details/43372687)
* [erlang虚拟机代码执行原理](http://blog.csdn.net/mycwq/article/details/45653897)
