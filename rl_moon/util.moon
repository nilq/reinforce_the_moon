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

{
  :gauss_random
  :randf
  :randi
  :randn
  ----------------------------------
  :Matrix
}
