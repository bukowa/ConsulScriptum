<script setup lang="ts">
import { computed } from 'vue'
import { state, nextHero as next, prevHero as prev, HOME_PLAYLIST } from '../index.mts'

const demoVideos = HOME_PLAYLIST

const currentVideo = computed(() => demoVideos[state.heroIndex])

// Determine active game based on current video
const activeGame = computed(() => currentVideo.value.game)

const setIndex = (index: number) => {
  state.heroIndex = index
}

const jumpToGame = (gameName: string) => {
  const index = demoVideos.findIndex(v => v.game === gameName)
  if (index !== -1) state.heroIndex = index
}
</script>

<template>
  <div class="hero-demo-container">
    <!-- Restored Tabs as Filters/Jumps -->
    <div class="hero-demo-tabs">
      <button 
        class="hero-demo-tab"
        :class="{ active: activeGame === 'Attila' }"
        @click="jumpToGame('Attila')"
      >
        Attila
      </button>
      <button 
        class="hero-demo-tab"
        :class="{ active: activeGame === 'Rome II' }"
        @click="jumpToGame('Rome II')"
      >
        Rome II
      </button>
    </div>

    <div class="hero-demo-display">
      <div class="video-wrapper">
        <video 
          :key="currentVideo.src"
          :src="currentVideo.src"
          autoplay 
          muted 
          loop
          playsinline
          class="demo-video"
        ></video>
      </div><!-- End video-wrapper -->
        
      <!-- Navigation Arrows (Now outside wrapper to allow overflow) -->
      <button class="nav-arrow prev" @click.stop="prev" aria-label="Previous Video">
        <span class="arrow-icon">‹</span>
      </button>
      <button class="nav-arrow next" @click.stop="next" aria-label="Next Video">
        <span class="arrow-icon">›</span>
      </button>

      <div class="video-expand-hint">
          <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h6v6M9 21H3v-6M21 3l-7 7M3 21l7-7"/></svg>
        </div>

        <!-- Video Info Badge -->
        <div class="video-info">
          <span class="game-tag">{{ currentVideo.game }}</span>
          <span class="video-title">{{ currentVideo.title }}</span>
        </div>

        <!-- Dot Indicators -->
        <div class="carousel-dots">
          <button 
            v-for="(_, index) in demoVideos" 
            :key="index"
            class="dot"
            :class="{ active: index === state.heroIndex }"
            @click.stop="setIndex(index)"
            :aria-label="`Go to slide ${index + 1}`"
          ></button>
        </div>
      </div>
  </div>
</template>

<style scoped>
.hero-demo-container {
  width: 100%;
  max-width: 720px;
  margin: 0 -40px 0 auto;
  position: relative;
  z-index: 10;
}

.hero-demo-tabs {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-bottom: 16px;
}

.hero-demo-tab {
  font-family: 'Cinzel', serif;
  font-size: 0.85rem;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  padding: 8px 24px;
  border: 1px solid var(--cs-border-strong);
  background: var(--cs-bg-card);
  color: var(--cs-text-muted);
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.25s ease;
}

.hero-demo-tab:hover {
  border-color: var(--cs-gold);
  color: var(--cs-gold);
  background: rgba(201, 168, 76, 0.05);
}

.hero-demo-tab.active {
  background: var(--cs-crimson);
  border-color: var(--cs-crimson-light);
  color: var(--cs-gold-light);
  box-shadow: 0 0 15px var(--cs-crimson-glow);
}

.hero-demo-display {
  background: #000;
  border: 1px solid var(--cs-border-strong);
  border-radius: 12px;
  /* overflow: hidden; Removed to allow arrows to float outside */
  box-shadow: 0 15px 50px rgba(0,0,0,0.9);
  position: relative;
  aspect-ratio: 4 / 3;
}

.video-wrapper {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden; /* Moved from parent to clip only the video */
  border-radius: 11px; /* Slightly less than parent for clean fit */
}

.demo-video {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  cursor: pointer;
  transition: transform 0.4s ease;
}

.demo-video:hover {
  transform: scale(1.01);
}

/* Navigation Arrows - Larger and more prominent */
.nav-arrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 64px;
  height: 64px;
  background: rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(201, 168, 76, 0.2);
  color: var(--cs-gold);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 10;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  backdrop-filter: blur(4px);
}

.nav-arrow:hover {
  background: rgba(139, 0, 0, 0.7);
  border-color: var(--cs-gold-light);
  color: var(--cs-gold-light);
  box-shadow: 0 0 25px rgba(139, 0, 0, 0.5);
  transform: translateY(-50%) scale(1.1);
}

.prev { left: -32px; }
.next { right: -32px; }

.arrow-icon {
  font-size: 3.5rem;
  line-height: 1;
  margin-top: -6px;
  transition: transform 0.2s ease;
}

.nav-arrow:active .arrow-icon {
  transform: scale(0.9);
}

/* Video Info Badge */
.video-info {
  position: absolute;
  top: 24px;
  left: 24px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  pointer-events: none;
  z-index: 5;
}

.game-tag {
  align-self: flex-start;
  font-family: 'Cinzel', serif;
  font-size: 0.75rem;
  color: var(--cs-gold-light);
  background: var(--cs-crimson);
  padding: 4px 12px;
  border-radius: 4px;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  box-shadow: 0 4px 12px rgba(0,0,0,0.5);
}

.video-title {
  font-family: 'Crimson Text', serif;
  font-size: 1.1rem;
  color: #fff;
  text-shadow: 0 2px 10px rgba(0,0,0,1);
  font-style: italic;
  font-weight: 600;
}

/* Dot Indicators */
.carousel-dots {
  position: absolute;
  bottom: 12px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 10px;
  z-index: 10;
}

.dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
  border: none;
  padding: 0;
  cursor: pointer;
  transition: all 0.3s ease;
}

.dot:hover {
  background: rgba(255, 255, 255, 0.5);
}

.dot.active {
  background: var(--cs-gold);
  transform: scale(1.4);
  box-shadow: 0 0 10px var(--cs-gold);
}

@media (max-width: 640px) {
  .hero-demo-container {
    max-width: 100%;
    margin-top: 2rem;
  }
}
</style>
