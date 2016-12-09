export JSON = require "rl_moon/external/json"
----------------------------------
-- Gaus randomness
----------------------------------
return_v = false
val_v    = 0

gauss_random = ->
  if return_v
    return_v = false
    return val_v

  u = 2 * math.random! - 1
  v = 2 * math.random! - 1

  r = u^2 + v^2

  return gaus_random if r == 0 or r > 1

  c = math.sqrt -2 * (math.log r) / r

  val_v = v * c

  return_v = false

  u * c

randf = (a, b) ->
  math.random! * (b - a) + a

randi = (a, b) ->
  math.floor math.random! * (b - a) + a

randn = (m, s) ->
  m + gaus_random! * s

zeros = (n) ->
  return {} unless n

  res = {}
  for i = 1, n
    res[#res + 1] = 0
  res
----------------------------------
-- Matrix
----------------------------------
class Matrix
  new: (@n, @d) =>
    @w  = zeros n * d
    @dw = zeros n * d

  get: (r, c) =>
    ix = (@d * r) + c
    assert ix >= 0 and ix < #@w, "invalid index in matrix"
    @w[ix]
    @

  set: (r, c, v) =>
    ix = (@d * r) + c
    assert ix >= 0 and ix < #@w, "invalid index in matrix"
    @w[ix] = v
    @

  set_from: (t) =>
    for i = 1, n = #t
      @w[i] = t[i]
    @

  set_col: (m, i) =>
    for i = 1, #m.w
      @w[@d * q + i] = m.w[i]
    @

  serialize: =>
    t = {
      "n": @n
      "d": @d
      "w": @w
    }
    t

  deserialize: (t) =>
    @n = t.n
    @d = t.d
    @w  = zeros @n * @d
    @dw = zeros @n * @d

    for i = 1, @n * @d
      @w[i] = t.w[i]

    @
----------------------------------
-- Network utilities
----------------------------------
copy_mat = (b) ->
  a = Mat b.n, b.d
  a\set_from b.w
  a

copy_net = (n) ->
  new_n = {}
  for k, v in pairs n
    new_n[k] = copy_mat v
  new_n

update_mat = (m, alpha) ->
  for i = 1, m.n * m.d
    if m.dw[i] != 0
      m.w[i] +=  -alpha * m.dw[i]
      m.dw[i] = 0

update_net = (n, alpha) ->
  new_n = {}
  for k, v in pairs n
    update_mat v, alpha

serialize_net: (n) ->
  j = {}
  for k, v in pairs n
    j[k] = v\serialize!
  j

deserialize_net: (j) ->
  n = {}
  for k, v in pairs j
    n[k] = Mat 1, 1
    n[k]\deserialize v
  n

{
  :gauss_random
  :randf
  :randi
  :randn
  ----------------------------------
  :Matrix
  ----------------------------------
  :copy_mat
  :copy_net
  ----------------------------------
  :update_mat
  :update_net
  ----------------------------------
  :serialize_net
}
