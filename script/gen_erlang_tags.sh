#!/bin/bash
## Erlang Source 前缀，这里默认是通过sudo apt-get 安装之后的默认路径
## 需要修改成自己对应路径
ErlSrcPrifix=/usr/lib/erlang/lib/

alias eltags='~/.vim/bundle/vim-erlang-tags/bin/vim-erlang-tags.erl'

echo  "生成Erlang stdlib、kernel、sasl标签文件"
eltags -o ~/ctags_dir/erlang.tags ${ErlSrcPrifix}/stdlib-2.5/src ${ErlSrcPrifix}/kernel-4.0/src  ${ErlSrcPrifix}/sasl-2.5/src 

echo "生成项目依赖库标签文件"
find ~/work/u3d/server/erl_deps/*/src/* | eltags -o ~/ctags_dir/u3d_deps.tags

echo "生成项目库标签文件"
eltags -o ~/ctags_dir/u3d_proj.tags ~/work/u3d/server/u3d_proj/src
eltags -o ~/ctags_dir/u3d_robot.tags ~/work/u3d/server/u3d_robot/src

echo "生成完毕!"
