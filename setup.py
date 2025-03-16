import os
import platform
import subprocess

def run_command(command):
    """ Run a system command """
    result = subprocess.run(command, shell=True, text=True)
    if result.returncode != 0:
        print(f"Error executing: {command}")
        exit(1)

def check_docker():
    """ Check if Docker is installed """
    try:
        subprocess.run(["docker", "--version"], check=True, capture_output=True, text=True)
        print("✅ Docker is installed.")
    except subprocess.CalledProcessError:
        print("❌ Docker is not installed! Please install Docker first:")
        print("🔗 https://www.docker.com/products/docker-desktop/")
        exit(1)

def create_docker_volume():
    """ Ensure the Docker volume is created """
    print("\n🔹 Checking if 'data-volume' exists...")
    result = subprocess.run("docker volume ls -q -f name=data-volume", shell=True, capture_output=True, text=True)
    
    if not result.stdout.strip():
        print("🔹 Creating Docker volume 'data-volume'...")
        run_command("docker volume create data-volume")
    else:
        print("🔹 Docker volume 'data-volume' already exists.")

def setup_docker():
    """ Run Docker Compose to start services """
    print("\n🔹 Starting Docker Compose services...")
    run_command("docker-compose up --build -d")

if __name__ == "__main__":
    check_docker()
    create_docker_volume()  # Ensure the volume is created
    setup_docker()          # Start the services
    print("\n✅ Setup complete! Your Docker containers are running.")
