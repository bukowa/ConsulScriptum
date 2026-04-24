<script setup lang="ts">
import { ref } from 'vue'

interface PackFile {
  path: string
  content: string
  language?: string
}

const props = defineProps<{
  nodes: any
  expandedFolders: Record<string, boolean>
  selectedPath?: string
}>()

const emit = defineEmits(['select', 'toggle'])
</script>

<template>
  <ul class="tree-list">
    <li v-for="node in nodes" :key="node.fullPath" :class="{ 'is-folder': node.isFolder, 'is-selected': selectedPath === node.fullPath }">
      <div class="tree-item" @click="node.isFolder ? emit('toggle', node.fullPath) : emit('select', node.fileRef)">
        <span class="tree-expander" v-if="node.isFolder">
          {{ expandedFolders[node.fullPath] === false ? '▶' : '▼' }}
        </span>
        <span class="tree-icon">
          <span v-if="node.isRoot">📦</span>
          <span v-else-if="node.isFolder">📁</span>
          <span v-else>📄</span>
        </span>
        <span class="tree-label">{{ node.name }}</span>
      </div>
      <PackExplorerItem 
        v-if="node.isFolder && expandedFolders[node.fullPath] !== false"
        :nodes="node.children" 
        :expanded-folders="expandedFolders"
        :selected-path="selectedPath"
        @select="emit('select', $event)"
        @toggle="emit('toggle', $event)"
      />
    </li>
  </ul>
</template>

<style scoped>
.tree-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.tree-list .tree-list {
  padding-left: 16px;
}

.tree-item {
  padding: 2px 8px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 4px;
  white-space: nowrap;
  user-select: none;
  color: var(--vp-c-text-1);
}

.tree-item:hover {
  background-color: var(--vp-c-bg-soft);
}

.is-selected > .tree-item {
  background-color: var(--vp-c-brand-soft);
  color: var(--vp-c-brand-1);
  font-weight: 600;
}

.tree-expander {
  width: 12px;
  font-size: 9px;
  color: var(--vp-c-text-3);
}

.tree-icon {
  font-size: 14px;
}

.tree-label {
  flex: 1;
}
</style>
