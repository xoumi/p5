<template lang="pug">
  .sidebar
    h1 p5!
    +each('sketches as sketch')
      button(on:click!='{() => handleClick(sketch)}') {sketch}
</template>

<script lang="coffee">
  import { createEventDispatcher } from 'svelte'
  export sketches = []

  dispatch = createEventDispatcher()

  handleClick = (name) ->
    dispatch 'selected', name
</script>