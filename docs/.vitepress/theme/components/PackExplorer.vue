<script setup lang="ts">
import { ref, computed } from 'vue'
import PackExplorerItem from './PackExplorerItem.vue'

interface PackFile {
  path: string
  content: string
  language?: string
}

const props = defineProps<{
  packName: string
  files: PackFile[]
}>()

const selectedFile = ref<PackFile | null>(props.files[0] || null)
const expandedFolders = ref<Record<string, boolean>>({})
const sidebarWidth = ref(220)
const showSidebar = ref(true)

const isResizing = ref(false)

const toggleSidebar = () => {
  showSidebar.value = !showSidebar.value
}

const startResizing = () => {
  if (!showSidebar.value) return
  isResizing.value = true
  window.addEventListener('mousemove', handleMouseMove)
  window.addEventListener('mouseup', stopResizing)
}

const handleMouseMove = (e: MouseEvent) => {
  if (!isResizing.value) return
  const explorer = document.querySelector('.pack-explorer')
  if (explorer) {
    const rect = explorer.getBoundingClientRect()
    const newWidth = e.clientX - rect.left
    if (newWidth > 100 && newWidth < 400) {
      sidebarWidth.value = newWidth
    }
  }
}

const stopResizing = () => {
  isResizing.value = false
  window.removeEventListener('mousemove', handleMouseMove)
  window.removeEventListener('mouseup', stopResizing)
}

// Tree node structure
interface TreeNode {
  name: string
  fullPath: string
  isFolder: boolean
  children: Record<string, TreeNode>
  fileRef?: PackFile
  isRoot?: boolean
}

const tree = computed(() => {
  const rootNode: TreeNode = {
    name: props.packName,
    fullPath: 'root',
    isFolder: true,
    isRoot: true,
    children: {}
  }
  
  props.files.forEach(file => {
    const parts = file.path.split('/')
    let current = rootNode.children
    let currentPath = ''
    
    parts.forEach((part, index) => {
      currentPath = currentPath ? `${currentPath}/${part}` : part
      const isLast = index === parts.length - 1
      
      if (!current[part]) {
        current[part] = {
          name: part,
          fullPath: currentPath,
          isFolder: !isLast,
          children: {},
          fileRef: isLast ? file : undefined
        }
      }
      current = current[part].children
    })
  })
  
  return { [props.packName]: rootNode }
})

const toggleFolder = (path: string) => {
  expandedFolders.value[path] = !expandedFolders.value[path]
}

const selectFile = (file: PackFile) => {
  selectedFile.value = file
}
</script>

<template>
  <div class="pack-explorer" :class="{ 'is-resizing': isResizing }">
    <div class="pack-header">
      <div class="header-left">
        <button class="toggle-btn" @click="toggleSidebar" :title="showSidebar ? 'Collapse Sidebar' : 'Expand Sidebar'">
          <span v-if="showSidebar">📂</span>
          <span v-else>📁</span>
        </button>
        <span class="pack-name">{{ packName }}</span>
      </div>
      <div class="header-right">
        <span class="status-badge">RPFM Mode</span>
      </div>
    </div>
    
    <div class="pack-body">
      <!-- Sidebar / Tree View -->
      <div v-show="showSidebar" class="pack-sidebar" :style="{ width: sidebarWidth + 'px' }">
        <div class="sidebar-label">PACK CONTENTS</div>
        <PackExplorerItem 
          :nodes="tree" 
          :expanded-folders="expandedFolders"
          :selected-path="selectedFile?.path"
          @select="selectFile"
          @toggle="toggleFolder"
        />
      </div>

      <!-- Resizer Handle -->
      <div v-show="showSidebar" class="pack-resizer" @mousedown="startResizing"></div>
      
      <!-- Main Content / Editor View -->
      <div class="pack-content">
        <div v-if="selectedFile" class="file-view">
          <div class="file-header">
            <span class="file-path">{{ selectedFile.path }}</span>
          </div>
          
          <div class="file-body">
            <div class="code-container">
              <pre><code>{{ selectedFile.content }}</code></pre>
            </div>
          </div>
        </div>
        <div v-else class="empty-state">
          <div class="welcome-view">
            <span class="welcome-icon">⚡</span>
            <p>Select a script to view its contents</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.pack-explorer {
  display: flex;
  flex-direction: column;
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  background-color: var(--vp-c-bg-soft);
  margin: 24px 0;
  overflow: hidden;
  font-family: var(--vp-font-family-mono);
  font-size: 12px;
  height: 400px;
  box-shadow: var(--vp-shadow-3);
}

.is-resizing {
  user-select: none;
  cursor: col-resize;
}

.pack-header {
  padding: 6px 12px;
  background-color: var(--vp-c-bg-mute);
  border-bottom: 1px solid var(--vp-c-divider);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.toggle-btn {
  background: var(--vp-c-bg-soft);
  border: 1px solid var(--vp-c-divider);
  cursor: pointer;
  padding: 2px 6px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  font-size: 12px;
}

.toggle-btn:hover {
  background-color: var(--vp-c-brand-soft);
  border-color: var(--vp-c-brand);
}

.pack-name { font-weight: 600; color: var(--vp-c-text-1); letter-spacing: 0.3px; }

.status-badge {
  font-size: 9px;
  padding: 2px 6px;
  background-color: var(--vp-c-brand-soft);
  color: var(--vp-c-brand-1);
  border-radius: 10px;
  font-weight: 700;
  text-transform: uppercase;
}

.pack-body {
  display: flex;
  flex: 1;
  overflow: hidden;
  position: relative;
}

.pack-sidebar {
  min-width: 100px;
  max-width: 400px;
  border-right: 1px solid var(--vp-c-divider);
  overflow-y: auto;
  background-color: var(--vp-c-bg-alt);
}

.sidebar-label {
  padding: 8px 12px;
  font-size: 9px;
  font-weight: 700;
  color: var(--vp-c-text-3);
  letter-spacing: 1px;
  border-bottom: 1px solid var(--vp-c-divider);
  background-color: var(--vp-c-bg-mute);
}

.pack-resizer {
  width: 4px;
  margin-left: -2px;
  cursor: col-resize;
  z-index: 10;
  transition: background 0.2s;
}

.pack-resizer:hover, .is-resizing .pack-resizer {
  background-color: var(--vp-c-brand);
}

.pack-content {
  flex: 1;
  overflow: auto;
  background-color: var(--vp-c-bg);
  position: relative;
}

.file-view {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.file-header {
  padding: 4px 12px;
  background-color: var(--vp-c-bg-soft);
  border-bottom: 1px solid var(--vp-c-divider);
  color: var(--vp-c-text-3);
  font-size: 10px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.file-body {
  flex: 1;
  padding: 12px;
  overflow: auto;
}

.code-container pre {
  margin: 0;
  padding: 0;
  background: transparent !important;
  line-height: 1.4;
  font-size: 11px;
  color: var(--vp-c-text-1);
}

.empty-state {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: var(--vp-c-text-3);
  text-align: center;
}

.welcome-view {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.welcome-icon {
  font-size: 32px;
  opacity: 0.5;
}

.empty-state p {
  margin: 0;
  font-style: italic;
}
</style>
