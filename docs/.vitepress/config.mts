import {defineConfig} from 'vitepress'
import {tabsMarkdownPlugin} from 'vitepress-plugin-tabs'
import {withMermaid} from 'vitepress-plugin-mermaid'

export default withMermaid(defineConfig({
    markdown: {
        config(md) {
            md.use(tabsMarkdownPlugin)
        }
    },

    title: 'Consul Scriptum',
    titleTemplate: 'Total War Console - Consul Scriptum',
    description: 'An in-game Lua console and script runner for Total War: Rome II and Attila.',
    base: '/ConsulScriptum/',
    appearance: 'force-dark',

    // SEO Optimization
    lastUpdated: true,
    cleanUrls: true,
    sitemap: {
        hostname: 'https://bukowa.github.io/ConsulScriptum/'
    },

    head: [
        ['link', {rel: 'icon', type: 'image/png', href: '/ConsulScriptum/logo.png'}],
        ['link', {rel: 'preconnect', href: 'https://fonts.googleapis.com'}],
        ['link', {rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: ''}],
        ['link', {
            rel: 'stylesheet',
            href: 'https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700&family=Crimson+Text:ital,wght@0,400;0,600;1,400&family=JetBrains+Mono:wght@400;500&display=swap'
        }],
        ['meta', {name: 'theme-color', content: '#8B1A1A'}],

        // Open Graph
        ['meta', {property: 'og:type', content: 'website'}],
        ['meta', {property: 'og:title', content: 'Consul Scriptum'}],
        ['meta', {
            property: 'og:description',
            content: 'An in-game Lua console and script runner for Total War: Rome II and Attila.'
        }],
        ['meta', {property: 'og:image', content: 'https://bukowa.github.io/ConsulScriptum/logo.png'}],
        ['meta', {property: 'og:url', content: 'https://bukowa.github.io/ConsulScriptum/'}],

        // Twitter
        ['meta', {name: 'twitter:card', content: 'summary'}],
        ['meta', {name: 'twitter:title', content: 'Consul Scriptum'}],
        ['meta', {
            name: 'twitter:description',
            content: 'An in-game Lua console and script runner for Total War: Rome II and Attila.'
        }],
        ['meta', {name: 'twitter:image', content: 'https://bukowa.github.io/ConsulScriptum/logo.png'}],
    ],

    themeConfig: {
        logo: '/ConsulScriptum/logo.png',
        siteTitle: 'Consul Scriptum',

        nav: [
            {text: 'Getting started', link: '/guide/getting-started'},
            {text: 'Scripting Manual', link: '/guide/scripting-manual'},
            {text: 'Installation', link: '/guide/installation-guide'},
            {
                text: 'v0.7.2',
                items: [
                    {text: 'Changelog', link: '/guide/changelog'},
                    {text: 'GitHub', link: 'https://github.com/bukowa/ConsulScriptum'},
                ]
            }
        ],

        sidebar: [
            {
                text: 'First steps',
                items: [
                    {text: 'Getting started', link: '/guide/getting-started'},
                    {text: 'Installation', link: '/guide/installation-guide'},
                    {text: 'Supported Games', link: '/guide/game-compatibility'},
                    {text: 'Limitations', link: '/guide/technical-limitations'},
                ]
            },
            {
                text: 'Using the interface',
                items: [
                    {text: 'One-Click Actions', link: '/guide/consul-manual'},
                    {text: 'Commands and Lua', link: '/guide/console-manual'},
                    {text: 'File-based Scripts', link: '/guide/scriptum-manual'},
                ]
            },
            {
                text: 'Beyond the basics',
                items: [
                    {text: 'Scripting Manual', link: '/guide/scripting-manual'},
                    {text: 'Debugging The World', link: '/guide/debugging-the-world'},
                    {text: 'Debugging The UI', link: '/guide/debugging-the-ui'},
                    {text: 'Local files and logs', link: '/guide/consul-scriptum-files'},
                    {text: 'Battle mode', link: '/guide/battle-mode-scripting'},
                ]
            },
            {
                text: 'Extend and customize',
                items: [
                    {text: 'Add Consul scripts', link: '/guide/advanced-consul-scripting'},
                    {text: 'Add console commands', link: '/reference/adding-custom-commands'},
                ]
            },
            {
                text: 'Consul Reference',
                items: [
                    {text: 'Consul API', link: '/reference/internal-lua-api'},
                    {text: 'Consul scripts', link: '/reference/consul-scripts-reference'},
                    {text: 'Console commands', link: '/reference/console-commands'},
                ]
            },
            {
                text: 'Game Reference',
                items: [
                    {text: 'Rome II API Reference', link: '/reference/rome2-api'},
                    {text: 'Rome II Event Reference', link: '/reference/rome2-events'},
                    {text: 'Attila API Reference', link: '/reference/attila-api'},
                    {text: 'Attila Event Reference', link: '/reference/attila-events'},
                ]
            },
            {
                text: 'Development',
                items: [
                    {text: 'Build from source', link: '/guide/building-from-source'},
                    {text: 'Changelog', link: '/guide/changelog'},
                ]
            },
        ],

        socialLinks: [
            {icon: 'github', link: 'https://github.com/bukowa/ConsulScriptum'},
            {icon: 'discord', link: 'https://discord.gg/6vm2M94vhX'}
        ],

        footer: {
            message: 'Released under the MIT License.',
            copyright: 'Copyright © 2026 Mateusz Kurowski'
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
                        boost: {title: 4, text: 2, headings: 1}
                    }
                }
            }
        },

        editLink: {
            pattern: 'https://github.com/bukowa/ConsulScriptum/edit/master/docs/:path',
            text: 'Edit this page on GitHub'
        }
    }
}, {
    // Mermaid configuration
    mermaid: {
        securityLevel: 'loose'
    }
}))
