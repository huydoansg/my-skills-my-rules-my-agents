# ELECTRON DESKTOP ENGINEERING & SECURITY CONVENTIONS

## 1. HARDENED SECURITY BASELINE (MANDATORY)
The default security settings in Electron are insecure. Every `BrowserWindow` must strictly enforce the following security parameters:

```typescript
import { BrowserWindow } from 'electron';

const mainWindow = new BrowserWindow({
  width: 1200,
  height: 800,
  webPreferences: {
    // 1. Mandatory isolation
    contextIsolation: true,
    // 2. Disable Node integration in renderer
    nodeIntegration: false,
    nodeIntegrationInWorker: false,
    // 3. Enable OS-level Chromium sandboxing
    sandbox: true,
    // 4. Secure preload script only
    preload: path.join(__dirname, 'preload.js'),
    // 5. Disable remote module and webview tags
    webSecurity: true,
    allowRunningInsecureContent: false,
  },
});
```

- **Navigation Guard**: Intercept all new window openings and external navigations. Open external links in the user's default OS browser using `shell.openExternal`, never inside the Electron window:
  ```typescript
  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    if (url.startsWith('https:')) {
      shell.openExternal(url);
    }
    return { action: 'deny' };
  });
  ```

## 2. SECURE IPC (INTER-PROCESS COMMUNICATION)
- **Typed, Whitelisted IPC Bridge in Preload**:
  - Never expose raw `ipcRenderer.send` or `ipcRenderer.on` directly to `window`.
  - Expose only strongly typed, narrow API methods via `contextBridge.exposeInMainWorld`.
- **Sender Validation**:
  - In the Main Process (`ipcMain.handle`), always validate the sender's origin (`event.senderFrame.origin`) before executing privileged OS actions (e.g., file reads, shell commands).

```typescript
// preload.ts
import { contextBridge, ipcRenderer } from 'electron';

contextBridge.exposeInMainWorld('desktopAPI', {
  readFile: (filePath: string): Promise<string> => 
    ipcRenderer.invoke('fs:read-file', filePath),
});
```

## 3. LIFECYCLE & MEMORY LEAK PREVENTION
- **Clean Up WebContents Listeners**: Remove all IPC listeners when a window is closed or destroyed to prevent renderer process memory retention.
- **Background Throttling**: Configure `backgroundThrottling: true` so minimized or background windows do not consume unnecessary CPU cycles and drain laptop batteries.
- **Crash Reporting & Auto-Update**: Integrate `electron-updater` with signed binaries and verified HTTPS release servers.
