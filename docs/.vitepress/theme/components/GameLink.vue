<script setup lang="ts">
import { inject, computed } from 'vue'
import { withBase } from 'vitepress'

const props = withDefaults(defineProps<{
  hash?: string
  type?: 'api' | 'events'
}>(), {
  type: 'api'
})

const injectionKey = 'vitepress:tabSharedState'
const sharedState = inject(injectionKey) as any

const game = computed(() => {
  return sharedState?.content?.game || 'Attila'
})

const href = computed(() => {
  const isRome2 = game.value === 'Rome II'
  const category = props.type === 'events' ? 'events' : 'api'
  const api = isRome2 ? `rome2-${category}` : `attila-${category}`
  const hashPart = props.hash ? `#${props.hash}` : ''
  return withBase(`/reference/${api}${hashPart}`)
})
</script>

<template>
  <a :href="href"><slot /></a>
</template>
