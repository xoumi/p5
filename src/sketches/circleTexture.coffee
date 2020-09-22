import Slider from '../utils/slider.coffee'
export default {
  name: 'circleTexture',
  sketch: (s) ->
    color = s.color 0
    color.setAlpha 50

    s.setup = () ->
      s.createCanvas 500, 500
      s.background 255

    s.draw = () ->
      s.noFill()
      s.strokeWeight 1
      s.stroke color
      s.circle s.random(0, 500), s.random(0, 500), s.random(0, 500)

}