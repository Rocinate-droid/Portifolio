 <h1>DOCKER FILES</h1>

<h2>1) static_website:</h2>
   <p>-This docker file consists of hosting a static webpage on a port of the user's choice by <n>
   -To build the docker image run the command: docker build -t docker_tag_name. <n>
   -After the docker image has been successfully built run the following command to create a container for the image: docker run -d --name container_name -p 80:80 docker_tag_name <n>
   -You can host the static website either on your local machine or you can also choose to host it on an virtual machine instance on any of the cloud platforms which will allow it to be accessible to anyone on the 
    internet provided they have the public ip of the virtual machine and the port number of the container and the security group must have necessary permissions for the site to be accessible <n>
    -If you are hosting it in your local machine use the address: localhost:80 <n>
    -If you are hosting it in a VM instance use the the address: public-ip-of-instance:80 <n>
   </p>
