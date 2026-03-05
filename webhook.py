import os
import subprocess
import requests
from http.server import BaseHTTPRequestHandler, HTTPServer

BOT_TOKEN = os.environ.get('TELEGRAM_BOT_TOKEN')
CHAT_ID = os.environ.get('TELEGRAM_CHAT_ID')

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/screenshot':
            if not BOT_TOKEN or not CHAT_ID:
                self.send_response(500)
                self.end_headers()
                self.wfile.write(b"Error: Telegram credentials not configured in docker-compose.yml")
                print("Error: Missing Telegram credentials")
                return
            
            print("Taking screenshot...")
            # Take screenshot with scrot
            subprocess.run(["scrot", "/tmp/screenshot.png"], check=False)
            
            if not os.path.exists("/tmp/screenshot.png"):
                self.send_response(500)
                self.end_headers()
                self.wfile.write(b"Error: Failed to take screenshot")
                return

            print("Sending to Telegram...")
            url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendPhoto"
            try:
                with open("/tmp/screenshot.png", "rb") as f:
                    files = {"photo": f}
                    data = {"chat_id": CHAT_ID}
                    # verify=False is needed in some isolated environments to avoid SSL cert issues
                    r = requests.post(url, data=data, files=files, timeout=10, verify=False)
                    
                if r.status_code == 200:
                    self.send_response(200)
                    self.end_headers()
                    self.wfile.write(b"Screenshot sent successfully to Telegram")
                    print("Screenshot sent successfully")
                else:
                    self.send_response(500)
                    self.end_headers()
                    self.wfile.write(f"Telegram API Error: {r.text}".encode())
                    print(f"Telegram API Error: {r.text}")
            except Exception as e:
                self.send_response(500)
                self.end_headers()
                self.wfile.write(f"Internal Error: {str(e)}".encode())
                print(f"Internal Error: {str(e)}")
            finally:
                # Cleanup
                if os.path.exists("/tmp/screenshot.png"):
                    os.remove("/tmp/screenshot.png")
        
        elif self.path == '/health':
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"OK")
        
        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b"Endpoints: /screenshot, /health")

if __name__ == '__main__':
    server_address = ('', 5000)
    httpd = HTTPServer(server_address, SimpleHandler)
    print('Starting webhook server on port 5000...')
    print('Waiting for GET requests on http://localhost:5000/screenshot')
    httpd.serve_forever()
