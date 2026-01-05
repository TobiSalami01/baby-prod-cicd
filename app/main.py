from flask import Flask
import os

app = Flask(__name__)

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/")
def hello():
    version = os.getenv("APP_VERSION", "v1")
    return {"message": "hello from v3", "version": version}


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)

