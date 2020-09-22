export default class Slider
  constructor: (s, label, min, max, v, step) ->
    @container = s.createElement 'div'
    @container.addClass 'slider'
    @container.parent 'controls'

    @label = s.createP label
    @label.addClass 'slider-label'
    @label.parent @container

    @slider = s.createSlider min, max, v, step
    @slider.parent @container

    @current = s.createElement 'span', v
    @current.addClass 'slider-current'
    @current.parent @container
  update: () ->
    @current.html @slider.value()
  value: () -> @slider.value()