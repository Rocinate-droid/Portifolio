# Docker Files
<h2> 1) static_website </h2>
This Dockerfile allows you to host a static webpage on a port of your choice using nginx. You can run it locally or deploy it to a cloud-based virtual machine for public access.

<h3>✅ Prerequisites</h3>
-Before you begin, make sure you have the following installed:

-Docker installed on your system.

-Basic understanding of how to use the command line.

-(Optional) A cloud provider account (e.g., AWS, GCP, Azure) if deploying on a virtual machine.

-If using a cloud VM:

  -A public IP address.

  -Firewall or security group allowing inbound traffic on port 80.

<h3>🔧 Build the Docker Image</h3>
docker build -t your_image_name.

<h3>🚀 Run the Docker Container</h3>
docker run -d --name your_container_name -p 80:80 your_image_name
<h3>🌐 Accessing the Website</h3>
Local Machine:
Visit http://localhost:80

Cloud VM Instance:
Visit http://vm-public-ip:80

<h3>Make sure:</h3>
-Port 80 is open in your VM's firewall or security group settings.

-The Docker container is running and mapped correctly.

