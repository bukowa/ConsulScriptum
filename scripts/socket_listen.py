import socket

HOST = "0.0.0.0"  # Listen on all network interfaces
PORT = 9155       # Default MobDebug port

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_socket.bind((HOST, PORT))
server_socket.listen(1)
server_socket.settimeout(10)  # Set timeout for socket connections

print(f"[*] Listening on {HOST}:{PORT}")

while True:
    try:
        client_socket, client_address = server_socket.accept()
        print(f"[+] Connection from {client_address}")

        while True:
            try:
                data = client_socket.recv(1024)
                if not data:
                    print("[-] No more data, client might have disconnected.")
                    break
                print(f"[RECV] {data.decode(errors='ignore')}")
                client_socket.sendall(data)
            except Exception as e:
                print(f"[ERROR] Receiving Data: {e}")
                break

        client_socket.close()
        print(f"[-] Connection closed")

    except Exception as e:
        print(f"[ERROR] Accepting Connection: {e}")
