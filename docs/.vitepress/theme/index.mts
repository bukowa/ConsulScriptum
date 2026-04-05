import DefaultTheme from 'vitepress/theme'
import './custom.css'
import { enhanceAppWithTabs } from 'vitepress-plugin-tabs/client'
import type { App } from 'vue'
import { h, reactive } from 'vue'
import HeroDemo from './components/HeroDemo.vue'
import VideoModal from './components/VideoModal.vue'

// Home page playlist for the hero section
const HOME_PLAYLIST = [
  { 
    title: "Attila: Accessing the Interface", 
    game: "Attila", 
    src: '/ConsulScriptum/videos/attila_accessconsole.mp4'
  },
  { 
    title: "Attila: Interacting with Consul", 
    game: "Attila", 
    src: '/ConsulScriptum/videos/attila_index.mp4'
  },
  { 
    title: "Attila: Interactive Mode", 
    game: "Attila", 
    src: '/ConsulScriptum/videos/attila_console.mp4'
  },
  { 
    title: "Rome II: Accessing the Interface", 
    game: "Rome II", 
    src: '/ConsulScriptum/videos/rome2_accessconsole.mp4'
  },
  { 
    title: "Rome II: Interacting with Consul", 
    game: "Rome II", 
    src: '/ConsulScriptum/videos/rome2_index.mp4'
  },
  { 
    title: "Rome II: Interactive Mode", 
    game: "Rome II", 
    src: '/ConsulScriptum/videos/rome2_console.mp4'
  }
]

// Synchronized state for Carousel and Modal
export const state = reactive({
  playlist: HOME_PLAYLIST,
  currentIndex: 0,
  isModalOpen: false,
  activeVideoSrc: null as string | null,
  isCarouselMode: true
})

export const nextVideo = () => {
  state.currentIndex = (state.currentIndex + 1) % state.playlist.length
}

export const prevVideo = () => {
  state.currentIndex = (state.currentIndex - 1 + state.playlist.length) % state.playlist.length
}

export default {
  extends: DefaultTheme,
  Layout() {
    return h(DefaultTheme.Layout, null, {
      'home-hero-image': () => h(HeroDemo),
      'layout-bottom': () => h(VideoModal, {
        state: state,
        onClose: () => { state.isModalOpen = false }
      })
    })
  },
  enhanceApp({ app }: { app: App }) {
    enhanceAppWithTabs(app)
    
    if (typeof window !== 'undefined') {
      // Global click handler for videos
      document.addEventListener('click', (e) => {
        const target = e.target as HTMLElement
        const video = target.closest('video')
        
        if (video && !video.closest('.video-modal-content')) {
          const videoSrc = new URL(video.src, window.location.origin).pathname
          const heroContainer = video.closest('.hero-demo-container')
          const tabContainer = video.closest('.plugin-tabs')
          const docContainer = video.closest('.vp-doc')
          
          let newPlaylist: any[] = []
          if (heroContainer) {
            newPlaylist = HOME_PLAYLIST
          } else {
            const contextContainer = tabContainer || docContainer
            if (contextContainer) {
              const videosInContext = Array.from(contextContainer.querySelectorAll('video'))
                .filter(v => !v.closest('.video-modal-content'))
              
              newPlaylist = videosInContext.map(v => ({
                src: new URL((v as HTMLVideoElement).src, window.location.origin).pathname,
                title: (v as HTMLElement).dataset.title || '',
                game: (v as HTMLElement).dataset.game || ''
              }))
            }
          }

          if (newPlaylist.length > 0) {
            const index = newPlaylist.findIndex(v => v.src === videoSrc)
            state.playlist = newPlaylist
            state.currentIndex = index !== -1 ? index : 0
            state.isCarouselMode = newPlaylist.length > 1
          } else {
            state.playlist = [{ src: videoSrc, title: (video as HTMLElement).dataset.title || '', game: (video as HTMLElement).dataset.game || '' }]
            state.currentIndex = 0
            state.isCarouselMode = false
          }
          state.isModalOpen = true
        }
      })

      // Inject expand hints for markdown videos that don't have them
      const injectHints = () => {
        const videos = document.querySelectorAll('.vp-doc video, .vp-tabs-content video')
        videos.forEach(video => {
          if (video.closest('.video-modal-content')) return
          if (video.parentElement?.querySelector('.video-expand-hint')) return
          
          const wrapper = document.createElement('div')
          wrapper.className = 'video-trigger-wrapper'
          wrapper.style.position = 'relative'
          wrapper.style.display = 'inline-block'
          wrapper.style.width = '100%'

          const hint = document.createElement('div')
          hint.className = 'video-expand-hint'
          hint.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h6v6M9 21H3v-6M21 3l-7 7M3 21l7-7"/></svg>`
          
          video.parentNode?.insertBefore(wrapper, video)
          wrapper.appendChild(video)
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
