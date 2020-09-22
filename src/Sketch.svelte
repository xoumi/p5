<div id="p5" bind:this={canvas}></div>
<div id="controls"></div>

<script lang="coffee">
  import { onMount } from 'svelte'
  import p5 from 'p5'

  export sketch = null

  canvas = null
  mounted = false
  instance = null

  onMount () ->
    mounted = true

  `$:if(mounted) {
    if(instance) instance.remove();
    instance = new p5(sketch, canvas)
  }`
</script>