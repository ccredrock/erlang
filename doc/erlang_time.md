#时间扭曲有三种模式：
1. 无扭曲、单扭曲、多扭曲
2. 每种模式都对应有开启和不开启时间校正两种 对应6种情况
3. 默认无扭曲&&开启时间校正

##无扭曲开启时间校正：+c true +C no_time_warp
* erlang:monotonic_time 调整频率
* erlang:time_offset 不变

##无扭曲不开启时间校正：+c false +C no_time_warp
* erlang:monotonic_time 冻结或直接设置
* erlang:time_offset 不变

##单扭曲开启时间校正：+c true +C single_time_warp
* 第一阶段
erlang:monotonic_time 正常频率
erlang:time_offset 调整
* 第二阶段
erlang:monotonic_time 调整频率
erlang:time_offset 不变

##单扭曲不开启时间校正：+c false +C single_time_warp
* erlang:monotonic_time 冻结或直接设置
* erlang:time_offset 不变

##多扭曲开启时间校正：+c true +C multi_time_warp
* erlang:monotonic_time 正常频率
* erlang:time_offset 调整

##多扭曲不开启时间校正：+c false +C multi_time_warp
* erlang:monotonic_time 冻结(很快之后时间偏移)或直接设置
* erlang:time_offset 不变

