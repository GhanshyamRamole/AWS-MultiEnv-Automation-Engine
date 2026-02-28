
# --- workerload Nodes (Docker, K8s, Swarm) ---
resource "aws_instance" "workloads" {
  # We use a flattened map to avoid the count/for_each conflict
  for_each = merge(
    { for i in range(var.docker_count) : "docker-${i}" => { type = "docker", name = "docker-node" } },
    { for i in range(var.k8s_count) : "k8s-${i}" => { type = "k8s", name = "k8s-node" } },
    { for i in range(var.swarm_master_count + var.swarm_worker_count) : "swarm-${i}" => { type = "swarm", name = "swarm-node" } }
  )

  ami                    = var.AWS_AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = aws_subnet.public[0].id
  key_name               = var.key
  
  user_data = templatefile("${path.module}/${var.workloads_script_path}", {
    admin_pw = var.passwd
    env_name = var.env
  })  

  tags = { 
    Name = "${var.env}-${each.value.name}" 
    Type = each.value.type
  }
}

# --- Ansible Controller ---
resource "aws_instance" "ansible" {
  count                  = var.ansible_count
  ami                    = var.AWS_AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = aws_subnet.public[0].id
  key_name               = var.key
  
  user_data = templatefile("${path.module}/${var.ansible_script_path}", {
    admin_pw = var.passwd
    env_name = var.env
  })

  connection {
    type     = "ssh"
    user     = "ec2-user" 
    password = var.passwd
    host     = self.public_ip
    timeout  = "2m"
  }
  
  provisioner "remote-exec" {
    inline = flatten([
      # Docker nodes
      [for i in aws_instance.workloads : 
        "echo '${i.private_ip} docker-server' | sudo tee -a /etc/hosts" 
        if i.tags["Type"] == "docker"
      ],
      
      # Kubernetes nodes
      [for i in aws_instance.workloads : 
        "echo '${i.private_ip} kubernetes-server' | sudo tee -a /etc/hosts" 
        if i.tags["Type"] == "k8s"
      ],
      
      # Swarm nodes with Master/Worker distinction
      [for idx, i in [for s in aws_instance.workloads : s if s.tags["Type"] == "swarm"] : 
        idx == 0 ? 
        "echo '${i.private_ip} master' | sudo tee -a /etc/hosts" : 
        "echo '${i.private_ip} worker-node${idx}' | sudo tee -a /etc/hosts"
      ]
    ])
  } 

  tags = { Name = "${var.env}-ansible-controller" }
}
