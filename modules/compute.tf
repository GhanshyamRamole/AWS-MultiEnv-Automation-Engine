# Resource for different envornments Docker/K8s/Swarm nodes

resource "aws_instance" "workloads" {
  for_each = {
    docker = var.docker_count
    k8s    = var.k8s_count
    swarm  = var.swarm_master_count + var.swarm_worker_count
  }
  
  count                  = each.value
  ami                    = var.AWS_AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = aws_subnet.public.id
  key_name               = var.key
  
  user_data = templatefile("${path.root}/${workloads_script_path}", {
    admin_pw = var.passwd
    env_name = var.env
  })  

  tags                   = { Name = "${var.env}-${each.key}-node" }
}

# --- Ansible Master Creation ---

resource "aws_instance" "ansible" {
  count                  = var.ansible_count
  ami                    = var.AWS_AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = aws_subnet.public.id
  key_name               = var.key
  
  user_data = templatefile("${path.root}/${var.ansible_script_path}", {
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
        if i.tags["Name"] == "${var.env}-docker-node"
      ],
      
      # Kubernetes nodes
      [for i in aws_instance.workloads : 
        "echo '${i.private_ip} kubernetes-server' | sudo tee -a /etc/hosts" 
        if i.tags["Name"] == "${var.env}-k8s-node"
      ],
      
      # Swarm nodes with Master and Worker 
      [for idx, i in [for s in aws_instance.workloads : s if s.tags["Name"] == "${var.env}-swarm-node"] : 
        idx == 0 ? 
        "echo '${i.private_ip} master' | sudo tee -a /etc/hosts" : 
        "echo '${i.private_ip} worker-node${idx}' | sudo tee -a /etc/hosts" 
    ])
  } 

  tags = { Name = "${var.env}-ansible-controller" }
}
