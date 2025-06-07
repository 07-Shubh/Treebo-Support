from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import paramiko
import json
import uvicorn
from pathlib import Path

app = FastAPI()

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_booking_data(phone_number: str):
    try:
        # SSH connection setup
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        # Use the private key
        private_key = str(Path.home() / '.ssh' / 'conman_id_rsa')
        key = paramiko.RSAKey.from_private_key_file(private_key)
        
        # Connect to the server
        ssh.connect(
            hostname="172.40.40.120",
            username="conman",
            pkey=key,
            timeout=10
        )
        
        # Execute the curl command
        command = f'curl -s "https://crs.treebo.be/v1/bookings?guest_phone={phone_number}"'
        stdin, stdout, stderr = ssh.exec_command(command)
        
        # Get the response
        output = stdout.read().decode().strip()
        error = stderr.read().decode().strip()
        ssh.close()
        
        if error:
            return {"success": False, "error": error}
            
        return {"success": True, "data": json.loads(output)}
        
    except Exception as e:
        return {"success": False, "error": str(e)}

@app.get("/api/booking/{phone_number}")
async def get_booking(phone_number: str):
    result = get_booking_data(phone_number)
    if not result["success"]:
        raise HTTPException(status_code=400, detail=result["error"])
    return result["data"]

if __name__ == "__main__":
    uvicorn.run("booking_server:app", host="0.0.0.0", port=8000, reload=True)
