import Slider from '../utils/slider.coffee'
export default {
  name: 'init',
  sketch: (s) ->
    x = y = 100
    red = green = blue = null

    s.setup = () ->
      red = new Slider s, 'Allign', 0, 255, 255 / 2, 1
      green = new Slider s, 'Cohesion', 0, 255, 255 / 2, 1
      blue = new Slider s, 'Separation', 0, 255, 255 / 2, 1

    s.draw = () ->
      red.update()
      green.update()
      blue.update()
      s.background red.slider.value(), green.slider.value(), blue.slider.value()

}