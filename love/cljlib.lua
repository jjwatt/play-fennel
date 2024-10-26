local function _1_()
  local Reduced
  local function _4_(_2_, view, options, indent)
    local _arg_3_ = _2_
    local x = _arg_3_[1]
    return ("#<reduced: " .. view(x, options, (11 + indent)) .. ">")
  end
  local function _7_(_5_)
    local _arg_6_ = _5_
    local x = _arg_6_[1]
    return x
  end
  local function _10_(_8_)
    local _arg_9_ = _8_
    local x = _arg_9_[1]
    return ("reduced: " .. tostring(x))
  end
  Reduced = {__fennelview = _4_, __index = {unbox = _7_}, __name = "reduced", __tostring = _10_}
  local function reduced(value)
    return setmetatable({value}, Reduced)
  end
  local function reduced_3f(value)
    return rawequal(getmetatable(value), Reduced)
  end
  return {is_reduced = reduced_3f, reduced = reduced, ["reduced?"] = reduced_3f}
end
package.preload.reduced = (package.preload.reduced or _1_)
local function _11_()
  local _local_12_ = table
  local t_2fsort = _local_12_["sort"]
  local t_2fconcat = _local_12_["concat"]
  local t_2fremove = _local_12_["remove"]
  local t_2fmove = _local_12_["move"]
  local t_2finsert = _local_12_["insert"]
  local t_2funpack = (table.unpack or _G.unpack)
  local t_2fpack
  local function _13_(...)
    local _14_ = {...}
    _14_["n"] = select("#", ...)
    return _14_
  end
  t_2fpack = _13_
  local function pairs_2a(t)
    local _16_
    do
      local _15_ = getmetatable(t)
      if ((_G.type(_15_) == "table") and (nil ~= _15_.__pairs)) then
        local p = _15_.__pairs
        _16_ = p
      else
        local _ = _15_
        _16_ = pairs
      end
    end
    return _16_(t)
  end
  local function ipairs_2a(t)
    local _21_
    do
      local _20_ = getmetatable(t)
      if ((_G.type(_20_) == "table") and (nil ~= _20_.__ipairs)) then
        local i = _20_.__ipairs
        _21_ = i
      else
        local _ = _20_
        _21_ = ipairs
      end
    end
    return _21_(t)
  end
  local function length_2a(t)
    local _26_
    do
      local _25_ = getmetatable(t)
      if ((_G.type(_25_) == "table") and (nil ~= _25_.__len)) then
        local l = _25_.__len
        _26_ = l
      else
        local _ = _25_
        local function _29_(...)
          return #...
        end
        _26_ = _29_
      end
    end
    return _26_(t)
  end
  local function copy(t)
    if t then
      local tbl_14_auto = {}
      for k, v in pairs_2a(t) do
        local k_15_auto, v_16_auto = k, v
        if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
          tbl_14_auto[k_15_auto] = v_16_auto
        else
        end
      end
      return tbl_14_auto
    else
      return nil
    end
  end
  local function eq(...)
    local _33_, _34_, _35_ = select("#", ...), ...
    if ((_33_ == 0) or (_33_ == 1)) then
      return true
    elseif ((_33_ == 2) and true and true) then
      local _3fa = _34_
      local _3fb = _35_
      if (_3fa == _3fb) then
        return true
      elseif (function(_36_,_37_,_38_) return (_36_ == _37_) and (_37_ == _38_) end)(type(_3fa),type(_3fb),"table") then
        local res, count_a, count_b = true, 0, 0
        for k, v in pairs_2a(_3fa) do
          if not res then break end
          local function _39_(...)
            local res0 = nil
            for k_2a, v0 in pairs_2a(_3fb) do
              if res0 then break end
              if eq(k_2a, k) then
                res0 = v0
              else
              end
            end
            return res0
          end
          res = eq(v, _39_(...))
          count_a = (count_a + 1)
        end
        if res then
          for _, _0 in pairs_2a(_3fb) do
            count_b = (count_b + 1)
          end
          res = (count_a == count_b)
        else
        end
        return res
      else
        return false
      end
    elseif (true and true and true) then
      local _ = _33_
      local _3fa = _34_
      local _3fb = _35_
      return (eq(_3fa, _3fb) and eq(select(2, ...)))
    else
      return nil
    end
  end
  local function deep_index(tbl, key)
    local res = nil
    for k, v in pairs_2a(tbl) do
      if res then break end
      if eq(k, key) then
        res = v
      else
        res = nil
      end
    end
    return res
  end
  local function deep_newindex(tbl, key, val)
    local done = false
    if ("table" == type(key)) then
      for k, _ in pairs_2a(tbl) do
        if done then break end
        if eq(k, key) then
          rawset(tbl, k, val)
          done = true
        else
        end
      end
    else
    end
    if not done then
      return rawset(tbl, key, val)
    else
      return nil
    end
  end
  local function immutable(t, opts)
    local t0
    if (opts and opts["fast-index?"]) then
      t0 = t
    else
      t0 = setmetatable(t, {__index = deep_index, __newindex = deep_newindex})
    end
    local len = length_2a(t0)
    local proxy = {}
    local __len
    local function _49_()
      return len
    end
    __len = _49_
    local __index
    local function _50_(_241, _242)
      return t0[_242]
    end
    __index = _50_
    local __newindex
    local function _51_()
      return error((tostring(proxy) .. " is immutable"), 2)
    end
    __newindex = _51_
    local __pairs
    local function _52_()
      local function _53_(_, k)
        return next(t0, k)
      end
      return _53_, nil, nil
    end
    __pairs = _52_
    local __ipairs
    local function _54_()
      local function _55_(_, k)
        return next(t0, k)
      end
      return _55_
    end
    __ipairs = _54_
    local __call
    local function _56_(_241, _242)
      return t0[_242]
    end
    __call = _56_
    local __fennelview
    local function _57_(_241, _242, _243, _244)
      return _242(t0, _243, _244)
    end
    __fennelview = _57_
    local __fennelrest
    local function _58_(_241, _242)
      return immutable({t_2funpack(t0, _242)})
    end
    __fennelrest = _58_
    return setmetatable(proxy, {__index = __index, __newindex = __newindex, __len = __len, __pairs = __pairs, __ipairs = __ipairs, __call = __call, __metatable = {__len = __len, __pairs = __pairs, __ipairs = __ipairs, __call = __call, __fennelrest = __fennelrest, __fennelview = __fennelview, ["itable/type"] = "immutable"}})
  end
  local function insert(t, ...)
    local t0 = copy(t)
    do
      local _59_, _60_, _61_ = select("#", ...), ...
      if (_59_ == 0) then
        error("wrong number of arguments to 'insert'")
      elseif ((_59_ == 1) and true) then
        local _3fv = _60_
        t_2finsert(t0, _3fv)
      elseif (true and true and true) then
        local _ = _59_
        local _3fk = _60_
        local _3fv = _61_
        t_2finsert(t0, _3fk, _3fv)
      else
      end
    end
    return immutable(t0)
  end
  local move
  if t_2fmove then
    local function _63_(src, start, _end, tgt, dest)
      local src0 = copy(src)
      local dest0 = copy(dest)
      return immutable(t_2fmove(src0, start, _end, tgt, dest0))
    end
    move = _63_
  else
    move = nil
  end
  local function pack(...)
    local function _66_(...)
      local _65_ = {...}
      _65_["n"] = select("#", ...)
      return _65_
    end
    return immutable(_66_(...))
  end
  local function remove(t, key)
    local t0 = copy(t)
    local v = t_2fremove(t0, key)
    return immutable(t0), v
  end
  local function concat(t, sep, start, _end, serializer, opts)
    local serializer0 = (serializer or tostring)
    local _67_
    do
      local tbl_19_auto = {}
      local i_20_auto = 0
      for _, v in ipairs_2a(t) do
        local val_21_auto = serializer0(v, opts)
        if (nil ~= val_21_auto) then
          i_20_auto = (i_20_auto + 1)
          do end (tbl_19_auto)[i_20_auto] = val_21_auto
        else
        end
      end
      _67_ = tbl_19_auto
    end
    return t_2fconcat(_67_, sep, start, _end)
  end
  local function unpack(t, ...)
    return t_2funpack(copy(t), ...)
  end
  local function assoc(t, key, val, ...)
    local len = select("#", ...)
    if (0 ~= (len % 2)) then
      error(("no value supplied for key " .. tostring(select(len, ...))), 2)
    else
    end
    local t0
    do
      local _70_ = copy(t)
      do end (_70_)[key] = val
      t0 = _70_
    end
    for i = 1, len, 2 do
      local k, v = select(i, ...)
      do end (t0)[k] = v
    end
    return immutable(t0)
  end
  local function assoc_in(t, _71_, val)
    local _arg_72_ = _71_
    local k = _arg_72_[1]
    local ks = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_arg_72_, 2)
    local t0 = (t or {})
    if next(ks) then
      return assoc(t0, k, assoc_in((t0[k] or {}), ks, val))
    else
      return assoc(t0, k, val)
    end
  end
  local function update(t, key, f)
    local function _75_()
      local _74_ = copy(t)
      do end (_74_)[key] = f(t[key])
      return _74_
    end
    return immutable(_75_())
  end
  local function update_in(t, _76_, f)
    local _arg_77_ = _76_
    local k = _arg_77_[1]
    local ks = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_arg_77_, 2)
    local t0 = (t or {})
    if next(ks) then
      return assoc(t0, k, update_in(t0[k], ks, f))
    else
      return update(t0, k, f)
    end
  end
  local function deepcopy(x)
    local function deepcopy_2a(x0, seen)
      local _79_ = type(x0)
      if (_79_ == "table") then
        local _80_ = seen[x0]
        if (_80_ == true) then
          return error("immutable tables can't contain self reference", 2)
        else
          local _ = _80_
          seen[x0] = true
          local function _81_()
            local tbl_14_auto = {}
            for k, v in pairs_2a(x0) do
              local k_15_auto, v_16_auto = deepcopy_2a(k, seen), deepcopy_2a(v, seen)
              if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
                tbl_14_auto[k_15_auto] = v_16_auto
              else
              end
            end
            return tbl_14_auto
          end
          return immutable(_81_())
        end
      else
        local _ = _79_
        return x0
      end
    end
    return deepcopy_2a(x, {})
  end
  local function first(_85_)
    local _arg_86_ = _85_
    local x = _arg_86_[1]
    return x
  end
  local function rest(t)
    local _87_ = remove(t, 1)
    return _87_
  end
  local function nthrest(t, n)
    local t_2a = {}
    for i = (n + 1), length_2a(t) do
      t_2finsert(t_2a, t[i])
    end
    return immutable(t_2a)
  end
  local function last(t)
    return t[length_2a(t)]
  end
  local function butlast(t)
    local _88_ = remove(t, length_2a(t))
    return _88_
  end
  local function join(...)
    local _89_, _90_, _91_ = select("#", ...), ...
    if (_89_ == 0) then
      return nil
    elseif ((_89_ == 1) and true) then
      local _3ft = _90_
      return immutable(copy(_3ft))
    elseif ((_89_ == 2) and true and true) then
      local _3ft1 = _90_
      local _3ft2 = _91_
      local to = copy(_3ft1)
      local from = (_3ft2 or {})
      for _, v in ipairs_2a(from) do
        t_2finsert(to, v)
      end
      return immutable(to)
    elseif (true and true and true) then
      local _ = _89_
      local _3ft1 = _90_
      local _3ft2 = _91_
      return join(join(_3ft1, _3ft2), select(3, ...))
    else
      return nil
    end
  end
  local function take(n, t)
    local t_2a = {}
    for i = 1, n do
      t_2finsert(t_2a, t[i])
    end
    return immutable(t_2a)
  end
  local function drop(n, t)
    return nthrest(t, n)
  end
  local function partition(...)
    local res = {}
    local function partition_2a(...)
      local _93_, _94_, _95_, _96_, _97_ = select("#", ...), ...
      if ((_93_ == 0) or (_93_ == 1)) then
        return error("wrong amount arguments to 'partition'")
      elseif ((_93_ == 2) and true and true) then
        local _3fn = _94_
        local _3ft = _95_
        return partition_2a(_3fn, _3fn, _3ft)
      elseif ((_93_ == 3) and true and true and true) then
        local _3fn = _94_
        local _3fstep = _95_
        local _3ft = _96_
        local p = take(_3fn, _3ft)
        if (_3fn == length_2a(p)) then
          t_2finsert(res, p)
          return partition_2a(_3fn, _3fstep, {t_2funpack(_3ft, (_3fstep + 1))})
        else
          return nil
        end
      elseif (true and true and true and true and true) then
        local _ = _93_
        local _3fn = _94_
        local _3fstep = _95_
        local _3fpad = _96_
        local _3ft = _97_
        local p = take(_3fn, _3ft)
        if (_3fn == length_2a(p)) then
          t_2finsert(res, p)
          return partition_2a(_3fn, _3fstep, _3fpad, {t_2funpack(_3ft, (_3fstep + 1))})
        else
          return t_2finsert(res, take(_3fn, join(p, _3fpad)))
        end
      else
        return nil
      end
    end
    partition_2a(...)
    return immutable(res)
  end
  local function keys(t)
    local function _101_()
      local tbl_19_auto = {}
      local i_20_auto = 0
      for k, _ in pairs_2a(t) do
        local val_21_auto = k
        if (nil ~= val_21_auto) then
          i_20_auto = (i_20_auto + 1)
          do end (tbl_19_auto)[i_20_auto] = val_21_auto
        else
        end
      end
      return tbl_19_auto
    end
    return immutable(_101_())
  end
  local function vals(t)
    local function _103_()
      local tbl_19_auto = {}
      local i_20_auto = 0
      for _, v in pairs_2a(t) do
        local val_21_auto = v
        if (nil ~= val_21_auto) then
          i_20_auto = (i_20_auto + 1)
          do end (tbl_19_auto)[i_20_auto] = val_21_auto
        else
        end
      end
      return tbl_19_auto
    end
    return immutable(_103_())
  end
  local function group_by(f, t)
    local res = {}
    local ungroupped = {}
    for _, v in pairs_2a(t) do
      local k = f(v)
      if (nil ~= k) then
        local _105_ = res[k]
        if (nil ~= _105_) then
          local t_2a = _105_
          t_2finsert(t_2a, v)
        else
          local _0 = _105_
          res[k] = {v}
        end
      else
        t_2finsert(ungroupped, v)
      end
    end
    local function _108_()
      local tbl_14_auto = {}
      for k, t0 in pairs_2a(res) do
        local k_15_auto, v_16_auto = k, immutable(t0)
        if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
          tbl_14_auto[k_15_auto] = v_16_auto
        else
        end
      end
      return tbl_14_auto
    end
    return immutable(_108_()), immutable(ungroupped)
  end
  local function frequencies(t)
    local res = setmetatable({}, {__index = deep_index, __newindex = deep_newindex})
    for _, v in pairs_2a(t) do
      local _110_ = res[v]
      if (nil ~= _110_) then
        local a = _110_
        res[v] = (a + 1)
      else
        local _0 = _110_
        res[v] = 1
      end
    end
    return immutable(res)
  end
  local itable
  local function _112_(t, f)
    local function _114_()
      local _113_ = copy(t)
      t_2fsort(_113_, f)
      return _113_
    end
    return immutable(_114_())
  end
  itable = {sort = _112_, pack = pack, unpack = unpack, concat = concat, insert = insert, move = move, remove = remove, pairs = pairs_2a, ipairs = ipairs_2a, length = length_2a, eq = eq, deepcopy = deepcopy, assoc = assoc, ["assoc-in"] = assoc_in, update = update, ["update-in"] = update_in, keys = keys, vals = vals, ["group-by"] = group_by, frequencies = frequencies, first = first, rest = rest, nthrest = nthrest, last = last, butlast = butlast, join = join, partition = partition, take = take, drop = drop}
  local function _115_(_, t, opts)
    local _116_ = getmetatable(t)
    if ((_G.type(_116_) == "table") and (_116_["itable/type"] == "immutable")) then
      return t
    else
      local _0 = _116_
      return immutable(copy(t), opts)
    end
  end
  return setmetatable(itable, {__call = _115_})
end
package.preload.itable = (package.preload.itable or _11_)
local function _118_()
  local function _119_()
    local Reduced
    local function _122_(_120_, view, options, indent)
      local _arg_121_ = _120_
      local x = _arg_121_[1]
      return ("#<reduced: " .. view(x, options, (11 + indent)) .. ">")
    end
    local function _125_(_123_)
      local _arg_124_ = _123_
      local x = _arg_124_[1]
      return x
    end
    local function _128_(_126_)
      local _arg_127_ = _126_
      local x = _arg_127_[1]
      return ("reduced: " .. tostring(x))
    end
    Reduced = {__fennelview = _122_, __index = {unbox = _125_}, __name = "reduced", __tostring = _128_}
    local function reduced(value)
      return setmetatable({value}, Reduced)
    end
    local function reduced_3f(value)
      return rawequal(getmetatable(value), Reduced)
    end
    return {is_reduced = reduced_3f, reduced = reduced, ["reduced?"] = reduced_3f}
  end
  package.preload.reduced = (package.preload.reduced or _119_)
  utf8 = _G.utf8
  local function pairs_2a(t)
    local mt = getmetatable(t)
    if (("table" == mt) and mt.__pairs) then
      return mt.__pairs(t)
    else
      return pairs(t)
    end
  end
  local function ipairs_2a(t)
    local mt = getmetatable(t)
    if (("table" == mt) and mt.__ipairs) then
      return mt.__ipairs(t)
    else
      return ipairs(t)
    end
  end
  local function rev_ipairs(t)
    local function next(t0, i)
      local i0 = (i - 1)
      if (i0 == 0) then
        return nil
      else
        local _ = i0
        return i0, t0[i0]
      end
    end
    return next, t, (1 + #t)
  end
  local function length_2a(t)
    local mt = getmetatable(t)
    if (("table" == mt) and mt.__len) then
      return mt.__len(t)
    else
      return #t
    end
  end
  local function table_pack(...)
    local _133_ = {...}
    _133_["n"] = select("#", ...)
    return _133_
  end
  local table_unpack = (table.unpack or _G.unpack)
  local seq = nil
  local cons_iter = nil
  local function first(s)
    local _134_ = seq(s)
    if (nil ~= _134_) then
      local s_2a = _134_
      return s_2a(true)
    else
      local _ = _134_
      return nil
    end
  end
  local function empty_cons_view()
    return "@seq()"
  end
  local function empty_cons_len()
    return 0
  end
  local function empty_cons_index()
    return nil
  end
  local function cons_newindex()
    return error("cons cell is immutable")
  end
  local function empty_cons_next(s)
    return nil
  end
  local function empty_cons_pairs(s)
    return empty_cons_next, nil, s
  end
  local function gettype(x)
    local _136_
    do
      local t_137_ = getmetatable(x)
      if (nil ~= t_137_) then
        t_137_ = t_137_["__lazy-seq/type"]
      else
      end
      _136_ = t_137_
    end
    if (nil ~= _136_) then
      local t = _136_
      return t
    else
      local _ = _136_
      return type(x)
    end
  end
  local function realize(c)
    if ("lazy-cons" == gettype(c)) then
      c()
    else
    end
    return c
  end
  local empty_cons = {}
  local function empty_cons_call(tf)
    if tf then
      return nil
    else
      return empty_cons
    end
  end
  local function empty_cons_fennelrest()
    return empty_cons
  end
  local function empty_cons_eq(_, s)
    return rawequal(getmetatable(empty_cons), getmetatable(realize(s)))
  end
  setmetatable(empty_cons, {__call = empty_cons_call, __len = empty_cons_len, __fennelview = empty_cons_view, __fennelrest = empty_cons_fennelrest, ["__lazy-seq/type"] = "empty-cons", __newindex = cons_newindex, __index = empty_cons_index, __name = "cons", __eq = empty_cons_eq, __pairs = empty_cons_pairs})
  local function rest(s)
    local _142_ = seq(s)
    if (nil ~= _142_) then
      local s_2a = _142_
      return s_2a(false)
    else
      local _ = _142_
      return empty_cons
    end
  end
  local function seq_3f(x)
    local tp = gettype(x)
    return ((tp == "cons") or (tp == "lazy-cons") or (tp == "empty-cons"))
  end
  local function empty_3f(x)
    return not seq(x)
  end
  local function next(s)
    return seq(realize(rest(seq(s))))
  end
  local function view_seq(list, options, view, indent, elements)
    table.insert(elements, view(first(list), options, indent))
    do
      local tail = next(list)
      if ("cons" == gettype(tail)) then
        view_seq(tail, options, view, indent, elements)
      else
      end
    end
    return elements
  end
  local function pp_seq(list, view, options, indent)
    local items = view_seq(list, options, view, (indent + 5), {})
    local lines
    do
      local tbl_19_auto = {}
      local i_20_auto = 0
      for i, line in ipairs(items) do
        local val_21_auto
        if (i == 1) then
          val_21_auto = line
        else
          val_21_auto = ("     " .. line)
        end
        if (nil ~= val_21_auto) then
          i_20_auto = (i_20_auto + 1)
          do end (tbl_19_auto)[i_20_auto] = val_21_auto
        else
        end
      end
      lines = tbl_19_auto
    end
    lines[1] = ("@seq(" .. (lines[1] or ""))
    do end (lines)[#lines] = (lines[#lines] .. ")")
    return lines
  end
  local drop = nil
  local function cons_fennelrest(c, i)
    return drop((i - 1), c)
  end
  local allowed_types = {cons = true, ["empty-cons"] = true, ["lazy-cons"] = true, ["nil"] = true, string = true, table = true}
  local function cons_next(_, s)
    if (empty_cons ~= s) then
      local tail = next(s)
      local _147_ = gettype(tail)
      if (_147_ == "cons") then
        return tail, first(s)
      else
        local _0 = _147_
        return empty_cons, first(s)
      end
    else
      return nil
    end
  end
  local function cons_pairs(s)
    return cons_next, nil, s
  end
  local function cons_eq(s1, s2)
    if rawequal(s1, s2) then
      return true
    else
      if (not rawequal(s2, empty_cons) and not rawequal(s1, empty_cons)) then
        local s10, s20, res = s1, s2, true
        while (res and s10 and s20) do
          res = (first(s10) == first(s20))
          s10 = next(s10)
          s20 = next(s20)
        end
        return res
      else
        return false
      end
    end
  end
  local function cons_len(s)
    local s0, len = s, 0
    while s0 do
      s0, len = next(s0), (len + 1)
    end
    return len
  end
  local function cons_index(s, i)
    if (i > 0) then
      local s0, i_2a = s, 1
      while ((i_2a ~= i) and s0) do
        s0, i_2a = next(s0), (i_2a + 1)
      end
      return first(s0)
    else
      return nil
    end
  end
  local function cons(head, tail)
    do local _ = {head, tail} end
    local tp = gettype(tail)
    assert(allowed_types[tp], ("expected nil, cons, table, or string as a tail, got: %s"):format(tp))
    local function _153_(_241, _242)
      if _242 then
        return head
      else
        if (nil ~= tail) then
          local s = tail
          return s
        elseif (tail == nil) then
          return empty_cons
        else
          return nil
        end
      end
    end
    return setmetatable({}, {__call = _153_, ["__lazy-seq/type"] = "cons", __index = cons_index, __newindex = cons_newindex, __len = cons_len, __pairs = cons_pairs, __name = "cons", __eq = cons_eq, __fennelview = pp_seq, __fennelrest = cons_fennelrest})
  end
  local function _156_(s)
    local _157_ = gettype(s)
    if (_157_ == "cons") then
      return s
    elseif (_157_ == "lazy-cons") then
      return seq(realize(s))
    elseif (_157_ == "empty-cons") then
      return nil
    elseif (_157_ == "nil") then
      return nil
    elseif (_157_ == "table") then
      return cons_iter(s)
    elseif (_157_ == "string") then
      return cons_iter(s)
    else
      local _ = _157_
      return error(("expected table, string or sequence, got %s"):format(_), 2)
    end
  end
  seq = _156_
  local function lazy_seq(f)
    local lazy_cons = cons(nil, nil)
    local realize0
    local function _159_()
      local s = seq(f())
      if (nil ~= s) then
        return setmetatable(lazy_cons, getmetatable(s))
      else
        return setmetatable(lazy_cons, getmetatable(empty_cons))
      end
    end
    realize0 = _159_
    local function _161_(_241, _242)
      return realize0()(_242)
    end
    local function _162_(_241, _242)
      return realize0()[_242]
    end
    local function _163_(...)
      realize0()
      return pp_seq(...)
    end
    local function _164_()
      return length_2a(realize0())
    end
    local function _165_()
      return pairs_2a(realize0())
    end
    local function _166_(_241, _242)
      return (realize0() == _242)
    end
    return setmetatable(lazy_cons, {__call = _161_, __index = _162_, __newindex = cons_newindex, __fennelview = _163_, __fennelrest = cons_fennelrest, __len = _164_, __pairs = _165_, __name = "lazy cons", __eq = _166_, ["__lazy-seq/type"] = "lazy-cons"})
  end
  local function list(...)
    local args = table_pack(...)
    local l = empty_cons
    for i = args.n, 1, -1 do
      l = cons(args[i], l)
    end
    return l
  end
  local function spread(arglist)
    local arglist0 = seq(arglist)
    if (nil == arglist0) then
      return nil
    elseif (nil == next(arglist0)) then
      return seq(first(arglist0))
    elseif "else" then
      return cons(first(arglist0), spread(next(arglist0)))
    else
      return nil
    end
  end
  local function list_2a(...)
    local _168_, _169_, _170_, _171_, _172_ = select("#", ...), ...
    if ((_168_ == 1) and true) then
      local _3fargs = _169_
      return seq(_3fargs)
    elseif ((_168_ == 2) and true and true) then
      local _3fa = _169_
      local _3fargs = _170_
      return cons(_3fa, seq(_3fargs))
    elseif ((_168_ == 3) and true and true and true) then
      local _3fa = _169_
      local _3fb = _170_
      local _3fargs = _171_
      return cons(_3fa, cons(_3fb, seq(_3fargs)))
    elseif ((_168_ == 4) and true and true and true and true) then
      local _3fa = _169_
      local _3fb = _170_
      local _3fc = _171_
      local _3fargs = _172_
      return cons(_3fa, cons(_3fb, cons(_3fc, seq(_3fargs))))
    else
      local _ = _168_
      return spread(list(...))
    end
  end
  local function kind(t)
    local _174_ = type(t)
    if (_174_ == "table") then
      local len = length_2a(t)
      local nxt, t_2a, k = pairs_2a(t)
      local function _175_()
        if (len == 0) then
          return k
        else
          return len
        end
      end
      if (nil ~= nxt(t_2a, _175_())) then
        return "assoc"
      elseif (len > 0) then
        return "seq"
      else
        return "empty"
      end
    elseif (_174_ == "string") then
      local len
      if utf8 then
        len = utf8.len(t)
      else
        len = #t
      end
      if (len > 0) then
        return "string"
      else
        return "empty"
      end
    else
      local _ = _174_
      return "else"
    end
  end
  local function rseq(rev)
    local _180_ = gettype(rev)
    if (_180_ == "table") then
      local _181_ = kind(rev)
      if (_181_ == "seq") then
        local function wrap(nxt, t, i)
          local i0, v = nxt(t, i)
          if (nil ~= i0) then
            local function _182_()
              return wrap(nxt, t, i0)
            end
            return cons(v, lazy_seq(_182_))
          else
            return empty_cons
          end
        end
        return wrap(rev_ipairs(rev))
      elseif (_181_ == "empty") then
        return nil
      else
        local _ = _181_
        return error("can't create an rseq from a non-sequential table")
      end
    else
      local _ = _180_
      return error(("can't create an rseq from a " .. _))
    end
  end
  local function _186_(t)
    local _187_ = kind(t)
    if (_187_ == "assoc") then
      local function wrap(nxt, t0, k)
        local k0, v = nxt(t0, k)
        if (nil ~= k0) then
          local function _188_()
            return wrap(nxt, t0, k0)
          end
          return cons({k0, v}, lazy_seq(_188_))
        else
          return empty_cons
        end
      end
      return wrap(pairs_2a(t))
    elseif (_187_ == "seq") then
      local function wrap(nxt, t0, i)
        local i0, v = nxt(t0, i)
        if (nil ~= i0) then
          local function _190_()
            return wrap(nxt, t0, i0)
          end
          return cons(v, lazy_seq(_190_))
        else
          return empty_cons
        end
      end
      return wrap(ipairs_2a(t))
    elseif (_187_ == "string") then
      local char
      if utf8 then
        char = utf8.char
      else
        char = string.char
      end
      local function wrap(nxt, t0, i)
        local i0, v = nxt(t0, i)
        if (nil ~= i0) then
          local function _193_()
            return wrap(nxt, t0, i0)
          end
          return cons(char(v), lazy_seq(_193_))
        else
          return empty_cons
        end
      end
      local function _195_()
        if utf8 then
          return utf8.codes(t)
        else
          return ipairs_2a({string.byte(t, 1, #t)})
        end
      end
      return wrap(_195_())
    elseif (_187_ == "empty") then
      return nil
    else
      return nil
    end
  end
  cons_iter = _186_
  local function every_3f(pred, coll)
    local _197_ = seq(coll)
    if (nil ~= _197_) then
      local s = _197_
      if pred(first(s)) then
        local _198_ = next(s)
        if (nil ~= _198_) then
          local r = _198_
          return every_3f(pred, r)
        else
          local _ = _198_
          return true
        end
      else
        return false
      end
    else
      local _ = _197_
      return false
    end
  end
  local function some_3f(pred, coll)
    local _202_ = seq(coll)
    if (nil ~= _202_) then
      local s = _202_
      local function _203_(...)
        local _204_ = next(s)
        if (nil ~= _204_) then
          local r = _204_
          return some_3f(pred, r)
        else
          local _ = _204_
          return nil
        end
      end
      return (pred(first(s)) or _203_())
    else
      local _ = _202_
      return nil
    end
  end
  local function pack(s)
    local res = {}
    local n = 0
    do
      local _207_ = seq(s)
      if (nil ~= _207_) then
        local s_2a = _207_
        for _, v in pairs_2a(s_2a) do
          n = (n + 1)
          do end (res)[n] = v
        end
      else
      end
    end
    res["n"] = n
    return res
  end
  local function count(s)
    local _209_ = seq(s)
    if (nil ~= _209_) then
      local s_2a = _209_
      return length_2a(s_2a)
    else
      local _ = _209_
      return 0
    end
  end
  local function unpack(s)
    local t = pack(s)
    return table_unpack(t, 1, t.n)
  end
  local function concat(...)
    local _211_ = select("#", ...)
    if (_211_ == 0) then
      return empty_cons
    elseif (_211_ == 1) then
      local x = ...
      local function _212_()
        return x
      end
      return lazy_seq(_212_)
    elseif (_211_ == 2) then
      local x, y = ...
      local function _213_()
        local _214_ = seq(x)
        if (nil ~= _214_) then
          local s = _214_
          return cons(first(s), concat(rest(s), y))
        elseif (_214_ == nil) then
          return y
        else
          return nil
        end
      end
      return lazy_seq(_213_)
    else
      local _ = _211_
      local function _218_(...)
        local _216_, _217_ = ...
        return _216_, _217_
      end
      return concat(concat(_218_(...)), select(3, ...))
    end
  end
  local function reverse(s)
    local function helper(s0, res)
      local _220_ = seq(s0)
      if (nil ~= _220_) then
        local s_2a = _220_
        return helper(rest(s_2a), cons(first(s_2a), res))
      else
        local _ = _220_
        return res
      end
    end
    return helper(s, empty_cons)
  end
  local function map(f, ...)
    local _222_ = select("#", ...)
    if (_222_ == 0) then
      return nil
    elseif (_222_ == 1) then
      local col = ...
      local function _223_()
        local _224_ = seq(col)
        if (nil ~= _224_) then
          local x = _224_
          return cons(f(first(x)), map(f, seq(rest(x))))
        else
          local _ = _224_
          return nil
        end
      end
      return lazy_seq(_223_)
    elseif (_222_ == 2) then
      local s1, s2 = ...
      local function _226_()
        local s10 = seq(s1)
        local s20 = seq(s2)
        if (s10 and s20) then
          return cons(f(first(s10), first(s20)), map(f, rest(s10), rest(s20)))
        else
          return nil
        end
      end
      return lazy_seq(_226_)
    elseif (_222_ == 3) then
      local s1, s2, s3 = ...
      local function _228_()
        local s10 = seq(s1)
        local s20 = seq(s2)
        local s30 = seq(s3)
        if (s10 and s20 and s30) then
          return cons(f(first(s10), first(s20), first(s30)), map(f, rest(s10), rest(s20), rest(s30)))
        else
          return nil
        end
      end
      return lazy_seq(_228_)
    else
      local _ = _222_
      local s = list(...)
      local function _230_()
        local function _231_(_2410)
          return (nil ~= seq(_2410))
        end
        if every_3f(_231_, s) then
          return cons(f(unpack(map(first, s))), map(f, unpack(map(rest, s))))
        else
          return nil
        end
      end
      return lazy_seq(_230_)
    end
  end
  local function map_indexed(f, coll)
    local mapi
    local function mapi0(idx, coll0)
      local function _234_()
        local _235_ = seq(coll0)
        if (nil ~= _235_) then
          local s = _235_
          return cons(f(idx, first(s)), mapi0((idx + 1), rest(s)))
        else
          local _ = _235_
          return nil
        end
      end
      return lazy_seq(_234_)
    end
    mapi = mapi0
    return mapi(1, coll)
  end
  local function mapcat(f, ...)
    local step
    local function step0(colls)
      local function _237_()
        local _238_ = seq(colls)
        if (nil ~= _238_) then
          local s = _238_
          local c = first(s)
          return concat(c, step0(rest(colls)))
        else
          local _ = _238_
          return nil
        end
      end
      return lazy_seq(_237_)
    end
    step = step0
    return step(map(f, ...))
  end
  local function take(n, coll)
    local function _240_()
      if (n > 0) then
        local _241_ = seq(coll)
        if (nil ~= _241_) then
          local s = _241_
          return cons(first(s), take((n - 1), rest(s)))
        else
          local _ = _241_
          return nil
        end
      else
        return nil
      end
    end
    return lazy_seq(_240_)
  end
  local function take_while(pred, coll)
    local function _244_()
      local _245_ = seq(coll)
      if (nil ~= _245_) then
        local s = _245_
        local v = first(s)
        if pred(v) then
          return cons(v, take_while(pred, rest(s)))
        else
          return nil
        end
      else
        local _ = _245_
        return nil
      end
    end
    return lazy_seq(_244_)
  end
  local function _248_(n, coll)
    local step
    local function step0(n0, coll0)
      local s = seq(coll0)
      if ((n0 > 0) and s) then
        return step0((n0 - 1), rest(s))
      else
        return s
      end
    end
    step = step0
    local function _250_()
      return step(n, coll)
    end
    return lazy_seq(_250_)
  end
  drop = _248_
  local function drop_while(pred, coll)
    local step
    local function step0(pred0, coll0)
      local s = seq(coll0)
      if (s and pred0(first(s))) then
        return step0(pred0, rest(s))
      else
        return s
      end
    end
    step = step0
    local function _252_()
      return step(pred, coll)
    end
    return lazy_seq(_252_)
  end
  local function drop_last(...)
    local _253_ = select("#", ...)
    if (_253_ == 0) then
      return empty_cons
    elseif (_253_ == 1) then
      return drop_last(1, ...)
    else
      local _ = _253_
      local n, coll = ...
      local function _254_(x)
        return x
      end
      return map(_254_, coll, drop(n, coll))
    end
  end
  local function take_last(n, coll)
    local function loop(s, lead)
      if lead then
        return loop(next(s), next(lead))
      else
        return s
      end
    end
    return loop(seq(coll), seq(drop(n, coll)))
  end
  local function take_nth(n, coll)
    local function _257_()
      local _258_ = seq(coll)
      if (nil ~= _258_) then
        local s = _258_
        return cons(first(s), take_nth(n, drop(n, s)))
      else
        return nil
      end
    end
    return lazy_seq(_257_)
  end
  local function split_at(n, coll)
    return {take(n, coll), drop(n, coll)}
  end
  local function split_with(pred, coll)
    return {take_while(pred, coll), drop_while(pred, coll)}
  end
  local function filter(pred, coll)
    local function _260_()
      local _261_ = seq(coll)
      if (nil ~= _261_) then
        local s = _261_
        local x = first(s)
        local r = rest(s)
        if pred(x) then
          return cons(x, filter(pred, r))
        else
          return filter(pred, r)
        end
      else
        local _ = _261_
        return nil
      end
    end
    return lazy_seq(_260_)
  end
  local function keep(f, coll)
    local function _264_()
      local _265_ = seq(coll)
      if (nil ~= _265_) then
        local s = _265_
        local _266_ = f(first(s))
        if (nil ~= _266_) then
          local x = _266_
          return cons(x, keep(f, rest(s)))
        elseif (_266_ == nil) then
          return keep(f, rest(s))
        else
          return nil
        end
      else
        local _ = _265_
        return nil
      end
    end
    return lazy_seq(_264_)
  end
  local function keep_indexed(f, coll)
    local keepi
    local function keepi0(idx, coll0)
      local function _269_()
        local _270_ = seq(coll0)
        if (nil ~= _270_) then
          local s = _270_
          local x = f(idx, first(s))
          if (nil == x) then
            return keepi0((1 + idx), rest(s))
          else
            return cons(x, keepi0((1 + idx), rest(s)))
          end
        else
          return nil
        end
      end
      return lazy_seq(_269_)
    end
    keepi = keepi0
    return keepi(1, coll)
  end
  local function remove(pred, coll)
    local function _273_(_241)
      return not pred(_241)
    end
    return filter(_273_, coll)
  end
  local function cycle(coll)
    local function _274_()
      return concat(seq(coll), cycle(coll))
    end
    return lazy_seq(_274_)
  end
  local function _repeat(x)
    local function step(x0)
      local function _275_()
        return cons(x0, step(x0))
      end
      return lazy_seq(_275_)
    end
    return step(x)
  end
  local function repeatedly(f, ...)
    local args = table_pack(...)
    local f0
    local function _276_()
      return f(table_unpack(args, 1, args.n))
    end
    f0 = _276_
    local function step(f1)
      local function _277_()
        return cons(f1(), step(f1))
      end
      return lazy_seq(_277_)
    end
    return step(f0)
  end
  local function iterate(f, x)
    local x_2a = f(x)
    local function _278_()
      return iterate(f, x_2a)
    end
    return cons(x, lazy_seq(_278_))
  end
  local function nthnext(coll, n)
    local function loop(n0, xs)
      local function _279_()
        local xs_2a = xs
        return (n0 > 0)
      end
      if ((nil ~= xs) and _279_()) then
        local xs_2a = xs
        return loop((n0 - 1), next(xs_2a))
      else
        local _ = xs
        return xs
      end
    end
    return loop(n, seq(coll))
  end
  local function nthrest(coll, n)
    local function loop(n0, xs)
      local _281_ = seq(xs)
      local function _282_()
        local xs_2a = _281_
        return (n0 > 0)
      end
      if ((nil ~= _281_) and _282_()) then
        local xs_2a = _281_
        return loop((n0 - 1), rest(xs_2a))
      else
        local _ = _281_
        return xs
      end
    end
    return loop(n, coll)
  end
  local function dorun(s)
    local _284_ = seq(s)
    if (nil ~= _284_) then
      local s_2a = _284_
      return dorun(next(s_2a))
    else
      local _ = _284_
      return nil
    end
  end
  local function doall(s)
    dorun(s)
    return s
  end
  local function partition(...)
    local _286_ = select("#", ...)
    if (_286_ == 2) then
      local n, coll = ...
      return partition(n, n, coll)
    elseif (_286_ == 3) then
      local n, step, coll = ...
      local function _287_()
        local _288_ = seq(coll)
        if (nil ~= _288_) then
          local s = _288_
          local p = take(n, s)
          if (n == length_2a(p)) then
            return cons(p, partition(n, step, nthrest(s, step)))
          else
            return nil
          end
        else
          local _ = _288_
          return nil
        end
      end
      return lazy_seq(_287_)
    elseif (_286_ == 4) then
      local n, step, pad, coll = ...
      local function _291_()
        local _292_ = seq(coll)
        if (nil ~= _292_) then
          local s = _292_
          local p = take(n, s)
          if (n == length_2a(p)) then
            return cons(p, partition(n, step, pad, nthrest(s, step)))
          else
            return list(take(n, concat(p, pad)))
          end
        else
          local _ = _292_
          return nil
        end
      end
      return lazy_seq(_291_)
    else
      local _ = _286_
      return error("wrong amount arguments to 'partition'")
    end
  end
  local function partition_by(f, coll)
    local function _296_()
      local _297_ = seq(coll)
      if (nil ~= _297_) then
        local s = _297_
        local v = first(s)
        local fv = f(v)
        local run
        local function _298_(_2410)
          return (fv == f(_2410))
        end
        run = cons(v, take_while(_298_, next(s)))
        local function _299_()
          return drop(length_2a(run), s)
        end
        return cons(run, partition_by(f, lazy_seq(_299_)))
      else
        return nil
      end
    end
    return lazy_seq(_296_)
  end
  local function partition_all(...)
    local _301_ = select("#", ...)
    if (_301_ == 2) then
      local n, coll = ...
      return partition_all(n, n, coll)
    elseif (_301_ == 3) then
      local n, step, coll = ...
      local function _302_()
        local _303_ = seq(coll)
        if (nil ~= _303_) then
          local s = _303_
          local p = take(n, s)
          return cons(p, partition_all(n, step, nthrest(s, step)))
        else
          local _ = _303_
          return nil
        end
      end
      return lazy_seq(_302_)
    else
      local _ = _301_
      return error("wrong amount arguments to 'partition-all'")
    end
  end
  local function reductions(...)
    local _306_ = select("#", ...)
    if (_306_ == 2) then
      local f, coll = ...
      local function _307_()
        local _308_ = seq(coll)
        if (nil ~= _308_) then
          local s = _308_
          return reductions(f, first(s), rest(s))
        else
          local _ = _308_
          return list(f())
        end
      end
      return lazy_seq(_307_)
    elseif (_306_ == 3) then
      local f, init, coll = ...
      local function _310_()
        local _311_ = seq(coll)
        if (nil ~= _311_) then
          local s = _311_
          return reductions(f, f(init, first(s)), rest(s))
        else
          return nil
        end
      end
      return cons(init, lazy_seq(_310_))
    else
      local _ = _306_
      return error("wrong amount arguments to 'reductions'")
    end
  end
  local function contains_3f(coll, elt)
    local _314_ = gettype(coll)
    if (_314_ == "table") then
      local _315_ = kind(coll)
      if (_315_ == "seq") then
        local res = false
        for _, v in ipairs_2a(coll) do
          if res then break end
          if (elt == v) then
            res = true
          else
            res = false
          end
        end
        return res
      elseif (_315_ == "assoc") then
        if coll[elt] then
          return true
        else
          return false
        end
      else
        return nil
      end
    else
      local _ = _314_
      local function loop(coll0)
        local _319_ = seq(coll0)
        if (nil ~= _319_) then
          local s = _319_
          if (elt == first(s)) then
            return true
          else
            return loop(rest(s))
          end
        elseif (_319_ == nil) then
          return false
        else
          return nil
        end
      end
      return loop(coll)
    end
  end
  local function distinct(coll)
    local function step(xs, seen)
      local loop
      local function loop0(_323_, seen0)
        local _arg_324_ = _323_
        local f = _arg_324_[1]
        local xs0 = _arg_324_
        local _325_ = seq(xs0)
        if (nil ~= _325_) then
          local s = _325_
          if seen0[f] then
            return loop0(rest(s), seen0)
          else
            local function _326_()
              seen0[f] = true
              return seen0
            end
            return cons(f, step(rest(s), _326_()))
          end
        else
          local _ = _325_
          return nil
        end
      end
      loop = loop0
      local function _329_()
        return loop(xs, seen)
      end
      return lazy_seq(_329_)
    end
    return step(coll, {})
  end
  local function inf_range(x, step)
    local function _330_()
      return cons(x, inf_range((x + step), step))
    end
    return lazy_seq(_330_)
  end
  local function fix_range(x, _end, step)
    local function _331_()
      if (((step >= 0) and (x < _end)) or ((step < 0) and (x > _end))) then
        return cons(x, fix_range((x + step), _end, step))
      elseif ((step == 0) and (x ~= _end)) then
        return cons(x, fix_range(x, _end, step))
      else
        return nil
      end
    end
    return lazy_seq(_331_)
  end
  local function range(...)
    local _333_ = select("#", ...)
    if (_333_ == 0) then
      return inf_range(0, 1)
    elseif (_333_ == 1) then
      local _end = ...
      return fix_range(0, _end, 1)
    elseif (_333_ == 2) then
      local x, _end = ...
      return fix_range(x, _end, 1)
    else
      local _ = _333_
      return fix_range(...)
    end
  end
  local function realized_3f(s)
    local _335_ = gettype(s)
    if (_335_ == "lazy-cons") then
      return false
    elseif (_335_ == "empty-cons") then
      return true
    elseif (_335_ == "cons") then
      return true
    else
      local _ = _335_
      return error(("expected a sequence, got: %s"):format(_))
    end
  end
  local function line_seq(file)
    local next_line = file:lines()
    local function step(f)
      local line = f()
      if ("string" == type(line)) then
        local function _337_()
          return step(f)
        end
        return cons(line, lazy_seq(_337_))
      else
        return nil
      end
    end
    return step(next_line)
  end
  local function tree_seq(branch_3f, children, root)
    local function walk(node)
      local function _339_()
        local function _340_()
          if branch_3f(node) then
            return mapcat(walk, children(node))
          else
            return nil
          end
        end
        return cons(node, _340_())
      end
      return lazy_seq(_339_)
    end
    return walk(root)
  end
  local function interleave(...)
    local _341_, _342_, _343_ = select("#", ...), ...
    if (_341_ == 0) then
      return empty_cons
    elseif ((_341_ == 1) and true) then
      local _3fs = _342_
      local function _344_()
        return _3fs
      end
      return lazy_seq(_344_)
    elseif ((_341_ == 2) and true and true) then
      local _3fs1 = _342_
      local _3fs2 = _343_
      local function _345_()
        local s1 = seq(_3fs1)
        local s2 = seq(_3fs2)
        if (s1 and s2) then
          return cons(first(s1), cons(first(s2), interleave(rest(s1), rest(s2))))
        else
          return nil
        end
      end
      return lazy_seq(_345_)
    elseif true then
      local _ = _341_
      local cols = list(...)
      local function _347_()
        local seqs = map(seq, cols)
        local function _348_(_2410)
          return (nil ~= seq(_2410))
        end
        if every_3f(_348_, seqs) then
          return concat(map(first, seqs), interleave(unpack(map(rest, seqs))))
        else
          return nil
        end
      end
      return lazy_seq(_347_)
    else
      return nil
    end
  end
  local function interpose(separator, coll)
    return drop(1, interleave(_repeat(separator), coll))
  end
  local function keys(t)
    assert(("assoc" == kind(t)), "expected an associative table")
    local function _351_(_241)
      return _241[1]
    end
    return map(_351_, t)
  end
  local function vals(t)
    assert(("assoc" == kind(t)), "expected an associative table")
    local function _352_(_241)
      return _241[2]
    end
    return map(_352_, t)
  end
  local function zipmap(keys0, vals0)
    local t = {}
    local function loop(s1, s2)
      if (s1 and s2) then
        t[first(s1)] = first(s2)
        return loop(next(s1), next(s2))
      else
        return nil
      end
    end
    loop(seq(keys0), seq(vals0))
    return t
  end
  local _local_354_ = require("reduced")
  local reduced = _local_354_["reduced"]
  local reduced_3f = _local_354_["reduced?"]
  local function reduce(f, ...)
    local _355_, _356_, _357_ = select("#", ...), ...
    if (_355_ == 0) then
      return error("expected a collection")
    elseif ((_355_ == 1) and true) then
      local _3fcoll = _356_
      local _358_ = count(_3fcoll)
      if (_358_ == 0) then
        return f()
      elseif (_358_ == 1) then
        return first(_3fcoll)
      else
        local _ = _358_
        return reduce(f, first(_3fcoll), rest(_3fcoll))
      end
    elseif ((_355_ == 2) and true and true) then
      local _3fval = _356_
      local _3fcoll = _357_
      local _360_ = seq(_3fcoll)
      if (nil ~= _360_) then
        local coll = _360_
        local done_3f = false
        local res = _3fval
        for _, v in pairs_2a(coll) do
          if done_3f then break end
          local res0 = f(res, v)
          if reduced_3f(res0) then
            done_3f = true
            res = res0:unbox()
          else
            res = res0
          end
        end
        return res
      else
        local _ = _360_
        return _3fval
      end
    else
      return nil
    end
  end
  return {first = first, rest = rest, nthrest = nthrest, next = next, nthnext = nthnext, cons = cons, seq = seq, rseq = rseq, ["seq?"] = seq_3f, ["empty?"] = empty_3f, ["lazy-seq"] = lazy_seq, list = list, ["list*"] = list_2a, ["every?"] = every_3f, ["some?"] = some_3f, pack = pack, unpack = unpack, count = count, concat = concat, map = map, ["map-indexed"] = map_indexed, mapcat = mapcat, take = take, ["take-while"] = take_while, ["take-last"] = take_last, ["take-nth"] = take_nth, drop = drop, ["drop-while"] = drop_while, ["drop-last"] = drop_last, remove = remove, ["split-at"] = split_at, ["split-with"] = split_with, partition = partition, ["partition-by"] = partition_by, ["partition-all"] = partition_all, filter = filter, keep = keep, ["keep-indexed"] = keep_indexed, ["contains?"] = contains_3f, distinct = distinct, cycle = cycle, ["repeat"] = _repeat, repeatedly = repeatedly, reductions = reductions, iterate = iterate, range = range, ["realized?"] = realized_3f, dorun = dorun, doall = doall, ["line-seq"] = line_seq, ["tree-seq"] = tree_seq, reverse = reverse, interleave = interleave, interpose = interpose, keys = keys, vals = vals, zipmap = zipmap, reduce = reduce, reduced = reduced, ["reduced?"] = reduced_3f}
end
package.preload["lazy-seq"] = (package.preload["lazy-seq"] or _118_)
local function _365_()
  return "#<namespace: core>"
end
--[[ "MIT License

Copyright (c) 2022 Andrey Listopadov

Permission is hereby granted‚ free of charge‚ to any person obtaining a copy
of this software and associated documentation files (the “Software”)‚ to deal
in the Software without restriction‚ including without limitation the rights
to use‚ copy‚ modify‚ merge‚ publish‚ distribute‚ sublicense‚ and/or sell
copies of the Software‚ and to permit persons to whom the Software is
furnished to do so‚ subject to the following conditions：

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”‚ WITHOUT WARRANTY OF ANY KIND‚ EXPRESS OR
IMPLIED‚ INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY‚
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM‚ DAMAGES OR OTHER
LIABILITY‚ WHETHER IN AN ACTION OF CONTRACT‚ TORT OR OTHERWISE‚ ARISING FROM‚
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE." ]]
local _local_364_ = {setmetatable({}, {__fennelview = _365_, __name = "namespace"}), require("lazy-seq"), require("itable")}, nil
local core = _local_364_[1]
local lazy = _local_364_[2]
local itable = _local_364_[3]
local function unpack_2a(x, ...)
  if core["seq?"](x) then
    return lazy.unpack(x)
  else
    return itable.unpack(x, ...)
  end
end
local function pack_2a(...)
  local _367_ = {...}
  _367_["n"] = select("#", ...)
  return _367_
end
local function pairs_2a(t)
  local _368_ = getmetatable(t)
  if ((_G.type(_368_) == "table") and (nil ~= _368_.__pairs)) then
    local p = _368_.__pairs
    return p(t)
  else
    local _ = _368_
    return pairs(t)
  end
end
local function ipairs_2a(t)
  local _370_ = getmetatable(t)
  if ((_G.type(_370_) == "table") and (nil ~= _370_.__ipairs)) then
    local i = _370_.__ipairs
    return i(t)
  else
    local _ = _370_
    return ipairs(t)
  end
end
local function length_2a(t)
  local _372_ = getmetatable(t)
  if ((_G.type(_372_) == "table") and (nil ~= _372_.__len)) then
    local l = _372_.__len
    return l(t)
  else
    local _ = _372_
    return #t
  end
end
local apply
do
  local v_29_auto
  local function apply0(...)
    local _375_ = select("#", ...)
    if (_375_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "apply"))
    elseif (_375_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "apply"))
    elseif (_375_ == 2) then
      local f, args = ...
      return f(unpack_2a(args))
    elseif (_375_ == 3) then
      local f, a, args = ...
      return f(a, unpack_2a(args))
    elseif (_375_ == 4) then
      local f, a, b, args = ...
      return f(a, b, unpack_2a(args))
    elseif (_375_ == 5) then
      local f, a, b, c, args = ...
      return f(a, b, c, unpack_2a(args))
    else
      local _ = _375_
      local core_43_auto = require("cljlib")
      local _let_376_ = core_43_auto.list(...)
      local f = _let_376_[1]
      local a = _let_376_[2]
      local b = _let_376_[3]
      local c = _let_376_[4]
      local d = _let_376_[5]
      local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_376_, 6)
      local flat_args = {}
      local len = (length_2a(args) - 1)
      for i = 1, len do
        flat_args[i] = args[i]
      end
      for i, a0 in pairs_2a(args[(len + 1)]) do
        flat_args[(i + len)] = a0
      end
      return f(a, b, c, d, unpack_2a(flat_args))
    end
  end
  v_29_auto = apply0
  core["apply"] = v_29_auto
  apply = v_29_auto
end
local add
do
  local v_29_auto
  local function add0(...)
    local _378_ = select("#", ...)
    if (_378_ == 0) then
      return 0
    elseif (_378_ == 1) then
      local a = ...
      return a
    elseif (_378_ == 2) then
      local a, b = ...
      return (a + b)
    elseif (_378_ == 3) then
      local a, b, c = ...
      return (a + b + c)
    elseif (_378_ == 4) then
      local a, b, c, d = ...
      return (a + b + c + d)
    else
      local _ = _378_
      local core_43_auto = require("cljlib")
      local _let_379_ = core_43_auto.list(...)
      local a = _let_379_[1]
      local b = _let_379_[2]
      local c = _let_379_[3]
      local d = _let_379_[4]
      local rest = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_379_, 5)
      return apply(add0, (a + b + c + d), rest)
    end
  end
  v_29_auto = add0
  core["add"] = v_29_auto
  add = v_29_auto
end
local sub
do
  local v_29_auto
  local function sub0(...)
    local _381_ = select("#", ...)
    if (_381_ == 0) then
      return 0
    elseif (_381_ == 1) then
      local a = ...
      return ( - a)
    elseif (_381_ == 2) then
      local a, b = ...
      return (a - b)
    elseif (_381_ == 3) then
      local a, b, c = ...
      return (a - b - c)
    elseif (_381_ == 4) then
      local a, b, c, d = ...
      return (a - b - c - d)
    else
      local _ = _381_
      local core_43_auto = require("cljlib")
      local _let_382_ = core_43_auto.list(...)
      local a = _let_382_[1]
      local b = _let_382_[2]
      local c = _let_382_[3]
      local d = _let_382_[4]
      local rest = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_382_, 5)
      return apply(sub0, (a - b - c - d), rest)
    end
  end
  v_29_auto = sub0
  core["sub"] = v_29_auto
  sub = v_29_auto
end
local mul
do
  local v_29_auto
  local function mul0(...)
    local _384_ = select("#", ...)
    if (_384_ == 0) then
      return 1
    elseif (_384_ == 1) then
      local a = ...
      return a
    elseif (_384_ == 2) then
      local a, b = ...
      return (a * b)
    elseif (_384_ == 3) then
      local a, b, c = ...
      return (a * b * c)
    elseif (_384_ == 4) then
      local a, b, c, d = ...
      return (a * b * c * d)
    else
      local _ = _384_
      local core_43_auto = require("cljlib")
      local _let_385_ = core_43_auto.list(...)
      local a = _let_385_[1]
      local b = _let_385_[2]
      local c = _let_385_[3]
      local d = _let_385_[4]
      local rest = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_385_, 5)
      return apply(mul0, (a * b * c * d), rest)
    end
  end
  v_29_auto = mul0
  core["mul"] = v_29_auto
  mul = v_29_auto
end
local div
do
  local v_29_auto
  local function div0(...)
    local _387_ = select("#", ...)
    if (_387_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "div"))
    elseif (_387_ == 1) then
      local a = ...
      return (1 / a)
    elseif (_387_ == 2) then
      local a, b = ...
      return (a / b)
    elseif (_387_ == 3) then
      local a, b, c = ...
      return (a / b / c)
    elseif (_387_ == 4) then
      local a, b, c, d = ...
      return (a / b / c / d)
    else
      local _ = _387_
      local core_43_auto = require("cljlib")
      local _let_388_ = core_43_auto.list(...)
      local a = _let_388_[1]
      local b = _let_388_[2]
      local c = _let_388_[3]
      local d = _let_388_[4]
      local rest = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_388_, 5)
      return apply(div0, (a / b / c / d), rest)
    end
  end
  v_29_auto = div0
  core["div"] = v_29_auto
  div = v_29_auto
end
local le
do
  local v_29_auto
  local function le0(...)
    local _390_ = select("#", ...)
    if (_390_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "le"))
    elseif (_390_ == 1) then
      local a = ...
      return true
    elseif (_390_ == 2) then
      local a, b = ...
      return (a <= b)
    else
      local _ = _390_
      local core_43_auto = require("cljlib")
      local _let_391_ = core_43_auto.list(...)
      local a = _let_391_[1]
      local b = _let_391_[2]
      local _let_392_ = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_391_, 3)
      local c = _let_392_[1]
      local d = _let_392_[2]
      local more = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_392_, 3)
      if (a <= b) then
        if d then
          return apply(le0, b, c, d, more)
        else
          return (b <= c)
        end
      else
        return false
      end
    end
  end
  v_29_auto = le0
  core["le"] = v_29_auto
  le = v_29_auto
end
local lt
do
  local v_29_auto
  local function lt0(...)
    local _396_ = select("#", ...)
    if (_396_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "lt"))
    elseif (_396_ == 1) then
      local a = ...
      return true
    elseif (_396_ == 2) then
      local a, b = ...
      return (a < b)
    else
      local _ = _396_
      local core_43_auto = require("cljlib")
      local _let_397_ = core_43_auto.list(...)
      local a = _let_397_[1]
      local b = _let_397_[2]
      local _let_398_ = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_397_, 3)
      local c = _let_398_[1]
      local d = _let_398_[2]
      local more = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_398_, 3)
      if (a < b) then
        if d then
          return apply(lt0, b, c, d, more)
        else
          return (b < c)
        end
      else
        return false
      end
    end
  end
  v_29_auto = lt0
  core["lt"] = v_29_auto
  lt = v_29_auto
end
local ge
do
  local v_29_auto
  local function ge0(...)
    local _402_ = select("#", ...)
    if (_402_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "ge"))
    elseif (_402_ == 1) then
      local a = ...
      return true
    elseif (_402_ == 2) then
      local a, b = ...
      return (a >= b)
    else
      local _ = _402_
      local core_43_auto = require("cljlib")
      local _let_403_ = core_43_auto.list(...)
      local a = _let_403_[1]
      local b = _let_403_[2]
      local _let_404_ = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_403_, 3)
      local c = _let_404_[1]
      local d = _let_404_[2]
      local more = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_404_, 3)
      if (a >= b) then
        if d then
          return apply(ge0, b, c, d, more)
        else
          return (b >= c)
        end
      else
        return false
      end
    end
  end
  v_29_auto = ge0
  core["ge"] = v_29_auto
  ge = v_29_auto
end
local gt
do
  local v_29_auto
  local function gt0(...)
    local _408_ = select("#", ...)
    if (_408_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "gt"))
    elseif (_408_ == 1) then
      local a = ...
      return true
    elseif (_408_ == 2) then
      local a, b = ...
      return (a > b)
    else
      local _ = _408_
      local core_43_auto = require("cljlib")
      local _let_409_ = core_43_auto.list(...)
      local a = _let_409_[1]
      local b = _let_409_[2]
      local _let_410_ = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_409_, 3)
      local c = _let_410_[1]
      local d = _let_410_[2]
      local more = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_410_, 3)
      if (a > b) then
        if d then
          return apply(gt0, b, c, d, more)
        else
          return (b > c)
        end
      else
        return false
      end
    end
  end
  v_29_auto = gt0
  core["gt"] = v_29_auto
  gt = v_29_auto
end
local inc
do
  local v_29_auto
  local function inc0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "inc"))
      else
      end
    end
    return (x + 1)
  end
  v_29_auto = inc0
  core["inc"] = v_29_auto
  inc = v_29_auto
end
local dec
do
  local v_29_auto
  local function dec0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "dec"))
      else
      end
    end
    return (x - 1)
  end
  v_29_auto = dec0
  core["dec"] = v_29_auto
  dec = v_29_auto
end
local class
do
  local v_29_auto
  local function class0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "class"))
      else
      end
    end
    local _417_ = type(x)
    if (_417_ == "table") then
      local _418_ = getmetatable(x)
      if ((_G.type(_418_) == "table") and (nil ~= _418_["cljlib/type"])) then
        local t = _418_["cljlib/type"]
        return t
      else
        local _ = _418_
        return "table"
      end
    elseif (nil ~= _417_) then
      local t = _417_
      return t
    else
      return nil
    end
  end
  v_29_auto = class0
  core["class"] = v_29_auto
  class = v_29_auto
end
local constantly
do
  local v_29_auto
  local function constantly0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "constantly"))
      else
      end
    end
    local function _422_()
      return x
    end
    return _422_
  end
  v_29_auto = constantly0
  core["constantly"] = v_29_auto
  constantly = v_29_auto
end
local complement
do
  local v_29_auto
  local function complement0(...)
    local f = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "complement"))
      else
      end
    end
    local function fn_424_(...)
      local _425_ = select("#", ...)
      if (_425_ == 0) then
        return not f()
      elseif (_425_ == 1) then
        local a = ...
        return not f(a)
      elseif (_425_ == 2) then
        local a, b = ...
        return not f(a, b)
      else
        local _ = _425_
        local core_43_auto = require("cljlib")
        local _let_426_ = core_43_auto.list(...)
        local a = _let_426_[1]
        local b = _let_426_[2]
        local cs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_426_, 3)
        return not apply(f, a, b, cs)
      end
    end
    return fn_424_
  end
  v_29_auto = complement0
  core["complement"] = v_29_auto
  complement = v_29_auto
end
local identity
do
  local v_29_auto
  local function identity0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "identity"))
      else
      end
    end
    return x
  end
  v_29_auto = identity0
  core["identity"] = v_29_auto
  identity = v_29_auto
end
local comp
do
  local v_29_auto
  local function comp0(...)
    local _429_ = select("#", ...)
    if (_429_ == 0) then
      return identity
    elseif (_429_ == 1) then
      local f = ...
      return f
    elseif (_429_ == 2) then
      local f, g = ...
      local function fn_430_(...)
        local _431_ = select("#", ...)
        if (_431_ == 0) then
          return f(g())
        elseif (_431_ == 1) then
          local x = ...
          return f(g(x))
        elseif (_431_ == 2) then
          local x, y = ...
          return f(g(x, y))
        elseif (_431_ == 3) then
          local x, y, z = ...
          return f(g(x, y, z))
        else
          local _ = _431_
          local core_43_auto = require("cljlib")
          local _let_432_ = core_43_auto.list(...)
          local x = _let_432_[1]
          local y = _let_432_[2]
          local z = _let_432_[3]
          local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_432_, 4)
          return f(apply(g, x, y, z, args))
        end
      end
      return fn_430_
    else
      local _ = _429_
      local core_43_auto = require("cljlib")
      local _let_434_ = core_43_auto.list(...)
      local f = _let_434_[1]
      local g = _let_434_[2]
      local fs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_434_, 3)
      return core.reduce(comp0, core.cons(f, core.cons(g, fs)))
    end
  end
  v_29_auto = comp0
  core["comp"] = v_29_auto
  comp = v_29_auto
end
local eq
do
  local v_29_auto
  local function eq0(...)
    local _436_ = select("#", ...)
    if (_436_ == 0) then
      return true
    elseif (_436_ == 1) then
      local _ = ...
      return true
    elseif (_436_ == 2) then
      local a, b = ...
      if ((a == b) and (b == a)) then
        return true
      elseif (function(_437_,_438_,_439_) return (_437_ == _438_) and (_438_ == _439_) end)("table",type(a),type(b)) then
        local res, count_a = true, 0
        for k, v in pairs_2a(a) do
          if not res then break end
          local function _440_(...)
            local res0, done = nil, nil
            for k_2a, v0 in pairs_2a(b) do
              if done then break end
              if eq0(k_2a, k) then
                res0, done = v0, true
              else
              end
            end
            return res0
          end
          res = eq0(v, _440_(...))
          count_a = (count_a + 1)
        end
        if res then
          local count_b
          do
            local res0 = 0
            for _, _0 in pairs_2a(b) do
              res0 = (res0 + 1)
            end
            count_b = res0
          end
          res = (count_a == count_b)
        else
        end
        return res
      else
        return false
      end
    else
      local _ = _436_
      local core_43_auto = require("cljlib")
      local _let_444_ = core_43_auto.list(...)
      local a = _let_444_[1]
      local b = _let_444_[2]
      local cs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_444_, 3)
      return (eq0(a, b) and apply(eq0, b, cs))
    end
  end
  v_29_auto = eq0
  core["eq"] = v_29_auto
  eq = v_29_auto
end
local function deep_index(tbl, key)
  local res = nil
  for k, v in pairs_2a(tbl) do
    if res then break end
    if eq(k, key) then
      res = v
    else
      res = nil
    end
  end
  return res
end
local function deep_newindex(tbl, key, val)
  local done = false
  if ("table" == type(key)) then
    for k, _ in pairs_2a(tbl) do
      if done then break end
      if eq(k, key) then
        rawset(tbl, k, val)
        done = true
      else
      end
    end
  else
  end
  if not done then
    return rawset(tbl, key, val)
  else
    return nil
  end
end
local memoize
do
  local v_29_auto
  local function memoize0(...)
    local f = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "memoize"))
      else
      end
    end
    local memo = setmetatable({}, {__index = deep_index})
    local function fn_451_(...)
      local core_43_auto = require("cljlib")
      local _let_452_ = core_43_auto.list(...)
      local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_452_, 1)
      local _453_ = memo[args]
      if (nil ~= _453_) then
        local res = _453_
        return unpack_2a(res, 1, res.n)
      else
        local _ = _453_
        local res = pack_2a(f(...))
        do end (memo)[args] = res
        return unpack_2a(res, 1, res.n)
      end
    end
    return fn_451_
  end
  v_29_auto = memoize0
  core["memoize"] = v_29_auto
  memoize = v_29_auto
end
local deref
do
  local v_29_auto
  local function deref0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "deref"))
      else
      end
    end
    local _456_ = getmetatable(x)
    if ((_G.type(_456_) == "table") and (nil ~= _456_["cljlib/deref"])) then
      local f = _456_["cljlib/deref"]
      return f(x)
    else
      local _ = _456_
      return error("object doesn't implement cljlib/deref metamethod", 2)
    end
  end
  v_29_auto = deref0
  core["deref"] = v_29_auto
  deref = v_29_auto
end
local empty
do
  local v_29_auto
  local function empty0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "empty"))
      else
      end
    end
    local _459_ = getmetatable(x)
    if ((_G.type(_459_) == "table") and (nil ~= _459_["cljlib/empty"])) then
      local f = _459_["cljlib/empty"]
      return f()
    else
      local _ = _459_
      local _460_ = type(x)
      if (_460_ == "table") then
        return {}
      elseif (_460_ == "string") then
        return ""
      else
        local _0 = _460_
        return error(("don't know how to create empty variant of type " .. _0))
      end
    end
  end
  v_29_auto = empty0
  core["empty"] = v_29_auto
  empty = v_29_auto
end
local nil_3f
do
  local v_29_auto
  local function nil_3f0(...)
    local _463_ = select("#", ...)
    if (_463_ == 0) then
      return true
    elseif (_463_ == 1) then
      local x = ...
      return (x == nil)
    else
      local _ = _463_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "nil?"))
    end
  end
  v_29_auto = nil_3f0
  core["nil?"] = v_29_auto
  nil_3f = v_29_auto
end
local zero_3f
do
  local v_29_auto
  local function zero_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "zero?"))
      else
      end
    end
    return (x == 0)
  end
  v_29_auto = zero_3f0
  core["zero?"] = v_29_auto
  zero_3f = v_29_auto
end
local pos_3f
do
  local v_29_auto
  local function pos_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "pos?"))
      else
      end
    end
    return (x > 0)
  end
  v_29_auto = pos_3f0
  core["pos?"] = v_29_auto
  pos_3f = v_29_auto
end
local neg_3f
do
  local v_29_auto
  local function neg_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "neg?"))
      else
      end
    end
    return (x < 0)
  end
  v_29_auto = neg_3f0
  core["neg?"] = v_29_auto
  neg_3f = v_29_auto
end
local even_3f
do
  local v_29_auto
  local function even_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "even?"))
      else
      end
    end
    return ((x % 2) == 0)
  end
  v_29_auto = even_3f0
  core["even?"] = v_29_auto
  even_3f = v_29_auto
end
local odd_3f
do
  local v_29_auto
  local function odd_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "odd?"))
      else
      end
    end
    return not even_3f(x)
  end
  v_29_auto = odd_3f0
  core["odd?"] = v_29_auto
  odd_3f = v_29_auto
end
local string_3f
do
  local v_29_auto
  local function string_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "string?"))
      else
      end
    end
    return (type(x) == "string")
  end
  v_29_auto = string_3f0
  core["string?"] = v_29_auto
  string_3f = v_29_auto
end
local boolean_3f
do
  local v_29_auto
  local function boolean_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "boolean?"))
      else
      end
    end
    return (type(x) == "boolean")
  end
  v_29_auto = boolean_3f0
  core["boolean?"] = v_29_auto
  boolean_3f = v_29_auto
end
local true_3f
do
  local v_29_auto
  local function true_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "true?"))
      else
      end
    end
    return (x == true)
  end
  v_29_auto = true_3f0
  core["true?"] = v_29_auto
  true_3f = v_29_auto
end
local false_3f
do
  local v_29_auto
  local function false_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "false?"))
      else
      end
    end
    return (x == false)
  end
  v_29_auto = false_3f0
  core["false?"] = v_29_auto
  false_3f = v_29_auto
end
local int_3f
do
  local v_29_auto
  local function int_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "int?"))
      else
      end
    end
    return ((type(x) == "number") and (x == math.floor(x)))
  end
  v_29_auto = int_3f0
  core["int?"] = v_29_auto
  int_3f = v_29_auto
end
local pos_int_3f
do
  local v_29_auto
  local function pos_int_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "pos-int?"))
      else
      end
    end
    return (int_3f(x) and pos_3f(x))
  end
  v_29_auto = pos_int_3f0
  core["pos-int?"] = v_29_auto
  pos_int_3f = v_29_auto
end
local neg_int_3f
do
  local v_29_auto
  local function neg_int_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "neg-int?"))
      else
      end
    end
    return (int_3f(x) and neg_3f(x))
  end
  v_29_auto = neg_int_3f0
  core["neg-int?"] = v_29_auto
  neg_int_3f = v_29_auto
end
local double_3f
do
  local v_29_auto
  local function double_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "double?"))
      else
      end
    end
    return ((type(x) == "number") and (x ~= math.floor(x)))
  end
  v_29_auto = double_3f0
  core["double?"] = v_29_auto
  double_3f = v_29_auto
end
local empty_3f
do
  local v_29_auto
  local function empty_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "empty?"))
      else
      end
    end
    local _479_ = type(x)
    if (_479_ == "table") then
      local _480_ = getmetatable(x)
      if ((_G.type(_480_) == "table") and (_480_["cljlib/type"] == "seq")) then
        return nil_3f(core.seq(x))
      elseif ((_480_ == nil) or ((_G.type(_480_) == "table") and (_480_["cljlib/type"] == nil))) then
        local next_2a = pairs_2a(x)
        return (next_2a(x) == nil)
      else
        return nil
      end
    elseif (_479_ == "string") then
      return (x == "")
    elseif (_479_ == "nil") then
      return true
    else
      local _ = _479_
      return error("empty?: unsupported collection")
    end
  end
  v_29_auto = empty_3f0
  core["empty?"] = v_29_auto
  empty_3f = v_29_auto
end
local not_empty
do
  local v_29_auto
  local function not_empty0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "not-empty"))
      else
      end
    end
    if not empty_3f(x) then
      return x
    else
      return nil
    end
  end
  v_29_auto = not_empty0
  core["not-empty"] = v_29_auto
  not_empty = v_29_auto
end
local map_3f
do
  local v_29_auto
  local function map_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "map?"))
      else
      end
    end
    if ("table" == type(x)) then
      local _486_ = getmetatable(x)
      if ((_G.type(_486_) == "table") and (_486_["cljlib/type"] == "hash-map")) then
        return true
      elseif ((_G.type(_486_) == "table") and (_486_["cljlib/type"] == "sorted-map")) then
        return true
      elseif ((_486_ == nil) or ((_G.type(_486_) == "table") and (_486_["cljlib/type"] == nil))) then
        local len = length_2a(x)
        local nxt, t, k = pairs_2a(x)
        local function _487_(...)
          if (len == 0) then
            return k
          else
            return len
          end
        end
        return (nil ~= nxt(t, _487_(...)))
      else
        local _ = _486_
        return false
      end
    else
      return false
    end
  end
  v_29_auto = map_3f0
  core["map?"] = v_29_auto
  map_3f = v_29_auto
end
local vector_3f
do
  local v_29_auto
  local function vector_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "vector?"))
      else
      end
    end
    if ("table" == type(x)) then
      local _491_ = getmetatable(x)
      if ((_G.type(_491_) == "table") and (_491_["cljlib/type"] == "vector")) then
        return true
      elseif ((_491_ == nil) or ((_G.type(_491_) == "table") and (_491_["cljlib/type"] == nil))) then
        local len = length_2a(x)
        local nxt, t, k = pairs_2a(x)
        local function _492_(...)
          if (len == 0) then
            return k
          else
            return len
          end
        end
        if (nil ~= nxt(t, _492_(...))) then
          return false
        elseif (len > 0) then
          return true
        else
          return false
        end
      else
        local _ = _491_
        return false
      end
    else
      return false
    end
  end
  v_29_auto = vector_3f0
  core["vector?"] = v_29_auto
  vector_3f = v_29_auto
end
local set_3f
do
  local v_29_auto
  local function set_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "set?"))
      else
      end
    end
    local _497_ = getmetatable(x)
    if ((_G.type(_497_) == "table") and (_497_["cljlib/type"] == "hash-set")) then
      return true
    else
      local _ = _497_
      return false
    end
  end
  v_29_auto = set_3f0
  core["set?"] = v_29_auto
  set_3f = v_29_auto
end
local seq_3f
do
  local v_29_auto
  local function seq_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "seq?"))
      else
      end
    end
    return lazy["seq?"](x)
  end
  v_29_auto = seq_3f0
  core["seq?"] = v_29_auto
  seq_3f = v_29_auto
end
local some_3f
do
  local v_29_auto
  local function some_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "some?"))
      else
      end
    end
    return (x ~= nil)
  end
  v_29_auto = some_3f0
  core["some?"] = v_29_auto
  some_3f = v_29_auto
end
local function vec__3etransient(immutable)
  local function _501_(vec)
    local len = #vec
    local function _502_(_, i)
      if (i <= len) then
        return vec[i]
      else
        return nil
      end
    end
    local function _504_()
      return len
    end
    local function _505_()
      return error("can't `conj` onto transient vector, use `conj!`")
    end
    local function _506_()
      return error("can't `assoc` onto transient vector, use `assoc!`")
    end
    local function _507_()
      return error("can't `dissoc` onto transient vector, use `dissoc!`")
    end
    local function _508_(tvec, v)
      len = (len + 1)
      tvec[len] = v
      return tvec
    end
    local function _509_(tvec, ...)
      do
        local len0 = #tvec
        for i = 1, select("#", ...), 2 do
          local k, v = select(i, ...)
          if ((1 <= i) and (i <= len0)) then
            tvec[i] = v
          else
            error(("index " .. i .. " is out of bounds"))
          end
        end
      end
      return tvec
    end
    local function _511_(tvec)
      if (len == 0) then
        return error("transient vector is empty", 2)
      else
        local val = table.remove(tvec)
        len = (len - 1)
        return tvec
      end
    end
    local function _513_()
      return error("can't `dissoc!` with a transient vector")
    end
    local function _514_(tvec)
      local v
      do
        local tbl_19_auto = {}
        local i_20_auto = 0
        for i = 1, len do
          local val_21_auto = tvec[i]
          if (nil ~= val_21_auto) then
            i_20_auto = (i_20_auto + 1)
            do end (tbl_19_auto)[i_20_auto] = val_21_auto
          else
          end
        end
        v = tbl_19_auto
      end
      while (len > 0) do
        table.remove(tvec)
        len = (len - 1)
      end
      local function _516_()
        return error("attempt to use transient after it was persistet")
      end
      local function _517_()
        return error("attempt to use transient after it was persistet")
      end
      setmetatable(tvec, {__index = _516_, __newindex = _517_})
      return immutable(itable(v))
    end
    return setmetatable({}, {__index = _502_, __len = _504_, ["cljlib/type"] = "transient", ["cljlib/conj"] = _505_, ["cljlib/assoc"] = _506_, ["cljlib/dissoc"] = _507_, ["cljlib/conj!"] = _508_, ["cljlib/assoc!"] = _509_, ["cljlib/pop!"] = _511_, ["cljlib/dissoc!"] = _513_, ["cljlib/persistent!"] = _514_})
  end
  return _501_
end
local function vec_2a(v, len)
  do
    local _518_ = getmetatable(v)
    if (nil ~= _518_) then
      local mt = _518_
      mt["__len"] = constantly((len or length_2a(v)))
      do end (mt)["cljlib/type"] = "vector"
      mt["cljlib/editable"] = true
      local function _519_(t, v0)
        local len0 = length_2a(t)
        return vec_2a(itable.assoc(t, (len0 + 1), v0), (len0 + 1))
      end
      mt["cljlib/conj"] = _519_
      local function _520_(t)
        local len0 = (length_2a(t) - 1)
        local coll = {}
        if (len0 < 0) then
          error("can't pop empty vector", 2)
        else
        end
        for i = 1, len0 do
          coll[i] = t[i]
        end
        return vec_2a(itable(coll), len0)
      end
      mt["cljlib/pop"] = _520_
      local function _522_()
        return vec_2a(itable({}))
      end
      mt["cljlib/empty"] = _522_
      mt["cljlib/transient"] = vec__3etransient(vec_2a)
      local function _523_(coll, view, inspector, indent)
        if empty_3f(coll) then
          return "[]"
        else
          local lines
          do
            local tbl_19_auto = {}
            local i_20_auto = 0
            for i = 1, length_2a(coll) do
              local val_21_auto = (" " .. view(coll[i], inspector, indent))
              if (nil ~= val_21_auto) then
                i_20_auto = (i_20_auto + 1)
                do end (tbl_19_auto)[i_20_auto] = val_21_auto
              else
              end
            end
            lines = tbl_19_auto
          end
          lines[1] = ("[" .. string.gsub((lines[1] or ""), "^%s+", ""))
          do end (lines)[#lines] = (lines[#lines] .. "]")
          return lines
        end
      end
      mt["__fennelview"] = _523_
    elseif (_518_ == nil) then
      vec_2a(setmetatable(v, {}))
    else
    end
  end
  return v
end
local vec
do
  local v_29_auto
  local function vec0(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "vec"))
      else
      end
    end
    if empty_3f(coll) then
      return vec_2a(itable({}), 0)
    elseif vector_3f(coll) then
      return vec_2a(itable(coll), length_2a(coll))
    elseif "else" then
      local packed = lazy.pack(core.seq(coll))
      local len = packed.n
      local _528_
      do
        packed["n"] = nil
        _528_ = packed
      end
      return vec_2a(itable(_528_, {["fast-index?"] = true}), len)
    else
      return nil
    end
  end
  v_29_auto = vec0
  core["vec"] = v_29_auto
  vec = v_29_auto
end
local vector
do
  local v_29_auto
  local function vector0(...)
    local core_43_auto = require("cljlib")
    local _let_530_ = core_43_auto.list(...)
    local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_530_, 1)
    return vec(args)
  end
  v_29_auto = vector0
  core["vector"] = v_29_auto
  vector = v_29_auto
end
local nth
do
  local v_29_auto
  local function nth0(...)
    local _532_ = select("#", ...)
    if (_532_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "nth"))
    elseif (_532_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "nth"))
    elseif (_532_ == 2) then
      local coll, i = ...
      if vector_3f(coll) then
        if ((i < 1) or (length_2a(coll) < i)) then
          return error(string.format("index %d is out of bounds", i))
        else
          return coll[i]
        end
      elseif string_3f(coll) then
        return nth0(vec(coll), i)
      elseif seq_3f(coll) then
        return nth0(vec(coll), i)
      elseif "else" then
        return error("expected an indexed collection")
      else
        return nil
      end
    elseif (_532_ == 3) then
      local coll, i, not_found = ...
      assert(int_3f(i), "expected an integer key")
      if vector_3f(coll) then
        return (coll[i] or not_found)
      elseif string_3f(coll) then
        return nth0(vec(coll), i, not_found)
      elseif seq_3f(coll) then
        return nth0(vec(coll), i, not_found)
      elseif "else" then
        return error("expected an indexed collection")
      else
        return nil
      end
    else
      local _ = _532_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "nth"))
    end
  end
  v_29_auto = nth0
  core["nth"] = v_29_auto
  nth = v_29_auto
end
local seq_2a
local function seq_2a0(...)
  local x = ...
  do
    local cnt_61_auto = select("#", ...)
    if (1 ~= cnt_61_auto) then
      error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "seq*"))
    else
    end
  end
  do
    local _538_ = getmetatable(x)
    if (nil ~= _538_) then
      local mt = _538_
      mt["cljlib/type"] = "seq"
      local function _539_(s, v)
        return core.cons(v, s)
      end
      mt["cljlib/conj"] = _539_
      local function _540_()
        return core.list()
      end
      mt["cljlib/empty"] = _540_
    else
    end
  end
  return x
end
seq_2a = seq_2a0
local seq
do
  local v_29_auto
  local function seq0(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "seq"))
      else
      end
    end
    local function _544_(...)
      local _543_ = getmetatable(coll)
      if ((_G.type(_543_) == "table") and (nil ~= _543_["cljlib/seq"])) then
        local f = _543_["cljlib/seq"]
        return f(coll)
      else
        local _ = _543_
        if lazy["seq?"](coll) then
          return lazy.seq(coll)
        elseif map_3f(coll) then
          return lazy.map(vec, coll)
        elseif "else" then
          return lazy.seq(coll)
        else
          return nil
        end
      end
    end
    return seq_2a(_544_(...))
  end
  v_29_auto = seq0
  core["seq"] = v_29_auto
  seq = v_29_auto
end
local rseq
do
  local v_29_auto
  local function rseq0(...)
    local rev = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "rseq"))
      else
      end
    end
    return seq_2a(lazy.rseq(rev))
  end
  v_29_auto = rseq0
  core["rseq"] = v_29_auto
  rseq = v_29_auto
end
local lazy_seq_2a
do
  local v_29_auto
  local function lazy_seq_2a0(...)
    local f = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "lazy-seq*"))
      else
      end
    end
    return seq_2a(lazy["lazy-seq"](f))
  end
  v_29_auto = lazy_seq_2a0
  core["lazy-seq*"] = v_29_auto
  lazy_seq_2a = v_29_auto
end
local first
do
  local v_29_auto
  local function first0(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "first"))
      else
      end
    end
    return lazy.first(seq(coll))
  end
  v_29_auto = first0
  core["first"] = v_29_auto
  first = v_29_auto
end
local rest
do
  local v_29_auto
  local function rest0(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "rest"))
      else
      end
    end
    return seq_2a(lazy.rest(seq(coll)))
  end
  v_29_auto = rest0
  core["rest"] = v_29_auto
  rest = v_29_auto
end
local next_2a
local function next_2a0(...)
  local s = ...
  do
    local cnt_61_auto = select("#", ...)
    if (1 ~= cnt_61_auto) then
      error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "next*"))
    else
    end
  end
  return seq_2a(lazy.next(s))
end
next_2a = next_2a0
do
  core["next"] = next_2a
end
local count
do
  local v_29_auto
  local function count0(...)
    local s = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "count"))
      else
      end
    end
    local _553_ = getmetatable(s)
    if ((_G.type(_553_) == "table") and (_553_["cljlib/type"] == "vector")) then
      return length_2a(s)
    else
      local _ = _553_
      return lazy.count(s)
    end
  end
  v_29_auto = count0
  core["count"] = v_29_auto
  count = v_29_auto
end
local cons
do
  local v_29_auto
  local function cons0(...)
    local head, tail = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "cons"))
      else
      end
    end
    return seq_2a(lazy.cons(head, tail))
  end
  v_29_auto = cons0
  core["cons"] = v_29_auto
  cons = v_29_auto
end
local function list(...)
  return seq_2a(lazy.list(...))
end
core.list = list
local list_2a
do
  local v_29_auto
  local function list_2a0(...)
    local core_43_auto = require("cljlib")
    local _let_556_ = core_43_auto.list(...)
    local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_556_, 1)
    return seq_2a(apply(lazy["list*"], args))
  end
  v_29_auto = list_2a0
  core["list*"] = v_29_auto
  list_2a = v_29_auto
end
local last
do
  local v_29_auto
  local function last0(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "last"))
      else
      end
    end
    local _558_ = next_2a(coll)
    if (nil ~= _558_) then
      local coll_2a = _558_
      return last0(coll_2a)
    else
      local _ = _558_
      return first(coll)
    end
  end
  v_29_auto = last0
  core["last"] = v_29_auto
  last = v_29_auto
end
local butlast
do
  local v_29_auto
  local function butlast0(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "butlast"))
      else
      end
    end
    return seq(lazy["drop-last"](coll))
  end
  v_29_auto = butlast0
  core["butlast"] = v_29_auto
  butlast = v_29_auto
end
local map
do
  local v_29_auto
  local function map0(...)
    local _561_ = select("#", ...)
    if (_561_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "map"))
    elseif (_561_ == 1) then
      local f = ...
      local function fn_562_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_562_"))
          else
          end
        end
        local function fn_564_(...)
          local _565_ = select("#", ...)
          if (_565_ == 0) then
            return rf()
          elseif (_565_ == 1) then
            local result = ...
            return rf(result)
          elseif (_565_ == 2) then
            local result, input = ...
            return rf(result, f(input))
          else
            local _ = _565_
            local core_43_auto = require("cljlib")
            local _let_566_ = core_43_auto.list(...)
            local result = _let_566_[1]
            local input = _let_566_[2]
            local inputs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_566_, 3)
            return rf(result, apply(f, input, inputs))
          end
        end
        return fn_564_
      end
      return fn_562_
    elseif (_561_ == 2) then
      local f, coll = ...
      return seq_2a(lazy.map(f, coll))
    else
      local _ = _561_
      local core_43_auto = require("cljlib")
      local _let_568_ = core_43_auto.list(...)
      local f = _let_568_[1]
      local coll = _let_568_[2]
      local colls = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_568_, 3)
      return seq_2a(apply(lazy.map, f, coll, colls))
    end
  end
  v_29_auto = map0
  core["map"] = v_29_auto
  map = v_29_auto
end
local mapv
do
  local v_29_auto
  local function mapv0(...)
    local _571_ = select("#", ...)
    if (_571_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "mapv"))
    elseif (_571_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "mapv"))
    elseif (_571_ == 2) then
      local f, coll = ...
      return core["persistent!"](core.transduce(map(f), core["conj!"], core.transient(vector()), coll))
    else
      local _ = _571_
      local core_43_auto = require("cljlib")
      local _let_572_ = core_43_auto.list(...)
      local f = _let_572_[1]
      local coll = _let_572_[2]
      local colls = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_572_, 3)
      return vec(apply(map, f, coll, colls))
    end
  end
  v_29_auto = mapv0
  core["mapv"] = v_29_auto
  mapv = v_29_auto
end
local map_indexed
do
  local v_29_auto
  local function map_indexed0(...)
    local _574_ = select("#", ...)
    if (_574_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "map-indexed"))
    elseif (_574_ == 1) then
      local f = ...
      local function fn_575_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_575_"))
          else
          end
        end
        local i = -1
        local function fn_577_(...)
          local _578_ = select("#", ...)
          if (_578_ == 0) then
            return rf()
          elseif (_578_ == 1) then
            local result = ...
            return rf(result)
          elseif (_578_ == 2) then
            local result, input = ...
            i = (i + 1)
            return rf(result, f(i, input))
          else
            local _ = _578_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_577_"))
          end
        end
        return fn_577_
      end
      return fn_575_
    elseif (_574_ == 2) then
      local f, coll = ...
      return seq_2a(lazy["map-indexed"](f, coll))
    else
      local _ = _574_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "map-indexed"))
    end
  end
  v_29_auto = map_indexed0
  core["map-indexed"] = v_29_auto
  map_indexed = v_29_auto
end
local mapcat
do
  local v_29_auto
  local function mapcat0(...)
    local _581_ = select("#", ...)
    if (_581_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "mapcat"))
    elseif (_581_ == 1) then
      local f = ...
      return comp(map(f), core.cat)
    else
      local _ = _581_
      local core_43_auto = require("cljlib")
      local _let_582_ = core_43_auto.list(...)
      local f = _let_582_[1]
      local colls = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_582_, 2)
      return seq_2a(apply(lazy.mapcat, f, colls))
    end
  end
  v_29_auto = mapcat0
  core["mapcat"] = v_29_auto
  mapcat = v_29_auto
end
local filter
do
  local v_29_auto
  local function filter0(...)
    local _584_ = select("#", ...)
    if (_584_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "filter"))
    elseif (_584_ == 1) then
      local pred = ...
      local function fn_585_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_585_"))
          else
          end
        end
        local function fn_587_(...)
          local _588_ = select("#", ...)
          if (_588_ == 0) then
            return rf()
          elseif (_588_ == 1) then
            local result = ...
            return rf(result)
          elseif (_588_ == 2) then
            local result, input = ...
            if pred(input) then
              return rf(result, input)
            else
              return result
            end
          else
            local _ = _588_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_587_"))
          end
        end
        return fn_587_
      end
      return fn_585_
    elseif (_584_ == 2) then
      local pred, coll = ...
      return seq_2a(lazy.filter(pred, coll))
    else
      local _ = _584_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "filter"))
    end
  end
  v_29_auto = filter0
  core["filter"] = v_29_auto
  filter = v_29_auto
end
local filterv
do
  local v_29_auto
  local function filterv0(...)
    local pred, coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "filterv"))
      else
      end
    end
    return vec(filter(pred, coll))
  end
  v_29_auto = filterv0
  core["filterv"] = v_29_auto
  filterv = v_29_auto
end
local every_3f
do
  local v_29_auto
  local function every_3f0(...)
    local pred, coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "every?"))
      else
      end
    end
    return lazy["every?"](pred, coll)
  end
  v_29_auto = every_3f0
  core["every?"] = v_29_auto
  every_3f = v_29_auto
end
local some
do
  local v_29_auto
  local function some0(...)
    local pred, coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "some"))
      else
      end
    end
    return lazy["some?"](pred, coll)
  end
  v_29_auto = some0
  core["some"] = v_29_auto
  some = v_29_auto
end
local not_any_3f
do
  local v_29_auto
  local function not_any_3f0(...)
    local pred, coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "not-any?"))
      else
      end
    end
    local function _596_(_241)
      return not pred(_241)
    end
    return some(_596_, coll)
  end
  v_29_auto = not_any_3f0
  core["not-any?"] = v_29_auto
  not_any_3f = v_29_auto
end
local range
do
  local v_29_auto
  local function range0(...)
    local _597_ = select("#", ...)
    if (_597_ == 0) then
      return seq_2a(lazy.range())
    elseif (_597_ == 1) then
      local upper = ...
      return seq_2a(lazy.range(upper))
    elseif (_597_ == 2) then
      local lower, upper = ...
      return seq_2a(lazy.range(lower, upper))
    elseif (_597_ == 3) then
      local lower, upper, step = ...
      return seq_2a(lazy.range(lower, upper, step))
    else
      local _ = _597_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "range"))
    end
  end
  v_29_auto = range0
  core["range"] = v_29_auto
  range = v_29_auto
end
local concat
do
  local v_29_auto
  local function concat0(...)
    local core_43_auto = require("cljlib")
    local _let_599_ = core_43_auto.list(...)
    local colls = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_599_, 1)
    return seq_2a(apply(lazy.concat, colls))
  end
  v_29_auto = concat0
  core["concat"] = v_29_auto
  concat = v_29_auto
end
local reverse
do
  local v_29_auto
  local function reverse0(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "reverse"))
      else
      end
    end
    return seq_2a(lazy.reverse(coll))
  end
  v_29_auto = reverse0
  core["reverse"] = v_29_auto
  reverse = v_29_auto
end
local take
do
  local v_29_auto
  local function take0(...)
    local _601_ = select("#", ...)
    if (_601_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "take"))
    elseif (_601_ == 1) then
      local n = ...
      local function fn_602_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_602_"))
          else
          end
        end
        local n0 = n
        local function fn_604_(...)
          local _605_ = select("#", ...)
          if (_605_ == 0) then
            return rf()
          elseif (_605_ == 1) then
            local result = ...
            return rf(result)
          elseif (_605_ == 2) then
            local result, input = ...
            local result0
            if (0 < n0) then
              result0 = rf(result, input)
            else
              result0 = result
            end
            n0 = (n0 - 1)
            if not (0 < n0) then
              return core["ensure-reduced"](result0)
            else
              return result0
            end
          else
            local _ = _605_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_604_"))
          end
        end
        return fn_604_
      end
      return fn_602_
    elseif (_601_ == 2) then
      local n, coll = ...
      return seq_2a(lazy.take(n, coll))
    else
      local _ = _601_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "take"))
    end
  end
  v_29_auto = take0
  core["take"] = v_29_auto
  take = v_29_auto
end
local take_while
do
  local v_29_auto
  local function take_while0(...)
    local _610_ = select("#", ...)
    if (_610_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "take-while"))
    elseif (_610_ == 1) then
      local pred = ...
      local function fn_611_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_611_"))
          else
          end
        end
        local function fn_613_(...)
          local _614_ = select("#", ...)
          if (_614_ == 0) then
            return rf()
          elseif (_614_ == 1) then
            local result = ...
            return rf(result)
          elseif (_614_ == 2) then
            local result, input = ...
            if pred(input) then
              return rf(result, input)
            else
              return core.reduced(result)
            end
          else
            local _ = _614_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_613_"))
          end
        end
        return fn_613_
      end
      return fn_611_
    elseif (_610_ == 2) then
      local pred, coll = ...
      return seq_2a(lazy["take-while"](pred, coll))
    else
      local _ = _610_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "take-while"))
    end
  end
  v_29_auto = take_while0
  core["take-while"] = v_29_auto
  take_while = v_29_auto
end
local drop
do
  local v_29_auto
  local function drop0(...)
    local _618_ = select("#", ...)
    if (_618_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "drop"))
    elseif (_618_ == 1) then
      local n = ...
      local function fn_619_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_619_"))
          else
          end
        end
        local nv = n
        local function fn_621_(...)
          local _622_ = select("#", ...)
          if (_622_ == 0) then
            return rf()
          elseif (_622_ == 1) then
            local result = ...
            return rf(result)
          elseif (_622_ == 2) then
            local result, input = ...
            local n0 = nv
            nv = (nv - 1)
            if pos_3f(n0) then
              return result
            else
              return rf(result, input)
            end
          else
            local _ = _622_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_621_"))
          end
        end
        return fn_621_
      end
      return fn_619_
    elseif (_618_ == 2) then
      local n, coll = ...
      return seq_2a(lazy.drop(n, coll))
    else
      local _ = _618_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "drop"))
    end
  end
  v_29_auto = drop0
  core["drop"] = v_29_auto
  drop = v_29_auto
end
local drop_while
do
  local v_29_auto
  local function drop_while0(...)
    local _626_ = select("#", ...)
    if (_626_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "drop-while"))
    elseif (_626_ == 1) then
      local pred = ...
      local function fn_627_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_627_"))
          else
          end
        end
        local dv = true
        local function fn_629_(...)
          local _630_ = select("#", ...)
          if (_630_ == 0) then
            return rf()
          elseif (_630_ == 1) then
            local result = ...
            return rf(result)
          elseif (_630_ == 2) then
            local result, input = ...
            local drop_3f = dv
            if (drop_3f and pred(input)) then
              return result
            else
              dv = nil
              return rf(result, input)
            end
          else
            local _ = _630_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_629_"))
          end
        end
        return fn_629_
      end
      return fn_627_
    elseif (_626_ == 2) then
      local pred, coll = ...
      return seq_2a(lazy["drop-while"](pred, coll))
    else
      local _ = _626_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "drop-while"))
    end
  end
  v_29_auto = drop_while0
  core["drop-while"] = v_29_auto
  drop_while = v_29_auto
end
local drop_last
do
  local v_29_auto
  local function drop_last0(...)
    local _634_ = select("#", ...)
    if (_634_ == 0) then
      return seq_2a(lazy["drop-last"]())
    elseif (_634_ == 1) then
      local coll = ...
      return seq_2a(lazy["drop-last"](coll))
    elseif (_634_ == 2) then
      local n, coll = ...
      return seq_2a(lazy["drop-last"](n, coll))
    else
      local _ = _634_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "drop-last"))
    end
  end
  v_29_auto = drop_last0
  core["drop-last"] = v_29_auto
  drop_last = v_29_auto
end
local take_last
do
  local v_29_auto
  local function take_last0(...)
    local n, coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "take-last"))
      else
      end
    end
    return seq_2a(lazy["take-last"](n, coll))
  end
  v_29_auto = take_last0
  core["take-last"] = v_29_auto
  take_last = v_29_auto
end
local take_nth
do
  local v_29_auto
  local function take_nth0(...)
    local _637_ = select("#", ...)
    if (_637_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "take-nth"))
    elseif (_637_ == 1) then
      local n = ...
      local function fn_638_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_638_"))
          else
          end
        end
        local iv = -1
        local function fn_640_(...)
          local _641_ = select("#", ...)
          if (_641_ == 0) then
            return rf()
          elseif (_641_ == 1) then
            local result = ...
            return rf(result)
          elseif (_641_ == 2) then
            local result, input = ...
            iv = (iv + 1)
            if (0 == (iv % n)) then
              return rf(result, input)
            else
              return result
            end
          else
            local _ = _641_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_640_"))
          end
        end
        return fn_640_
      end
      return fn_638_
    elseif (_637_ == 2) then
      local n, coll = ...
      return seq_2a(lazy["take-nth"](n, coll))
    else
      local _ = _637_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "take-nth"))
    end
  end
  v_29_auto = take_nth0
  core["take-nth"] = v_29_auto
  take_nth = v_29_auto
end
local split_at
do
  local v_29_auto
  local function split_at0(...)
    local n, coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "split-at"))
      else
      end
    end
    return vec(lazy["split-at"](n, coll))
  end
  v_29_auto = split_at0
  core["split-at"] = v_29_auto
  split_at = v_29_auto
end
local split_with
do
  local v_29_auto
  local function split_with0(...)
    local pred, coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "split-with"))
      else
      end
    end
    return vec(lazy["split-with"](pred, coll))
  end
  v_29_auto = split_with0
  core["split-with"] = v_29_auto
  split_with = v_29_auto
end
local nthrest
do
  local v_29_auto
  local function nthrest0(...)
    local coll, n = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "nthrest"))
      else
      end
    end
    return seq_2a(lazy.nthrest(coll, n))
  end
  v_29_auto = nthrest0
  core["nthrest"] = v_29_auto
  nthrest = v_29_auto
end
local nthnext
do
  local v_29_auto
  local function nthnext0(...)
    local coll, n = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "nthnext"))
      else
      end
    end
    return lazy.nthnext(coll, n)
  end
  v_29_auto = nthnext0
  core["nthnext"] = v_29_auto
  nthnext = v_29_auto
end
local keep
do
  local v_29_auto
  local function keep0(...)
    local _649_ = select("#", ...)
    if (_649_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "keep"))
    elseif (_649_ == 1) then
      local f = ...
      local function fn_650_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_650_"))
          else
          end
        end
        local function fn_652_(...)
          local _653_ = select("#", ...)
          if (_653_ == 0) then
            return rf()
          elseif (_653_ == 1) then
            local result = ...
            return rf(result)
          elseif (_653_ == 2) then
            local result, input = ...
            local v = f(input)
            if nil_3f(v) then
              return result
            else
              return rf(result, v)
            end
          else
            local _ = _653_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_652_"))
          end
        end
        return fn_652_
      end
      return fn_650_
    elseif (_649_ == 2) then
      local f, coll = ...
      return seq_2a(lazy.keep(f, coll))
    else
      local _ = _649_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "keep"))
    end
  end
  v_29_auto = keep0
  core["keep"] = v_29_auto
  keep = v_29_auto
end
local keep_indexed
do
  local v_29_auto
  local function keep_indexed0(...)
    local _657_ = select("#", ...)
    if (_657_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "keep-indexed"))
    elseif (_657_ == 1) then
      local f = ...
      local function fn_658_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_658_"))
          else
          end
        end
        local iv = -1
        local function fn_660_(...)
          local _661_ = select("#", ...)
          if (_661_ == 0) then
            return rf()
          elseif (_661_ == 1) then
            local result = ...
            return rf(result)
          elseif (_661_ == 2) then
            local result, input = ...
            iv = (iv + 1)
            local v = f(iv, input)
            if nil_3f(v) then
              return result
            else
              return rf(result, v)
            end
          else
            local _ = _661_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_660_"))
          end
        end
        return fn_660_
      end
      return fn_658_
    elseif (_657_ == 2) then
      local f, coll = ...
      return seq_2a(lazy["keep-indexed"](f, coll))
    else
      local _ = _657_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "keep-indexed"))
    end
  end
  v_29_auto = keep_indexed0
  core["keep-indexed"] = v_29_auto
  keep_indexed = v_29_auto
end
local partition
do
  local v_29_auto
  local function partition0(...)
    local _666_ = select("#", ...)
    if (_666_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "partition"))
    elseif (_666_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "partition"))
    elseif (_666_ == 2) then
      local n, coll = ...
      return map(seq_2a, lazy.partition(n, coll))
    elseif (_666_ == 3) then
      local n, step, coll = ...
      return map(seq_2a, lazy.partition(n, step, coll))
    elseif (_666_ == 4) then
      local n, step, pad, coll = ...
      return map(seq_2a, lazy.partition(n, step, pad, coll))
    else
      local _ = _666_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "partition"))
    end
  end
  v_29_auto = partition0
  core["partition"] = v_29_auto
  partition = v_29_auto
end
local function array()
  local len = 0
  local function _668_()
    return len
  end
  local function _669_(self)
    while (0 ~= len) do
      self[len] = nil
      len = (len - 1)
    end
    return nil
  end
  local function _670_(self, val)
    len = (len + 1)
    do end (self)[len] = val
    return self
  end
  return setmetatable({}, {__len = _668_, __index = {clear = _669_, add = _670_}})
end
local partition_by
do
  local v_29_auto
  local function partition_by0(...)
    local _671_ = select("#", ...)
    if (_671_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "partition-by"))
    elseif (_671_ == 1) then
      local f = ...
      local function fn_672_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_672_"))
          else
          end
        end
        local a = array()
        local none = {}
        local pv = none
        local function fn_674_(...)
          local _675_ = select("#", ...)
          if (_675_ == 0) then
            return rf()
          elseif (_675_ == 1) then
            local result = ...
            local function _676_(...)
              if empty_3f(a) then
                return result
              else
                local v = vec(a)
                a:clear()
                return core.unreduced(rf(result, v))
              end
            end
            return rf(_676_(...))
          elseif (_675_ == 2) then
            local result, input = ...
            local pval = pv
            local val = f(input)
            pv = val
            if ((pval == none) or (val == pval)) then
              a:add(input)
              return result
            else
              local v = vec(a)
              a:clear()
              local ret = rf(result, v)
              if not core["reduced?"](ret) then
                a:add(input)
              else
              end
              return ret
            end
          else
            local _ = _675_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_674_"))
          end
        end
        return fn_674_
      end
      return fn_672_
    elseif (_671_ == 2) then
      local f, coll = ...
      return map(seq_2a, lazy["partition-by"](f, coll))
    else
      local _ = _671_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "partition-by"))
    end
  end
  v_29_auto = partition_by0
  core["partition-by"] = v_29_auto
  partition_by = v_29_auto
end
local partition_all
do
  local v_29_auto
  local function partition_all0(...)
    local _681_ = select("#", ...)
    if (_681_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "partition-all"))
    elseif (_681_ == 1) then
      local n = ...
      local function fn_682_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_682_"))
          else
          end
        end
        local a = array()
        local function fn_684_(...)
          local _685_ = select("#", ...)
          if (_685_ == 0) then
            return rf()
          elseif (_685_ == 1) then
            local result = ...
            local function _686_(...)
              if (0 == #a) then
                return result
              else
                local v = vec(a)
                a:clear()
                return core.unreduced(rf(result, v))
              end
            end
            return rf(_686_(...))
          elseif (_685_ == 2) then
            local result, input = ...
            a:add(input)
            if (n == #a) then
              local v = vec(a)
              a:clear()
              return rf(result, v)
            else
              return result
            end
          else
            local _ = _685_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_684_"))
          end
        end
        return fn_684_
      end
      return fn_682_
    elseif (_681_ == 2) then
      local n, coll = ...
      return map(seq_2a, lazy["partition-all"](n, coll))
    elseif (_681_ == 3) then
      local n, step, coll = ...
      return map(seq_2a, lazy["partition-all"](n, step, coll))
    else
      local _ = _681_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "partition-all"))
    end
  end
  v_29_auto = partition_all0
  core["partition-all"] = v_29_auto
  partition_all = v_29_auto
end
local reductions
do
  local v_29_auto
  local function reductions0(...)
    local _691_ = select("#", ...)
    if (_691_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "reductions"))
    elseif (_691_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "reductions"))
    elseif (_691_ == 2) then
      local f, coll = ...
      return seq_2a(lazy.reductions(f, coll))
    elseif (_691_ == 3) then
      local f, init, coll = ...
      return seq_2a(lazy.reductions(f, init, coll))
    else
      local _ = _691_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "reductions"))
    end
  end
  v_29_auto = reductions0
  core["reductions"] = v_29_auto
  reductions = v_29_auto
end
local contains_3f
do
  local v_29_auto
  local function contains_3f0(...)
    local coll, elt = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "contains?"))
      else
      end
    end
    return lazy["contains?"](coll, elt)
  end
  v_29_auto = contains_3f0
  core["contains?"] = v_29_auto
  contains_3f = v_29_auto
end
local distinct
do
  local v_29_auto
  local function distinct0(...)
    local _694_ = select("#", ...)
    if (_694_ == 0) then
      local function fn_695_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_695_"))
          else
          end
        end
        local seen = setmetatable({}, {__index = deep_index})
        local function fn_697_(...)
          local _698_ = select("#", ...)
          if (_698_ == 0) then
            return rf()
          elseif (_698_ == 1) then
            local result = ...
            return rf(result)
          elseif (_698_ == 2) then
            local result, input = ...
            if seen[input] then
              return result
            else
              seen[input] = true
              return rf(result, input)
            end
          else
            local _ = _698_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_697_"))
          end
        end
        return fn_697_
      end
      return fn_695_
    elseif (_694_ == 1) then
      local coll = ...
      return seq_2a(lazy.distinct(coll))
    else
      local _ = _694_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "distinct"))
    end
  end
  v_29_auto = distinct0
  core["distinct"] = v_29_auto
  distinct = v_29_auto
end
local dedupe
do
  local v_29_auto
  local function dedupe0(...)
    local _702_ = select("#", ...)
    if (_702_ == 0) then
      local function fn_703_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_703_"))
          else
          end
        end
        local none = {}
        local pv = none
        local function fn_705_(...)
          local _706_ = select("#", ...)
          if (_706_ == 0) then
            return rf()
          elseif (_706_ == 1) then
            local result = ...
            return rf(result)
          elseif (_706_ == 2) then
            local result, input = ...
            local prior = pv
            pv = input
            if (prior == input) then
              return result
            else
              return rf(result, input)
            end
          else
            local _ = _706_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_705_"))
          end
        end
        return fn_705_
      end
      return fn_703_
    elseif (_702_ == 1) then
      local coll = ...
      return core.sequence(dedupe0(), coll)
    else
      local _ = _702_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "dedupe"))
    end
  end
  v_29_auto = dedupe0
  core["dedupe"] = v_29_auto
  dedupe = v_29_auto
end
local random_sample
do
  local v_29_auto
  local function random_sample0(...)
    local _710_ = select("#", ...)
    if (_710_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "random-sample"))
    elseif (_710_ == 1) then
      local prob = ...
      local function _711_()
        return (math.random() < prob)
      end
      return filter(_711_)
    elseif (_710_ == 2) then
      local prob, coll = ...
      local function _712_()
        return (math.random() < prob)
      end
      return filter(_712_, coll)
    else
      local _ = _710_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "random-sample"))
    end
  end
  v_29_auto = random_sample0
  core["random-sample"] = v_29_auto
  random_sample = v_29_auto
end
local doall
do
  local v_29_auto
  local function doall0(...)
    local seq0 = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "doall"))
      else
      end
    end
    return seq_2a(lazy.doall(seq0))
  end
  v_29_auto = doall0
  core["doall"] = v_29_auto
  doall = v_29_auto
end
local dorun
do
  local v_29_auto
  local function dorun0(...)
    local seq0 = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "dorun"))
      else
      end
    end
    return lazy.dorun(seq0)
  end
  v_29_auto = dorun0
  core["dorun"] = v_29_auto
  dorun = v_29_auto
end
local line_seq
do
  local v_29_auto
  local function line_seq0(...)
    local file = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "line-seq"))
      else
      end
    end
    return seq_2a(lazy["line-seq"](file))
  end
  v_29_auto = line_seq0
  core["line-seq"] = v_29_auto
  line_seq = v_29_auto
end
local iterate
do
  local v_29_auto
  local function iterate0(...)
    local f, x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "iterate"))
      else
      end
    end
    return seq_2a(lazy.iterate(f, x))
  end
  v_29_auto = iterate0
  core["iterate"] = v_29_auto
  iterate = v_29_auto
end
local remove
do
  local v_29_auto
  local function remove0(...)
    local _718_ = select("#", ...)
    if (_718_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "remove"))
    elseif (_718_ == 1) then
      local pred = ...
      return filter(complement(pred))
    elseif (_718_ == 2) then
      local pred, coll = ...
      return seq_2a(lazy.remove(pred, coll))
    else
      local _ = _718_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "remove"))
    end
  end
  v_29_auto = remove0
  core["remove"] = v_29_auto
  remove = v_29_auto
end
local cycle
do
  local v_29_auto
  local function cycle0(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "cycle"))
      else
      end
    end
    return seq_2a(lazy.cycle(coll))
  end
  v_29_auto = cycle0
  core["cycle"] = v_29_auto
  cycle = v_29_auto
end
local _repeat
do
  local v_29_auto
  local function _repeat0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "repeat"))
      else
      end
    end
    return seq_2a(lazy["repeat"](x))
  end
  v_29_auto = _repeat0
  core["repeat"] = v_29_auto
  _repeat = v_29_auto
end
local repeatedly
do
  local v_29_auto
  local function repeatedly0(...)
    local core_43_auto = require("cljlib")
    local _let_722_ = core_43_auto.list(...)
    local f = _let_722_[1]
    local args = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_722_, 2)
    return seq_2a(apply(lazy.repeatedly, f, args))
  end
  v_29_auto = repeatedly0
  core["repeatedly"] = v_29_auto
  repeatedly = v_29_auto
end
local tree_seq
do
  local v_29_auto
  local function tree_seq0(...)
    local branch_3f, children, root = ...
    do
      local cnt_61_auto = select("#", ...)
      if (3 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "tree-seq"))
      else
      end
    end
    return seq_2a(lazy["tree-seq"](branch_3f, children, root))
  end
  v_29_auto = tree_seq0
  core["tree-seq"] = v_29_auto
  tree_seq = v_29_auto
end
local interleave
do
  local v_29_auto
  local function interleave0(...)
    local _724_ = select("#", ...)
    if (_724_ == 0) then
      return seq_2a(lazy.interleave())
    elseif (_724_ == 1) then
      local s = ...
      return seq_2a(lazy.interleave(s))
    elseif (_724_ == 2) then
      local s1, s2 = ...
      return seq_2a(lazy.interleave(s1, s2))
    else
      local _ = _724_
      local core_43_auto = require("cljlib")
      local _let_725_ = core_43_auto.list(...)
      local s1 = _let_725_[1]
      local s2 = _let_725_[2]
      local ss = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_725_, 3)
      return seq_2a(apply(lazy.interleave, s1, s2, ss))
    end
  end
  v_29_auto = interleave0
  core["interleave"] = v_29_auto
  interleave = v_29_auto
end
local interpose
do
  local v_29_auto
  local function interpose0(...)
    local _727_ = select("#", ...)
    if (_727_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "interpose"))
    elseif (_727_ == 1) then
      local sep = ...
      local function fn_728_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_728_"))
          else
          end
        end
        local started = false
        local function fn_730_(...)
          local _731_ = select("#", ...)
          if (_731_ == 0) then
            return rf()
          elseif (_731_ == 1) then
            local result = ...
            return rf(result)
          elseif (_731_ == 2) then
            local result, input = ...
            if started then
              local sepr = rf(result, sep)
              if core["reduced?"](sepr) then
                return sepr
              else
                return rf(sepr, input)
              end
            else
              started = true
              return rf(result, input)
            end
          else
            local _ = _731_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_730_"))
          end
        end
        return fn_730_
      end
      return fn_728_
    elseif (_727_ == 2) then
      local separator, coll = ...
      return seq_2a(lazy.interpose(separator, coll))
    else
      local _ = _727_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "interpose"))
    end
  end
  v_29_auto = interpose0
  core["interpose"] = v_29_auto
  interpose = v_29_auto
end
local halt_when
do
  local v_29_auto
  local function halt_when0(...)
    local _736_ = select("#", ...)
    if (_736_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "halt-when"))
    elseif (_736_ == 1) then
      local pred = ...
      return halt_when0(pred, nil)
    elseif (_736_ == 2) then
      local pred, retf = ...
      local function fn_737_(...)
        local rf = ...
        do
          local cnt_61_auto = select("#", ...)
          if (1 ~= cnt_61_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_737_"))
          else
          end
        end
        local halt
        local function _739_()
          return "#<halt>"
        end
        halt = setmetatable({}, {__fennelview = _739_})
        local function fn_740_(...)
          local _741_ = select("#", ...)
          if (_741_ == 0) then
            return rf()
          elseif (_741_ == 1) then
            local result = ...
            if (map_3f(result) and contains_3f(result, halt)) then
              return result.value
            else
              return rf(result)
            end
          elseif (_741_ == 2) then
            local result, input = ...
            if pred(input) then
              local _743_
              if retf then
                _743_ = retf(rf(result), input)
              else
                _743_ = input
              end
              return core.reduced({[halt] = true, value = _743_})
            else
              return rf(result, input)
            end
          else
            local _ = _741_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_740_"))
          end
        end
        return fn_740_
      end
      return fn_737_
    else
      local _ = _736_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "halt-when"))
    end
  end
  v_29_auto = halt_when0
  core["halt-when"] = v_29_auto
  halt_when = v_29_auto
end
local realized_3f
do
  local v_29_auto
  local function realized_3f0(...)
    local s = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "realized?"))
      else
      end
    end
    return lazy["realized?"](s)
  end
  v_29_auto = realized_3f0
  core["realized?"] = v_29_auto
  realized_3f = v_29_auto
end
local keys
do
  local v_29_auto
  local function keys0(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "keys"))
      else
      end
    end
    assert((map_3f(coll) or empty_3f(coll)), "expected a map")
    if empty_3f(coll) then
      return lazy.list()
    else
      return lazy.keys(coll)
    end
  end
  v_29_auto = keys0
  core["keys"] = v_29_auto
  keys = v_29_auto
end
local vals
do
  local v_29_auto
  local function vals0(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "vals"))
      else
      end
    end
    assert((map_3f(coll) or empty_3f(coll)), "expected a map")
    if empty_3f(coll) then
      return lazy.list()
    else
      return lazy.vals(coll)
    end
  end
  v_29_auto = vals0
  core["vals"] = v_29_auto
  vals = v_29_auto
end
local find
do
  local v_29_auto
  local function find0(...)
    local coll, key = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "find"))
      else
      end
    end
    assert((map_3f(coll) or empty_3f(coll)), "expected a map")
    local _754_ = coll[key]
    if (nil ~= _754_) then
      local v = _754_
      return {key, v}
    else
      return nil
    end
  end
  v_29_auto = find0
  core["find"] = v_29_auto
  find = v_29_auto
end
local sort
do
  local v_29_auto
  local function sort0(...)
    local _756_ = select("#", ...)
    if (_756_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "sort"))
    elseif (_756_ == 1) then
      local coll = ...
      local _757_ = seq(coll)
      if (nil ~= _757_) then
        local s = _757_
        return seq(itable.sort(vec(s)))
      else
        local _ = _757_
        return list()
      end
    elseif (_756_ == 2) then
      local comparator, coll = ...
      local _759_ = seq(coll)
      if (nil ~= _759_) then
        local s = _759_
        return seq(itable.sort(vec(s), comparator))
      else
        local _ = _759_
        return list()
      end
    else
      local _ = _756_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "sort"))
    end
  end
  v_29_auto = sort0
  core["sort"] = v_29_auto
  sort = v_29_auto
end
local reduce
do
  local v_29_auto
  local function reduce0(...)
    local _763_ = select("#", ...)
    if (_763_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "reduce"))
    elseif (_763_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "reduce"))
    elseif (_763_ == 2) then
      local f, coll = ...
      return lazy.reduce(f, seq(coll))
    elseif (_763_ == 3) then
      local f, val, coll = ...
      return lazy.reduce(f, val, seq(coll))
    else
      local _ = _763_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "reduce"))
    end
  end
  v_29_auto = reduce0
  core["reduce"] = v_29_auto
  reduce = v_29_auto
end
local reduced
do
  local v_29_auto
  local function reduced0(...)
    local value = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "reduced"))
      else
      end
    end
    local _766_ = lazy.reduced(value)
    local function _767_(_241)
      return _241:unbox()
    end
    getmetatable(_766_)["cljlib/deref"] = _767_
    return _766_
  end
  v_29_auto = reduced0
  core["reduced"] = v_29_auto
  reduced = v_29_auto
end
local reduced_3f
do
  local v_29_auto
  local function reduced_3f0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "reduced?"))
      else
      end
    end
    return lazy["reduced?"](x)
  end
  v_29_auto = reduced_3f0
  core["reduced?"] = v_29_auto
  reduced_3f = v_29_auto
end
local unreduced
do
  local v_29_auto
  local function unreduced0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "unreduced"))
      else
      end
    end
    if reduced_3f(x) then
      return deref(x)
    else
      return x
    end
  end
  v_29_auto = unreduced0
  core["unreduced"] = v_29_auto
  unreduced = v_29_auto
end
local ensure_reduced
do
  local v_29_auto
  local function ensure_reduced0(...)
    local x = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "ensure-reduced"))
      else
      end
    end
    if reduced_3f(x) then
      return x
    else
      return reduced(x)
    end
  end
  v_29_auto = ensure_reduced0
  core["ensure-reduced"] = v_29_auto
  ensure_reduced = v_29_auto
end
local preserving_reduced
local function preserving_reduced0(...)
  local rf = ...
  do
    local cnt_61_auto = select("#", ...)
    if (1 ~= cnt_61_auto) then
      error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "preserving-reduced"))
    else
    end
  end
  local function fn_774_(...)
    local a, b = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "fn_774_"))
      else
      end
    end
    local ret = rf(a, b)
    if reduced_3f(ret) then
      return reduced(ret)
    else
      return ret
    end
  end
  return fn_774_
end
preserving_reduced = preserving_reduced0
local cat
do
  local v_29_auto
  local function cat0(...)
    local rf = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "cat"))
      else
      end
    end
    local rrf = preserving_reduced(rf)
    local function fn_778_(...)
      local _779_ = select("#", ...)
      if (_779_ == 0) then
        return rf()
      elseif (_779_ == 1) then
        local result = ...
        return rf(result)
      elseif (_779_ == 2) then
        local result, input = ...
        return reduce(rrf, result, input)
      else
        local _ = _779_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_778_"))
      end
    end
    return fn_778_
  end
  v_29_auto = cat0
  core["cat"] = v_29_auto
  cat = v_29_auto
end
local reduce_kv
do
  local v_29_auto
  local function reduce_kv0(...)
    local f, val, s = ...
    do
      local cnt_61_auto = select("#", ...)
      if (3 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "reduce-kv"))
      else
      end
    end
    if map_3f(s) then
      local function _784_(res, _782_)
        local _arg_783_ = _782_
        local k = _arg_783_[1]
        local v = _arg_783_[2]
        return f(res, k, v)
      end
      return reduce(_784_, val, seq(s))
    else
      local function _787_(res, _785_)
        local _arg_786_ = _785_
        local k = _arg_786_[1]
        local v = _arg_786_[2]
        return f(res, k, v)
      end
      return reduce(_787_, val, map(vector, drop(1, range()), seq(s)))
    end
  end
  v_29_auto = reduce_kv0
  core["reduce-kv"] = v_29_auto
  reduce_kv = v_29_auto
end
local completing
do
  local v_29_auto
  local function completing0(...)
    local _789_ = select("#", ...)
    if (_789_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "completing"))
    elseif (_789_ == 1) then
      local f = ...
      return completing0(f, identity)
    elseif (_789_ == 2) then
      local f, cf = ...
      local function fn_790_(...)
        local _791_ = select("#", ...)
        if (_791_ == 0) then
          return f()
        elseif (_791_ == 1) then
          local x = ...
          return cf(x)
        elseif (_791_ == 2) then
          local x, y = ...
          return f(x, y)
        else
          local _ = _791_
          return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_790_"))
        end
      end
      return fn_790_
    else
      local _ = _789_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "completing"))
    end
  end
  v_29_auto = completing0
  core["completing"] = v_29_auto
  completing = v_29_auto
end
local transduce
do
  local v_29_auto
  local function transduce0(...)
    local _797_ = select("#", ...)
    if (_797_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "transduce"))
    elseif (_797_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "transduce"))
    elseif (_797_ == 2) then
      return error(("Wrong number of args (%s) passed to %s"):format(2, "transduce"))
    elseif (_797_ == 3) then
      local xform, f, coll = ...
      return transduce0(xform, f, f(), coll)
    elseif (_797_ == 4) then
      local xform, f, init, coll = ...
      local f0 = xform(f)
      return f0(reduce(f0, init, seq(coll)))
    else
      local _ = _797_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "transduce"))
    end
  end
  v_29_auto = transduce0
  core["transduce"] = v_29_auto
  transduce = v_29_auto
end
local sequence
do
  local v_29_auto
  local function sequence0(...)
    local _799_ = select("#", ...)
    if (_799_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "sequence"))
    elseif (_799_ == 1) then
      local coll = ...
      if seq_3f(coll) then
        return coll
      else
        return (seq(coll) or list())
      end
    elseif (_799_ == 2) then
      local xform, coll = ...
      local f
      local function _801_(_241, _242)
        return cons(_242, _241)
      end
      f = xform(completing(_801_))
      local function step(coll0)
        local val_99_auto = seq(coll0)
        if (nil ~= val_99_auto) then
          local s = val_99_auto
          local res = f(nil, first(s))
          if reduced_3f(res) then
            return f(deref(res))
          elseif seq_3f(res) then
            local function _802_()
              return step(rest(s))
            end
            return concat(res, lazy_seq_2a(_802_))
          elseif "else" then
            return step(rest(s))
          else
            return nil
          end
        else
          return f(nil)
        end
      end
      return (step(coll) or list())
    else
      local _ = _799_
      local core_43_auto = require("cljlib")
      local _let_805_ = core_43_auto.list(...)
      local xform = _let_805_[1]
      local coll = _let_805_[2]
      local colls = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_805_, 3)
      local f
      local function _806_(_241, _242)
        return cons(_242, _241)
      end
      f = xform(completing(_806_))
      local function step(colls0)
        if every_3f(seq, colls0) then
          local res = apply(f, nil, map(first, colls0))
          if reduced_3f(res) then
            return f(deref(res))
          elseif seq_3f(res) then
            local function _807_()
              return step(map(rest, colls0))
            end
            return concat(res, lazy_seq_2a(_807_))
          elseif "else" then
            return step(map(rest, colls0))
          else
            return nil
          end
        else
          return f(nil)
        end
      end
      return (step(cons(coll, colls)) or list())
    end
  end
  v_29_auto = sequence0
  core["sequence"] = v_29_auto
  sequence = v_29_auto
end
local function map__3etransient(immutable)
  local function _811_(map0)
    local removed = setmetatable({}, {__index = deep_index})
    local function _812_(_, k)
      if not removed[k] then
        return map0[k]
      else
        return nil
      end
    end
    local function _814_()
      return error("can't `conj` onto transient map, use `conj!`")
    end
    local function _815_()
      return error("can't `assoc` onto transient map, use `assoc!`")
    end
    local function _816_()
      return error("can't `dissoc` onto transient map, use `dissoc!`")
    end
    local function _819_(tmap, _817_)
      local _arg_818_ = _817_
      local k = _arg_818_[1]
      local v = _arg_818_[2]
      if (nil == v) then
        removed[k] = true
      else
        removed[k] = nil
      end
      tmap[k] = v
      return tmap
    end
    local function _821_(tmap, ...)
      for i = 1, select("#", ...), 2 do
        local k, v = select(i, ...)
        do end (tmap)[k] = v
        if (nil == v) then
          removed[k] = true
        else
          removed[k] = nil
        end
      end
      return tmap
    end
    local function _823_(tmap, ...)
      for i = 1, select("#", ...) do
        local k = select(i, ...)
        do end (tmap)[k] = nil
        removed[k] = true
      end
      return tmap
    end
    local function _824_(tmap)
      local t
      do
        local tbl_14_auto
        do
          local tbl_14_auto0 = {}
          for k, v in pairs(map0) do
            local k_15_auto, v_16_auto = k, v
            if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
              tbl_14_auto0[k_15_auto] = v_16_auto
            else
            end
          end
          tbl_14_auto = tbl_14_auto0
        end
        for k, v in pairs(tmap) do
          local k_15_auto, v_16_auto = k, v
          if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
            tbl_14_auto[k_15_auto] = v_16_auto
          else
          end
        end
        t = tbl_14_auto
      end
      for k in pairs(removed) do
        t[k] = nil
      end
      local function _827_()
        local tbl_19_auto = {}
        local i_20_auto = 0
        for k in pairs_2a(tmap) do
          local val_21_auto = k
          if (nil ~= val_21_auto) then
            i_20_auto = (i_20_auto + 1)
            do end (tbl_19_auto)[i_20_auto] = val_21_auto
          else
          end
        end
        return tbl_19_auto
      end
      for _, k in ipairs(_827_()) do
        tmap[k] = nil
      end
      local function _829_()
        return error("attempt to use transient after it was persistet")
      end
      local function _830_()
        return error("attempt to use transient after it was persistet")
      end
      setmetatable(tmap, {__index = _829_, __newindex = _830_})
      return immutable(itable(t))
    end
    return setmetatable({}, {__index = _812_, ["cljlib/type"] = "transient", ["cljlib/conj"] = _814_, ["cljlib/assoc"] = _815_, ["cljlib/dissoc"] = _816_, ["cljlib/conj!"] = _819_, ["cljlib/assoc!"] = _821_, ["cljlib/dissoc!"] = _823_, ["cljlib/persistent!"] = _824_})
  end
  return _811_
end
local function hash_map_2a(x)
  do
    local _831_ = getmetatable(x)
    if (nil ~= _831_) then
      local mt = _831_
      mt["cljlib/type"] = "hash-map"
      mt["cljlib/editable"] = true
      local function _834_(t, _832_, ...)
        local _arg_833_ = _832_
        local k = _arg_833_[1]
        local v = _arg_833_[2]
        local function _835_(...)
          local kvs = {}
          for _, _836_ in ipairs_2a({...}) do
            local _each_837_ = _836_
            local k0 = _each_837_[1]
            local v0 = _each_837_[2]
            table.insert(kvs, k0)
            table.insert(kvs, v0)
            kvs = kvs
          end
          return kvs
        end
        return apply(core.assoc, t, k, v, _835_(...))
      end
      mt["cljlib/conj"] = _834_
      mt["cljlib/transient"] = map__3etransient(hash_map_2a)
      local function _838_()
        return hash_map_2a(itable({}))
      end
      mt["cljlib/empty"] = _838_
    else
      local _ = _831_
      hash_map_2a(setmetatable(x, {}))
    end
  end
  return x
end
local assoc
do
  local v_29_auto
  local function assoc0(...)
    local _842_ = select("#", ...)
    if (_842_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "assoc"))
    elseif (_842_ == 1) then
      local tbl = ...
      return hash_map_2a(itable({}))
    elseif (_842_ == 2) then
      return error(("Wrong number of args (%s) passed to %s"):format(2, "assoc"))
    elseif (_842_ == 3) then
      local tbl, k, v = ...
      assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map")
      assert(not nil_3f(k), "attempt to use nil as key")
      return hash_map_2a(itable.assoc((tbl or {}), k, v))
    else
      local _ = _842_
      local core_43_auto = require("cljlib")
      local _let_843_ = core_43_auto.list(...)
      local tbl = _let_843_[1]
      local k = _let_843_[2]
      local v = _let_843_[3]
      local kvs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_843_, 4)
      assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map")
      assert(not nil_3f(k), "attempt to use nil as key")
      return hash_map_2a(apply(itable.assoc, (tbl or {}), k, v, kvs))
    end
  end
  v_29_auto = assoc0
  core["assoc"] = v_29_auto
  assoc = v_29_auto
end
local assoc_in
do
  local v_29_auto
  local function assoc_in0(...)
    local tbl, key_seq, val = ...
    do
      local cnt_61_auto = select("#", ...)
      if (3 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "assoc-in"))
      else
      end
    end
    assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map or nil")
    return hash_map_2a(itable["assoc-in"](tbl, key_seq, val))
  end
  v_29_auto = assoc_in0
  core["assoc-in"] = v_29_auto
  assoc_in = v_29_auto
end
local update
do
  local v_29_auto
  local function update0(...)
    local tbl, key, f = ...
    do
      local cnt_61_auto = select("#", ...)
      if (3 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "update"))
      else
      end
    end
    assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map")
    return hash_map_2a(itable.update(tbl, key, f))
  end
  v_29_auto = update0
  core["update"] = v_29_auto
  update = v_29_auto
end
local update_in
do
  local v_29_auto
  local function update_in0(...)
    local tbl, key_seq, f = ...
    do
      local cnt_61_auto = select("#", ...)
      if (3 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "update-in"))
      else
      end
    end
    assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map or nil")
    return hash_map_2a(itable["update-in"](tbl, key_seq, f))
  end
  v_29_auto = update_in0
  core["update-in"] = v_29_auto
  update_in = v_29_auto
end
local hash_map
do
  local v_29_auto
  local function hash_map0(...)
    local core_43_auto = require("cljlib")
    local _let_848_ = core_43_auto.list(...)
    local kvs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_848_, 1)
    return apply(assoc, {}, kvs)
  end
  v_29_auto = hash_map0
  core["hash-map"] = v_29_auto
  hash_map = v_29_auto
end
local get
do
  local v_29_auto
  local function get0(...)
    local _850_ = select("#", ...)
    if (_850_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "get"))
    elseif (_850_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "get"))
    elseif (_850_ == 2) then
      local tbl, key = ...
      return get0(tbl, key, nil)
    elseif (_850_ == 3) then
      local tbl, key, not_found = ...
      assert((map_3f(tbl) or empty_3f(tbl)), "expected a map")
      return (tbl[key] or not_found)
    else
      local _ = _850_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "get"))
    end
  end
  v_29_auto = get0
  core["get"] = v_29_auto
  get = v_29_auto
end
local get_in
do
  local v_29_auto
  local function get_in0(...)
    local _853_ = select("#", ...)
    if (_853_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "get-in"))
    elseif (_853_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "get-in"))
    elseif (_853_ == 2) then
      local tbl, keys0 = ...
      return get_in0(tbl, keys0, nil)
    elseif (_853_ == 3) then
      local tbl, keys0, not_found = ...
      assert((map_3f(tbl) or empty_3f(tbl)), "expected a map")
      local res, t, done = tbl, tbl, nil
      for _, k in ipairs_2a(keys0) do
        if done then break end
        local _854_ = t[k]
        if (nil ~= _854_) then
          local v = _854_
          res, t = v, v
        else
          local _0 = _854_
          res, done = not_found, true
        end
      end
      return res
    else
      local _ = _853_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "get-in"))
    end
  end
  v_29_auto = get_in0
  core["get-in"] = v_29_auto
  get_in = v_29_auto
end
local dissoc
do
  local v_29_auto
  local function dissoc0(...)
    local _857_ = select("#", ...)
    if (_857_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "dissoc"))
    elseif (_857_ == 1) then
      local tbl = ...
      return tbl
    elseif (_857_ == 2) then
      local tbl, key = ...
      assert((map_3f(tbl) or empty_3f(tbl)), "expected a map")
      local function _858_(...)
        tbl[key] = nil
        return tbl
      end
      return hash_map_2a(_858_(...))
    else
      local _ = _857_
      local core_43_auto = require("cljlib")
      local _let_859_ = core_43_auto.list(...)
      local tbl = _let_859_[1]
      local key = _let_859_[2]
      local keys0 = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_859_, 3)
      return apply(dissoc0, dissoc0(tbl, key), keys0)
    end
  end
  v_29_auto = dissoc0
  core["dissoc"] = v_29_auto
  dissoc = v_29_auto
end
local merge
do
  local v_29_auto
  local function merge0(...)
    local core_43_auto = require("cljlib")
    local _let_861_ = core_43_auto.list(...)
    local maps = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_861_, 1)
    if some(identity, maps) then
      local function _862_(a, b)
        local tbl_14_auto = a
        for k, v in pairs_2a(b) do
          local k_15_auto, v_16_auto = k, v
          if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
            tbl_14_auto[k_15_auto] = v_16_auto
          else
          end
        end
        return tbl_14_auto
      end
      return hash_map_2a(itable(reduce(_862_, {}, maps)))
    else
      return nil
    end
  end
  v_29_auto = merge0
  core["merge"] = v_29_auto
  merge = v_29_auto
end
local frequencies
do
  local v_29_auto
  local function frequencies0(...)
    local t = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "frequencies"))
      else
      end
    end
    return hash_map_2a(itable.frequencies(t))
  end
  v_29_auto = frequencies0
  core["frequencies"] = v_29_auto
  frequencies = v_29_auto
end
local group_by
do
  local v_29_auto
  local function group_by0(...)
    local f, t = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "group-by"))
      else
      end
    end
    local function _868_(...)
      local _867_ = itable["group-by"](f, t)
      return _867_
    end
    return hash_map_2a(_868_(...))
  end
  v_29_auto = group_by0
  core["group-by"] = v_29_auto
  group_by = v_29_auto
end
local zipmap
do
  local v_29_auto
  local function zipmap0(...)
    local keys0, vals0 = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "zipmap"))
      else
      end
    end
    return hash_map_2a(itable(lazy.zipmap(keys0, vals0)))
  end
  v_29_auto = zipmap0
  core["zipmap"] = v_29_auto
  zipmap = v_29_auto
end
local replace
do
  local v_29_auto
  local function replace0(...)
    local _870_ = select("#", ...)
    if (_870_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "replace"))
    elseif (_870_ == 1) then
      local smap = ...
      local function _871_(_241)
        local val_93_auto = find(smap, _241)
        if val_93_auto then
          local e = val_93_auto
          return e[2]
        else
          return _241
        end
      end
      return map(_871_)
    elseif (_870_ == 2) then
      local smap, coll = ...
      if vector_3f(coll) then
        local function _873_(res, v)
          local val_93_auto = find(smap, v)
          if val_93_auto then
            local e = val_93_auto
            table.insert(res, e[2])
            return res
          else
            table.insert(res, v)
            return res
          end
        end
        return vec_2a(itable(reduce(_873_, {}, coll)))
      else
        local function _875_(_241)
          local val_93_auto = find(smap, _241)
          if val_93_auto then
            local e = val_93_auto
            return e[2]
          else
            return _241
          end
        end
        return map(_875_, coll)
      end
    else
      local _ = _870_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "replace"))
    end
  end
  v_29_auto = replace0
  core["replace"] = v_29_auto
  replace = v_29_auto
end
local conj
do
  local v_29_auto
  local function conj0(...)
    local _879_ = select("#", ...)
    if (_879_ == 0) then
      return vector()
    elseif (_879_ == 1) then
      local s = ...
      return s
    elseif (_879_ == 2) then
      local s, x = ...
      local _880_ = getmetatable(s)
      if ((_G.type(_880_) == "table") and (nil ~= _880_["cljlib/conj"])) then
        local f = _880_["cljlib/conj"]
        return f(s, x)
      else
        local _ = _880_
        if vector_3f(s) then
          return vec_2a(itable.insert(s, x))
        elseif map_3f(s) then
          return apply(assoc, s, x)
        elseif nil_3f(s) then
          return cons(x, s)
        elseif empty_3f(s) then
          return vector(x)
        else
          return error("expected collection, got", type(s))
        end
      end
    else
      local _ = _879_
      local core_43_auto = require("cljlib")
      local _let_883_ = core_43_auto.list(...)
      local s = _let_883_[1]
      local x = _let_883_[2]
      local xs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_883_, 3)
      return apply(conj0, conj0(s, x), xs)
    end
  end
  v_29_auto = conj0
  core["conj"] = v_29_auto
  conj = v_29_auto
end
local disj
do
  local v_29_auto
  local function disj0(...)
    local _885_ = select("#", ...)
    if (_885_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "disj"))
    elseif (_885_ == 1) then
      local Set = ...
      return Set
    elseif (_885_ == 2) then
      local Set, key = ...
      local _886_ = getmetatable(Set)
      if ((_G.type(_886_) == "table") and (_886_["cljlib/type"] == "hash-set") and (nil ~= _886_["cljlib/disj"])) then
        local f = _886_["cljlib/disj"]
        return f(Set, key)
      else
        local _ = _886_
        return error(("disj is not supported on " .. class(Set)), 2)
      end
    else
      local _ = _885_
      local core_43_auto = require("cljlib")
      local _let_888_ = core_43_auto.list(...)
      local Set = _let_888_[1]
      local key = _let_888_[2]
      local keys0 = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_888_, 3)
      local _889_ = getmetatable(Set)
      if ((_G.type(_889_) == "table") and (_889_["cljlib/type"] == "hash-set") and (nil ~= _889_["cljlib/disj"])) then
        local f = _889_["cljlib/disj"]
        return apply(f, Set, key, keys0)
      else
        local _0 = _889_
        return error(("disj is not supported on " .. class(Set)), 2)
      end
    end
  end
  v_29_auto = disj0
  core["disj"] = v_29_auto
  disj = v_29_auto
end
local pop
do
  local v_29_auto
  local function pop0(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "pop"))
      else
      end
    end
    local _893_ = getmetatable(coll)
    if ((_G.type(_893_) == "table") and (_893_["cljlib/type"] == "seq")) then
      local _894_ = seq(coll)
      if (nil ~= _894_) then
        local s = _894_
        return drop(1, s)
      else
        local _ = _894_
        return error("can't pop empty list", 2)
      end
    elseif ((_G.type(_893_) == "table") and (nil ~= _893_["cljlib/pop"])) then
      local f = _893_["cljlib/pop"]
      return f(coll)
    else
      local _ = _893_
      return error(("pop is not supported on " .. class(coll)), 2)
    end
  end
  v_29_auto = pop0
  core["pop"] = v_29_auto
  pop = v_29_auto
end
local transient
do
  local v_29_auto
  local function transient0(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "transient"))
      else
      end
    end
    local _898_ = getmetatable(coll)
    if ((_G.type(_898_) == "table") and (_898_["cljlib/editable"] == true) and (nil ~= _898_["cljlib/transient"])) then
      local f = _898_["cljlib/transient"]
      return f(coll)
    else
      local _ = _898_
      return error("expected editable collection", 2)
    end
  end
  v_29_auto = transient0
  core["transient"] = v_29_auto
  transient = v_29_auto
end
local conj_21
do
  local v_29_auto
  local function conj_210(...)
    local _900_ = select("#", ...)
    if (_900_ == 0) then
      return transient(vec_2a({}))
    elseif (_900_ == 1) then
      local coll = ...
      return coll
    elseif (_900_ == 2) then
      local coll, x = ...
      do
        local _901_ = getmetatable(coll)
        if ((_G.type(_901_) == "table") and (_901_["cljlib/type"] == "transient") and (nil ~= _901_["cljlib/conj!"])) then
          local f = _901_["cljlib/conj!"]
          f(coll, x)
        elseif ((_G.type(_901_) == "table") and (_901_["cljlib/type"] == "transient")) then
          error("unsupported transient operation", 2)
        else
          local _ = _901_
          error("expected transient collection", 2)
        end
      end
      return coll
    else
      local _ = _900_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "conj!"))
    end
  end
  v_29_auto = conj_210
  core["conj!"] = v_29_auto
  conj_21 = v_29_auto
end
local assoc_21
do
  local v_29_auto
  local function assoc_210(...)
    local core_43_auto = require("cljlib")
    local _let_904_ = core_43_auto.list(...)
    local map0 = _let_904_[1]
    local k = _let_904_[2]
    local ks = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_904_, 3)
    do
      local _905_ = getmetatable(map0)
      if ((_G.type(_905_) == "table") and (_905_["cljlib/type"] == "transient") and (nil ~= _905_["cljlib/dissoc!"])) then
        local f = _905_["cljlib/dissoc!"]
        apply(f, map0, k, ks)
      elseif ((_G.type(_905_) == "table") and (_905_["cljlib/type"] == "transient")) then
        error("unsupported transient operation", 2)
      else
        local _ = _905_
        error("expected transient collection", 2)
      end
    end
    return map0
  end
  v_29_auto = assoc_210
  core["assoc!"] = v_29_auto
  assoc_21 = v_29_auto
end
local dissoc_21
do
  local v_29_auto
  local function dissoc_210(...)
    local core_43_auto = require("cljlib")
    local _let_907_ = core_43_auto.list(...)
    local map0 = _let_907_[1]
    local k = _let_907_[2]
    local ks = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_907_, 3)
    do
      local _908_ = getmetatable(map0)
      if ((_G.type(_908_) == "table") and (_908_["cljlib/type"] == "transient") and (nil ~= _908_["cljlib/dissoc!"])) then
        local f = _908_["cljlib/dissoc!"]
        apply(f, map0, k, ks)
      elseif ((_G.type(_908_) == "table") and (_908_["cljlib/type"] == "transient")) then
        error("unsupported transient operation", 2)
      else
        local _ = _908_
        error("expected transient collection", 2)
      end
    end
    return map0
  end
  v_29_auto = dissoc_210
  core["dissoc!"] = v_29_auto
  dissoc_21 = v_29_auto
end
local disj_21
do
  local v_29_auto
  local function disj_210(...)
    local _910_ = select("#", ...)
    if (_910_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "disj!"))
    elseif (_910_ == 1) then
      local Set = ...
      return Set
    else
      local _ = _910_
      local core_43_auto = require("cljlib")
      local _let_911_ = core_43_auto.list(...)
      local Set = _let_911_[1]
      local key = _let_911_[2]
      local ks = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_911_, 3)
      local _912_ = getmetatable(Set)
      if ((_G.type(_912_) == "table") and (_912_["cljlib/type"] == "transient") and (nil ~= _912_["cljlib/disj!"])) then
        local f = _912_["cljlib/disj!"]
        return apply(f, Set, key, ks)
      elseif ((_G.type(_912_) == "table") and (_912_["cljlib/type"] == "transient")) then
        return error("unsupported transient operation", 2)
      else
        local _0 = _912_
        return error("expected transient collection", 2)
      end
    end
  end
  v_29_auto = disj_210
  core["disj!"] = v_29_auto
  disj_21 = v_29_auto
end
local pop_21
do
  local v_29_auto
  local function pop_210(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "pop!"))
      else
      end
    end
    local _916_ = getmetatable(coll)
    if ((_G.type(_916_) == "table") and (_916_["cljlib/type"] == "transient") and (nil ~= _916_["cljlib/pop!"])) then
      local f = _916_["cljlib/pop!"]
      return f(coll)
    elseif ((_G.type(_916_) == "table") and (_916_["cljlib/type"] == "transient")) then
      return error("unsupported transient operation", 2)
    else
      local _ = _916_
      return error("expected transient collection", 2)
    end
  end
  v_29_auto = pop_210
  core["pop!"] = v_29_auto
  pop_21 = v_29_auto
end
local persistent_21
do
  local v_29_auto
  local function persistent_210(...)
    local coll = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "persistent!"))
      else
      end
    end
    local _919_ = getmetatable(coll)
    if ((_G.type(_919_) == "table") and (_919_["cljlib/type"] == "transient") and (nil ~= _919_["cljlib/persistent!"])) then
      local f = _919_["cljlib/persistent!"]
      return f(coll)
    else
      local _ = _919_
      return error("expected transient collection", 2)
    end
  end
  v_29_auto = persistent_210
  core["persistent!"] = v_29_auto
  persistent_21 = v_29_auto
end
local into
do
  local v_29_auto
  local function into0(...)
    local _921_ = select("#", ...)
    if (_921_ == 0) then
      return vector()
    elseif (_921_ == 1) then
      local to = ...
      return to
    elseif (_921_ == 2) then
      local to, from = ...
      local _922_ = getmetatable(to)
      if ((_G.type(_922_) == "table") and (_922_["cljlib/editable"] == true)) then
        return persistent_21(reduce(conj_21, transient(to), from))
      else
        local _ = _922_
        return reduce(conj, to, from)
      end
    elseif (_921_ == 3) then
      local to, xform, from = ...
      local _924_ = getmetatable(to)
      if ((_G.type(_924_) == "table") and (_924_["cljlib/editable"] == true)) then
        return persistent_21(transduce(xform, conj_21, transient(to), from))
      else
        local _ = _924_
        return transduce(xform, conj, to, from)
      end
    else
      local _ = _921_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "into"))
    end
  end
  v_29_auto = into0
  core["into"] = v_29_auto
  into = v_29_auto
end
local function viewset(Set, view, inspector, indent)
  if inspector.seen[Set] then
    return ("@set" .. inspector.seen[Set] .. "{...}")
  else
    local prefix
    local function _927_()
      if inspector["visible-cycle?"](Set) then
        return inspector.seen[Set]
      else
        return ""
      end
    end
    prefix = ("@set" .. _927_() .. "{")
    local set_indent = #prefix
    local indent_str = string.rep(" ", set_indent)
    local lines
    do
      local tbl_19_auto = {}
      local i_20_auto = 0
      for v in pairs_2a(Set) do
        local val_21_auto = (indent_str .. view(v, inspector, (indent + set_indent), true))
        if (nil ~= val_21_auto) then
          i_20_auto = (i_20_auto + 1)
          do end (tbl_19_auto)[i_20_auto] = val_21_auto
        else
        end
      end
      lines = tbl_19_auto
    end
    lines[1] = (prefix .. string.gsub((lines[1] or ""), "^%s+", ""))
    do end (lines)[#lines] = (lines[#lines] .. "}")
    return lines
  end
end
local function hash_set__3etransient(immutable)
  local function _930_(hset)
    local removed = setmetatable({}, {__index = deep_index})
    local function _931_(_, k)
      if not removed[k] then
        return hset[k]
      else
        return nil
      end
    end
    local function _933_()
      return error("can't `conj` onto transient set, use `conj!`")
    end
    local function _934_()
      return error("can't `disj` a transient set, use `disj!`")
    end
    local function _935_()
      return error("can't `assoc` onto transient set, use `assoc!`")
    end
    local function _936_()
      return error("can't `dissoc` onto transient set, use `dissoc!`")
    end
    local function _937_(thset, v)
      if (nil == v) then
        removed[v] = true
      else
        removed[v] = nil
      end
      thset[v] = v
      return thset
    end
    local function _939_()
      return error("can't `dissoc!` a transient set")
    end
    local function _940_(thset, ...)
      for i = 1, select("#", ...) do
        local k = select(i, ...)
        do end (thset)[k] = nil
        removed[k] = true
      end
      return thset
    end
    local function _941_(thset)
      local t
      do
        local tbl_14_auto
        do
          local tbl_14_auto0 = {}
          for k, v in pairs(hset) do
            local k_15_auto, v_16_auto = k, v
            if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
              tbl_14_auto0[k_15_auto] = v_16_auto
            else
            end
          end
          tbl_14_auto = tbl_14_auto0
        end
        for k, v in pairs(thset) do
          local k_15_auto, v_16_auto = k, v
          if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
            tbl_14_auto[k_15_auto] = v_16_auto
          else
          end
        end
        t = tbl_14_auto
      end
      for k in pairs(removed) do
        t[k] = nil
      end
      local function _944_()
        local tbl_19_auto = {}
        local i_20_auto = 0
        for k in pairs_2a(thset) do
          local val_21_auto = k
          if (nil ~= val_21_auto) then
            i_20_auto = (i_20_auto + 1)
            do end (tbl_19_auto)[i_20_auto] = val_21_auto
          else
          end
        end
        return tbl_19_auto
      end
      for _, k in ipairs(_944_()) do
        thset[k] = nil
      end
      local function _946_()
        return error("attempt to use transient after it was persistet")
      end
      local function _947_()
        return error("attempt to use transient after it was persistet")
      end
      setmetatable(thset, {__index = _946_, __newindex = _947_})
      return immutable(itable(t))
    end
    return setmetatable({}, {__index = _931_, ["cljlib/type"] = "transient", ["cljlib/conj"] = _933_, ["cljlib/disj"] = _934_, ["cljlib/assoc"] = _935_, ["cljlib/dissoc"] = _936_, ["cljlib/conj!"] = _937_, ["cljlib/assoc!"] = _939_, ["cljlib/disj!"] = _940_, ["cljlib/persistent!"] = _941_})
  end
  return _930_
end
local function hash_set_2a(x)
  do
    local _948_ = getmetatable(x)
    if (nil ~= _948_) then
      local mt = _948_
      mt["cljlib/type"] = "hash-set"
      local function _949_(s, v, ...)
        local function _950_(...)
          local res = {}
          for _, v0 in ipairs({...}) do
            table.insert(res, v0)
            table.insert(res, v0)
          end
          return res
        end
        return hash_set_2a(itable.assoc(s, v, v, unpack_2a(_950_(...))))
      end
      mt["cljlib/conj"] = _949_
      local function _951_(s, k, ...)
        local to_remove
        do
          local tbl_14_auto = setmetatable({[k] = true}, {__index = deep_index})
          for _, k0 in ipairs({...}) do
            local k_15_auto, v_16_auto = k0, true
            if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
              tbl_14_auto[k_15_auto] = v_16_auto
            else
            end
          end
          to_remove = tbl_14_auto
        end
        local function _953_(...)
          local res = {}
          for _, v in pairs(s) do
            if not to_remove[v] then
              table.insert(res, v)
              table.insert(res, v)
            else
            end
          end
          return res
        end
        return hash_set_2a(itable.assoc({}, unpack_2a(_953_(...))))
      end
      mt["cljlib/disj"] = _951_
      local function _955_()
        return hash_set_2a(itable({}))
      end
      mt["cljlib/empty"] = _955_
      mt["cljlib/editable"] = true
      mt["cljlib/transient"] = hash_set__3etransient(hash_set_2a)
      local function _956_(s)
        local function _957_(_241)
          if vector_3f(_241) then
            return _241[1]
          else
            return _241
          end
        end
        return map(_957_, s)
      end
      mt["cljlib/seq"] = _956_
      mt["__fennelview"] = viewset
      local function _959_(s, i)
        local j = 1
        local vals0 = {}
        for v in pairs_2a(s) do
          if (j >= i) then
            table.insert(vals0, v)
          else
            j = (j + 1)
          end
        end
        return core["hash-set"](unpack_2a(vals0))
      end
      mt["__fennelrest"] = _959_
    else
      local _ = _948_
      hash_set_2a(setmetatable(x, {}))
    end
  end
  return x
end
local hash_set
do
  local v_29_auto
  local function hash_set0(...)
    local core_43_auto = require("cljlib")
    local _let_962_ = core_43_auto.list(...)
    local xs = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_962_, 1)
    local Set
    do
      local tbl_14_auto = setmetatable({}, {__newindex = deep_newindex})
      for _, val in pairs_2a(xs) do
        local k_15_auto, v_16_auto = val, val
        if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
          tbl_14_auto[k_15_auto] = v_16_auto
        else
        end
      end
      Set = tbl_14_auto
    end
    return hash_set_2a(itable(Set))
  end
  v_29_auto = hash_set0
  core["hash-set"] = v_29_auto
  hash_set = v_29_auto
end
local multifn_3f
do
  local v_29_auto
  local function multifn_3f0(...)
    local mf = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "multifn?"))
      else
      end
    end
    local _965_ = getmetatable(mf)
    if ((_G.type(_965_) == "table") and (_965_["cljlib/type"] == "multifn")) then
      return true
    else
      local _ = _965_
      return false
    end
  end
  v_29_auto = multifn_3f0
  core["multifn?"] = v_29_auto
  multifn_3f = v_29_auto
end
local remove_method
do
  local v_29_auto
  local function remove_method0(...)
    local multimethod, dispatch_value = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "remove-method"))
      else
      end
    end
    if multifn_3f(multimethod) then
      multimethod[dispatch_value] = nil
    else
      error((tostring(multimethod) .. " is not a multifn"), 2)
    end
    return multimethod
  end
  v_29_auto = remove_method0
  core["remove-method"] = v_29_auto
  remove_method = v_29_auto
end
local remove_all_methods
do
  local v_29_auto
  local function remove_all_methods0(...)
    local multimethod = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "remove-all-methods"))
      else
      end
    end
    if multifn_3f(multimethod) then
      for k, _ in pairs(multimethod) do
        multimethod[k] = nil
      end
    else
      error((tostring(multimethod) .. " is not a multifn"), 2)
    end
    return multimethod
  end
  v_29_auto = remove_all_methods0
  core["remove-all-methods"] = v_29_auto
  remove_all_methods = v_29_auto
end
local methods
do
  local v_29_auto
  local function methods0(...)
    local multimethod = ...
    do
      local cnt_61_auto = select("#", ...)
      if (1 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "methods"))
      else
      end
    end
    if multifn_3f(multimethod) then
      local m = {}
      for k, v in pairs(multimethod) do
        m[k] = v
      end
      return m
    else
      return error((tostring(multimethod) .. " is not a multifn"), 2)
    end
  end
  v_29_auto = methods0
  core["methods"] = v_29_auto
  methods = v_29_auto
end
local get_method
do
  local v_29_auto
  local function get_method0(...)
    local multimethod, dispatch_value = ...
    do
      local cnt_61_auto = select("#", ...)
      if (2 ~= cnt_61_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_61_auto, "get-method"))
      else
      end
    end
    if multifn_3f(multimethod) then
      return (multimethod[dispatch_value] or multimethod.default)
    else
      return error((tostring(multimethod) .. " is not a multifn"), 2)
    end
  end
  v_29_auto = get_method0
  core["get-method"] = v_29_auto
  get_method = v_29_auto
end
return core
