import p5 from 'p5'
s = null
export default class Firefly
  constructor: (instance, speed, shareAmt, decayRate, perception, chargeRate, index) ->
    s = instance
    # @pos = s.createVector s.random(s.width), s.random(s.height)
    xoff = s.noise(index) * 500
    yoff = s.noise(index + 100) * 500
    @pos = s.createVector  xoff, yoff
    @vel = p5.Vector.random2D()
    @vel.setMag speed
    @acc = s.createVector()
    @speed = speed
    @charge = s.random 0, 100
    @chargeRate = chargeRate
    @shareAmt = shareAmt
    @decayRate = decayRate
    @perception = perception
    @maxCharge = 100
    @state = 'charging'
    @x = @pos.x
    @y = @pos.y
    @i = index
    @time = 0
    @flip = 1

  move: () ->
    @chargeUp()
    @x = @pos.x
    @y = @pos.y
    @acc.limit (1)
    @vel.add @acc
    @vel.limit @speed
    @pos.add @vel
    @wrap()

  chargeUp: () ->
    if @state is 'charging' then @charge += @chargeRate
    else if @state is 'discharging' then @charge -= @decayRate
     
    if @charge >= @maxCharge
      @charge = @maxCharge
      @state = 'share'
    if @charge <= 0
      @charge = 0
      @state = 'charging'

  share: (tree) ->
    @state = 'discharging'
    colliding = tree.colliding @pos, (fly1, fly2) =>
      distVec = p5.Vector.sub(fly1, fly2.pos)
      fly2.distance = distVec.mag()
      fly2.distance < @perception
    add = (fly) =>
      # fly.charge += @shareAmt / (fly.distance * 0.1)
      fly.charge += @shareAmt
    add fly for fly in colliding when fly.state is 'charging'

  flock: (tree) ->
    align = s.createVector()
    cohesion = s.createVector()
    separation = s.createVector()

    colliding = tree.colliding @pos, (fly1, fly2) =>
      distVec = p5.Vector.sub(fly1, fly2.pos)
      fly2.distance = distVec.mag()
      fly2.i isnt @i and fly2.distance < @perception

    steer = (fly) =>
      diff = p5.Vector.sub @pos, fly.pos
      diff.div fly.distance * fly.distance
      align.add fly.vel
      cohesion.add fly.pos
      separation.add diff
    steer fly for fly in colliding

    if colliding.length
      align.div colliding.length
      cohesion.div colliding.length
      separation.div colliding.length
      
      align.setMag @speed
      cohesion.sub @pos
      cohesion.setMag @speed
      separation.setMag @speed

      align.sub @vel
      cohesion.sub @vel
      separation.add @vel

      align.limit .1
      cohesion.limit .1
      separation.limit .15

      @acc.mult 0
      @acc.add align
      @acc.add cohesion
      @acc.add separation

  wrap: () ->
    mag = @vel.mag
    if @pos.x > s.width then @vel.mult -1
    if @pos.x < 0 then @vel.mult -1
    if @pos.y > s.height - 50 then @vel.mult -1
    if @pos.y < 0 then @vel.mult -1
    ###
    if @pos.x > s.width then @pos.x = 0
    if @pos.x < 0 then @pos.x = s.width
    if @pos.y > s.height - 50 then @pos.y = 0
    if @pos.y < 0 then @pos.y = s.height - 50
    ###

  show: () ->
    normal = s.color 230
    charged = s.color 'coral'
    opacity = s.map @charge, 0, @maxCharge, 0, 1
    s.strokeWeight 5
    if @state is 'charging' then s.stroke normal
    else s.stroke s.lerpColor normal, charged, opacity
    # s.stroke s.map @i, 0, 500, 0, 255

    ###
    # RGB
    @time += @flip
    if @time > 255 then @flip = -1
    if @time < 0 then @flip = 1
    s.colorMode s.HSB
    currentColor = s.color(@time, 50, 80)
    s.stroke currentColor
    ###

    s.point @pos.x, @pos.y

    # show perception if discharging
    if @state is 'discharging'
      s.strokeWeight 0
      charged.setAlpha opacity * 255
      s.fill charged
      s.circle @pos.x, @pos.y, s.map opacity, 0, 1, @perception + 5, 5

    ###
    # Debug Lines
    scale = 5 / 10
    s.strokeWeight 0
    s.fill 'coral'
    s.rect scale * @i
      , s.height
      , scale
      , -1 * @charge * .5
    ###