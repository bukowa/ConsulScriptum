<script setup lang="ts">
import { inject, computed } from 'vue'

const injectionKey = 'vitepress:tabSharedState'
// vitepress-plugin-tabs exposes a reactive state that syncs with localStorage
const sharedState = inject(injectionKey) as any

const selectedGame = computed({
  get() {
    return sharedState?.content?.game || 'Attila' // Default fallback
  },
  set(value) {
    if (sharedState) {
      if (!sharedState.content) {
        sharedState.content = {}
      }
      sharedState.content.game = value
    }
  }
})

const games = ['Attila', 'Rome II']
</script>

<template>
  <div class="cs-game-selector">
    <label for="game-switcher-select" class="cs-game-label">Game</label>
    <div class="cs-select-wrapper">
      <select id="game-switcher-select" v-model="selectedGame" class="cs-game-select">
        <option v-for="game in games" :key="game" :value="game">
          {{ game }}
        </option>
      </select>
      <svg class="cs-select-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <polyline points="6 9 12 15 18 9"></polyline>
      </svg>
    </div>
  </div>
</template>

<style scoped>
.cs-game-selector {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0 12px;
  height: 36px;
  margin-left: 12px;
}

.cs-game-label {
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--vp-c-text-2);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  cursor: pointer;
  white-space: nowrap;
}

.cs-select-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.cs-game-select {
  appearance: none;
  background-color: var(--cs-bg-card, #231B12);
  border: 1px solid var(--cs-border, rgba(201, 168, 76, 0.2));
  border-radius: 4px;
  padding: 0.2rem 2rem 0.2rem 0.75rem;
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.8rem;
  font-weight: 500;
  color: var(--cs-gold-light, #E5C97E);
  cursor: pointer;
  outline: none;
  transition: all 0.2s ease;
  min-width: 110px;
}

.cs-game-select:hover {
  border-color: var(--cs-border-strong, rgba(201, 168, 76, 0.45));
  background-color: var(--cs-bg-raised, #1C1610);
}

.cs-game-select:focus {
  border-color: var(--cs-gold, #C9A84C);
  box-shadow: 0 0 0 1px var(--cs-gold, #C9A84C);
}

.cs-game-select option {
  background-color: var(--cs-bg-deep, #0D0B08);
  color: var(--cs-text-primary, #E8D5B0);
  font-family: 'JetBrains Mono', monospace;
  padding: 8px;
}

.cs-select-icon {
  position: absolute;
  right: 0.5rem;
  pointer-events: none;
  width: 14px;
  height: 14px;
  color: var(--cs-gold);
  opacity: 0.8;
  transition: opacity 0.2s;
}

.cs-game-select:hover + .cs-select-icon {
  opacity: 1;
}

/* Adjustments for mobile view where it might wrap or need spacing */
@media (max-width: 768px) {
  .cs-game-selector {
    margin-left: 0;
    padding: 0.75rem 1rem;
    border-bottom: 1px solid var(--vp-c-divider);
    justify-content: space-between;
    height: auto;
  }
}
</style>
