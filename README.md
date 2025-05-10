Docker Files
1) Static Website
This Dockerfile allows you to host a static webpage on a port of your choice. You can run it locally or deploy it to a cloud-based virtual machine for public access.

✅ Prerequisites
Before you begin, make sure you have the following installed:

Docker installed on your system.

Basic understanding of how to use the command line.

(Optional) A cloud provider account (e.g., AWS, GCP, Azure) if deploying on a virtual machine.

If using a cloud VM:

A public IP address.

Firewall or security group allowing inbound traffic on port 80.

🔧 Build the Docker Image
bash
Copy
Edit
docker build -t your_image_name .
🚀 Run the Docker Container
bash
Copy
Edit
docker run -d --name your_container_name -p 80:80 your_image_name
🌐 Accessing the Website
Local Machine:
Visit http://localhost:80

Cloud VM Instance:
Visit http://<your-public-ip>:80

Make sure:

Port 80 is open in your VM's firewall or security group settings.

The Docker container is running and mapped correctly.

