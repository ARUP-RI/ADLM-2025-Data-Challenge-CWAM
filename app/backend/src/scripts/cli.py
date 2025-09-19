import os
import subprocess
import sys
from dotenv import load_dotenv


def start_api():
    load_dotenv()  # Load environment variables from a .env file if present

    cmd = [sys.executable, "-m", "gunicorn", "app.api:app"]

    options = {
        "--name": "ADLM-CWAM-API",
        "--bind": "0.0.0.0:8000",
        "--workers": "4",
        "-k": "uvicorn.workers.UvicornWorker",
        "--access-logfile": "-",
        "--error-logfile": "-",
    }
    cmd.extend([f"{k}={v}" if v else k for k, v in options.items()])

    try:
        return subprocess.run(cmd, env=os.environ)
    except OSError as e:
        print(f"Failed to start Gunicorn: {e}", file=sys.stderr)
        return 1
