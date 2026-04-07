import { defineConfig } from 'vitepress'
import { tabsMarkdownPlugin } from 'vitepress-plugin-tabs'

export default defineConfig({
  markdown: {
    config(md) {
      md.use(tabsMarkdownPlugin)
    }
  },

  title: 'ConsulScriptum',
  description: 'An in-game Lua console and script runner for Total War: Rome II and Attila.',
  base: '/ConsulScriptum/',

  head: [
    ['link', { rel: 'preconnect', href: 'https://fonts.googleapis.com' }],
    ['link', { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' }],
    ['link', {
      rel: 'stylesheet',
      href: 'https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700&family=Crimson+Text:ital,wght@0,400;0,600;1,400&family=JetBrains+Mono:wght@400;500&display=swap'
    }],
    ['meta', { name: 'theme-color', content: '#8B1A1A' }],
  ],

  themeConfig: {
    logo: '/logo.png',
    siteTitle: 'ConsulScriptum',

    nav: [
      { text: 'Install', link: '/guide/installation' },
      { text: 'Guide', link: '/guide/getting-started' },
      { text: 'Docs', link: '/reference/commands' },
      {
        text: 'v0.7.0',
        items: [
          { text: 'Changelog', link: '/guide/changelog' },
          { text: 'GitHub', link: 'https://github.com/bukowa/ConsulScriptum' },
        ]
      }
    ],

    sidebar: [
      {
        text: 'Guide',
        items: [
          { text: 'Getting Started', link: '/guide/getting-started' },
        ]
      },
      {
        items: [
          { text: 'Installation', link: '/guide/installation' },
          { text: 'Compatibility', link: '/guide/compatibility' },
          { text: 'Limitations', link: '/guide/limitations' },
          { text: 'Consul', link: '/guide/consul-scripts' },
          { text: 'Console', link: '/guide/console' },
          { text: 'Scriptum', link: '/guide/scriptum' },
          { text: 'Local Files', link: '/guide/files' },
          { text: 'Battle Mode', link: '/guide/battle' },
        ]
      },
      {
        text: 'Docs',
        items: [
          { text: 'Built-in Commands', link: '/reference/commands' },
          { text: 'Custom Commands', link: '/reference/custom-commands' },
          { text: 'Internal API', link: '/reference/internal-api' },
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/bukowa/ConsulScriptum' },
      { icon: 'discord', link: 'https://discord.gg/tgggqMs4' }
    ],

    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Copyright © 2024 Mateusz Kurowski'
    },

    search: {
      provider: 'local',
      options: {
        detailedView: true,
        miniSearch: {
          options: {
            /* Keep the '/' prefix in the index for slash commands */
            tokenize: (str) => str.split(/[\s,.;:!?"()\[\]{}]+/)
          },
          searchOptions: {
            fuzzy: 0.2,
            prefix: true,
            boost: { title: 4, text: 2, headings: 1 }
          }
        }
      }
    },

    editLink: {
      pattern: 'https://github.com/bukowa/ConsulScriptum/edit/master/docs/:path',
      text: 'Edit this page on GitHub'
    }
  }
})
