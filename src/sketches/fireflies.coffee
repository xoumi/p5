import Slider from '../utils/slider.coffee'
import Firefly from './Classes/Firefly.coffee'
import Quadtree from "quadtree-lib"
s = null

export default {
  name: 'fireflies',

  sketch: (p5) ->
    s = p5
    count = 400
    width = 1000
    height = window.innerHeight - 50
    speed = shareAmt = decayRate = perception = chargeRate = null
    quadtree = new Quadtree {
      width, height
      maxElements: 5
    }
    flies = []


    s.setup = () ->
      s.createCanvas width, height
      s.colorMode s.RGB
      s.frameRate(60)
      speed = new Slider s, 'Speed', 0.001, 5, 1.5, .01
      shareAmt = new Slider s, 'shareAmt', 0, 20, 1, .01
      chargeRate = new Slider s, 'chargeRate', 0, 1, 1, .01
      decayRate = new Slider s, 'DecayRate', 0, 100, 2, 1
      perception = new Slider s, 'Perception', 5, 50, 15, 1

      flies.push new Firefly s
        , speed.value()
        , shareAmt.value()
        , decayRate.value()
        , perception.value()
        , chargeRate.value(), i for i in [0..count]

    s.draw = () ->
      avgCharge = 0
      updateSliders()
      setFromSliders fly for fly in flies
      quadtree.clear()
      quadtree.pushAll flies

      s.background 255
      action = (fly, i) ->
        if fly.state is 'share'
          fly.share quadtree
        fly.flock quadtree
        fly.move()
        fly.show()
        avgCharge += fly.charge
      action fly, me for fly, me in flies
      ###
      avgCharge /= count
      s.stroke 'white'
      s.fill 'white'
      s.strokeWeight 2
      s.line 0, s.height - 50, s.width, s.height - 50
      s.rect 0, s.height - 50, s.width / count, -1 * avgCharge * .5
      ###

    updateSliders = () ->
      speed.update()
      shareAmt.update()
      decayRate.update()
      perception.update()
      chargeRate.update()

    setFromSliders = (fly) ->
      fly.speed = speed.value()
      fly.shareAmt = shareAmt.value()
      fly.decayRate = decayRate.value()
      fly.perception = perception.value()
      fly.chargeRate = chargeRate.value()
}