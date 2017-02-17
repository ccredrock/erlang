
%%%--------------------------------------------------------------------
%%% @author     ccredrock@gmail.com
%%% @copyright  2015/5/11
%%% @doc   
%%%             贷款计算
%%% @end
%%%--------------------------------------------------------------------
-module(daikuan).

-export([cal_lixi13/3,
         cal_yue_huankuan/3,
         cal_nian_touzi/3,
         cmp_gong_dai/4,
         cmp_gong_dai/6,
         cmp_shang_dai/4,
         cmp_shang_dai/6,
         cal_huankuan_touzi/6,
         cal_yue_touzi/3]).

-define(DAIKUAN_TYPE_SHANGYE,   1).
-define(DAIKUAN_TYPE_GONGJIJIN, 2).

%% 等额本息
cal_lixi(BenJIn, Nian, NianLilv) ->
    Yue = Nian * 12,
    YueHuanKuan = cal_yue_huankuan(BenJIn, Nian, NianLilv), 
    YueHuanKuan * Yue - BenJIn.

%% 贷款
cal_yue_huankuan(BenJIn, Nian, NianLilv) ->
    YueLiLv = NianLilv / 12,
    Yue = Nian * 12,
    BenJIn * YueLiLv * math:pow(1 + YueLiLv, Yue) / (math:pow(1 + YueLiLv, Yue) - 1).

%% 贷款 1000 每月投资100 还款5年 还款利率5.9% 投资10年 投资利率6% 10年后得 10330
cal_huankuan_touzi(BenJIn, HuanKuanNian, HuanKuanLilv, YueTouZi, TouZiNian, TouZiNianLiLv) ->
    YueHuanKuan = cal_yue_huankuan(BenJIn, HuanKuanNian, HuanKuanLilv),
    TouZi = YueTouZi - YueHuanKuan,
    ZiJin1 = cal_nian_touzi(TouZi, HuanKuanNian, TouZiNianLiLv),
    ZiJin2 = cal_nian_touzi(YueTouZi, TouZiNian - HuanKuanNian, TouZiNianLiLv),
    ZiJin1 + ZiJin2.

%% 每月投资100 投资5年 利率6% 5年后得 6984
cal_nian_touzi(YueTouZi, TouZiNian, TouZiNianLiLv) ->
    ZongYue = TouZiNian * 12,
    Fun = fun(Yue, Acc) ->
                  Acc + cal_yue_touzi(YueTouZi, Yue, TouZiNianLiLv)
          end,
    lists:foldr(Fun, 0, lists:seq(1, ZongYue)). 

%% 当月投资100 投资13个月 利率6% 13个月后得  
cal_yue_touzi(YueTouZi, TouZiYue, TouZiNianLiLv) ->
    Nian = TouZiYue div 12,
    Yue = TouZiYue rem 12,
    YueTouZi * math:pow(1 + TouZiNianLiLv, Nian) * (1 + Yue / 12 * TouZiNianLiLv).


do_get_shangdai_lilv(Nian) ->
    case Nian =< 5 of
        true -> 0.055;
        false -> 0.0565
    end.

do_get_gongdai_lilv(Nian) ->
    case Nian =< 5 of
        true -> 0.0325;
        false -> 0.0375
    end.

do_get_daikuan_lilv(DaiKuanType, Nian) ->
    case DaiKuanType of
        ?DAIKUAN_TYPE_SHANGYE -> do_get_shangdai_lilv(Nian);
        ?DAIKUAN_TYPE_GONGJIJIN -> do_get_gongdai_lilv(Nian)
    end.

cmp_gong_dai(BenJIn, HuanKuanNian1, HuanKuanNian2, TouZiNianLiLv) ->
    cmp_daikuan(BenJIn, HuanKuanNian1, HuanKuanNian2, TouZiNianLiLv, ?DAIKUAN_TYPE_GONGJIJIN).

cmp_shang_dai(BenJIn, HuanKuanNian1, HuanKuanNian2, TouZiNianLiLv) ->
    cmp_daikuan(BenJIn, HuanKuanNian1, HuanKuanNian2, TouZiNianLiLv, ?DAIKUAN_TYPE_SHANGYE).

cmp_daikuan(BenJIn, HuanKuanNian1, HuanKuanNian2, TouZiNianLiLv, DaiKuanType) ->
    LiLv1 = do_get_daikuan_lilv(DaiKuanType, HuanKuanNian1),
    YueHuanKuan1 = cal_yue_huankuan(BenJIn, HuanKuanNian1, LiLv1),
    LiLv2 = do_get_daikuan_lilv(DaiKuanType, HuanKuanNian2),
    YueHuanKuan2 = cal_yue_huankuan(BenJIn, HuanKuanNian2, LiLv2),
    case HuanKuanNian1 < HuanKuanNian2 of
        true -> 
            YueTouZi = YueHuanKuan1,
            TouZiNian = HuanKuanNian2;
        false -> 
            YueTouZi = YueHuanKuan2,
            TouZiNian = HuanKuanNian1
    end,
    ShouYi1 = cal_huankuan_touzi(BenJIn, HuanKuanNian1, LiLv1, YueTouZi, TouZiNian, TouZiNianLiLv),
    ShouYi2 = cal_huankuan_touzi(BenJIn, HuanKuanNian2, LiLv1, YueTouZi, TouZiNian, TouZiNianLiLv),
    io:format("BenJin:~p, HuanKuanNian:~p, MeiYueHuan:~p, YueTou:~p, ZongShouYi:~p~n", 
              [BenJIn, HuanKuanNian1, YueHuanKuan1, YueTouZi, ShouYi1]),
    io:format("BenJin:~p, HuanKuanNian:~p, MeiYueHuan:~p, YueTou:~p, ZongShouYi:~p~n", 
              [BenJIn, HuanKuanNian2, YueHuanKuan2, YueTouZi, ShouYi2]).

cmp_gong_dai(BenJIn, HuanKuanNian1, HuanKuanNian2, YueTouZi, TouZiNian, TouZiNianLiLv) ->
    cmp_daikuan(BenJIn, HuanKuanNian1, HuanKuanNian2, YueTouZi, TouZiNian, TouZiNianLiLv, ?DAIKUAN_TYPE_GONGJIJIN).

cmp_shang_dai(BenJIn, HuanKuanNian1, HuanKuanNian2, YueTouZi, TouZiNian, TouZiNianLiLv) ->
    cmp_daikuan(BenJIn, HuanKuanNian1, HuanKuanNian2, YueTouZi, TouZiNian, TouZiNianLiLv, ?DAIKUAN_TYPE_SHANGYE).

cmp_daikuan(BenJIn, HuanKuanNian1, HuanKuanNian2, YueTouZi, TouZiNian, TouZiNianLiLv, DaiKuanType) ->
    LiLv1 = do_get_daikuan_lilv(DaiKuanType, HuanKuanNian1),
    YueHuanKuan1 = cal_yue_huankuan(BenJIn, HuanKuanNian1, LiLv1),
    ShouYi1 = cal_huankuan_touzi(BenJIn, HuanKuanNian1, LiLv1, YueTouZi, TouZiNian, TouZiNianLiLv),
    io:format("BenJin:~p, HuanKuanNian:~p, MeiYueHuan:~p, YueTou:~p, TouZiNian:~p, ZongShouYi:~p~n", 
              [BenJIn, HuanKuanNian1, YueHuanKuan1, YueTouZi, TouZiNian, ShouYi1]),
    LiLv2 = do_get_daikuan_lilv(DaiKuanType, HuanKuanNian2),
    YueHuanKuan2 = cal_yue_huankuan(BenJIn, HuanKuanNian2, LiLv2),
    ShouYi2 = cal_huankuan_touzi(BenJIn, HuanKuanNian2, LiLv1, YueTouZi, TouZiNian, TouZiNianLiLv),
    io:format("BenJin:~p, HuanKuanNian:~p, MeiYueHuan:~p, YueTou:~p, TouZiNian:~p, ZongShouYi:~p~n", 
              [BenJIn, HuanKuanNian2, YueHuanKuan2, YueTouZi, TouZiNian, ShouYi2]).
