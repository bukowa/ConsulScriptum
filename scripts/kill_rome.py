import win32gui
import win32con

def close_window(window_name):
    hwnd = win32gui.FindWindow(None, window_name)
    if hwnd:
        print("Closing window...")
        win32gui.PostMessage(hwnd, win32con.WM_CLOSE, 0, 0)
    else:
        print(f"Window '{window_name}' not found.")
        exit(1)

close_window("Total War: Rome 2")
