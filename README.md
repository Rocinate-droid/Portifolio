# 🚀Web App Deployment via Terraform, Docker & Jenkins

This project demonstrates a complete Infrastructure as Code (IaC) pipeline to provision cloud infrastructure and automate deployment of a web application using **Terraform**, **Docker Swarm**, **Ansible**, and **Jenkins**.

---

## 📦 Features

### ✅ Infrastructure as Code (IaC)
- All AWS resources are provisioned using **Terraform**.
- Enables **repeatable**, **predictable**, and **automated** infrastructure deployments.

### 🐳 Container Orchestration
- Docker images are built using **Dockerfiles**.
- **Docker Swarm** is used for orchestrating containers across nodes for **scalability** and **fault tolerance**.

### ⚙️ Configuration Management
- Server configuration is automated via **Ansible Playbooks**.
- Uses **Ansible roles** for modular playbooks and **Ansible Vault** for secure storage of secrets.
- Shell scripts are used for automating manual deployment tasks.

### 🔐 Security
- Resources are launched in a **custom VPC** with specific **subnets**, **network interfaces**, **security groups**, and **private IPs**.
- Secure handling of access credentials and traffic control.

### 🔄 CI/CD Pipeline
- **Jenkins** is used to automate the deployment of the web application.
- Manages credentials securely and reduces deployment time.

### 🔧 Web App Deployment
- You can deploy **any web application** by simply modifying the `Dockerfile` according to your app's requirements.

---

## 📁 Terraform Modules

- **`instance_template`**: Provisions the **master server** along with its VPC, subnet, and security groups. Configuration is bootstrapped via **cloud-init**.
- **`node_template`**: Provisions **worker nodes** that join the Docker Swarm cluster (You can increase the no of nodes needed as per your need by modifying this template but also take care to add and modify the variables also)

---
## Terraform variables

## 📥 Terraform Variables

| Variable            | Description                                     |
|---------------------|-------------------------------------------------|
| `region`            | Region where your instance will be deployed     |
| `vpc-cidr`          | CIDR block for the VPC                          |
| `subnet-cidr`       | CIDR block for the subnet                       |
| `ami`               | AMI ID to launch the EC2 instance               |
| `instance-type`     | EC2 instance type (e.g., t2.micro)              |
| `key`               | Key pair name to access the instance            |
| `role`              | IAM role name (should allow EC2 access)         |
| `private-ip`        | Private IP of the node instance                 |
| `master-private-ip` | Private IP of the master instance               |

## 🚀 Usage Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo

## 2. AWS Credentials & Key Setup

- Generate **Access Key** and **Secret Key** from your AWS account.
- Create an **IAM Role** with EC2 access.
- Generate an **EC2 key pair**  
  *(Take care to change the IAM role and EC2 key pair in the terraform variables.)*

---

### 3. Export AWS Credentials

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
```

---

### 4. Deploy the Master Server

- Go to the master template folder and execute the following command:
```bash
bash create.sh
```

---

### 6. Set Up SSH Key for Nodes

Inside the master instance:

```bash
ssh-keygen
```

- Copy the **public key** and paste it into the `user_data` section of the `node_template` Terraform file.

---

### 7. Initialize Docker Swarm

Inside the master instance:

```bash
docker swarm init
```

- Copy the **join token** displayed in the terminal.

---

### 8. Store Swarm Token Securely

```bash
cd resume-role/vars
ansible-vault edit main.yml
```

> 💡 Password: `devops`  
> Paste the **Docker Swarm join token** inside the `main.yml` file.

---

### 10. Deploy Nodes

- Inside the master instance
```bash
cd node_template
terraform init
terraform apply
```

---

### 11. Jenkins Setup

- Visit Jenkins at:

```
http://<master-public-ip>:8080
```

- Add a Jenkins **credential** for accessing ansible vault(swarm token):

  - **ID**: `vault_password`  
  - **Secret Text**: `devops`

---

### 12. Setup Pipeline

- Push your files to a **GitHub repository**.
- Create a **Pipeline Job** in Jenkins and link it to your GitHub repo.
- Trigger the pipeline to deploy the application.

---

### 13. Access Your Web Application

Visit your deployed web application:

```
http://<master-public-ip>:80
http://<node-public-ip>:80
```
