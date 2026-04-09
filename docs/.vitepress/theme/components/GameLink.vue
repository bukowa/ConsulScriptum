<script setup lang="ts">
import { inject, computed } from 'vue'
import { withBase } from 'vitepress'

const props = defineProps<{
  hash?: string
}>()

const injectionKey = 'vitepress:tabSharedState'
const sharedState = inject(injectionKey) as any

const game = computed(() => {
  return sharedState?.content?.game || 'Attila'
})

const href = computed(() => {
  const api = game.value === 'Rome II' ? 'rome2-api' : 'attila-api'
  const hashPart = props.hash ? `#${props.hash}` : ''
  return withBase(`/reference/${api}${hashPart}`)
})
</script>

<template>
  <a :href="href"><slot /></a>
</template>
