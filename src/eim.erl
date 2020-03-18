%%
%% Copyright (C) 2011 by Steven Gravell
%% 
%% Permission is hereby granted, free of charge, to any person obtaining a copy
%% of this software and associated documentation files (the "Software"), to deal
%% in the Software without restriction, including without limitation the rights
%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%% copies of the Software, and to permit persons to whom the Software is
%% furnished to do so, subject to the following conditions:
%% 
%% The above copyright notice and this permission notice shall be included in
%% all copies or substantial portions of the Software.
%% 
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%%

-module(eim).
-author('Steven Gravell <steve@mokele.co.uk>').
-export([load/1, derive/3]).
-on_load(init/0).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

init() ->
    SoName = case code:priv_dir(eim) of
        {error, bad_name} ->
            filename:join([filename:dirname(code:which(?MODULE)), "..", "priv", "eim"]);
        Dir ->
            filename:join(Dir, "eim")
    end,
    erlang:load_nif(SoName, 0).

-spec load(binary()) -> {ok, reference()} | error.
load(_Bin) ->
    exit(nif_library_not_loaded).

-type image_format() :: jpg | gif | png.
-type deriv() :: deriv_opt() | [deriv_opt()].
-type deriv_opt() :: {crop, integer(), integer(), integer(), integer()}
                   | {scale, dimension(), integer()}
                   | {max, dimension(), integer()}
                   | {box, integer(), integer()}
                   | {box, integer(), integer(), h_float(), v_float()}
                   | {fit, integer(), integer()}
                   | {rotate, rotate()}.
-type dimension() :: width | height.
-type rotate() :: 1 | 2 | 3.
-type h_float() :: left | center | right.
-type v_float() :: top | center | bottom.
-spec derive(reference(), image_format(), deriv()) -> binary() | error.
derive(Image, Fmt, Deriv) when is_tuple(Deriv)->
    derive(Image, Fmt, [Deriv]);
derive(Image, Fmt, Deriv) ->
    do_derive(Image, Fmt, Deriv).

do_derive(_Image, _Fmt, _Deriv) ->
    exit(nif_library_not_loaded).

%% ===================================================================
%% EUnit tests
%% ===================================================================
-ifdef(TEST).

all_test() ->
    error = load(<<>>),
    ok.

-endif.