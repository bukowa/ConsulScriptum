<script setup lang="ts">
import { computed, watch, onUnmounted } from 'vue'
import { nextVideo, prevVideo } from '../index.mts'

const props = defineProps<{
  state: {
    playlist: any[],
    currentIndex: number,
    isModalOpen: boolean,
    activeVideoSrc: string | null,
    isCarouselMode: boolean
  }
}>()

const emit = defineEmits(['close'])

const currentVideo = computed(() => {
  return props.state.playlist[props.state.currentIndex] || { src: '', title: '', game: '' }
})

const closeOnEsc = (e: KeyboardEvent) => {
  if (e.key === 'Escape') emit('close')
}

// Lock scroll when open
watch(() => props.state.isModalOpen, (newVal) => {
  if (newVal) {
    document.body.style.overflow = 'hidden'
    window.addEventListener('keydown', closeOnEsc)
  } else {
    document.body.style.overflow = ''
    window.removeEventListener('keydown', closeOnEsc)
  }
}, { immediate: true })

onUnmounted(() => {
  document.body.style.overflow = ''
  window.removeEventListener('keydown', closeOnEsc)
})
</script>

<template>
  <Teleport to="body">
    <Transition name="fade">
      <div v-if="state.isModalOpen" class="video-modal-overlay" @click.self="emit('close')">
        <div class="video-modal-container">
          <button class="video-modal-close" @click="emit('close')" aria-label="Close">
            <span class="icon">×</span>
          </button>
          
          <div class="video-modal-content">
            <video 
              v-if="currentVideo.src"
              :key="currentVideo.src"
              :src="currentVideo.src" 
              controls 
              autoplay 
              loop
              class="video-modal-player"
            ></video>

            <!-- Navigation Arrows (Only in Carousel Mode) -->
            <template v-if="state.isCarouselMode">
              <button class="modal-nav prev" @click.stop="prevVideo" aria-label="Previous Video">
                <span class="arrow">‹</span>
              </button>
              <button class="modal-nav next" @click.stop="nextVideo" aria-label="Next Video">
                <span class="arrow">›</span>
              </button>

              <!-- Sync Info Badge -->
              <div class="modal-video-info" v-if="currentVideo.game || currentVideo.title">
                <span class="modal-game-tag" v-if="currentVideo.game">{{ currentVideo.game }}</span>
                <span class="modal-video-title" v-if="currentVideo.title">{{ currentVideo.title }}</span>
              </div>
            </template>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped>
.video-modal-overlay {
  position: fixed;
  inset: 0;
  z-index: 9999;
  background-color: rgba(13, 11, 8, 0.96);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
  cursor: zoom-out;
}

.video-modal-container {
  position: relative;
  width: 100%;
  max-width: 1200px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  background: var(--cs-bg-deep);
  border: 1px solid var(--cs-border-strong);
  border-radius: 8px;
  box-shadow: 0 0 50px rgba(0, 0, 0, 0.8), 0 0 20px var(--cs-crimson-glow);
  cursor: default;
}

.video-modal-close {
  position: absolute;
  top: -48px;
  right: -10px;
  background: none;
  border: none;
  color: var(--cs-gold-light);
  font-size: 2.5rem;
  cursor: pointer;
  transition: transform 0.2s, color 0.2s;
  padding: 10px;
  line-height: 1;
}

.video-modal-close:hover {
  color: var(--cs-crimson-light);
  transform: scale(1.1);
}

.video-modal-content {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  border-radius: 6px;
}

.video-modal-player {
  width: 100%;
  max-height: 85vh;
  display: block;
  object-fit: contain;
}

/* Modal Navigation */
.modal-nav {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 60px;
  height: 60px;
  background: rgba(0, 0, 0, 0.5);
  border: 1px solid rgba(201, 168, 76, 0.2);
  color: var(--cs-gold);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 100;
  transition: all 0.3s ease;
  backdrop-filter: blur(4px);
}

.modal-nav:hover {
  background: rgba(139, 0, 0, 0.7);
  border-color: var(--cs-gold-light);
  color: var(--cs-gold-light);
  box-shadow: 0 0 25px rgba(139, 0, 0, 0.5);
  transform: translateY(-50%) scale(1.1);
}

.modal-nav.prev { left: 40px; }
.modal-nav.next { right: 40px; }

.modal-nav .arrow {
  font-size: 3.5rem;
  line-height: 1;
  margin-top: -6px;
}

/* Modal Video Info */
.modal-video-info {
  position: absolute;
  bottom: 40px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  pointer-events: none;
  z-index: 100;
  text-align: center;
}

.modal-game-tag {
  font-family: 'Cinzel', serif;
  font-size: 0.8rem;
  color: var(--cs-gold-light);
  background: var(--cs-crimson);
  padding: 4px 16px;
  border-radius: 4px;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  box-shadow: 0 4px 15px rgba(0,0,0,0.6);
}

.modal-video-title {
  font-family: 'Crimson Text', serif;
  font-size: 1.25rem;
  color: #fff;
  text-shadow: 0 2px 10px rgba(0,0,0,1);
  font-style: italic;
  font-weight: 600;
}

/* Animations */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.fade-enter-active .video-modal-container {
  animation: scale-up 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

@keyframes scale-up {
  from { transform: scale(0.9); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}

@media (max-width: 768px) {
  .video-modal-overlay {
    padding: 16px;
  }
  
  .video-modal-close {
    top: 5px;
    right: 5px;
    font-size: 1.8rem;
    background: rgba(0,0,0,0.5);
    border-radius: 50%;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    z-index: 10;
  }
}
</style>
