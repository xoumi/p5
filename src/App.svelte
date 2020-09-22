<template lang="pug">
  .app
    Sidebar(on:selected='{handleSelected}' sketches!='{sketches.map((sketch) => sketch.name)}')
    +if('active')
      Sketch(sketch='{active.sketch}')
</template>

<script lang="coffee">
import './styles/index.sass'
import Sketch from './Sketch.svelte'
import Sidebar from './Sidebar.svelte'

import init from './sketches/init.coffee'
import circleTexture from './sketches/circleTexture.coffee'
import fireflies from './sketches/fireflies.coffee'

sketches = [init, fireflies, circleTexture]
active = circleTexture

handleSelected = (event) ->
  selected = event.detail
  active = sketches.find (sketch) =>
    sketch.name is event.detail
</script>