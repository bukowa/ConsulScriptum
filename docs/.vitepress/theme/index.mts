import DefaultTheme from 'vitepress/theme'
import './custom.css'
import { enhanceAppWithTabs } from 'vitepress-plugin-tabs/client'
import type { App } from 'vue'
import { h, reactive } from 'vue'
import { withBase } from 'vitepress'
import HeroDemo from './components/HeroDemo.vue'
import MediaModal from './components/MediaModal.vue'
import GameSwitcher from './components/GameSwitcher.vue'

// Home page playlist for the hero section
export const HOME_PLAYLIST = [
  {
    title: "Attila: Accessing the Interface",
    game: "Attila",
    src: withBase('/videos/attila_accessconsole.mp4'),
    type: 'video'
  },
  {
    title: "Attila: Interacting with Consul",
    game: "Attila",
    src: withBase('/videos/attila_index.mp4'),
    type: 'video'
  },
  {
    title: "Attila: Interactive Mode",
    game: "Attila",
    src: withBase('/videos/attila_console.mp4'),
    type: 'video'
  },
  {
    title: "Rome II: Accessing the Interface",
    game: "Rome II",
    src: withBase('/videos/rome2_accessconsole.mp4'),
    type: 'video'
  },
  {
    title: "Rome II: Interacting with Consul",
    game: "Rome II",
    src: withBase('/videos/rome2_index.mp4'),
    type: 'video'
  },
  {
    title: "Rome II: Interactive Mode",
    game: "Rome II",
    src: withBase('/videos/rome2_console.mp4'),
    type: 'video'
  }
]

// Synchronized state for Carousel and Modal
export const state = reactive({
  heroIndex: 0,
  modalPlaylist: HOME_PLAYLIST,
  modalIndex: 0,
  isModalOpen: false,
  isCarouselMode: true
})

export const nextHero = () => {
  state.heroIndex = (state.heroIndex + 1) % HOME_PLAYLIST.length
}

export const prevHero = () => {
  state.heroIndex = (state.heroIndex - 1 + HOME_PLAYLIST.length) % HOME_PLAYLIST.length
}

export const nextModal = () => {
  state.modalIndex = (state.modalIndex + 1) % state.modalPlaylist.length
  // If viewing hero videos in modal, keep the background hero in sync
  if (state.modalPlaylist === HOME_PLAYLIST) {
    state.heroIndex = state.modalIndex
  }
}

export const prevModal = () => {
  state.modalIndex = (state.modalIndex - 1 + state.modalPlaylist.length) % state.modalPlaylist.length
  // If viewing hero videos in modal, keep the background hero in sync
  if (state.modalPlaylist === HOME_PLAYLIST) {
    state.heroIndex = state.modalIndex
  }
}

export default {
  extends: DefaultTheme,
  Layout() {
    return h(DefaultTheme.Layout, null, {
      'home-hero-image': () => h(HeroDemo),
      'nav-bar-content-before': () => h(GameSwitcher),
      'nav-screen-content-before': () => h(GameSwitcher),
      'layout-bottom': () => h(MediaModal, {
        state: state,
        onClose: () => { state.isModalOpen = false }
      })
    })
  },
  enhanceApp({ app }: { app: App }) {
    app.config.globalProperties.$withBase = withBase
    enhanceAppWithTabs(app)

    if (typeof window !== 'undefined') {
      // Global click handler for media (videos and images)
      document.addEventListener('click', (e) => {
        const target = e.target as HTMLElement
        const video = target.closest('video')
        const img = target.closest('.vp-doc img, .vp-tabs-content img, .cs-ui-magnifier img') as HTMLImageElement

        if ((video && !video.closest('.video-modal-content')) || img) {
          const mediaElement = video || img
          const isVideo = !!video
          const mediaSrc = isVideo
            ? new URL((mediaElement as HTMLVideoElement).src, window.location.origin).pathname
            : new URL((mediaElement as HTMLImageElement).src, window.location.origin).pathname

          const heroContainer = mediaElement.closest('.hero-demo-container')
          const tabContainer = mediaElement.closest('.plugin-tabs')
          const docContainer = mediaElement.closest('.vp-doc')
          const magnifierContainer = mediaElement.closest('.cs-ui-magnifier')

          let newPlaylist: any[] = []

          if (heroContainer && isVideo) {
            newPlaylist = HOME_PLAYLIST
            state.modalIndex = state.heroIndex // Start modal at the same index as hero
          } else {
            // Find related media in the same context
            const contextContainer = magnifierContainer || tabContainer || docContainer
            if (contextContainer) {
              const selector = isVideo ? 'video' : 'img'
              const mediaInContext = Array.from(contextContainer.querySelectorAll(selector))
                .filter(m => !m.closest('.video-modal-content'))

              newPlaylist = mediaInContext.map(m => ({
                src: new URL((m as any).src, window.location.origin).pathname,
                title: (m as HTMLElement).dataset.title || (m as HTMLImageElement).alt || '',
                game: (m as HTMLElement).dataset.game || '',
                type: isVideo ? 'video' : 'image'
              }))
            }
          }

          if (newPlaylist.length > 0) {
            const index = newPlaylist.findIndex(m => m.src === mediaSrc)
            state.modalPlaylist = newPlaylist
            state.modalIndex = index !== -1 ? index : 0
            state.isCarouselMode = newPlaylist.length > 1
          } else {
            state.modalPlaylist = [{
              src: mediaSrc,
              title: (mediaElement as HTMLElement).dataset.title || (mediaElement as HTMLImageElement).alt || '',
              game: (mediaElement as HTMLElement).dataset.game || '',
              type: isVideo ? 'video' : 'image'
            }]
            state.modalIndex = 0
            state.isCarouselMode = false
          }
          state.isModalOpen = true
        }
      })

      // Close sidebar on anchor link click (mobile)
      document.addEventListener('click', (e) => {
        const target = e.target as HTMLElement
        const link = target.closest('a')
        if (link && link.hash && (link.pathname === window.location.pathname || link.pathname === window.location.pathname + '/')) {
          const sidebar = document.querySelector('.VPSidebar.open')
          if (sidebar) {
            const backdrop = document.querySelector('.VPBackdrop')
            if (backdrop instanceof HTMLElement) {
              backdrop.click()
            }
          }
        }
      }, true)

      // Inject expand hints for markdown media that don't have them
      const injectHints = () => {
        const media = document.querySelectorAll('.vp-doc video, .vp-tabs-content video, .vp-doc img:not(.logo), .vp-tabs-content img, .cs-ui-magnifier img')
        media.forEach(el => {
          if (el.closest('.video-modal-content')) return
          if (el.parentElement?.classList.contains('video-trigger-wrapper')) return

          // Skip small icons or specific UI elements if needed
          if (el instanceof HTMLImageElement && (el.width < 50 || el.height < 50)) return

          const wrapper = document.createElement('div')
          wrapper.className = 'video-trigger-wrapper'
          wrapper.style.position = 'relative'
          wrapper.style.display = el.tagName === 'IMG' ? 'inline-block' : 'block'
          wrapper.style.width = el.tagName === 'IMG' ? 'auto' : '100%'

          const hint = document.createElement('div')
          hint.className = 'video-expand-hint'
          hint.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h6v6M9 21H3v-6M21 3l-7 7M3 21l7-7"/></svg>`

          el.parentNode?.insertBefore(wrapper, el)
          wrapper.appendChild(el)
          wrapper.appendChild(hint)
        })
      }

      // Run on initial load
      setTimeout(injectHints, 500)

      // Re-run on navigation (VitePress is an SPA)
      const observer = new MutationObserver(() => {
        injectHints()
      })
      observer.observe(document.querySelector('#app') || document.body, { childList: true, subtree: true })
    }
  }
}
