const fs = require('fs');
const path = require('path');

const indexFile = path.join(__dirname, 'index.md');

try {
    const indexContent = fs.readFileSync(indexFile, 'utf8');

    const games = [
        { file: 'attila.md', game: 'Attila' },
        { file: 'rome2.md', game: 'Rome II' },
        { file: 'tob.md', game: 'ToB' }
    ];

    const scriptTemplate = (game) => `
<script setup>
import { inject, onMounted } from 'vue'

const sharedState = inject('vitepress:tabSharedState')
if (sharedState) {
  if (!sharedState.content) sharedState.content = {}
  sharedState.content.game = '${game}'
}

onMounted(() => {
  if (typeof window !== 'undefined') {
    window.history.replaceState({}, '', '/')
  }
})
</script>
`;

    games.forEach(({ file, game }) => {
        const targetFile = path.join(__dirname, file);
        const fullContent = indexContent.trim() + '\n' + scriptTemplate(game);
        fs.writeFileSync(targetFile, fullContent, 'utf8');
        console.log(`[Docs] Generated alias: ${file} for game: ${game}`);
    });
} catch (err) {
    console.error(`[Docs] Failed to generate aliases: ${err.message}`);
    process.exit(1);
}
