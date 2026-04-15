local or_1_ = package.preload.reduced
if not or_1_ then
  local function _2_()
    local Reduced
    local function _4_(_3_, view, options, indent)
      local x = _3_[1]
      return ("#<reduced: " .. view(x, options, (11 + indent)) .. ">")
    end
    local function _6_(_5_)
      local x = _5_[1]
      return x
    end
    local function _8_(_7_)
      local x = _7_[1]
      return ("reduced: " .. tostring(x))
    end
    Reduced = {__fennelview = _4_, __index = {unbox = _6_}, __name = "reduced", __tostring = _8_}
    local function reduced(value)
      return setmetatable({value}, Reduced)
    end
    local function reduced_3f(value)
      return rawequal(getmetatable(value), Reduced)
    end
    return {is_reduced = reduced_3f, reduced = reduced, ["reduced?"] = reduced_3f}
  end
  or_1_ = _2_
end
package.preload.reduced = or_1_
local or_9_ = package.preload.itable
if not or_9_ then
  local function _10_()
    local t_2fsort = table.sort
    local t_2fconcat = table.concat
    local t_2fremove = table.remove
    local t_2fmove = table.move
    local t_2finsert = table.insert
    local t_2funpack = (table.unpack or _G.unpack)
    local t_2fpack
    local function _11_(...)
      local tmp_9_ = {...}
      tmp_9_["n"] = select("#", ...)
      return tmp_9_
    end
    t_2fpack = _11_
    local function pairs_2a(t)
      local _13_
      do
        local case_12_ = getmetatable(t)
        if ((_G.type(case_12_) == "table") and (nil ~= case_12_.__pairs)) then
          local p = case_12_.__pairs
          _13_ = p
        else
          local _ = case_12_
          _13_ = pairs
        end
      end
      return _13_(t)
    end
    local function ipairs_2a(t)
      local _18_
      do
        local case_17_ = getmetatable(t)
        if ((_G.type(case_17_) == "table") and (nil ~= case_17_.__ipairs)) then
          local i = case_17_.__ipairs
          _18_ = i
        else
          local _ = case_17_
          _18_ = ipairs
        end
      end
      return _18_(t)
    end
    local function length_2a(t)
      local _23_
      do
        local case_22_ = getmetatable(t)
        if ((_G.type(case_22_) == "table") and (nil ~= case_22_.__len)) then
          local l = case_22_.__len
          _23_ = l
        else
          local _ = case_22_
          local function _26_(...)
            return #...
          end
          _23_ = _26_
        end
      end
      return _23_(t)
    end
    local function copy(t)
      if t then
        local tbl_21_ = {}
        for k, v in pairs_2a(t) do
          local k_22_, v_23_ = k, v
          if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
            tbl_21_[k_22_] = v_23_
          else
          end
        end
        return tbl_21_
      else
        return nil
      end
    end
    local function eq(...)
      local case_30_, case_31_, case_32_ = select("#", ...), ...
      if ((case_30_ == 0) or (case_30_ == 1)) then
        return true
      elseif ((case_30_ == 2) and true and true) then
        local _3fa = case_31_
        local _3fb = case_32_
        if (_3fa == _3fb) then
          return true
        else
          local _33_ = type(_3fb)
          if ((type(_3fa) == _33_) and (_33_ == "table")) then
            local res, count_a, count_b = true, 0, 0
            for k, v in pairs_2a(_3fa) do
              if not res then break end
              local function _34_(...)
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
              res = eq(v, _34_(...))
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
        end
      elseif (true and true and true) then
        local _ = case_30_
        local _3fa = case_31_
        local _3fb = case_32_
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
      local function _44_()
        return len
      end
      __len = _44_
      local __index
      local function _45_(_241, _242)
        return t0[_242]
      end
      __index = _45_
      local __newindex
      local function _46_()
        return error((tostring(proxy) .. " is immutable"), 2)
      end
      __newindex = _46_
      local __pairs
      local function _47_()
        local function _48_(_, k)
          return next(t0, k)
        end
        return _48_, nil, nil
      end
      __pairs = _47_
      local __ipairs
      local function _49_()
        local function _50_(_, k)
          return next(t0, k)
        end
        return _50_
      end
      __ipairs = _49_
      local __call
      local function _51_(_241, _242)
        return t0[_242]
      end
      __call = _51_
      local __fennelview
      local function _52_(_241, _242, _243, _244)
        return _242(t0, _243, _244)
      end
      __fennelview = _52_
      local __fennelrest
      local function _53_(_241, _242)
        return immutable({t_2funpack(t0, _242)})
      end
      __fennelrest = _53_
      return setmetatable(proxy, {__index = __index, __newindex = __newindex, __len = __len, __pairs = __pairs, __ipairs = __ipairs, __call = __call, __metatable = {__len = __len, __pairs = __pairs, __ipairs = __ipairs, __call = __call, __fennelrest = __fennelrest, __fennelview = __fennelview, ["itable/type"] = "immutable"}})
    end
    local function insert(t, ...)
      local t0 = copy(t)
      do
        local case_54_, case_55_, case_56_ = select("#", ...), ...
        if (case_54_ == 0) then
          error("wrong number of arguments to 'insert'")
        elseif ((case_54_ == 1) and true) then
          local _3fv = case_55_
          t_2finsert(t0, _3fv)
        elseif (true and true and true) then
          local _ = case_54_
          local _3fk = case_55_
          local _3fv = case_56_
          t_2finsert(t0, _3fk, _3fv)
        else
        end
      end
      return immutable(t0)
    end
    local move
    if t_2fmove then
      local function _58_(src, start, _end, tgt, dest)
        local src0 = copy(src)
        local dest0 = copy(dest)
        return immutable(t_2fmove(src0, start, _end, tgt, dest0))
      end
      move = _58_
    else
      move = nil
    end
    local function pack(...)
      local function _60_(...)
        local tmp_9_ = {...}
        tmp_9_["n"] = select("#", ...)
        return tmp_9_
      end
      return immutable(_60_(...))
    end
    local function remove(t, key)
      local t0 = copy(t)
      local v = t_2fremove(t0, key)
      return immutable(t0), v
    end
    local function concat(t, sep, start, _end, serializer, opts)
      local serializer0 = (serializer or tostring)
      local _61_
      do
        local tbl_26_ = {}
        local i_27_ = 0
        for _, v in ipairs_2a(t) do
          local val_28_ = serializer0(v, opts)
          if (nil ~= val_28_) then
            i_27_ = (i_27_ + 1)
            tbl_26_[i_27_] = val_28_
          else
          end
        end
        _61_ = tbl_26_
      end
      return t_2fconcat(_61_, sep, start, _end)
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
        local tmp_9_ = copy(t)
        tmp_9_[key] = val
        t0 = tmp_9_
      end
      for i = 1, len, 2 do
        local k, v = select(i, ...)
        t0[k] = v
      end
      return immutable(t0)
    end
    local function assoc_in(t, _64_, val)
      local k = _64_[1]
      local ks = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_64_, 2)
      local t0 = (t or {})
      if next(ks) then
        return assoc(t0, k, assoc_in((t0[k] or {}), ks, val))
      else
        return assoc(t0, k, val)
      end
    end
    local function update(t, key, f)
      local function _66_()
        local tmp_9_ = copy(t)
        tmp_9_[key] = f(t[key])
        return tmp_9_
      end
      return immutable(_66_())
    end
    local function update_in(t, _67_, f)
      local k = _67_[1]
      local ks = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_67_, 2)
      local t0 = (t or {})
      if next(ks) then
        return assoc(t0, k, update_in(t0[k], ks, f))
      else
        return update(t0, k, f)
      end
    end
    local function deepcopy(x)
      local function deepcopy_2a(x0, seen)
        local case_69_ = type(x0)
        if (case_69_ == "table") then
          local case_70_ = seen[x0]
          if (case_70_ == true) then
            return error("immutable tables can't contain self reference", 2)
          else
            local _ = case_70_
            seen[x0] = true
            local function _71_()
              local tbl_21_ = {}
              for k, v in pairs_2a(x0) do
                local k_22_, v_23_ = deepcopy_2a(k, seen), deepcopy_2a(v, seen)
                if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
                  tbl_21_[k_22_] = v_23_
                else
                end
              end
              return tbl_21_
            end
            return immutable(_71_())
          end
        else
          local _ = case_69_
          return x0
        end
      end
      return deepcopy_2a(x, {})
    end
    local function first(_75_)
      local x = _75_[1]
      return x
    end
    local function rest(t)
      return (remove(t, 1))
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
      return (remove(t, length_2a(t)))
    end
    local function join(...)
      local case_76_, case_77_, case_78_ = select("#", ...), ...
      if (case_76_ == 0) then
        return nil
      elseif ((case_76_ == 1) and true) then
        local _3ft = case_77_
        return immutable(copy(_3ft))
      elseif ((case_76_ == 2) and true and true) then
        local _3ft1 = case_77_
        local _3ft2 = case_78_
        local to = copy(_3ft1)
        local from = (_3ft2 or {})
        for _, v in ipairs_2a(from) do
          t_2finsert(to, v)
        end
        return immutable(to)
      elseif (true and true and true) then
        local _ = case_76_
        local _3ft1 = case_77_
        local _3ft2 = case_78_
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
        local case_80_, case_81_, case_82_, case_83_, case_84_ = select("#", ...), ...
        if ((case_80_ == 0) or (case_80_ == 1)) then
          return error("wrong amount arguments to 'partition'")
        elseif ((case_80_ == 2) and true and true) then
          local _3fn = case_81_
          local _3ft = case_82_
          return partition_2a(_3fn, _3fn, _3ft)
        elseif ((case_80_ == 3) and true and true and true) then
          local _3fn = case_81_
          local _3fstep = case_82_
          local _3ft = case_83_
          local p = take(_3fn, _3ft)
          if (_3fn == length_2a(p)) then
            t_2finsert(res, p)
            return partition_2a(_3fn, _3fstep, {t_2funpack(_3ft, (_3fstep + 1))})
          else
            return nil
          end
        elseif (true and true and true and true and true) then
          local _ = case_80_
          local _3fn = case_81_
          local _3fstep = case_82_
          local _3fpad = case_83_
          local _3ft = case_84_
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
      local function _88_()
        local tbl_26_ = {}
        local i_27_ = 0
        for k, _ in pairs_2a(t) do
          local val_28_ = k
          if (nil ~= val_28_) then
            i_27_ = (i_27_ + 1)
            tbl_26_[i_27_] = val_28_
          else
          end
        end
        return tbl_26_
      end
      return immutable(_88_())
    end
    local function vals(t)
      local function _90_()
        local tbl_26_ = {}
        local i_27_ = 0
        for _, v in pairs_2a(t) do
          local val_28_ = v
          if (nil ~= val_28_) then
            i_27_ = (i_27_ + 1)
            tbl_26_[i_27_] = val_28_
          else
          end
        end
        return tbl_26_
      end
      return immutable(_90_())
    end
    local function group_by(f, t)
      local res = {}
      local ungroupped = {}
      for _, v in pairs_2a(t) do
        local k = f(v)
        if (nil ~= k) then
          local case_92_ = res[k]
          if (nil ~= case_92_) then
            local t_2a = case_92_
            t_2finsert(t_2a, v)
          else
            local _0 = case_92_
            res[k] = {v}
          end
        else
          t_2finsert(ungroupped, v)
        end
      end
      local function _95_()
        local tbl_21_ = {}
        for k, t0 in pairs_2a(res) do
          local k_22_, v_23_ = k, immutable(t0)
          if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
            tbl_21_[k_22_] = v_23_
          else
          end
        end
        return tbl_21_
      end
      return immutable(_95_()), immutable(ungroupped)
    end
    local function frequencies(t)
      local res = setmetatable({}, {__index = deep_index, __newindex = deep_newindex})
      for _, v in pairs_2a(t) do
        local case_97_ = res[v]
        if (nil ~= case_97_) then
          local a = case_97_
          res[v] = (a + 1)
        else
          local _0 = case_97_
          res[v] = 1
        end
      end
      return immutable(res)
    end
    local itable
    local function _99_(t, f)
      local function _100_()
        local tmp_9_ = copy(t)
        t_2fsort(tmp_9_, f)
        return tmp_9_
      end
      return immutable(_100_())
    end
    itable = {sort = _99_, pack = pack, unpack = unpack, concat = concat, insert = insert, move = move, remove = remove, pairs = pairs_2a, ipairs = ipairs_2a, length = length_2a, eq = eq, deepcopy = deepcopy, assoc = assoc, ["assoc-in"] = assoc_in, update = update, ["update-in"] = update_in, keys = keys, vals = vals, ["group-by"] = group_by, frequencies = frequencies, first = first, rest = rest, nthrest = nthrest, last = last, butlast = butlast, join = join, partition = partition, take = take, drop = drop}
    local function _101_(_, t, opts)
      local case_102_ = getmetatable(t)
      if ((_G.type(case_102_) == "table") and (case_102_["itable/type"] == "immutable")) then
        return t
      else
        local _0 = case_102_
        return immutable(copy(t), opts)
      end
    end
    return setmetatable(itable, {__call = _101_})
  end
  or_9_ = _10_
end
package.preload.itable = or_9_
local or_104_ = package.preload["lazy-seq"]
if not or_104_ then
  local function _105_()
    local or_106_ = package.preload.reduced
    if not or_106_ then
      local function _107_()
        local Reduced
        local function _109_(_108_, view, options, indent)
          local x = _108_[1]
          return ("#<reduced: " .. view(x, options, (11 + indent)) .. ">")
        end
        local function _111_(_110_)
          local x = _110_[1]
          return x
        end
        local function _113_(_112_)
          local x = _112_[1]
          return ("reduced: " .. tostring(x))
        end
        Reduced = {__fennelview = _109_, __index = {unbox = _111_}, __name = "reduced", __tostring = _113_}
        local function reduced(value)
          return setmetatable({value}, Reduced)
        end
        local function reduced_3f(value)
          return rawequal(getmetatable(value), Reduced)
        end
        return {is_reduced = reduced_3f, reduced = reduced, ["reduced?"] = reduced_3f}
      end
      or_106_ = _107_
    end
    package.preload.reduced = or_106_
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
      local tmp_9_ = {...}
      tmp_9_["n"] = select("#", ...)
      return tmp_9_
    end
    local table_unpack = (table.unpack or _G.unpack)
    local seq = nil
    local cons_iter = nil
    local function first(s)
      local case_118_ = seq(s)
      if (nil ~= case_118_) then
        local s_2a = case_118_
        return s_2a(true)
      else
        local _ = case_118_
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
      local case_120_
      do
        local t_121_ = getmetatable(x)
        if (nil ~= t_121_) then
          t_121_ = t_121_["__lazy-seq/type"]
        else
        end
        case_120_ = t_121_
      end
      if (nil ~= case_120_) then
        local t = case_120_
        return t
      else
        local _ = case_120_
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
      local case_126_ = seq(s)
      if (nil ~= case_126_) then
        local s_2a = case_126_
        return s_2a(false)
      else
        local _ = case_126_
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
        local tbl_26_ = {}
        local i_27_ = 0
        for i, line in ipairs(items) do
          local val_28_
          if (i == 1) then
            val_28_ = line
          else
            val_28_ = ("     " .. line)
          end
          if (nil ~= val_28_) then
            i_27_ = (i_27_ + 1)
            tbl_26_[i_27_] = val_28_
          else
          end
        end
        lines = tbl_26_
      end
      lines[1] = ("@seq(" .. (lines[1] or ""))
      lines[#lines] = (lines[#lines] .. ")")
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
        local case_131_ = gettype(tail)
        if (case_131_ == "cons") then
          return tail, first(s)
        else
          local _0 = case_131_
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
      local function _137_(_241, _242)
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
      return setmetatable({}, {__call = _137_, ["__lazy-seq/type"] = "cons", __index = cons_index, __newindex = cons_newindex, __len = cons_len, __pairs = cons_pairs, __name = "cons", __eq = cons_eq, __fennelview = pp_seq, __fennelrest = cons_fennelrest})
    end
    local function _140_(s)
      local case_141_ = gettype(s)
      if (case_141_ == "cons") then
        return s
      elseif (case_141_ == "lazy-cons") then
        return seq(realize(s))
      elseif (case_141_ == "empty-cons") then
        return nil
      elseif (case_141_ == "nil") then
        return nil
      elseif (case_141_ == "table") then
        return cons_iter(s)
      elseif (case_141_ == "string") then
        return cons_iter(s)
      else
        local _ = case_141_
        return error(("expected table, string or sequence, got %s"):format(_), 2)
      end
    end
    seq = _140_
    local function lazy_seq(f)
      local lazy_cons = cons(nil, nil)
      local realize0
      local function _143_()
        local s = seq(f())
        if (nil ~= s) then
          return setmetatable(lazy_cons, getmetatable(s))
        else
          return setmetatable(lazy_cons, getmetatable(empty_cons))
        end
      end
      realize0 = _143_
      local function _145_(_241, _242)
        return realize0()(_242)
      end
      local function _146_(_241, _242)
        return realize0()[_242]
      end
      local function _147_(...)
        realize0()
        return pp_seq(...)
      end
      local function _148_()
        return length_2a(realize0())
      end
      local function _149_()
        return pairs_2a(realize0())
      end
      local function _150_(_241, _242)
        return (realize0() == _242)
      end
      return setmetatable(lazy_cons, {__call = _145_, __index = _146_, __newindex = cons_newindex, __fennelview = _147_, __fennelrest = cons_fennelrest, __len = _148_, __pairs = _149_, __name = "lazy cons", __eq = _150_, ["__lazy-seq/type"] = "lazy-cons"})
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
      local case_152_, case_153_, case_154_, case_155_, case_156_ = select("#", ...), ...
      if ((case_152_ == 1) and true) then
        local _3fargs = case_153_
        return seq(_3fargs)
      elseif ((case_152_ == 2) and true and true) then
        local _3fa = case_153_
        local _3fargs = case_154_
        return cons(_3fa, seq(_3fargs))
      elseif ((case_152_ == 3) and true and true and true) then
        local _3fa = case_153_
        local _3fb = case_154_
        local _3fargs = case_155_
        return cons(_3fa, cons(_3fb, seq(_3fargs)))
      elseif ((case_152_ == 4) and true and true and true and true) then
        local _3fa = case_153_
        local _3fb = case_154_
        local _3fc = case_155_
        local _3fargs = case_156_
        return cons(_3fa, cons(_3fb, cons(_3fc, seq(_3fargs))))
      else
        local _ = case_152_
        return spread(list(...))
      end
    end
    local function kind(t)
      local case_158_ = type(t)
      if (case_158_ == "table") then
        local len = length_2a(t)
        local nxt, t_2a, k = pairs_2a(t)
        local function _159_()
          if (len == 0) then
            return k
          else
            return len
          end
        end
        if (nil ~= nxt(t_2a, _159_())) then
          return "assoc"
        elseif (len > 0) then
          return "seq"
        else
          return "empty"
        end
      elseif (case_158_ == "string") then
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
        local _ = case_158_
        return "else"
      end
    end
    local function rseq(rev)
      local case_164_ = gettype(rev)
      if (case_164_ == "table") then
        local case_165_ = kind(rev)
        if (case_165_ == "seq") then
          local function wrap(nxt, t, i)
            local i0, v = nxt(t, i)
            if (nil ~= i0) then
              local function _166_()
                return wrap(nxt, t, i0)
              end
              return cons(v, lazy_seq(_166_))
            else
              return empty_cons
            end
          end
          return wrap(rev_ipairs(rev))
        elseif (case_165_ == "empty") then
          return nil
        else
          local _ = case_165_
          return error("can't create an rseq from a non-sequential table")
        end
      else
        local _ = case_164_
        return error(("can't create an rseq from a " .. _))
      end
    end
    local function _170_(t)
      local case_171_ = kind(t)
      if (case_171_ == "assoc") then
        local function wrap(nxt, t0, k)
          local k0, v = nxt(t0, k)
          if (nil ~= k0) then
            local function _172_()
              return wrap(nxt, t0, k0)
            end
            return cons({k0, v}, lazy_seq(_172_))
          else
            return empty_cons
          end
        end
        return wrap(pairs_2a(t))
      elseif (case_171_ == "seq") then
        local function wrap(nxt, t0, i)
          local i0, v = nxt(t0, i)
          if (nil ~= i0) then
            local function _174_()
              return wrap(nxt, t0, i0)
            end
            return cons(v, lazy_seq(_174_))
          else
            return empty_cons
          end
        end
        return wrap(ipairs_2a(t))
      elseif (case_171_ == "string") then
        local char
        if utf8 then
          char = utf8.char
        else
          char = string.char
        end
        local function wrap(nxt, t0, i)
          local i0, v = nxt(t0, i)
          if (nil ~= i0) then
            local function _177_()
              return wrap(nxt, t0, i0)
            end
            return cons(char(v), lazy_seq(_177_))
          else
            return empty_cons
          end
        end
        local function _179_()
          if utf8 then
            return utf8.codes(t)
          else
            return ipairs_2a({string.byte(t, 1, #t)})
          end
        end
        return wrap(_179_())
      elseif (case_171_ == "empty") then
        return nil
      else
        return nil
      end
    end
    cons_iter = _170_
    local function every_3f(pred, coll)
      local case_181_ = seq(coll)
      if (nil ~= case_181_) then
        local s = case_181_
        if pred(first(s)) then
          local case_182_ = next(s)
          if (nil ~= case_182_) then
            local r = case_182_
            return every_3f(pred, r)
          else
            local _ = case_182_
            return true
          end
        else
          return false
        end
      else
        local _ = case_181_
        return false
      end
    end
    local function some_3f(pred, coll)
      local case_186_ = seq(coll)
      if (nil ~= case_186_) then
        local s = case_186_
        local or_187_ = pred(first(s))
        if not or_187_ then
          local case_188_ = next(s)
          if (nil ~= case_188_) then
            local r = case_188_
            or_187_ = some_3f(pred, r)
          else
            local _ = case_188_
            or_187_ = nil
          end
        end
        return or_187_
      else
        local _ = case_186_
        return nil
      end
    end
    local function pack(s)
      local res = {}
      local n = 0
      do
        local case_194_ = seq(s)
        if (nil ~= case_194_) then
          local s_2a = case_194_
          for _, v in pairs_2a(s_2a) do
            n = (n + 1)
            res[n] = v
          end
        else
        end
      end
      res["n"] = n
      return res
    end
    local function count(s)
      local case_196_ = seq(s)
      if (nil ~= case_196_) then
        local s_2a = case_196_
        return length_2a(s_2a)
      else
        local _ = case_196_
        return 0
      end
    end
    local function unpack(s)
      local t = pack(s)
      return table_unpack(t, 1, t.n)
    end
    local function concat(...)
      local case_198_ = select("#", ...)
      if (case_198_ == 0) then
        return empty_cons
      elseif (case_198_ == 1) then
        local x = ...
        local function _199_()
          return x
        end
        return lazy_seq(_199_)
      elseif (case_198_ == 2) then
        local x, y = ...
        local function _200_()
          local case_201_ = seq(x)
          if (nil ~= case_201_) then
            local s = case_201_
            return cons(first(s), concat(rest(s), y))
          elseif (case_201_ == nil) then
            return y
          else
            return nil
          end
        end
        return lazy_seq(_200_)
      else
        local _ = case_198_
        local pv_203_, pv_204_ = ...
        return concat(concat(pv_203_, pv_204_), select(3, ...))
      end
    end
    local function reverse(s)
      local function helper(s0, res)
        local case_206_ = seq(s0)
        if (nil ~= case_206_) then
          local s_2a = case_206_
          return helper(rest(s_2a), cons(first(s_2a), res))
        else
          local _ = case_206_
          return res
        end
      end
      return helper(s, empty_cons)
    end
    local function map(f, ...)
      local case_208_ = select("#", ...)
      if (case_208_ == 0) then
        return nil
      elseif (case_208_ == 1) then
        local col = ...
        local function _209_()
          local case_210_ = seq(col)
          if (nil ~= case_210_) then
            local x = case_210_
            return cons(f(first(x)), map(f, seq(rest(x))))
          else
            local _ = case_210_
            return nil
          end
        end
        return lazy_seq(_209_)
      elseif (case_208_ == 2) then
        local s1, s2 = ...
        local function _212_()
          local s10 = seq(s1)
          local s20 = seq(s2)
          if (s10 and s20) then
            return cons(f(first(s10), first(s20)), map(f, rest(s10), rest(s20)))
          else
            return nil
          end
        end
        return lazy_seq(_212_)
      elseif (case_208_ == 3) then
        local s1, s2, s3 = ...
        local function _214_()
          local s10 = seq(s1)
          local s20 = seq(s2)
          local s30 = seq(s3)
          if (s10 and s20 and s30) then
            return cons(f(first(s10), first(s20), first(s30)), map(f, rest(s10), rest(s20), rest(s30)))
          else
            return nil
          end
        end
        return lazy_seq(_214_)
      else
        local _ = case_208_
        local s = list(...)
        local function _216_()
          local function _217_(_2410)
            return (nil ~= seq(_2410))
          end
          if every_3f(_217_, s) then
            return cons(f(unpack(map(first, s))), map(f, unpack(map(rest, s))))
          else
            return nil
          end
        end
        return lazy_seq(_216_)
      end
    end
    local function map_indexed(f, coll)
      local mapi
      local function mapi0(idx, coll0)
        local function _220_()
          local case_221_ = seq(coll0)
          if (nil ~= case_221_) then
            local s = case_221_
            return cons(f(idx, first(s)), mapi0((idx + 1), rest(s)))
          else
            local _ = case_221_
            return nil
          end
        end
        return lazy_seq(_220_)
      end
      mapi = mapi0
      return mapi(1, coll)
    end
    local function mapcat(f, ...)
      local step
      local function step0(colls)
        local function _223_()
          local case_224_ = seq(colls)
          if (nil ~= case_224_) then
            local s = case_224_
            local c = first(s)
            return concat(c, step0(rest(colls)))
          else
            local _ = case_224_
            return nil
          end
        end
        return lazy_seq(_223_)
      end
      step = step0
      return step(map(f, ...))
    end
    local function take(n, coll)
      local function _226_()
        if (n > 0) then
          local case_227_ = seq(coll)
          if (nil ~= case_227_) then
            local s = case_227_
            return cons(first(s), take((n - 1), rest(s)))
          else
            local _ = case_227_
            return nil
          end
        else
          return nil
        end
      end
      return lazy_seq(_226_)
    end
    local function take_while(pred, coll)
      local function _230_()
        local case_231_ = seq(coll)
        if (nil ~= case_231_) then
          local s = case_231_
          local v = first(s)
          if pred(v) then
            return cons(v, take_while(pred, rest(s)))
          else
            return nil
          end
        else
          local _ = case_231_
          return nil
        end
      end
      return lazy_seq(_230_)
    end
    local function _234_(n, coll)
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
      local function _236_()
        return step(n, coll)
      end
      return lazy_seq(_236_)
    end
    drop = _234_
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
      local function _238_()
        return step(pred, coll)
      end
      return lazy_seq(_238_)
    end
    local function drop_last(...)
      local case_239_ = select("#", ...)
      if (case_239_ == 0) then
        return empty_cons
      elseif (case_239_ == 1) then
        return drop_last(1, ...)
      else
        local _ = case_239_
        local n, coll = ...
        local function _240_(x)
          return x
        end
        return map(_240_, coll, drop(n, coll))
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
      local function _243_()
        local case_244_ = seq(coll)
        if (nil ~= case_244_) then
          local s = case_244_
          return cons(first(s), take_nth(n, drop(n, s)))
        else
          return nil
        end
      end
      return lazy_seq(_243_)
    end
    local function split_at(n, coll)
      return {take(n, coll), drop(n, coll)}
    end
    local function split_with(pred, coll)
      return {take_while(pred, coll), drop_while(pred, coll)}
    end
    local function filter(pred, coll)
      local function _246_()
        local case_247_ = seq(coll)
        if (nil ~= case_247_) then
          local s = case_247_
          local x = first(s)
          local r = rest(s)
          if pred(x) then
            return cons(x, filter(pred, r))
          else
            return filter(pred, r)
          end
        else
          local _ = case_247_
          return nil
        end
      end
      return lazy_seq(_246_)
    end
    local function keep(f, coll)
      local function _250_()
        local case_251_ = seq(coll)
        if (nil ~= case_251_) then
          local s = case_251_
          local case_252_ = f(first(s))
          if (nil ~= case_252_) then
            local x = case_252_
            return cons(x, keep(f, rest(s)))
          elseif (case_252_ == nil) then
            return keep(f, rest(s))
          else
            return nil
          end
        else
          local _ = case_251_
          return nil
        end
      end
      return lazy_seq(_250_)
    end
    local function keep_indexed(f, coll)
      local keepi
      local function keepi0(idx, coll0)
        local function _255_()
          local case_256_ = seq(coll0)
          if (nil ~= case_256_) then
            local s = case_256_
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
        return lazy_seq(_255_)
      end
      keepi = keepi0
      return keepi(1, coll)
    end
    local function remove(pred, coll)
      local function _259_(_241)
        return not pred(_241)
      end
      return filter(_259_, coll)
    end
    local function cycle(coll)
      local function _260_()
        return concat(seq(coll), cycle(coll))
      end
      return lazy_seq(_260_)
    end
    local function _repeat(x)
      local function step(x0)
        local function _261_()
          return cons(x0, step(x0))
        end
        return lazy_seq(_261_)
      end
      return step(x)
    end
    local function repeatedly(f, ...)
      local args = table_pack(...)
      local f0
      local function _262_()
        return f(table_unpack(args, 1, args.n))
      end
      f0 = _262_
      local function step(f1)
        local function _263_()
          return cons(f1(), step(f1))
        end
        return lazy_seq(_263_)
      end
      return step(f0)
    end
    local function iterate(f, x)
      local x_2a = f(x)
      local function _264_()
        return iterate(f, x_2a)
      end
      return cons(x, lazy_seq(_264_))
    end
    local function nthnext(coll, n)
      local function loop(n0, xs)
        local and_265_ = (nil ~= xs)
        if and_265_ then
          local xs_2a = xs
          and_265_ = (n0 > 0)
        end
        if and_265_ then
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
        local case_268_ = seq(xs)
        local and_269_ = (nil ~= case_268_)
        if and_269_ then
          local xs_2a = case_268_
          and_269_ = (n0 > 0)
        end
        if and_269_ then
          local xs_2a = case_268_
          return loop((n0 - 1), rest(xs_2a))
        else
          local _ = case_268_
          return xs
        end
      end
      return loop(n, coll)
    end
    local function dorun(s)
      local case_272_ = seq(s)
      if (nil ~= case_272_) then
        local s_2a = case_272_
        return dorun(next(s_2a))
      else
        local _ = case_272_
        return nil
      end
    end
    local function doall(s)
      dorun(s)
      return s
    end
    local function partition(...)
      local case_274_ = select("#", ...)
      if (case_274_ == 2) then
        local n, coll = ...
        return partition(n, n, coll)
      elseif (case_274_ == 3) then
        local n, step, coll = ...
        local function _275_()
          local case_276_ = seq(coll)
          if (nil ~= case_276_) then
            local s = case_276_
            local p = take(n, s)
            if (n == length_2a(p)) then
              return cons(p, partition(n, step, nthrest(s, step)))
            else
              return nil
            end
          else
            local _ = case_276_
            return nil
          end
        end
        return lazy_seq(_275_)
      elseif (case_274_ == 4) then
        local n, step, pad, coll = ...
        local function _279_()
          local case_280_ = seq(coll)
          if (nil ~= case_280_) then
            local s = case_280_
            local p = take(n, s)
            if (n == length_2a(p)) then
              return cons(p, partition(n, step, pad, nthrest(s, step)))
            else
              return list(take(n, concat(p, pad)))
            end
          else
            local _ = case_280_
            return nil
          end
        end
        return lazy_seq(_279_)
      else
        local _ = case_274_
        return error("wrong amount arguments to 'partition'")
      end
    end
    local function partition_by(f, coll)
      local function _284_()
        local case_285_ = seq(coll)
        if (nil ~= case_285_) then
          local s = case_285_
          local v = first(s)
          local fv = f(v)
          local run
          local function _286_(_2410)
            return (fv == f(_2410))
          end
          run = cons(v, take_while(_286_, next(s)))
          local function _287_()
            return drop(length_2a(run), s)
          end
          return cons(run, partition_by(f, lazy_seq(_287_)))
        else
          return nil
        end
      end
      return lazy_seq(_284_)
    end
    local function partition_all(...)
      local case_289_ = select("#", ...)
      if (case_289_ == 2) then
        local n, coll = ...
        return partition_all(n, n, coll)
      elseif (case_289_ == 3) then
        local n, step, coll = ...
        local function _290_()
          local case_291_ = seq(coll)
          if (nil ~= case_291_) then
            local s = case_291_
            local p = take(n, s)
            return cons(p, partition_all(n, step, nthrest(s, step)))
          else
            local _ = case_291_
            return nil
          end
        end
        return lazy_seq(_290_)
      else
        local _ = case_289_
        return error("wrong amount arguments to 'partition-all'")
      end
    end
    local function reductions(...)
      local case_294_ = select("#", ...)
      if (case_294_ == 2) then
        local f, coll = ...
        local function _295_()
          local case_296_ = seq(coll)
          if (nil ~= case_296_) then
            local s = case_296_
            return reductions(f, first(s), rest(s))
          else
            local _ = case_296_
            return list(f())
          end
        end
        return lazy_seq(_295_)
      elseif (case_294_ == 3) then
        local f, init, coll = ...
        local function _298_()
          local case_299_ = seq(coll)
          if (nil ~= case_299_) then
            local s = case_299_
            return reductions(f, f(init, first(s)), rest(s))
          else
            return nil
          end
        end
        return cons(init, lazy_seq(_298_))
      else
        local _ = case_294_
        return error("wrong amount arguments to 'reductions'")
      end
    end
    local function contains_3f(coll, elt)
      local case_302_ = gettype(coll)
      if (case_302_ == "table") then
        local case_303_ = kind(coll)
        if (case_303_ == "seq") then
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
        elseif (case_303_ == "assoc") then
          if coll[elt] then
            return true
          else
            return false
          end
        else
          return nil
        end
      else
        local _ = case_302_
        local function loop(coll0)
          local case_307_ = seq(coll0)
          if (nil ~= case_307_) then
            local s = case_307_
            if (elt == first(s)) then
              return true
            else
              return loop(rest(s))
            end
          elseif (case_307_ == nil) then
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
        local function loop0(_311_, seen0)
          local f = _311_[1]
          local xs0 = _311_
          local case_312_ = seq(xs0)
          if (nil ~= case_312_) then
            local s = case_312_
            if seen0[f] then
              return loop0(rest(s), seen0)
            else
              local function _313_()
                seen0[f] = true
                return seen0
              end
              return cons(f, step(rest(s), _313_()))
            end
          else
            local _ = case_312_
            return nil
          end
        end
        loop = loop0
        local function _316_()
          return loop(xs, seen)
        end
        return lazy_seq(_316_)
      end
      return step(coll, {})
    end
    local function inf_range(x, step)
      local function _317_()
        return cons(x, inf_range((x + step), step))
      end
      return lazy_seq(_317_)
    end
    local function fix_range(x, _end, step)
      local function _318_()
        if (((step >= 0) and (x < _end)) or ((step < 0) and (x > _end))) then
          return cons(x, fix_range((x + step), _end, step))
        elseif ((step == 0) and (x ~= _end)) then
          return cons(x, fix_range(x, _end, step))
        else
          return nil
        end
      end
      return lazy_seq(_318_)
    end
    local function range(...)
      local case_320_ = select("#", ...)
      if (case_320_ == 0) then
        return inf_range(0, 1)
      elseif (case_320_ == 1) then
        local _end = ...
        return fix_range(0, _end, 1)
      elseif (case_320_ == 2) then
        local x, _end = ...
        return fix_range(x, _end, 1)
      else
        local _ = case_320_
        return fix_range(...)
      end
    end
    local function realized_3f(s)
      local case_322_ = gettype(s)
      if (case_322_ == "lazy-cons") then
        return false
      elseif (case_322_ == "empty-cons") then
        return true
      elseif (case_322_ == "cons") then
        return true
      else
        local _ = case_322_
        return error(("expected a sequence, got: %s"):format(_))
      end
    end
    local function line_seq(file)
      local next_line = file:lines()
      local function step(f)
        local line = f()
        if ("string" == type(line)) then
          local function _324_()
            return step(f)
          end
          return cons(line, lazy_seq(_324_))
        else
          return nil
        end
      end
      return step(next_line)
    end
    local function tree_seq(branch_3f, children, root)
      local function walk(node)
        local function _326_()
          local function _327_()
            if branch_3f(node) then
              return mapcat(walk, children(node))
            else
              return nil
            end
          end
          return cons(node, _327_())
        end
        return lazy_seq(_326_)
      end
      return walk(root)
    end
    local function interleave(...)
      local case_328_, case_329_, case_330_ = select("#", ...), ...
      if (case_328_ == 0) then
        return empty_cons
      elseif ((case_328_ == 1) and true) then
        local _3fs = case_329_
        local function _331_()
          return _3fs
        end
        return lazy_seq(_331_)
      elseif ((case_328_ == 2) and true and true) then
        local _3fs1 = case_329_
        local _3fs2 = case_330_
        local function _332_()
          local s1 = seq(_3fs1)
          local s2 = seq(_3fs2)
          if (s1 and s2) then
            return cons(first(s1), cons(first(s2), interleave(rest(s1), rest(s2))))
          else
            return nil
          end
        end
        return lazy_seq(_332_)
      elseif true then
        local _ = case_328_
        local cols = list(...)
        local function _334_()
          local seqs = map(seq, cols)
          local function _335_(_2410)
            return (nil ~= seq(_2410))
          end
          if every_3f(_335_, seqs) then
            return concat(map(first, seqs), interleave(unpack(map(rest, seqs))))
          else
            return nil
          end
        end
        return lazy_seq(_334_)
      else
        return nil
      end
    end
    local function interpose(separator, coll)
      return drop(1, interleave(_repeat(separator), coll))
    end
    local function keys(t)
      assert(("assoc" == kind(t)), "expected an associative table")
      local function _338_(_241)
        return _241[1]
      end
      return map(_338_, t)
    end
    local function vals(t)
      assert(("assoc" == kind(t)), "expected an associative table")
      local function _339_(_241)
        return _241[2]
      end
      return map(_339_, t)
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
    local _local_341_ = require("reduced")
    local reduced = _local_341_.reduced
    local reduced_3f = _local_341_["reduced?"]
    local function reduce(f, ...)
      local case_342_, case_343_, case_344_ = select("#", ...), ...
      if (case_342_ == 0) then
        return error("expected a collection")
      elseif ((case_342_ == 1) and true) then
        local _3fcoll = case_343_
        local case_345_ = count(_3fcoll)
        if (case_345_ == 0) then
          return f()
        elseif (case_345_ == 1) then
          return first(_3fcoll)
        else
          local _ = case_345_
          return reduce(f, first(_3fcoll), rest(_3fcoll))
        end
      elseif ((case_342_ == 2) and true and true) then
        local _3fval = case_343_
        local _3fcoll = case_344_
        local case_347_ = seq(_3fcoll)
        if (nil ~= case_347_) then
          local coll = case_347_
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
          local _ = case_347_
          return _3fval
        end
      else
        return nil
      end
    end
    return {first = first, rest = rest, nthrest = nthrest, next = next, nthnext = nthnext, cons = cons, seq = seq, rseq = rseq, ["seq?"] = seq_3f, ["empty?"] = empty_3f, ["lazy-seq"] = lazy_seq, list = list, ["list*"] = list_2a, ["every?"] = every_3f, ["some?"] = some_3f, pack = pack, unpack = unpack, count = count, concat = concat, map = map, ["map-indexed"] = map_indexed, mapcat = mapcat, take = take, ["take-while"] = take_while, ["take-last"] = take_last, ["take-nth"] = take_nth, drop = drop, ["drop-while"] = drop_while, ["drop-last"] = drop_last, remove = remove, ["split-at"] = split_at, ["split-with"] = split_with, partition = partition, ["partition-by"] = partition_by, ["partition-all"] = partition_all, filter = filter, keep = keep, ["keep-indexed"] = keep_indexed, ["contains?"] = contains_3f, distinct = distinct, cycle = cycle, ["repeat"] = _repeat, repeatedly = repeatedly, reductions = reductions, iterate = iterate, range = range, ["realized?"] = realized_3f, dorun = dorun, doall = doall, ["line-seq"] = line_seq, ["tree-seq"] = tree_seq, reverse = reverse, interleave = interleave, interpose = interpose, keys = keys, vals = vals, zipmap = zipmap, reduce = reduce, reduced = reduced, ["reduced?"] = reduced_3f}
  end
  or_104_ = _105_
end
package.preload["lazy-seq"] = or_104_
local function _351_()
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
local _local_352_ = {setmetatable({}, {__fennelview = _351_, __name = "namespace"}), require("lazy-seq"), require("itable")}, nil
local core = _local_352_[1]
local lazy = _local_352_[2]
local itable = _local_352_[3]
local function unpack_2a(x, ...)
  if core["seq?"](x) then
    return lazy.unpack(x)
  else
    return itable.unpack(x, ...)
  end
end
local function pack_2a(...)
  local tmp_9_ = {...}
  tmp_9_["n"] = select("#", ...)
  return tmp_9_
end
local function pairs_2a(t)
  local case_354_ = getmetatable(t)
  if ((_G.type(case_354_) == "table") and (nil ~= case_354_.__pairs)) then
    local p = case_354_.__pairs
    return p(t)
  else
    local _ = case_354_
    return pairs(t)
  end
end
local function ipairs_2a(t)
  local case_356_ = getmetatable(t)
  if ((_G.type(case_356_) == "table") and (nil ~= case_356_.__ipairs)) then
    local i = case_356_.__ipairs
    return i(t)
  else
    local _ = case_356_
    return ipairs(t)
  end
end
local function length_2a(t)
  local case_358_ = getmetatable(t)
  if ((_G.type(case_358_) == "table") and (nil ~= case_358_.__len)) then
    local l = case_358_.__len
    return l(t)
  else
    local _ = case_358_
    return #t
  end
end
local apply
do
  local v_27_auto
  local function apply0(...)
    local case_361_ = select("#", ...)
    if (case_361_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "apply"))
    elseif (case_361_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "apply"))
    elseif (case_361_ == 2) then
      local f, args = ...
      return f(unpack_2a(args))
    elseif (case_361_ == 3) then
      local f, a, args = ...
      return f(a, unpack_2a(args))
    elseif (case_361_ == 4) then
      local f, a, b, args = ...
      return f(a, b, unpack_2a(args))
    elseif (case_361_ == 5) then
      local f, a, b, c, args = ...
      return f(a, b, c, unpack_2a(args))
    else
      local _ = case_361_
      local core_38_auto = require("cljlib")
      local _let_362_ = core_38_auto.list(...)
      local f = _let_362_[1]
      local a = _let_362_[2]
      local b = _let_362_[3]
      local c = _let_362_[4]
      local d = _let_362_[5]
      local args = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_362_, 6)
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
  v_27_auto = apply0
  core["apply"] = v_27_auto
  apply = v_27_auto
end
local add
do
  local v_27_auto
  local function add0(...)
    local case_364_ = select("#", ...)
    if (case_364_ == 0) then
      return 0
    elseif (case_364_ == 1) then
      local a = ...
      return a
    elseif (case_364_ == 2) then
      local a, b = ...
      return (a + b)
    elseif (case_364_ == 3) then
      local a, b, c = ...
      return (a + b + c)
    elseif (case_364_ == 4) then
      local a, b, c, d = ...
      return (a + b + c + d)
    else
      local _ = case_364_
      local core_38_auto = require("cljlib")
      local _let_365_ = core_38_auto.list(...)
      local a = _let_365_[1]
      local b = _let_365_[2]
      local c = _let_365_[3]
      local d = _let_365_[4]
      local rest = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_365_, 5)
      return apply(add0, (a + b + c + d), rest)
    end
  end
  v_27_auto = add0
  core["add"] = v_27_auto
  add = v_27_auto
end
local sub
do
  local v_27_auto
  local function sub0(...)
    local case_367_ = select("#", ...)
    if (case_367_ == 0) then
      return 0
    elseif (case_367_ == 1) then
      local a = ...
      return ( - a)
    elseif (case_367_ == 2) then
      local a, b = ...
      return (a - b)
    elseif (case_367_ == 3) then
      local a, b, c = ...
      return (a - b - c)
    elseif (case_367_ == 4) then
      local a, b, c, d = ...
      return (a - b - c - d)
    else
      local _ = case_367_
      local core_38_auto = require("cljlib")
      local _let_368_ = core_38_auto.list(...)
      local a = _let_368_[1]
      local b = _let_368_[2]
      local c = _let_368_[3]
      local d = _let_368_[4]
      local rest = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_368_, 5)
      return apply(sub0, (a - b - c - d), rest)
    end
  end
  v_27_auto = sub0
  core["sub"] = v_27_auto
  sub = v_27_auto
end
local mul
do
  local v_27_auto
  local function mul0(...)
    local case_370_ = select("#", ...)
    if (case_370_ == 0) then
      return 1
    elseif (case_370_ == 1) then
      local a = ...
      return a
    elseif (case_370_ == 2) then
      local a, b = ...
      return (a * b)
    elseif (case_370_ == 3) then
      local a, b, c = ...
      return (a * b * c)
    elseif (case_370_ == 4) then
      local a, b, c, d = ...
      return (a * b * c * d)
    else
      local _ = case_370_
      local core_38_auto = require("cljlib")
      local _let_371_ = core_38_auto.list(...)
      local a = _let_371_[1]
      local b = _let_371_[2]
      local c = _let_371_[3]
      local d = _let_371_[4]
      local rest = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_371_, 5)
      return apply(mul0, (a * b * c * d), rest)
    end
  end
  v_27_auto = mul0
  core["mul"] = v_27_auto
  mul = v_27_auto
end
local div
do
  local v_27_auto
  local function div0(...)
    local case_373_ = select("#", ...)
    if (case_373_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "div"))
    elseif (case_373_ == 1) then
      local a = ...
      return (1 / a)
    elseif (case_373_ == 2) then
      local a, b = ...
      return (a / b)
    elseif (case_373_ == 3) then
      local a, b, c = ...
      return (a / b / c)
    elseif (case_373_ == 4) then
      local a, b, c, d = ...
      return (a / b / c / d)
    else
      local _ = case_373_
      local core_38_auto = require("cljlib")
      local _let_374_ = core_38_auto.list(...)
      local a = _let_374_[1]
      local b = _let_374_[2]
      local c = _let_374_[3]
      local d = _let_374_[4]
      local rest = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_374_, 5)
      return apply(div0, (a / b / c / d), rest)
    end
  end
  v_27_auto = div0
  core["div"] = v_27_auto
  div = v_27_auto
end
local le
do
  local v_27_auto
  local function le0(...)
    local case_376_ = select("#", ...)
    if (case_376_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "le"))
    elseif (case_376_ == 1) then
      local a = ...
      return true
    elseif (case_376_ == 2) then
      local a, b = ...
      return (a <= b)
    else
      local _ = case_376_
      local core_38_auto = require("cljlib")
      local _let_377_ = core_38_auto.list(...)
      local a = _let_377_[1]
      local b = _let_377_[2]
      local _let_378_ = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_377_, 3)
      local c = _let_378_[1]
      local d = _let_378_[2]
      local more = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_378_, 3)
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
  v_27_auto = le0
  core["le"] = v_27_auto
  le = v_27_auto
end
local lt
do
  local v_27_auto
  local function lt0(...)
    local case_382_ = select("#", ...)
    if (case_382_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "lt"))
    elseif (case_382_ == 1) then
      local a = ...
      return true
    elseif (case_382_ == 2) then
      local a, b = ...
      return (a < b)
    else
      local _ = case_382_
      local core_38_auto = require("cljlib")
      local _let_383_ = core_38_auto.list(...)
      local a = _let_383_[1]
      local b = _let_383_[2]
      local _let_384_ = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_383_, 3)
      local c = _let_384_[1]
      local d = _let_384_[2]
      local more = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_384_, 3)
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
  v_27_auto = lt0
  core["lt"] = v_27_auto
  lt = v_27_auto
end
local ge
do
  local v_27_auto
  local function ge0(...)
    local case_388_ = select("#", ...)
    if (case_388_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "ge"))
    elseif (case_388_ == 1) then
      local a = ...
      return true
    elseif (case_388_ == 2) then
      local a, b = ...
      return (a >= b)
    else
      local _ = case_388_
      local core_38_auto = require("cljlib")
      local _let_389_ = core_38_auto.list(...)
      local a = _let_389_[1]
      local b = _let_389_[2]
      local _let_390_ = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_389_, 3)
      local c = _let_390_[1]
      local d = _let_390_[2]
      local more = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_390_, 3)
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
  v_27_auto = ge0
  core["ge"] = v_27_auto
  ge = v_27_auto
end
local gt
do
  local v_27_auto
  local function gt0(...)
    local case_394_ = select("#", ...)
    if (case_394_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "gt"))
    elseif (case_394_ == 1) then
      local a = ...
      return true
    elseif (case_394_ == 2) then
      local a, b = ...
      return (a > b)
    else
      local _ = case_394_
      local core_38_auto = require("cljlib")
      local _let_395_ = core_38_auto.list(...)
      local a = _let_395_[1]
      local b = _let_395_[2]
      local _let_396_ = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_395_, 3)
      local c = _let_396_[1]
      local d = _let_396_[2]
      local more = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_396_, 3)
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
  v_27_auto = gt0
  core["gt"] = v_27_auto
  gt = v_27_auto
end
local inc
do
  local v_27_auto
  local function inc0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "inc"))
      else
      end
    end
    return (x + 1)
  end
  v_27_auto = inc0
  core["inc"] = v_27_auto
  inc = v_27_auto
end
local dec
do
  local v_27_auto
  local function dec0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "dec"))
      else
      end
    end
    return (x - 1)
  end
  v_27_auto = dec0
  core["dec"] = v_27_auto
  dec = v_27_auto
end
local class
do
  local v_27_auto
  local function class0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "class"))
      else
      end
    end
    local case_403_ = type(x)
    if (case_403_ == "table") then
      local case_404_ = getmetatable(x)
      if ((_G.type(case_404_) == "table") and (nil ~= case_404_["cljlib/type"])) then
        local t = case_404_["cljlib/type"]
        return t
      else
        local _ = case_404_
        return "table"
      end
    elseif (nil ~= case_403_) then
      local t = case_403_
      return t
    else
      return nil
    end
  end
  v_27_auto = class0
  core["class"] = v_27_auto
  class = v_27_auto
end
local constantly
do
  local v_27_auto
  local function constantly0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "constantly"))
      else
      end
    end
    local function _408_()
      return x
    end
    return _408_
  end
  v_27_auto = constantly0
  core["constantly"] = v_27_auto
  constantly = v_27_auto
end
local complement
do
  local v_27_auto
  local function complement0(...)
    local f = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "complement"))
      else
      end
    end
    local function fn_410_(...)
      local case_411_ = select("#", ...)
      if (case_411_ == 0) then
        return not f()
      elseif (case_411_ == 1) then
        local a = ...
        return not f(a)
      elseif (case_411_ == 2) then
        local a, b = ...
        return not f(a, b)
      else
        local _ = case_411_
        local core_38_auto = require("cljlib")
        local _let_412_ = core_38_auto.list(...)
        local a = _let_412_[1]
        local b = _let_412_[2]
        local cs = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_412_, 3)
        return not apply(f, a, b, cs)
      end
    end
    return fn_410_
  end
  v_27_auto = complement0
  core["complement"] = v_27_auto
  complement = v_27_auto
end
local identity
do
  local v_27_auto
  local function identity0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "identity"))
      else
      end
    end
    return x
  end
  v_27_auto = identity0
  core["identity"] = v_27_auto
  identity = v_27_auto
end
local comp
do
  local v_27_auto
  local function comp0(...)
    local case_415_ = select("#", ...)
    if (case_415_ == 0) then
      return identity
    elseif (case_415_ == 1) then
      local f = ...
      return f
    elseif (case_415_ == 2) then
      local f, g = ...
      local function fn_416_(...)
        local case_417_ = select("#", ...)
        if (case_417_ == 0) then
          return f(g())
        elseif (case_417_ == 1) then
          local x = ...
          return f(g(x))
        elseif (case_417_ == 2) then
          local x, y = ...
          return f(g(x, y))
        elseif (case_417_ == 3) then
          local x, y, z = ...
          return f(g(x, y, z))
        else
          local _ = case_417_
          local core_38_auto = require("cljlib")
          local _let_418_ = core_38_auto.list(...)
          local x = _let_418_[1]
          local y = _let_418_[2]
          local z = _let_418_[3]
          local args = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_418_, 4)
          return f(apply(g, x, y, z, args))
        end
      end
      return fn_416_
    else
      local _ = case_415_
      local core_38_auto = require("cljlib")
      local _let_420_ = core_38_auto.list(...)
      local f = _let_420_[1]
      local g = _let_420_[2]
      local fs = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_420_, 3)
      return core.reduce(comp0, core.cons(f, core.cons(g, fs)))
    end
  end
  v_27_auto = comp0
  core["comp"] = v_27_auto
  comp = v_27_auto
end
local eq
do
  local v_27_auto
  local function eq0(...)
    local case_422_ = select("#", ...)
    if (case_422_ == 0) then
      return true
    elseif (case_422_ == 1) then
      local _ = ...
      return true
    elseif (case_422_ == 2) then
      local a, b = ...
      if ((a == b) and (b == a)) then
        return true
      else
        local _423_ = type(a)
        if (("table" == _423_) and (_423_ == type(b))) then
          local res, count_a = true, 0
          for k, v in pairs_2a(a) do
            if not res then break end
            local function _424_(...)
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
            res = eq0(v, _424_(...))
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
      end
    else
      local _ = case_422_
      local core_38_auto = require("cljlib")
      local _let_428_ = core_38_auto.list(...)
      local a = _let_428_[1]
      local b = _let_428_[2]
      local cs = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_428_, 3)
      return (eq0(a, b) and apply(eq0, b, cs))
    end
  end
  v_27_auto = eq0
  core["eq"] = v_27_auto
  eq = v_27_auto
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
  local v_27_auto
  local function memoize0(...)
    local f = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "memoize"))
      else
      end
    end
    local memo = setmetatable({}, {__index = deep_index})
    local function fn_435_(...)
      local core_38_auto = require("cljlib")
      local _let_436_ = core_38_auto.list(...)
      local args = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_436_, 1)
      local case_437_ = memo[args]
      if (nil ~= case_437_) then
        local res = case_437_
        return unpack_2a(res, 1, res.n)
      else
        local _ = case_437_
        local res = pack_2a(f(...))
        memo[args] = res
        return unpack_2a(res, 1, res.n)
      end
    end
    return fn_435_
  end
  v_27_auto = memoize0
  core["memoize"] = v_27_auto
  memoize = v_27_auto
end
local deref
do
  local v_27_auto
  local function deref0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "deref"))
      else
      end
    end
    local case_440_ = getmetatable(x)
    if ((_G.type(case_440_) == "table") and (nil ~= case_440_["cljlib/deref"])) then
      local f = case_440_["cljlib/deref"]
      return f(x)
    else
      local _ = case_440_
      return error("object doesn't implement cljlib/deref metamethod", 2)
    end
  end
  v_27_auto = deref0
  core["deref"] = v_27_auto
  deref = v_27_auto
end
local empty
do
  local v_27_auto
  local function empty0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "empty"))
      else
      end
    end
    local case_443_ = getmetatable(x)
    if ((_G.type(case_443_) == "table") and (nil ~= case_443_["cljlib/empty"])) then
      local f = case_443_["cljlib/empty"]
      return f()
    else
      local _ = case_443_
      local case_444_ = type(x)
      if (case_444_ == "table") then
        return {}
      elseif (case_444_ == "string") then
        return ""
      else
        local _0 = case_444_
        return error(("don't know how to create empty variant of type " .. _0))
      end
    end
  end
  v_27_auto = empty0
  core["empty"] = v_27_auto
  empty = v_27_auto
end
local nil_3f
do
  local v_27_auto
  local function nil_3f0(...)
    local case_447_ = select("#", ...)
    if (case_447_ == 0) then
      return true
    elseif (case_447_ == 1) then
      local x = ...
      return (x == nil)
    else
      local _ = case_447_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "nil?"))
    end
  end
  v_27_auto = nil_3f0
  core["nil?"] = v_27_auto
  nil_3f = v_27_auto
end
local zero_3f
do
  local v_27_auto
  local function zero_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "zero?"))
      else
      end
    end
    return (x == 0)
  end
  v_27_auto = zero_3f0
  core["zero?"] = v_27_auto
  zero_3f = v_27_auto
end
local pos_3f
do
  local v_27_auto
  local function pos_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "pos?"))
      else
      end
    end
    return (x > 0)
  end
  v_27_auto = pos_3f0
  core["pos?"] = v_27_auto
  pos_3f = v_27_auto
end
local neg_3f
do
  local v_27_auto
  local function neg_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "neg?"))
      else
      end
    end
    return (x < 0)
  end
  v_27_auto = neg_3f0
  core["neg?"] = v_27_auto
  neg_3f = v_27_auto
end
local even_3f
do
  local v_27_auto
  local function even_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "even?"))
      else
      end
    end
    return ((x % 2) == 0)
  end
  v_27_auto = even_3f0
  core["even?"] = v_27_auto
  even_3f = v_27_auto
end
local odd_3f
do
  local v_27_auto
  local function odd_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "odd?"))
      else
      end
    end
    return not even_3f(x)
  end
  v_27_auto = odd_3f0
  core["odd?"] = v_27_auto
  odd_3f = v_27_auto
end
local string_3f
do
  local v_27_auto
  local function string_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "string?"))
      else
      end
    end
    return (type(x) == "string")
  end
  v_27_auto = string_3f0
  core["string?"] = v_27_auto
  string_3f = v_27_auto
end
local boolean_3f
do
  local v_27_auto
  local function boolean_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "boolean?"))
      else
      end
    end
    return (type(x) == "boolean")
  end
  v_27_auto = boolean_3f0
  core["boolean?"] = v_27_auto
  boolean_3f = v_27_auto
end
local true_3f
do
  local v_27_auto
  local function true_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "true?"))
      else
      end
    end
    return (x == true)
  end
  v_27_auto = true_3f0
  core["true?"] = v_27_auto
  true_3f = v_27_auto
end
local false_3f
do
  local v_27_auto
  local function false_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "false?"))
      else
      end
    end
    return (x == false)
  end
  v_27_auto = false_3f0
  core["false?"] = v_27_auto
  false_3f = v_27_auto
end
local int_3f
do
  local v_27_auto
  local function int_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "int?"))
      else
      end
    end
    return ((type(x) == "number") and (x == math.floor(x)))
  end
  v_27_auto = int_3f0
  core["int?"] = v_27_auto
  int_3f = v_27_auto
end
local pos_int_3f
do
  local v_27_auto
  local function pos_int_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "pos-int?"))
      else
      end
    end
    return (int_3f(x) and pos_3f(x))
  end
  v_27_auto = pos_int_3f0
  core["pos-int?"] = v_27_auto
  pos_int_3f = v_27_auto
end
local neg_int_3f
do
  local v_27_auto
  local function neg_int_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "neg-int?"))
      else
      end
    end
    return (int_3f(x) and neg_3f(x))
  end
  v_27_auto = neg_int_3f0
  core["neg-int?"] = v_27_auto
  neg_int_3f = v_27_auto
end
local double_3f
do
  local v_27_auto
  local function double_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "double?"))
      else
      end
    end
    return ((type(x) == "number") and (x ~= math.floor(x)))
  end
  v_27_auto = double_3f0
  core["double?"] = v_27_auto
  double_3f = v_27_auto
end
local empty_3f
do
  local v_27_auto
  local function empty_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "empty?"))
      else
      end
    end
    local case_463_ = type(x)
    if (case_463_ == "table") then
      local case_464_ = getmetatable(x)
      if ((_G.type(case_464_) == "table") and (case_464_["cljlib/type"] == "seq")) then
        return nil_3f(core.seq(x))
      elseif ((case_464_ == nil) or ((_G.type(case_464_) == "table") and (case_464_["cljlib/type"] == nil))) then
        local next_2a = pairs_2a(x)
        return (next_2a(x) == nil)
      else
        return nil
      end
    elseif (case_463_ == "string") then
      return (x == "")
    elseif (case_463_ == "nil") then
      return true
    else
      local _ = case_463_
      return error("empty?: unsupported collection")
    end
  end
  v_27_auto = empty_3f0
  core["empty?"] = v_27_auto
  empty_3f = v_27_auto
end
local not_empty
do
  local v_27_auto
  local function not_empty0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "not-empty"))
      else
      end
    end
    if not empty_3f(x) then
      return x
    else
      return nil
    end
  end
  v_27_auto = not_empty0
  core["not-empty"] = v_27_auto
  not_empty = v_27_auto
end
local map_3f
do
  local v_27_auto
  local function map_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "map?"))
      else
      end
    end
    if ("table" == type(x)) then
      local case_470_ = getmetatable(x)
      if ((_G.type(case_470_) == "table") and (case_470_["cljlib/type"] == "hash-map")) then
        return true
      elseif ((_G.type(case_470_) == "table") and (case_470_["cljlib/type"] == "sorted-map")) then
        return true
      elseif ((case_470_ == nil) or ((_G.type(case_470_) == "table") and (case_470_["cljlib/type"] == nil))) then
        local len = length_2a(x)
        local nxt, t, k = pairs_2a(x)
        local function _471_(...)
          if (len == 0) then
            return k
          else
            return len
          end
        end
        return (nil ~= nxt(t, _471_(...)))
      else
        local _ = case_470_
        return false
      end
    else
      return false
    end
  end
  v_27_auto = map_3f0
  core["map?"] = v_27_auto
  map_3f = v_27_auto
end
local vector_3f
do
  local v_27_auto
  local function vector_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "vector?"))
      else
      end
    end
    if ("table" == type(x)) then
      local case_475_ = getmetatable(x)
      if ((_G.type(case_475_) == "table") and (case_475_["cljlib/type"] == "vector")) then
        return true
      elseif ((case_475_ == nil) or ((_G.type(case_475_) == "table") and (case_475_["cljlib/type"] == nil))) then
        local len = length_2a(x)
        local nxt, t, k = pairs_2a(x)
        local function _476_(...)
          if (len == 0) then
            return k
          else
            return len
          end
        end
        if (nil ~= nxt(t, _476_(...))) then
          return false
        elseif (len > 0) then
          return true
        else
          return false
        end
      else
        local _ = case_475_
        return false
      end
    else
      return false
    end
  end
  v_27_auto = vector_3f0
  core["vector?"] = v_27_auto
  vector_3f = v_27_auto
end
local set_3f
do
  local v_27_auto
  local function set_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "set?"))
      else
      end
    end
    local case_481_ = getmetatable(x)
    if ((_G.type(case_481_) == "table") and (case_481_["cljlib/type"] == "hash-set")) then
      return true
    else
      local _ = case_481_
      return false
    end
  end
  v_27_auto = set_3f0
  core["set?"] = v_27_auto
  set_3f = v_27_auto
end
local seq_3f
do
  local v_27_auto
  local function seq_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "seq?"))
      else
      end
    end
    return lazy["seq?"](x)
  end
  v_27_auto = seq_3f0
  core["seq?"] = v_27_auto
  seq_3f = v_27_auto
end
local some_3f
do
  local v_27_auto
  local function some_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "some?"))
      else
      end
    end
    return (x ~= nil)
  end
  v_27_auto = some_3f0
  core["some?"] = v_27_auto
  some_3f = v_27_auto
end
local function vec__3etransient(immutable)
  local function _485_(vec)
    local len = #vec
    local function _486_(_, i)
      if (i <= len) then
        return vec[i]
      else
        return nil
      end
    end
    local function _488_()
      return len
    end
    local function _489_()
      return error("can't `conj` onto transient vector, use `conj!`")
    end
    local function _490_()
      return error("can't `assoc` onto transient vector, use `assoc!`")
    end
    local function _491_()
      return error("can't `dissoc` onto transient vector, use `dissoc!`")
    end
    local function _492_(tvec, v)
      len = (len + 1)
      tvec[len] = v
      return tvec
    end
    local function _493_(tvec, ...)
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
    local function _495_(tvec)
      if (len == 0) then
        return error("transient vector is empty", 2)
      else
        local val = table.remove(tvec)
        len = (len - 1)
        return tvec
      end
    end
    local function _497_()
      return error("can't `dissoc!` with a transient vector")
    end
    local function _498_(tvec)
      local v
      do
        local tbl_26_ = {}
        local i_27_ = 0
        for i = 1, len do
          local val_28_ = tvec[i]
          if (nil ~= val_28_) then
            i_27_ = (i_27_ + 1)
            tbl_26_[i_27_] = val_28_
          else
          end
        end
        v = tbl_26_
      end
      while (len > 0) do
        table.remove(tvec)
        len = (len - 1)
      end
      local function _500_()
        return error("attempt to use transient after it was persistet")
      end
      local function _501_()
        return error("attempt to use transient after it was persistet")
      end
      setmetatable(tvec, {__index = _500_, __newindex = _501_})
      return immutable(itable(v))
    end
    return setmetatable({}, {__index = _486_, __len = _488_, ["cljlib/type"] = "transient", ["cljlib/conj"] = _489_, ["cljlib/assoc"] = _490_, ["cljlib/dissoc"] = _491_, ["cljlib/conj!"] = _492_, ["cljlib/assoc!"] = _493_, ["cljlib/pop!"] = _495_, ["cljlib/dissoc!"] = _497_, ["cljlib/persistent!"] = _498_})
  end
  return _485_
end
local function vec_2a(v, len)
  do
    local case_502_ = getmetatable(v)
    if (nil ~= case_502_) then
      local mt = case_502_
      mt["__len"] = constantly((len or length_2a(v)))
      mt["cljlib/type"] = "vector"
      mt["cljlib/editable"] = true
      local function _503_(t, v0)
        local len0 = length_2a(t)
        return vec_2a(itable.assoc(t, (len0 + 1), v0), (len0 + 1))
      end
      mt["cljlib/conj"] = _503_
      local function _504_(t)
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
      mt["cljlib/pop"] = _504_
      local function _506_()
        return vec_2a(itable({}))
      end
      mt["cljlib/empty"] = _506_
      mt["cljlib/transient"] = vec__3etransient(vec_2a)
      local function _507_(coll, view, inspector, indent)
        if empty_3f(coll) then
          return "[]"
        else
          local lines
          do
            local tbl_26_ = {}
            local i_27_ = 0
            for i = 1, length_2a(coll) do
              local val_28_ = (" " .. view(coll[i], inspector, indent))
              if (nil ~= val_28_) then
                i_27_ = (i_27_ + 1)
                tbl_26_[i_27_] = val_28_
              else
              end
            end
            lines = tbl_26_
          end
          lines[1] = ("[" .. string.gsub((lines[1] or ""), "^%s+", ""))
          lines[#lines] = (lines[#lines] .. "]")
          return lines
        end
      end
      mt["__fennelview"] = _507_
    elseif (case_502_ == nil) then
      vec_2a(setmetatable(v, {}))
    else
    end
  end
  return v
end
local vec
do
  local v_27_auto
  local function vec0(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "vec"))
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
      local _512_
      do
        packed["n"] = nil
        _512_ = packed
      end
      return vec_2a(itable(_512_, {["fast-index?"] = true}), len)
    else
      return nil
    end
  end
  v_27_auto = vec0
  core["vec"] = v_27_auto
  vec = v_27_auto
end
local vector
do
  local v_27_auto
  local function vector0(...)
    local core_38_auto = require("cljlib")
    local _let_514_ = core_38_auto.list(...)
    local args = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_514_, 1)
    return vec(args)
  end
  v_27_auto = vector0
  core["vector"] = v_27_auto
  vector = v_27_auto
end
local nth
do
  local v_27_auto
  local function nth0(...)
    local case_516_ = select("#", ...)
    if (case_516_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "nth"))
    elseif (case_516_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "nth"))
    elseif (case_516_ == 2) then
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
    elseif (case_516_ == 3) then
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
      local _ = case_516_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "nth"))
    end
  end
  v_27_auto = nth0
  core["nth"] = v_27_auto
  nth = v_27_auto
end
local seq_2a
local function seq_2a0(...)
  local x = ...
  do
    local cnt_54_auto = select("#", ...)
    if (1 ~= cnt_54_auto) then
      error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "seq*"))
    else
    end
  end
  do
    local case_522_ = getmetatable(x)
    if (nil ~= case_522_) then
      local mt = case_522_
      mt["cljlib/type"] = "seq"
      local function _523_(s, v)
        return core.cons(v, s)
      end
      mt["cljlib/conj"] = _523_
      local function _524_()
        return core.list()
      end
      mt["cljlib/empty"] = _524_
    else
    end
  end
  return x
end
seq_2a = seq_2a0
local seq
do
  local v_27_auto
  local function seq0(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "seq"))
      else
      end
    end
    local function _528_(...)
      local case_527_ = getmetatable(coll)
      if ((_G.type(case_527_) == "table") and (nil ~= case_527_["cljlib/seq"])) then
        local f = case_527_["cljlib/seq"]
        return f(coll)
      else
        local _ = case_527_
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
    return seq_2a(_528_(...))
  end
  v_27_auto = seq0
  core["seq"] = v_27_auto
  seq = v_27_auto
end
local rseq
do
  local v_27_auto
  local function rseq0(...)
    local rev = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "rseq"))
      else
      end
    end
    return seq_2a(lazy.rseq(rev))
  end
  v_27_auto = rseq0
  core["rseq"] = v_27_auto
  rseq = v_27_auto
end
local lazy_seq_2a
do
  local v_27_auto
  local function lazy_seq_2a0(...)
    local f = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "lazy-seq*"))
      else
      end
    end
    return seq_2a(lazy["lazy-seq"](f))
  end
  v_27_auto = lazy_seq_2a0
  core["lazy-seq*"] = v_27_auto
  lazy_seq_2a = v_27_auto
end
local first
do
  local v_27_auto
  local function first0(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "first"))
      else
      end
    end
    return lazy.first(seq(coll))
  end
  v_27_auto = first0
  core["first"] = v_27_auto
  first = v_27_auto
end
local rest
do
  local v_27_auto
  local function rest0(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "rest"))
      else
      end
    end
    return seq_2a(lazy.rest(seq(coll)))
  end
  v_27_auto = rest0
  core["rest"] = v_27_auto
  rest = v_27_auto
end
local next_2a
local function next_2a0(...)
  local s = ...
  do
    local cnt_54_auto = select("#", ...)
    if (1 ~= cnt_54_auto) then
      error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "next*"))
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
  local v_27_auto
  local function count0(...)
    local s = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "count"))
      else
      end
    end
    local case_537_ = getmetatable(s)
    if ((_G.type(case_537_) == "table") and (case_537_["cljlib/type"] == "vector")) then
      return length_2a(s)
    else
      local _ = case_537_
      return lazy.count(s)
    end
  end
  v_27_auto = count0
  core["count"] = v_27_auto
  count = v_27_auto
end
local cons
do
  local v_27_auto
  local function cons0(...)
    local head, tail = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "cons"))
      else
      end
    end
    return seq_2a(lazy.cons(head, tail))
  end
  v_27_auto = cons0
  core["cons"] = v_27_auto
  cons = v_27_auto
end
local function list(...)
  return seq_2a(lazy.list(...))
end
core.list = list
local list_2a
do
  local v_27_auto
  local function list_2a0(...)
    local core_38_auto = require("cljlib")
    local _let_540_ = core_38_auto.list(...)
    local args = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_540_, 1)
    return seq_2a(apply(lazy["list*"], args))
  end
  v_27_auto = list_2a0
  core["list*"] = v_27_auto
  list_2a = v_27_auto
end
local last
do
  local v_27_auto
  local function last0(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "last"))
      else
      end
    end
    local case_542_ = next_2a(coll)
    if (nil ~= case_542_) then
      local coll_2a = case_542_
      return last0(coll_2a)
    else
      local _ = case_542_
      return first(coll)
    end
  end
  v_27_auto = last0
  core["last"] = v_27_auto
  last = v_27_auto
end
local butlast
do
  local v_27_auto
  local function butlast0(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "butlast"))
      else
      end
    end
    return seq(lazy["drop-last"](coll))
  end
  v_27_auto = butlast0
  core["butlast"] = v_27_auto
  butlast = v_27_auto
end
local map
do
  local v_27_auto
  local function map0(...)
    local case_545_ = select("#", ...)
    if (case_545_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "map"))
    elseif (case_545_ == 1) then
      local f = ...
      local function fn_546_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_546_"))
          else
          end
        end
        local function fn_548_(...)
          local case_549_ = select("#", ...)
          if (case_549_ == 0) then
            return rf()
          elseif (case_549_ == 1) then
            local result = ...
            return rf(result)
          elseif (case_549_ == 2) then
            local result, input = ...
            return rf(result, f(input))
          else
            local _ = case_549_
            local core_38_auto = require("cljlib")
            local _let_550_ = core_38_auto.list(...)
            local result = _let_550_[1]
            local input = _let_550_[2]
            local inputs = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_550_, 3)
            return rf(result, apply(f, input, inputs))
          end
        end
        return fn_548_
      end
      return fn_546_
    elseif (case_545_ == 2) then
      local f, coll = ...
      return seq_2a(lazy.map(f, coll))
    else
      local _ = case_545_
      local core_38_auto = require("cljlib")
      local _let_552_ = core_38_auto.list(...)
      local f = _let_552_[1]
      local coll = _let_552_[2]
      local colls = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_552_, 3)
      return seq_2a(apply(lazy.map, f, coll, colls))
    end
  end
  v_27_auto = map0
  core["map"] = v_27_auto
  map = v_27_auto
end
local mapv
do
  local v_27_auto
  local function mapv0(...)
    local case_555_ = select("#", ...)
    if (case_555_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "mapv"))
    elseif (case_555_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "mapv"))
    elseif (case_555_ == 2) then
      local f, coll = ...
      return core["persistent!"](core.transduce(map(f), core["conj!"], core.transient(vector()), coll))
    else
      local _ = case_555_
      local core_38_auto = require("cljlib")
      local _let_556_ = core_38_auto.list(...)
      local f = _let_556_[1]
      local coll = _let_556_[2]
      local colls = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_556_, 3)
      return vec(apply(map, f, coll, colls))
    end
  end
  v_27_auto = mapv0
  core["mapv"] = v_27_auto
  mapv = v_27_auto
end
local map_indexed
do
  local v_27_auto
  local function map_indexed0(...)
    local case_558_ = select("#", ...)
    if (case_558_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "map-indexed"))
    elseif (case_558_ == 1) then
      local f = ...
      local function fn_559_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_559_"))
          else
          end
        end
        local i = -1
        local function fn_561_(...)
          local case_562_ = select("#", ...)
          if (case_562_ == 0) then
            return rf()
          elseif (case_562_ == 1) then
            local result = ...
            return rf(result)
          elseif (case_562_ == 2) then
            local result, input = ...
            i = (i + 1)
            return rf(result, f(i, input))
          else
            local _ = case_562_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_561_"))
          end
        end
        return fn_561_
      end
      return fn_559_
    elseif (case_558_ == 2) then
      local f, coll = ...
      return seq_2a(lazy["map-indexed"](f, coll))
    else
      local _ = case_558_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "map-indexed"))
    end
  end
  v_27_auto = map_indexed0
  core["map-indexed"] = v_27_auto
  map_indexed = v_27_auto
end
local mapcat
do
  local v_27_auto
  local function mapcat0(...)
    local case_565_ = select("#", ...)
    if (case_565_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "mapcat"))
    elseif (case_565_ == 1) then
      local f = ...
      return comp(map(f), core.cat)
    else
      local _ = case_565_
      local core_38_auto = require("cljlib")
      local _let_566_ = core_38_auto.list(...)
      local f = _let_566_[1]
      local colls = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_566_, 2)
      return seq_2a(apply(lazy.mapcat, f, colls))
    end
  end
  v_27_auto = mapcat0
  core["mapcat"] = v_27_auto
  mapcat = v_27_auto
end
local filter
do
  local v_27_auto
  local function filter0(...)
    local case_568_ = select("#", ...)
    if (case_568_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "filter"))
    elseif (case_568_ == 1) then
      local pred = ...
      local function fn_569_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_569_"))
          else
          end
        end
        local function fn_571_(...)
          local case_572_ = select("#", ...)
          if (case_572_ == 0) then
            return rf()
          elseif (case_572_ == 1) then
            local result = ...
            return rf(result)
          elseif (case_572_ == 2) then
            local result, input = ...
            if pred(input) then
              return rf(result, input)
            else
              return result
            end
          else
            local _ = case_572_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_571_"))
          end
        end
        return fn_571_
      end
      return fn_569_
    elseif (case_568_ == 2) then
      local pred, coll = ...
      return seq_2a(lazy.filter(pred, coll))
    else
      local _ = case_568_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "filter"))
    end
  end
  v_27_auto = filter0
  core["filter"] = v_27_auto
  filter = v_27_auto
end
local filterv
do
  local v_27_auto
  local function filterv0(...)
    local pred, coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "filterv"))
      else
      end
    end
    return vec(filter(pred, coll))
  end
  v_27_auto = filterv0
  core["filterv"] = v_27_auto
  filterv = v_27_auto
end
local every_3f
do
  local v_27_auto
  local function every_3f0(...)
    local pred, coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "every?"))
      else
      end
    end
    return lazy["every?"](pred, coll)
  end
  v_27_auto = every_3f0
  core["every?"] = v_27_auto
  every_3f = v_27_auto
end
local some
do
  local v_27_auto
  local function some0(...)
    local pred, coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "some"))
      else
      end
    end
    return lazy["some?"](pred, coll)
  end
  v_27_auto = some0
  core["some"] = v_27_auto
  some = v_27_auto
end
local not_any_3f
do
  local v_27_auto
  local function not_any_3f0(...)
    local pred, coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "not-any?"))
      else
      end
    end
    local function _580_(_241)
      return not pred(_241)
    end
    return some(_580_, coll)
  end
  v_27_auto = not_any_3f0
  core["not-any?"] = v_27_auto
  not_any_3f = v_27_auto
end
local range
do
  local v_27_auto
  local function range0(...)
    local case_581_ = select("#", ...)
    if (case_581_ == 0) then
      return seq_2a(lazy.range())
    elseif (case_581_ == 1) then
      local upper = ...
      return seq_2a(lazy.range(upper))
    elseif (case_581_ == 2) then
      local lower, upper = ...
      return seq_2a(lazy.range(lower, upper))
    elseif (case_581_ == 3) then
      local lower, upper, step = ...
      return seq_2a(lazy.range(lower, upper, step))
    else
      local _ = case_581_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "range"))
    end
  end
  v_27_auto = range0
  core["range"] = v_27_auto
  range = v_27_auto
end
local concat
do
  local v_27_auto
  local function concat0(...)
    local core_38_auto = require("cljlib")
    local _let_583_ = core_38_auto.list(...)
    local colls = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_583_, 1)
    return seq_2a(apply(lazy.concat, colls))
  end
  v_27_auto = concat0
  core["concat"] = v_27_auto
  concat = v_27_auto
end
local reverse
do
  local v_27_auto
  local function reverse0(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "reverse"))
      else
      end
    end
    return seq_2a(lazy.reverse(coll))
  end
  v_27_auto = reverse0
  core["reverse"] = v_27_auto
  reverse = v_27_auto
end
local take
do
  local v_27_auto
  local function take0(...)
    local case_585_ = select("#", ...)
    if (case_585_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "take"))
    elseif (case_585_ == 1) then
      local n = ...
      local function fn_586_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_586_"))
          else
          end
        end
        local n0 = n
        local function fn_588_(...)
          local case_589_ = select("#", ...)
          if (case_589_ == 0) then
            return rf()
          elseif (case_589_ == 1) then
            local result = ...
            return rf(result)
          elseif (case_589_ == 2) then
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
            local _ = case_589_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_588_"))
          end
        end
        return fn_588_
      end
      return fn_586_
    elseif (case_585_ == 2) then
      local n, coll = ...
      return seq_2a(lazy.take(n, coll))
    else
      local _ = case_585_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "take"))
    end
  end
  v_27_auto = take0
  core["take"] = v_27_auto
  take = v_27_auto
end
local take_while
do
  local v_27_auto
  local function take_while0(...)
    local case_594_ = select("#", ...)
    if (case_594_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "take-while"))
    elseif (case_594_ == 1) then
      local pred = ...
      local function fn_595_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_595_"))
          else
          end
        end
        local function fn_597_(...)
          local case_598_ = select("#", ...)
          if (case_598_ == 0) then
            return rf()
          elseif (case_598_ == 1) then
            local result = ...
            return rf(result)
          elseif (case_598_ == 2) then
            local result, input = ...
            if pred(input) then
              return rf(result, input)
            else
              return core.reduced(result)
            end
          else
            local _ = case_598_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_597_"))
          end
        end
        return fn_597_
      end
      return fn_595_
    elseif (case_594_ == 2) then
      local pred, coll = ...
      return seq_2a(lazy["take-while"](pred, coll))
    else
      local _ = case_594_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "take-while"))
    end
  end
  v_27_auto = take_while0
  core["take-while"] = v_27_auto
  take_while = v_27_auto
end
local drop
do
  local v_27_auto
  local function drop0(...)
    local case_602_ = select("#", ...)
    if (case_602_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "drop"))
    elseif (case_602_ == 1) then
      local n = ...
      local function fn_603_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_603_"))
          else
          end
        end
        local nv = n
        local function fn_605_(...)
          local case_606_ = select("#", ...)
          if (case_606_ == 0) then
            return rf()
          elseif (case_606_ == 1) then
            local result = ...
            return rf(result)
          elseif (case_606_ == 2) then
            local result, input = ...
            local n0 = nv
            nv = (nv - 1)
            if pos_3f(n0) then
              return result
            else
              return rf(result, input)
            end
          else
            local _ = case_606_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_605_"))
          end
        end
        return fn_605_
      end
      return fn_603_
    elseif (case_602_ == 2) then
      local n, coll = ...
      return seq_2a(lazy.drop(n, coll))
    else
      local _ = case_602_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "drop"))
    end
  end
  v_27_auto = drop0
  core["drop"] = v_27_auto
  drop = v_27_auto
end
local drop_while
do
  local v_27_auto
  local function drop_while0(...)
    local case_610_ = select("#", ...)
    if (case_610_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "drop-while"))
    elseif (case_610_ == 1) then
      local pred = ...
      local function fn_611_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_611_"))
          else
          end
        end
        local dv = true
        local function fn_613_(...)
          local case_614_ = select("#", ...)
          if (case_614_ == 0) then
            return rf()
          elseif (case_614_ == 1) then
            local result = ...
            return rf(result)
          elseif (case_614_ == 2) then
            local result, input = ...
            local drop_3f = dv
            if (drop_3f and pred(input)) then
              return result
            else
              dv = nil
              return rf(result, input)
            end
          else
            local _ = case_614_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_613_"))
          end
        end
        return fn_613_
      end
      return fn_611_
    elseif (case_610_ == 2) then
      local pred, coll = ...
      return seq_2a(lazy["drop-while"](pred, coll))
    else
      local _ = case_610_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "drop-while"))
    end
  end
  v_27_auto = drop_while0
  core["drop-while"] = v_27_auto
  drop_while = v_27_auto
end
local drop_last
do
  local v_27_auto
  local function drop_last0(...)
    local case_618_ = select("#", ...)
    if (case_618_ == 0) then
      return seq_2a(lazy["drop-last"]())
    elseif (case_618_ == 1) then
      local coll = ...
      return seq_2a(lazy["drop-last"](coll))
    elseif (case_618_ == 2) then
      local n, coll = ...
      return seq_2a(lazy["drop-last"](n, coll))
    else
      local _ = case_618_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "drop-last"))
    end
  end
  v_27_auto = drop_last0
  core["drop-last"] = v_27_auto
  drop_last = v_27_auto
end
local take_last
do
  local v_27_auto
  local function take_last0(...)
    local n, coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "take-last"))
      else
      end
    end
    return seq_2a(lazy["take-last"](n, coll))
  end
  v_27_auto = take_last0
  core["take-last"] = v_27_auto
  take_last = v_27_auto
end
local take_nth
do
  local v_27_auto
  local function take_nth0(...)
    local case_621_ = select("#", ...)
    if (case_621_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "take-nth"))
    elseif (case_621_ == 1) then
      local n = ...
      local function fn_622_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_622_"))
          else
          end
        end
        local iv = -1
        local function fn_624_(...)
          local case_625_ = select("#", ...)
          if (case_625_ == 0) then
            return rf()
          elseif (case_625_ == 1) then
            local result = ...
            return rf(result)
          elseif (case_625_ == 2) then
            local result, input = ...
            iv = (iv + 1)
            if (0 == (iv % n)) then
              return rf(result, input)
            else
              return result
            end
          else
            local _ = case_625_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_624_"))
          end
        end
        return fn_624_
      end
      return fn_622_
    elseif (case_621_ == 2) then
      local n, coll = ...
      return seq_2a(lazy["take-nth"](n, coll))
    else
      local _ = case_621_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "take-nth"))
    end
  end
  v_27_auto = take_nth0
  core["take-nth"] = v_27_auto
  take_nth = v_27_auto
end
local split_at
do
  local v_27_auto
  local function split_at0(...)
    local n, coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "split-at"))
      else
      end
    end
    return vec(lazy["split-at"](n, coll))
  end
  v_27_auto = split_at0
  core["split-at"] = v_27_auto
  split_at = v_27_auto
end
local split_with
do
  local v_27_auto
  local function split_with0(...)
    local pred, coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "split-with"))
      else
      end
    end
    return vec(lazy["split-with"](pred, coll))
  end
  v_27_auto = split_with0
  core["split-with"] = v_27_auto
  split_with = v_27_auto
end
local nthrest
do
  local v_27_auto
  local function nthrest0(...)
    local coll, n = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "nthrest"))
      else
      end
    end
    return seq_2a(lazy.nthrest(coll, n))
  end
  v_27_auto = nthrest0
  core["nthrest"] = v_27_auto
  nthrest = v_27_auto
end
local nthnext
do
  local v_27_auto
  local function nthnext0(...)
    local coll, n = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "nthnext"))
      else
      end
    end
    return lazy.nthnext(coll, n)
  end
  v_27_auto = nthnext0
  core["nthnext"] = v_27_auto
  nthnext = v_27_auto
end
local keep
do
  local v_27_auto
  local function keep0(...)
    local case_633_ = select("#", ...)
    if (case_633_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "keep"))
    elseif (case_633_ == 1) then
      local f = ...
      local function fn_634_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_634_"))
          else
          end
        end
        local function fn_636_(...)
          local case_637_ = select("#", ...)
          if (case_637_ == 0) then
            return rf()
          elseif (case_637_ == 1) then
            local result = ...
            return rf(result)
          elseif (case_637_ == 2) then
            local result, input = ...
            local v = f(input)
            if nil_3f(v) then
              return result
            else
              return rf(result, v)
            end
          else
            local _ = case_637_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_636_"))
          end
        end
        return fn_636_
      end
      return fn_634_
    elseif (case_633_ == 2) then
      local f, coll = ...
      return seq_2a(lazy.keep(f, coll))
    else
      local _ = case_633_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "keep"))
    end
  end
  v_27_auto = keep0
  core["keep"] = v_27_auto
  keep = v_27_auto
end
local keep_indexed
do
  local v_27_auto
  local function keep_indexed0(...)
    local case_641_ = select("#", ...)
    if (case_641_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "keep-indexed"))
    elseif (case_641_ == 1) then
      local f = ...
      local function fn_642_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_642_"))
          else
          end
        end
        local iv = -1
        local function fn_644_(...)
          local case_645_ = select("#", ...)
          if (case_645_ == 0) then
            return rf()
          elseif (case_645_ == 1) then
            local result = ...
            return rf(result)
          elseif (case_645_ == 2) then
            local result, input = ...
            iv = (iv + 1)
            local v = f(iv, input)
            if nil_3f(v) then
              return result
            else
              return rf(result, v)
            end
          else
            local _ = case_645_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_644_"))
          end
        end
        return fn_644_
      end
      return fn_642_
    elseif (case_641_ == 2) then
      local f, coll = ...
      return seq_2a(lazy["keep-indexed"](f, coll))
    else
      local _ = case_641_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "keep-indexed"))
    end
  end
  v_27_auto = keep_indexed0
  core["keep-indexed"] = v_27_auto
  keep_indexed = v_27_auto
end
local partition
do
  local v_27_auto
  local function partition0(...)
    local case_650_ = select("#", ...)
    if (case_650_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "partition"))
    elseif (case_650_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "partition"))
    elseif (case_650_ == 2) then
      local n, coll = ...
      return map(seq_2a, lazy.partition(n, coll))
    elseif (case_650_ == 3) then
      local n, step, coll = ...
      return map(seq_2a, lazy.partition(n, step, coll))
    elseif (case_650_ == 4) then
      local n, step, pad, coll = ...
      return map(seq_2a, lazy.partition(n, step, pad, coll))
    else
      local _ = case_650_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "partition"))
    end
  end
  v_27_auto = partition0
  core["partition"] = v_27_auto
  partition = v_27_auto
end
local function array()
  local len = 0
  local function _652_()
    return len
  end
  local function _653_(self)
    while (0 ~= len) do
      self[len] = nil
      len = (len - 1)
    end
    return nil
  end
  local function _654_(self, val)
    len = (len + 1)
    self[len] = val
    return self
  end
  return setmetatable({}, {__len = _652_, __index = {clear = _653_, add = _654_}})
end
local partition_by
do
  local v_27_auto
  local function partition_by0(...)
    local case_655_ = select("#", ...)
    if (case_655_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "partition-by"))
    elseif (case_655_ == 1) then
      local f = ...
      local function fn_656_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_656_"))
          else
          end
        end
        local a = array()
        local none = {}
        local pv = none
        local function fn_658_(...)
          local case_659_ = select("#", ...)
          if (case_659_ == 0) then
            return rf()
          elseif (case_659_ == 1) then
            local result = ...
            local function _660_(...)
              if empty_3f(a) then
                return result
              else
                local v = vec(a)
                a:clear()
                return core.unreduced(rf(result, v))
              end
            end
            return rf(_660_(...))
          elseif (case_659_ == 2) then
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
            local _ = case_659_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_658_"))
          end
        end
        return fn_658_
      end
      return fn_656_
    elseif (case_655_ == 2) then
      local f, coll = ...
      return map(seq_2a, lazy["partition-by"](f, coll))
    else
      local _ = case_655_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "partition-by"))
    end
  end
  v_27_auto = partition_by0
  core["partition-by"] = v_27_auto
  partition_by = v_27_auto
end
local partition_all
do
  local v_27_auto
  local function partition_all0(...)
    local case_665_ = select("#", ...)
    if (case_665_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "partition-all"))
    elseif (case_665_ == 1) then
      local n = ...
      local function fn_666_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_666_"))
          else
          end
        end
        local a = array()
        local function fn_668_(...)
          local case_669_ = select("#", ...)
          if (case_669_ == 0) then
            return rf()
          elseif (case_669_ == 1) then
            local result = ...
            local function _670_(...)
              if (0 == #a) then
                return result
              else
                local v = vec(a)
                a:clear()
                return core.unreduced(rf(result, v))
              end
            end
            return rf(_670_(...))
          elseif (case_669_ == 2) then
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
            local _ = case_669_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_668_"))
          end
        end
        return fn_668_
      end
      return fn_666_
    elseif (case_665_ == 2) then
      local n, coll = ...
      return map(seq_2a, lazy["partition-all"](n, coll))
    elseif (case_665_ == 3) then
      local n, step, coll = ...
      return map(seq_2a, lazy["partition-all"](n, step, coll))
    else
      local _ = case_665_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "partition-all"))
    end
  end
  v_27_auto = partition_all0
  core["partition-all"] = v_27_auto
  partition_all = v_27_auto
end
local reductions
do
  local v_27_auto
  local function reductions0(...)
    local case_675_ = select("#", ...)
    if (case_675_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "reductions"))
    elseif (case_675_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "reductions"))
    elseif (case_675_ == 2) then
      local f, coll = ...
      return seq_2a(lazy.reductions(f, coll))
    elseif (case_675_ == 3) then
      local f, init, coll = ...
      return seq_2a(lazy.reductions(f, init, coll))
    else
      local _ = case_675_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "reductions"))
    end
  end
  v_27_auto = reductions0
  core["reductions"] = v_27_auto
  reductions = v_27_auto
end
local contains_3f
do
  local v_27_auto
  local function contains_3f0(...)
    local coll, elt = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "contains?"))
      else
      end
    end
    return lazy["contains?"](coll, elt)
  end
  v_27_auto = contains_3f0
  core["contains?"] = v_27_auto
  contains_3f = v_27_auto
end
local distinct
do
  local v_27_auto
  local function distinct0(...)
    local case_678_ = select("#", ...)
    if (case_678_ == 0) then
      local function fn_679_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_679_"))
          else
          end
        end
        local seen = setmetatable({}, {__index = deep_index})
        local function fn_681_(...)
          local case_682_ = select("#", ...)
          if (case_682_ == 0) then
            return rf()
          elseif (case_682_ == 1) then
            local result = ...
            return rf(result)
          elseif (case_682_ == 2) then
            local result, input = ...
            if seen[input] then
              return result
            else
              seen[input] = true
              return rf(result, input)
            end
          else
            local _ = case_682_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_681_"))
          end
        end
        return fn_681_
      end
      return fn_679_
    elseif (case_678_ == 1) then
      local coll = ...
      return seq_2a(lazy.distinct(coll))
    else
      local _ = case_678_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "distinct"))
    end
  end
  v_27_auto = distinct0
  core["distinct"] = v_27_auto
  distinct = v_27_auto
end
local dedupe
do
  local v_27_auto
  local function dedupe0(...)
    local case_686_ = select("#", ...)
    if (case_686_ == 0) then
      local function fn_687_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_687_"))
          else
          end
        end
        local none = {}
        local pv = none
        local function fn_689_(...)
          local case_690_ = select("#", ...)
          if (case_690_ == 0) then
            return rf()
          elseif (case_690_ == 1) then
            local result = ...
            return rf(result)
          elseif (case_690_ == 2) then
            local result, input = ...
            local prior = pv
            pv = input
            if (prior == input) then
              return result
            else
              return rf(result, input)
            end
          else
            local _ = case_690_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_689_"))
          end
        end
        return fn_689_
      end
      return fn_687_
    elseif (case_686_ == 1) then
      local coll = ...
      return core.sequence(dedupe0(), coll)
    else
      local _ = case_686_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "dedupe"))
    end
  end
  v_27_auto = dedupe0
  core["dedupe"] = v_27_auto
  dedupe = v_27_auto
end
local random_sample
do
  local v_27_auto
  local function random_sample0(...)
    local case_694_ = select("#", ...)
    if (case_694_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "random-sample"))
    elseif (case_694_ == 1) then
      local prob = ...
      local function _695_()
        return (math.random() < prob)
      end
      return filter(_695_)
    elseif (case_694_ == 2) then
      local prob, coll = ...
      local function _696_()
        return (math.random() < prob)
      end
      return filter(_696_, coll)
    else
      local _ = case_694_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "random-sample"))
    end
  end
  v_27_auto = random_sample0
  core["random-sample"] = v_27_auto
  random_sample = v_27_auto
end
local doall
do
  local v_27_auto
  local function doall0(...)
    local seq0 = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "doall"))
      else
      end
    end
    return seq_2a(lazy.doall(seq0))
  end
  v_27_auto = doall0
  core["doall"] = v_27_auto
  doall = v_27_auto
end
local dorun
do
  local v_27_auto
  local function dorun0(...)
    local seq0 = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "dorun"))
      else
      end
    end
    return lazy.dorun(seq0)
  end
  v_27_auto = dorun0
  core["dorun"] = v_27_auto
  dorun = v_27_auto
end
local line_seq
do
  local v_27_auto
  local function line_seq0(...)
    local file = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "line-seq"))
      else
      end
    end
    return seq_2a(lazy["line-seq"](file))
  end
  v_27_auto = line_seq0
  core["line-seq"] = v_27_auto
  line_seq = v_27_auto
end
local iterate
do
  local v_27_auto
  local function iterate0(...)
    local f, x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "iterate"))
      else
      end
    end
    return seq_2a(lazy.iterate(f, x))
  end
  v_27_auto = iterate0
  core["iterate"] = v_27_auto
  iterate = v_27_auto
end
local remove
do
  local v_27_auto
  local function remove0(...)
    local case_702_ = select("#", ...)
    if (case_702_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "remove"))
    elseif (case_702_ == 1) then
      local pred = ...
      return filter(complement(pred))
    elseif (case_702_ == 2) then
      local pred, coll = ...
      return seq_2a(lazy.remove(pred, coll))
    else
      local _ = case_702_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "remove"))
    end
  end
  v_27_auto = remove0
  core["remove"] = v_27_auto
  remove = v_27_auto
end
local cycle
do
  local v_27_auto
  local function cycle0(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "cycle"))
      else
      end
    end
    return seq_2a(lazy.cycle(coll))
  end
  v_27_auto = cycle0
  core["cycle"] = v_27_auto
  cycle = v_27_auto
end
local _repeat
do
  local v_27_auto
  local function _repeat0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "repeat"))
      else
      end
    end
    return seq_2a(lazy["repeat"](x))
  end
  v_27_auto = _repeat0
  core["repeat"] = v_27_auto
  _repeat = v_27_auto
end
local repeatedly
do
  local v_27_auto
  local function repeatedly0(...)
    local core_38_auto = require("cljlib")
    local _let_706_ = core_38_auto.list(...)
    local f = _let_706_[1]
    local args = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_706_, 2)
    return seq_2a(apply(lazy.repeatedly, f, args))
  end
  v_27_auto = repeatedly0
  core["repeatedly"] = v_27_auto
  repeatedly = v_27_auto
end
local tree_seq
do
  local v_27_auto
  local function tree_seq0(...)
    local branch_3f, children, root = ...
    do
      local cnt_54_auto = select("#", ...)
      if (3 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "tree-seq"))
      else
      end
    end
    return seq_2a(lazy["tree-seq"](branch_3f, children, root))
  end
  v_27_auto = tree_seq0
  core["tree-seq"] = v_27_auto
  tree_seq = v_27_auto
end
local interleave
do
  local v_27_auto
  local function interleave0(...)
    local case_708_ = select("#", ...)
    if (case_708_ == 0) then
      return seq_2a(lazy.interleave())
    elseif (case_708_ == 1) then
      local s = ...
      return seq_2a(lazy.interleave(s))
    elseif (case_708_ == 2) then
      local s1, s2 = ...
      return seq_2a(lazy.interleave(s1, s2))
    else
      local _ = case_708_
      local core_38_auto = require("cljlib")
      local _let_709_ = core_38_auto.list(...)
      local s1 = _let_709_[1]
      local s2 = _let_709_[2]
      local ss = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_709_, 3)
      return seq_2a(apply(lazy.interleave, s1, s2, ss))
    end
  end
  v_27_auto = interleave0
  core["interleave"] = v_27_auto
  interleave = v_27_auto
end
local interpose
do
  local v_27_auto
  local function interpose0(...)
    local case_711_ = select("#", ...)
    if (case_711_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "interpose"))
    elseif (case_711_ == 1) then
      local sep = ...
      local function fn_712_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_712_"))
          else
          end
        end
        local started = false
        local function fn_714_(...)
          local case_715_ = select("#", ...)
          if (case_715_ == 0) then
            return rf()
          elseif (case_715_ == 1) then
            local result = ...
            return rf(result)
          elseif (case_715_ == 2) then
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
            local _ = case_715_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_714_"))
          end
        end
        return fn_714_
      end
      return fn_712_
    elseif (case_711_ == 2) then
      local separator, coll = ...
      return seq_2a(lazy.interpose(separator, coll))
    else
      local _ = case_711_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "interpose"))
    end
  end
  v_27_auto = interpose0
  core["interpose"] = v_27_auto
  interpose = v_27_auto
end
local halt_when
do
  local v_27_auto
  local function halt_when0(...)
    local case_720_ = select("#", ...)
    if (case_720_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "halt-when"))
    elseif (case_720_ == 1) then
      local pred = ...
      return halt_when0(pred, nil)
    elseif (case_720_ == 2) then
      local pred, retf = ...
      local function fn_721_(...)
        local rf = ...
        do
          local cnt_54_auto = select("#", ...)
          if (1 ~= cnt_54_auto) then
            error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_721_"))
          else
          end
        end
        local halt
        local function _723_()
          return "#<halt>"
        end
        halt = setmetatable({}, {__fennelview = _723_})
        local function fn_724_(...)
          local case_725_ = select("#", ...)
          if (case_725_ == 0) then
            return rf()
          elseif (case_725_ == 1) then
            local result = ...
            if (map_3f(result) and contains_3f(result, halt)) then
              return result.value
            else
              return rf(result)
            end
          elseif (case_725_ == 2) then
            local result, input = ...
            if pred(input) then
              local _727_
              if retf then
                _727_ = retf(rf(result), input)
              else
                _727_ = input
              end
              return core.reduced({[halt] = true, value = _727_})
            else
              return rf(result, input)
            end
          else
            local _ = case_725_
            return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_724_"))
          end
        end
        return fn_724_
      end
      return fn_721_
    else
      local _ = case_720_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "halt-when"))
    end
  end
  v_27_auto = halt_when0
  core["halt-when"] = v_27_auto
  halt_when = v_27_auto
end
local realized_3f
do
  local v_27_auto
  local function realized_3f0(...)
    local s = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "realized?"))
      else
      end
    end
    return lazy["realized?"](s)
  end
  v_27_auto = realized_3f0
  core["realized?"] = v_27_auto
  realized_3f = v_27_auto
end
local keys
do
  local v_27_auto
  local function keys0(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "keys"))
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
  v_27_auto = keys0
  core["keys"] = v_27_auto
  keys = v_27_auto
end
local vals
do
  local v_27_auto
  local function vals0(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "vals"))
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
  v_27_auto = vals0
  core["vals"] = v_27_auto
  vals = v_27_auto
end
local find
do
  local v_27_auto
  local function find0(...)
    local coll, key = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "find"))
      else
      end
    end
    assert((map_3f(coll) or empty_3f(coll)), "expected a map")
    local case_738_ = coll[key]
    if (nil ~= case_738_) then
      local v = case_738_
      return {key, v}
    else
      return nil
    end
  end
  v_27_auto = find0
  core["find"] = v_27_auto
  find = v_27_auto
end
local sort
do
  local v_27_auto
  local function sort0(...)
    local case_740_ = select("#", ...)
    if (case_740_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "sort"))
    elseif (case_740_ == 1) then
      local coll = ...
      local case_741_ = seq(coll)
      if (nil ~= case_741_) then
        local s = case_741_
        return seq(itable.sort(vec(s)))
      else
        local _ = case_741_
        return list()
      end
    elseif (case_740_ == 2) then
      local comparator, coll = ...
      local case_743_ = seq(coll)
      if (nil ~= case_743_) then
        local s = case_743_
        return seq(itable.sort(vec(s), comparator))
      else
        local _ = case_743_
        return list()
      end
    else
      local _ = case_740_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "sort"))
    end
  end
  v_27_auto = sort0
  core["sort"] = v_27_auto
  sort = v_27_auto
end
local reduce
do
  local v_27_auto
  local function reduce0(...)
    local case_747_ = select("#", ...)
    if (case_747_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "reduce"))
    elseif (case_747_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "reduce"))
    elseif (case_747_ == 2) then
      local f, coll = ...
      return lazy.reduce(f, seq(coll))
    elseif (case_747_ == 3) then
      local f, val, coll = ...
      return lazy.reduce(f, val, seq(coll))
    else
      local _ = case_747_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "reduce"))
    end
  end
  v_27_auto = reduce0
  core["reduce"] = v_27_auto
  reduce = v_27_auto
end
local reduced
do
  local v_27_auto
  local function reduced0(...)
    local value = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "reduced"))
      else
      end
    end
    local tmp_9_ = lazy.reduced(value)
    local function _750_(_241)
      return _241:unbox()
    end
    getmetatable(tmp_9_)["cljlib/deref"] = _750_
    return tmp_9_
  end
  v_27_auto = reduced0
  core["reduced"] = v_27_auto
  reduced = v_27_auto
end
local reduced_3f
do
  local v_27_auto
  local function reduced_3f0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "reduced?"))
      else
      end
    end
    return lazy["reduced?"](x)
  end
  v_27_auto = reduced_3f0
  core["reduced?"] = v_27_auto
  reduced_3f = v_27_auto
end
local unreduced
do
  local v_27_auto
  local function unreduced0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "unreduced"))
      else
      end
    end
    if reduced_3f(x) then
      return deref(x)
    else
      return x
    end
  end
  v_27_auto = unreduced0
  core["unreduced"] = v_27_auto
  unreduced = v_27_auto
end
local ensure_reduced
do
  local v_27_auto
  local function ensure_reduced0(...)
    local x = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "ensure-reduced"))
      else
      end
    end
    if reduced_3f(x) then
      return x
    else
      return reduced(x)
    end
  end
  v_27_auto = ensure_reduced0
  core["ensure-reduced"] = v_27_auto
  ensure_reduced = v_27_auto
end
local preserving_reduced
local function preserving_reduced0(...)
  local rf = ...
  do
    local cnt_54_auto = select("#", ...)
    if (1 ~= cnt_54_auto) then
      error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "preserving-reduced"))
    else
    end
  end
  local function fn_757_(...)
    local a, b = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "fn_757_"))
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
  return fn_757_
end
preserving_reduced = preserving_reduced0
local cat
do
  local v_27_auto
  local function cat0(...)
    local rf = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "cat"))
      else
      end
    end
    local rrf = preserving_reduced(rf)
    local function fn_761_(...)
      local case_762_ = select("#", ...)
      if (case_762_ == 0) then
        return rf()
      elseif (case_762_ == 1) then
        local result = ...
        return rf(result)
      elseif (case_762_ == 2) then
        local result, input = ...
        return reduce(rrf, result, input)
      else
        local _ = case_762_
        return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_761_"))
      end
    end
    return fn_761_
  end
  v_27_auto = cat0
  core["cat"] = v_27_auto
  cat = v_27_auto
end
local reduce_kv
do
  local v_27_auto
  local function reduce_kv0(...)
    local f, val, s = ...
    do
      local cnt_54_auto = select("#", ...)
      if (3 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "reduce-kv"))
      else
      end
    end
    if map_3f(s) then
      local function _766_(res, _765_)
        local k = _765_[1]
        local v = _765_[2]
        return f(res, k, v)
      end
      return reduce(_766_, val, seq(s))
    else
      local function _768_(res, _767_)
        local k = _767_[1]
        local v = _767_[2]
        return f(res, k, v)
      end
      return reduce(_768_, val, map(vector, drop(1, range()), seq(s)))
    end
  end
  v_27_auto = reduce_kv0
  core["reduce-kv"] = v_27_auto
  reduce_kv = v_27_auto
end
local completing
do
  local v_27_auto
  local function completing0(...)
    local case_770_ = select("#", ...)
    if (case_770_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "completing"))
    elseif (case_770_ == 1) then
      local f = ...
      return completing0(f, identity)
    elseif (case_770_ == 2) then
      local f, cf = ...
      local function fn_771_(...)
        local case_772_ = select("#", ...)
        if (case_772_ == 0) then
          return f()
        elseif (case_772_ == 1) then
          local x = ...
          return cf(x)
        elseif (case_772_ == 2) then
          local x, y = ...
          return f(x, y)
        else
          local _ = case_772_
          return error(("Wrong number of args (%s) passed to %s"):format(_, "fn_771_"))
        end
      end
      return fn_771_
    else
      local _ = case_770_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "completing"))
    end
  end
  v_27_auto = completing0
  core["completing"] = v_27_auto
  completing = v_27_auto
end
local transduce
do
  local v_27_auto
  local function transduce0(...)
    local case_778_ = select("#", ...)
    if (case_778_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "transduce"))
    elseif (case_778_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "transduce"))
    elseif (case_778_ == 2) then
      return error(("Wrong number of args (%s) passed to %s"):format(2, "transduce"))
    elseif (case_778_ == 3) then
      local xform, f, coll = ...
      return transduce0(xform, f, f(), coll)
    elseif (case_778_ == 4) then
      local xform, f, init, coll = ...
      local f0 = xform(f)
      return f0(reduce(f0, init, seq(coll)))
    else
      local _ = case_778_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "transduce"))
    end
  end
  v_27_auto = transduce0
  core["transduce"] = v_27_auto
  transduce = v_27_auto
end
local sequence
do
  local v_27_auto
  local function sequence0(...)
    local case_780_ = select("#", ...)
    if (case_780_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "sequence"))
    elseif (case_780_ == 1) then
      local coll = ...
      if seq_3f(coll) then
        return coll
      else
        return (seq(coll) or list())
      end
    elseif (case_780_ == 2) then
      local xform, coll = ...
      local f
      local function _782_(_241, _242)
        return cons(_242, _241)
      end
      f = xform(completing(_782_))
      local function step(coll0)
        local val_100_auto = seq(coll0)
        if (nil ~= val_100_auto) then
          local s = val_100_auto
          local res = f(nil, first(s))
          if reduced_3f(res) then
            return f(deref(res))
          elseif seq_3f(res) then
            local function _783_()
              return step(rest(s))
            end
            return concat(res, lazy_seq_2a(_783_))
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
      local _ = case_780_
      local core_38_auto = require("cljlib")
      local _let_786_ = core_38_auto.list(...)
      local xform = _let_786_[1]
      local coll = _let_786_[2]
      local colls = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_786_, 3)
      local f
      local function _787_(_241, _242)
        return cons(_242, _241)
      end
      f = xform(completing(_787_))
      local function step(colls0)
        if every_3f(seq, colls0) then
          local res = apply(f, nil, map(first, colls0))
          if reduced_3f(res) then
            return f(deref(res))
          elseif seq_3f(res) then
            local function _788_()
              return step(map(rest, colls0))
            end
            return concat(res, lazy_seq_2a(_788_))
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
  v_27_auto = sequence0
  core["sequence"] = v_27_auto
  sequence = v_27_auto
end
local function map__3etransient(immutable)
  local function _792_(map0)
    local removed = setmetatable({}, {__index = deep_index})
    local function _793_(_, k)
      if not removed[k] then
        return map0[k]
      else
        return nil
      end
    end
    local function _795_()
      return error("can't `conj` onto transient map, use `conj!`")
    end
    local function _796_()
      return error("can't `assoc` onto transient map, use `assoc!`")
    end
    local function _797_()
      return error("can't `dissoc` onto transient map, use `dissoc!`")
    end
    local function _799_(tmap, _798_)
      local k = _798_[1]
      local v = _798_[2]
      if (nil == v) then
        removed[k] = true
      else
        removed[k] = nil
      end
      tmap[k] = v
      return tmap
    end
    local function _801_(tmap, ...)
      for i = 1, select("#", ...), 2 do
        local k, v = select(i, ...)
        tmap[k] = v
        if (nil == v) then
          removed[k] = true
        else
          removed[k] = nil
        end
      end
      return tmap
    end
    local function _803_(tmap, ...)
      for i = 1, select("#", ...) do
        local k = select(i, ...)
        tmap[k] = nil
        removed[k] = true
      end
      return tmap
    end
    local function _804_(tmap)
      local t
      do
        local tbl_21_
        do
          local tbl_21_0 = {}
          for k, v in pairs(map0) do
            local k_22_, v_23_ = k, v
            if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
              tbl_21_0[k_22_] = v_23_
            else
            end
          end
          tbl_21_ = tbl_21_0
        end
        for k, v in pairs(tmap) do
          local k_22_, v_23_ = k, v
          if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
            tbl_21_[k_22_] = v_23_
          else
          end
        end
        t = tbl_21_
      end
      for k in pairs(removed) do
        t[k] = nil
      end
      local function _807_()
        local tbl_26_ = {}
        local i_27_ = 0
        for k in pairs_2a(tmap) do
          local val_28_ = k
          if (nil ~= val_28_) then
            i_27_ = (i_27_ + 1)
            tbl_26_[i_27_] = val_28_
          else
          end
        end
        return tbl_26_
      end
      for _, k in ipairs(_807_()) do
        tmap[k] = nil
      end
      local function _809_()
        return error("attempt to use transient after it was persistet")
      end
      local function _810_()
        return error("attempt to use transient after it was persistet")
      end
      setmetatable(tmap, {__index = _809_, __newindex = _810_})
      return immutable(itable(t))
    end
    return setmetatable({}, {__index = _793_, ["cljlib/type"] = "transient", ["cljlib/conj"] = _795_, ["cljlib/assoc"] = _796_, ["cljlib/dissoc"] = _797_, ["cljlib/conj!"] = _799_, ["cljlib/assoc!"] = _801_, ["cljlib/dissoc!"] = _803_, ["cljlib/persistent!"] = _804_})
  end
  return _792_
end
local function hash_map_2a(x)
  do
    local case_811_ = getmetatable(x)
    if (nil ~= case_811_) then
      local mt = case_811_
      mt["cljlib/type"] = "hash-map"
      mt["cljlib/editable"] = true
      local function _813_(t, _812_, ...)
        local k = _812_[1]
        local v = _812_[2]
        local function _814_(...)
          local kvs = {}
          for _, _815_ in ipairs_2a({...}) do
            local k0 = _815_[1]
            local v0 = _815_[2]
            table.insert(kvs, k0)
            table.insert(kvs, v0)
            kvs = kvs
          end
          return kvs
        end
        return apply(core.assoc, t, k, v, _814_(...))
      end
      mt["cljlib/conj"] = _813_
      mt["cljlib/transient"] = map__3etransient(hash_map_2a)
      local function _816_()
        return hash_map_2a(itable({}))
      end
      mt["cljlib/empty"] = _816_
    else
      local _ = case_811_
      hash_map_2a(setmetatable(x, {}))
    end
  end
  return x
end
local assoc
do
  local v_27_auto
  local function assoc0(...)
    local case_820_ = select("#", ...)
    if (case_820_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "assoc"))
    elseif (case_820_ == 1) then
      local tbl = ...
      return hash_map_2a(itable({}))
    elseif (case_820_ == 2) then
      return error(("Wrong number of args (%s) passed to %s"):format(2, "assoc"))
    elseif (case_820_ == 3) then
      local tbl, k, v = ...
      assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map")
      assert(not nil_3f(k), "attempt to use nil as key")
      return hash_map_2a(itable.assoc((tbl or {}), k, v))
    else
      local _ = case_820_
      local core_38_auto = require("cljlib")
      local _let_821_ = core_38_auto.list(...)
      local tbl = _let_821_[1]
      local k = _let_821_[2]
      local v = _let_821_[3]
      local kvs = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_821_, 4)
      assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map")
      assert(not nil_3f(k), "attempt to use nil as key")
      return hash_map_2a(apply(itable.assoc, (tbl or {}), k, v, kvs))
    end
  end
  v_27_auto = assoc0
  core["assoc"] = v_27_auto
  assoc = v_27_auto
end
local assoc_in
do
  local v_27_auto
  local function assoc_in0(...)
    local tbl, key_seq, val = ...
    do
      local cnt_54_auto = select("#", ...)
      if (3 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "assoc-in"))
      else
      end
    end
    assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map or nil")
    return hash_map_2a(itable["assoc-in"](tbl, key_seq, val))
  end
  v_27_auto = assoc_in0
  core["assoc-in"] = v_27_auto
  assoc_in = v_27_auto
end
local update
do
  local v_27_auto
  local function update0(...)
    local tbl, key, f = ...
    do
      local cnt_54_auto = select("#", ...)
      if (3 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "update"))
      else
      end
    end
    assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map")
    return hash_map_2a(itable.update(tbl, key, f))
  end
  v_27_auto = update0
  core["update"] = v_27_auto
  update = v_27_auto
end
local update_in
do
  local v_27_auto
  local function update_in0(...)
    local tbl, key_seq, f = ...
    do
      local cnt_54_auto = select("#", ...)
      if (3 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "update-in"))
      else
      end
    end
    assert((nil_3f(tbl) or map_3f(tbl) or empty_3f(tbl)), "expected a map or nil")
    return hash_map_2a(itable["update-in"](tbl, key_seq, f))
  end
  v_27_auto = update_in0
  core["update-in"] = v_27_auto
  update_in = v_27_auto
end
local hash_map
do
  local v_27_auto
  local function hash_map0(...)
    local core_38_auto = require("cljlib")
    local _let_826_ = core_38_auto.list(...)
    local kvs = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_826_, 1)
    return apply(assoc, {}, kvs)
  end
  v_27_auto = hash_map0
  core["hash-map"] = v_27_auto
  hash_map = v_27_auto
end
local get
do
  local v_27_auto
  local function get0(...)
    local case_828_ = select("#", ...)
    if (case_828_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "get"))
    elseif (case_828_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "get"))
    elseif (case_828_ == 2) then
      local tbl, key = ...
      return get0(tbl, key, nil)
    elseif (case_828_ == 3) then
      local tbl, key, not_found = ...
      assert((map_3f(tbl) or empty_3f(tbl)), "expected a map")
      return (tbl[key] or not_found)
    else
      local _ = case_828_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "get"))
    end
  end
  v_27_auto = get0
  core["get"] = v_27_auto
  get = v_27_auto
end
local get_in
do
  local v_27_auto
  local function get_in0(...)
    local case_831_ = select("#", ...)
    if (case_831_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "get-in"))
    elseif (case_831_ == 1) then
      return error(("Wrong number of args (%s) passed to %s"):format(1, "get-in"))
    elseif (case_831_ == 2) then
      local tbl, keys0 = ...
      return get_in0(tbl, keys0, nil)
    elseif (case_831_ == 3) then
      local tbl, keys0, not_found = ...
      assert((map_3f(tbl) or empty_3f(tbl)), "expected a map")
      local res, t, done = tbl, tbl, nil
      for _, k in ipairs_2a(keys0) do
        if done then break end
        local case_832_ = t[k]
        if (nil ~= case_832_) then
          local v = case_832_
          res, t = v, v
        else
          local _0 = case_832_
          res, done = not_found, true
        end
      end
      return res
    else
      local _ = case_831_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "get-in"))
    end
  end
  v_27_auto = get_in0
  core["get-in"] = v_27_auto
  get_in = v_27_auto
end
local dissoc
do
  local v_27_auto
  local function dissoc0(...)
    local case_835_ = select("#", ...)
    if (case_835_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "dissoc"))
    elseif (case_835_ == 1) then
      local tbl = ...
      return tbl
    elseif (case_835_ == 2) then
      local tbl, key = ...
      assert((map_3f(tbl) or empty_3f(tbl)), "expected a map")
      local function _836_(...)
        tbl[key] = nil
        return tbl
      end
      return hash_map_2a(_836_(...))
    else
      local _ = case_835_
      local core_38_auto = require("cljlib")
      local _let_837_ = core_38_auto.list(...)
      local tbl = _let_837_[1]
      local key = _let_837_[2]
      local keys0 = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_837_, 3)
      return apply(dissoc0, dissoc0(tbl, key), keys0)
    end
  end
  v_27_auto = dissoc0
  core["dissoc"] = v_27_auto
  dissoc = v_27_auto
end
local merge
do
  local v_27_auto
  local function merge0(...)
    local core_38_auto = require("cljlib")
    local _let_839_ = core_38_auto.list(...)
    local maps = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_839_, 1)
    if some(identity, maps) then
      local function _840_(a, b)
        local tbl_21_ = a
        for k, v in pairs_2a(b) do
          local k_22_, v_23_ = k, v
          if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
            tbl_21_[k_22_] = v_23_
          else
          end
        end
        return tbl_21_
      end
      return hash_map_2a(itable(reduce(_840_, {}, maps)))
    else
      return nil
    end
  end
  v_27_auto = merge0
  core["merge"] = v_27_auto
  merge = v_27_auto
end
local frequencies
do
  local v_27_auto
  local function frequencies0(...)
    local t = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "frequencies"))
      else
      end
    end
    return hash_map_2a(itable.frequencies(t))
  end
  v_27_auto = frequencies0
  core["frequencies"] = v_27_auto
  frequencies = v_27_auto
end
local group_by
do
  local v_27_auto
  local function group_by0(...)
    local f, t = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "group-by"))
      else
      end
    end
    return hash_map_2a((itable["group-by"](f, t)))
  end
  v_27_auto = group_by0
  core["group-by"] = v_27_auto
  group_by = v_27_auto
end
local zipmap
do
  local v_27_auto
  local function zipmap0(...)
    local keys0, vals0 = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "zipmap"))
      else
      end
    end
    return hash_map_2a(itable(lazy.zipmap(keys0, vals0)))
  end
  v_27_auto = zipmap0
  core["zipmap"] = v_27_auto
  zipmap = v_27_auto
end
local replace
do
  local v_27_auto
  local function replace0(...)
    local case_846_ = select("#", ...)
    if (case_846_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "replace"))
    elseif (case_846_ == 1) then
      local smap = ...
      local function _847_(_241)
        local val_96_auto = find(smap, _241)
        if val_96_auto then
          local e = val_96_auto
          return e[2]
        else
          return _241
        end
      end
      return map(_847_)
    elseif (case_846_ == 2) then
      local smap, coll = ...
      if vector_3f(coll) then
        local function _849_(res, v)
          local val_96_auto = find(smap, v)
          if val_96_auto then
            local e = val_96_auto
            table.insert(res, e[2])
            return res
          else
            table.insert(res, v)
            return res
          end
        end
        return vec_2a(itable(reduce(_849_, {}, coll)))
      else
        local function _851_(_241)
          local val_96_auto = find(smap, _241)
          if val_96_auto then
            local e = val_96_auto
            return e[2]
          else
            return _241
          end
        end
        return map(_851_, coll)
      end
    else
      local _ = case_846_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "replace"))
    end
  end
  v_27_auto = replace0
  core["replace"] = v_27_auto
  replace = v_27_auto
end
local conj
do
  local v_27_auto
  local function conj0(...)
    local case_855_ = select("#", ...)
    if (case_855_ == 0) then
      return vector()
    elseif (case_855_ == 1) then
      local s = ...
      return s
    elseif (case_855_ == 2) then
      local s, x = ...
      local case_856_ = getmetatable(s)
      if ((_G.type(case_856_) == "table") and (nil ~= case_856_["cljlib/conj"])) then
        local f = case_856_["cljlib/conj"]
        return f(s, x)
      else
        local _ = case_856_
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
      local _ = case_855_
      local core_38_auto = require("cljlib")
      local _let_859_ = core_38_auto.list(...)
      local s = _let_859_[1]
      local x = _let_859_[2]
      local xs = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_859_, 3)
      return apply(conj0, conj0(s, x), xs)
    end
  end
  v_27_auto = conj0
  core["conj"] = v_27_auto
  conj = v_27_auto
end
local disj
do
  local v_27_auto
  local function disj0(...)
    local case_861_ = select("#", ...)
    if (case_861_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "disj"))
    elseif (case_861_ == 1) then
      local Set = ...
      return Set
    elseif (case_861_ == 2) then
      local Set, key = ...
      local case_862_ = getmetatable(Set)
      if ((_G.type(case_862_) == "table") and (case_862_["cljlib/type"] == "hash-set") and (nil ~= case_862_["cljlib/disj"])) then
        local f = case_862_["cljlib/disj"]
        return f(Set, key)
      else
        local _ = case_862_
        return error(("disj is not supported on " .. class(Set)), 2)
      end
    else
      local _ = case_861_
      local core_38_auto = require("cljlib")
      local _let_864_ = core_38_auto.list(...)
      local Set = _let_864_[1]
      local key = _let_864_[2]
      local keys0 = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_864_, 3)
      local case_865_ = getmetatable(Set)
      if ((_G.type(case_865_) == "table") and (case_865_["cljlib/type"] == "hash-set") and (nil ~= case_865_["cljlib/disj"])) then
        local f = case_865_["cljlib/disj"]
        return apply(f, Set, key, keys0)
      else
        local _0 = case_865_
        return error(("disj is not supported on " .. class(Set)), 2)
      end
    end
  end
  v_27_auto = disj0
  core["disj"] = v_27_auto
  disj = v_27_auto
end
local pop
do
  local v_27_auto
  local function pop0(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "pop"))
      else
      end
    end
    local case_869_ = getmetatable(coll)
    if ((_G.type(case_869_) == "table") and (case_869_["cljlib/type"] == "seq")) then
      local case_870_ = seq(coll)
      if (nil ~= case_870_) then
        local s = case_870_
        return drop(1, s)
      else
        local _ = case_870_
        return error("can't pop empty list", 2)
      end
    elseif ((_G.type(case_869_) == "table") and (nil ~= case_869_["cljlib/pop"])) then
      local f = case_869_["cljlib/pop"]
      return f(coll)
    else
      local _ = case_869_
      return error(("pop is not supported on " .. class(coll)), 2)
    end
  end
  v_27_auto = pop0
  core["pop"] = v_27_auto
  pop = v_27_auto
end
local transient
do
  local v_27_auto
  local function transient0(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "transient"))
      else
      end
    end
    local case_874_ = getmetatable(coll)
    if ((_G.type(case_874_) == "table") and (case_874_["cljlib/editable"] == true) and (nil ~= case_874_["cljlib/transient"])) then
      local f = case_874_["cljlib/transient"]
      return f(coll)
    else
      local _ = case_874_
      return error("expected editable collection", 2)
    end
  end
  v_27_auto = transient0
  core["transient"] = v_27_auto
  transient = v_27_auto
end
local conj_21
do
  local v_27_auto
  local function conj_210(...)
    local case_876_ = select("#", ...)
    if (case_876_ == 0) then
      return transient(vec_2a({}))
    elseif (case_876_ == 1) then
      local coll = ...
      return coll
    elseif (case_876_ == 2) then
      local coll, x = ...
      do
        local case_877_ = getmetatable(coll)
        if ((_G.type(case_877_) == "table") and (case_877_["cljlib/type"] == "transient") and (nil ~= case_877_["cljlib/conj!"])) then
          local f = case_877_["cljlib/conj!"]
          f(coll, x)
        elseif ((_G.type(case_877_) == "table") and (case_877_["cljlib/type"] == "transient")) then
          error("unsupported transient operation", 2)
        else
          local _ = case_877_
          error("expected transient collection", 2)
        end
      end
      return coll
    else
      local _ = case_876_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "conj!"))
    end
  end
  v_27_auto = conj_210
  core["conj!"] = v_27_auto
  conj_21 = v_27_auto
end
local assoc_21
do
  local v_27_auto
  local function assoc_210(...)
    local core_38_auto = require("cljlib")
    local _let_880_ = core_38_auto.list(...)
    local map0 = _let_880_[1]
    local k = _let_880_[2]
    local ks = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_880_, 3)
    do
      local case_881_ = getmetatable(map0)
      if ((_G.type(case_881_) == "table") and (case_881_["cljlib/type"] == "transient") and (nil ~= case_881_["cljlib/dissoc!"])) then
        local f = case_881_["cljlib/dissoc!"]
        apply(f, map0, k, ks)
      elseif ((_G.type(case_881_) == "table") and (case_881_["cljlib/type"] == "transient")) then
        error("unsupported transient operation", 2)
      else
        local _ = case_881_
        error("expected transient collection", 2)
      end
    end
    return map0
  end
  v_27_auto = assoc_210
  core["assoc!"] = v_27_auto
  assoc_21 = v_27_auto
end
local dissoc_21
do
  local v_27_auto
  local function dissoc_210(...)
    local core_38_auto = require("cljlib")
    local _let_883_ = core_38_auto.list(...)
    local map0 = _let_883_[1]
    local k = _let_883_[2]
    local ks = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_883_, 3)
    do
      local case_884_ = getmetatable(map0)
      if ((_G.type(case_884_) == "table") and (case_884_["cljlib/type"] == "transient") and (nil ~= case_884_["cljlib/dissoc!"])) then
        local f = case_884_["cljlib/dissoc!"]
        apply(f, map0, k, ks)
      elseif ((_G.type(case_884_) == "table") and (case_884_["cljlib/type"] == "transient")) then
        error("unsupported transient operation", 2)
      else
        local _ = case_884_
        error("expected transient collection", 2)
      end
    end
    return map0
  end
  v_27_auto = dissoc_210
  core["dissoc!"] = v_27_auto
  dissoc_21 = v_27_auto
end
local disj_21
do
  local v_27_auto
  local function disj_210(...)
    local case_886_ = select("#", ...)
    if (case_886_ == 0) then
      return error(("Wrong number of args (%s) passed to %s"):format(0, "disj!"))
    elseif (case_886_ == 1) then
      local Set = ...
      return Set
    else
      local _ = case_886_
      local core_38_auto = require("cljlib")
      local _let_887_ = core_38_auto.list(...)
      local Set = _let_887_[1]
      local key = _let_887_[2]
      local ks = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_887_, 3)
      local case_888_ = getmetatable(Set)
      if ((_G.type(case_888_) == "table") and (case_888_["cljlib/type"] == "transient") and (nil ~= case_888_["cljlib/disj!"])) then
        local f = case_888_["cljlib/disj!"]
        return apply(f, Set, key, ks)
      elseif ((_G.type(case_888_) == "table") and (case_888_["cljlib/type"] == "transient")) then
        return error("unsupported transient operation", 2)
      else
        local _0 = case_888_
        return error("expected transient collection", 2)
      end
    end
  end
  v_27_auto = disj_210
  core["disj!"] = v_27_auto
  disj_21 = v_27_auto
end
local pop_21
do
  local v_27_auto
  local function pop_210(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "pop!"))
      else
      end
    end
    local case_892_ = getmetatable(coll)
    if ((_G.type(case_892_) == "table") and (case_892_["cljlib/type"] == "transient") and (nil ~= case_892_["cljlib/pop!"])) then
      local f = case_892_["cljlib/pop!"]
      return f(coll)
    elseif ((_G.type(case_892_) == "table") and (case_892_["cljlib/type"] == "transient")) then
      return error("unsupported transient operation", 2)
    else
      local _ = case_892_
      return error("expected transient collection", 2)
    end
  end
  v_27_auto = pop_210
  core["pop!"] = v_27_auto
  pop_21 = v_27_auto
end
local persistent_21
do
  local v_27_auto
  local function persistent_210(...)
    local coll = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "persistent!"))
      else
      end
    end
    local case_895_ = getmetatable(coll)
    if ((_G.type(case_895_) == "table") and (case_895_["cljlib/type"] == "transient") and (nil ~= case_895_["cljlib/persistent!"])) then
      local f = case_895_["cljlib/persistent!"]
      return f(coll)
    else
      local _ = case_895_
      return error("expected transient collection", 2)
    end
  end
  v_27_auto = persistent_210
  core["persistent!"] = v_27_auto
  persistent_21 = v_27_auto
end
local into
do
  local v_27_auto
  local function into0(...)
    local case_897_ = select("#", ...)
    if (case_897_ == 0) then
      return vector()
    elseif (case_897_ == 1) then
      local to = ...
      return to
    elseif (case_897_ == 2) then
      local to, from = ...
      local case_898_ = getmetatable(to)
      if ((_G.type(case_898_) == "table") and (case_898_["cljlib/editable"] == true)) then
        return persistent_21(reduce(conj_21, transient(to), from))
      else
        local _ = case_898_
        return reduce(conj, to, from)
      end
    elseif (case_897_ == 3) then
      local to, xform, from = ...
      local case_900_ = getmetatable(to)
      if ((_G.type(case_900_) == "table") and (case_900_["cljlib/editable"] == true)) then
        return persistent_21(transduce(xform, conj_21, transient(to), from))
      else
        local _ = case_900_
        return transduce(xform, conj, to, from)
      end
    else
      local _ = case_897_
      return error(("Wrong number of args (%s) passed to %s"):format(_, "into"))
    end
  end
  v_27_auto = into0
  core["into"] = v_27_auto
  into = v_27_auto
end
local function viewset(Set, view, inspector, indent)
  if inspector.seen[Set] then
    return ("@set" .. inspector.seen[Set] .. "{...}")
  else
    local prefix
    local _903_
    if inspector["visible-cycle?"](Set) then
      _903_ = inspector.seen[Set]
    else
      _903_ = ""
    end
    prefix = ("@set" .. _903_ .. "{")
    local set_indent = #prefix
    local indent_str = string.rep(" ", set_indent)
    local lines
    do
      local tbl_26_ = {}
      local i_27_ = 0
      for v in pairs_2a(Set) do
        local val_28_ = (indent_str .. view(v, inspector, (indent + set_indent), true))
        if (nil ~= val_28_) then
          i_27_ = (i_27_ + 1)
          tbl_26_[i_27_] = val_28_
        else
        end
      end
      lines = tbl_26_
    end
    lines[1] = (prefix .. string.gsub((lines[1] or ""), "^%s+", ""))
    lines[#lines] = (lines[#lines] .. "}")
    return lines
  end
end
local function hash_set__3etransient(immutable)
  local function _907_(hset)
    local removed = setmetatable({}, {__index = deep_index})
    local function _908_(_, k)
      if not removed[k] then
        return hset[k]
      else
        return nil
      end
    end
    local function _910_()
      return error("can't `conj` onto transient set, use `conj!`")
    end
    local function _911_()
      return error("can't `disj` a transient set, use `disj!`")
    end
    local function _912_()
      return error("can't `assoc` onto transient set, use `assoc!`")
    end
    local function _913_()
      return error("can't `dissoc` onto transient set, use `dissoc!`")
    end
    local function _914_(thset, v)
      if (nil == v) then
        removed[v] = true
      else
        removed[v] = nil
      end
      thset[v] = v
      return thset
    end
    local function _916_()
      return error("can't `dissoc!` a transient set")
    end
    local function _917_(thset, ...)
      for i = 1, select("#", ...) do
        local k = select(i, ...)
        thset[k] = nil
        removed[k] = true
      end
      return thset
    end
    local function _918_(thset)
      local t
      do
        local tbl_21_
        do
          local tbl_21_0 = {}
          for k, v in pairs(hset) do
            local k_22_, v_23_ = k, v
            if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
              tbl_21_0[k_22_] = v_23_
            else
            end
          end
          tbl_21_ = tbl_21_0
        end
        for k, v in pairs(thset) do
          local k_22_, v_23_ = k, v
          if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
            tbl_21_[k_22_] = v_23_
          else
          end
        end
        t = tbl_21_
      end
      for k in pairs(removed) do
        t[k] = nil
      end
      local function _921_()
        local tbl_26_ = {}
        local i_27_ = 0
        for k in pairs_2a(thset) do
          local val_28_ = k
          if (nil ~= val_28_) then
            i_27_ = (i_27_ + 1)
            tbl_26_[i_27_] = val_28_
          else
          end
        end
        return tbl_26_
      end
      for _, k in ipairs(_921_()) do
        thset[k] = nil
      end
      local function _923_()
        return error("attempt to use transient after it was persistet")
      end
      local function _924_()
        return error("attempt to use transient after it was persistet")
      end
      setmetatable(thset, {__index = _923_, __newindex = _924_})
      return immutable(itable(t))
    end
    return setmetatable({}, {__index = _908_, ["cljlib/type"] = "transient", ["cljlib/conj"] = _910_, ["cljlib/disj"] = _911_, ["cljlib/assoc"] = _912_, ["cljlib/dissoc"] = _913_, ["cljlib/conj!"] = _914_, ["cljlib/assoc!"] = _916_, ["cljlib/disj!"] = _917_, ["cljlib/persistent!"] = _918_})
  end
  return _907_
end
local function hash_set_2a(x)
  do
    local case_925_ = getmetatable(x)
    if (nil ~= case_925_) then
      local mt = case_925_
      mt["cljlib/type"] = "hash-set"
      local function _926_(s, v, ...)
        local function _927_(...)
          local res = {}
          for _, v0 in ipairs({...}) do
            table.insert(res, v0)
            table.insert(res, v0)
          end
          return res
        end
        return hash_set_2a(itable.assoc(s, v, v, unpack_2a(_927_(...))))
      end
      mt["cljlib/conj"] = _926_
      local function _928_(s, k, ...)
        local to_remove
        do
          local tbl_21_ = setmetatable({[k] = true}, {__index = deep_index})
          for _, k0 in ipairs({...}) do
            local k_22_, v_23_ = k0, true
            if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
              tbl_21_[k_22_] = v_23_
            else
            end
          end
          to_remove = tbl_21_
        end
        local function _930_(...)
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
        return hash_set_2a(itable.assoc({}, unpack_2a(_930_(...))))
      end
      mt["cljlib/disj"] = _928_
      local function _932_()
        return hash_set_2a(itable({}))
      end
      mt["cljlib/empty"] = _932_
      mt["cljlib/editable"] = true
      mt["cljlib/transient"] = hash_set__3etransient(hash_set_2a)
      local function _933_(s)
        local function _934_(_241)
          if vector_3f(_241) then
            return _241[1]
          else
            return _241
          end
        end
        return map(_934_, s)
      end
      mt["cljlib/seq"] = _933_
      mt["__fennelview"] = viewset
      local function _936_(s, i)
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
      mt["__fennelrest"] = _936_
    else
      local _ = case_925_
      hash_set_2a(setmetatable(x, {}))
    end
  end
  return x
end
local hash_set
do
  local v_27_auto
  local function hash_set0(...)
    local core_38_auto = require("cljlib")
    local _let_939_ = core_38_auto.list(...)
    local xs = (function (t, k) return ((getmetatable(t) or {}).__fennelrest or function (t, k) return {(table.unpack or unpack)(t, k)} end)(t, k) end)(_let_939_, 1)
    local Set
    do
      local tbl_21_ = setmetatable({}, {__newindex = deep_newindex})
      for _, val in pairs_2a(xs) do
        local k_22_, v_23_ = val, val
        if ((k_22_ ~= nil) and (v_23_ ~= nil)) then
          tbl_21_[k_22_] = v_23_
        else
        end
      end
      Set = tbl_21_
    end
    return hash_set_2a(itable(Set))
  end
  v_27_auto = hash_set0
  core["hash-set"] = v_27_auto
  hash_set = v_27_auto
end
local multifn_3f
do
  local v_27_auto
  local function multifn_3f0(...)
    local mf = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "multifn?"))
      else
      end
    end
    local case_942_ = getmetatable(mf)
    if ((_G.type(case_942_) == "table") and (case_942_["cljlib/type"] == "multifn")) then
      return true
    else
      local _ = case_942_
      return false
    end
  end
  v_27_auto = multifn_3f0
  core["multifn?"] = v_27_auto
  multifn_3f = v_27_auto
end
local remove_method
do
  local v_27_auto
  local function remove_method0(...)
    local multimethod, dispatch_value = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "remove-method"))
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
  v_27_auto = remove_method0
  core["remove-method"] = v_27_auto
  remove_method = v_27_auto
end
local remove_all_methods
do
  local v_27_auto
  local function remove_all_methods0(...)
    local multimethod = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "remove-all-methods"))
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
  v_27_auto = remove_all_methods0
  core["remove-all-methods"] = v_27_auto
  remove_all_methods = v_27_auto
end
local methods
do
  local v_27_auto
  local function methods0(...)
    local multimethod = ...
    do
      local cnt_54_auto = select("#", ...)
      if (1 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "methods"))
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
  v_27_auto = methods0
  core["methods"] = v_27_auto
  methods = v_27_auto
end
local get_method
do
  local v_27_auto
  local function get_method0(...)
    local multimethod, dispatch_value = ...
    do
      local cnt_54_auto = select("#", ...)
      if (2 ~= cnt_54_auto) then
        error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "get-method"))
      else
      end
    end
    if multifn_3f(multimethod) then
      return (multimethod[dispatch_value] or multimethod.default)
    else
      return error((tostring(multimethod) .. " is not a multifn"), 2)
    end
  end
  v_27_auto = get_method0
  core["get-method"] = v_27_auto
  get_method = v_27_auto
end
return core
