# Création des instances EC2, jump_host, master et worker

# Instance EC2 pour les masters
resource "aws_instance" "master" {
    depends_on = [aws_key_pair.kubernetes]

    count = var.master_instance_count
    ami = var.ami_id
    instance_type = var.master_instance_type

    subnet_id = aws_subnet.kubernetes.id
    key_name = aws_key_pair.kubernetes.key_name
    
    associate_public_ip_address = true   
    private_ip = "${var.master_instance_private_ip}${count.index}"

    security_groups = [aws_security_group.kubernetes.id]

    user_data = <<-EOF
            #!/bin/bash
            echo "${var.master_instance_name}${count.index+1}" > /etc/instance-data
            EOF    

    ebs_block_device {
        device_name = "/dev/sda1"
        volume_size = 20
        volume_type = "gp2"
        delete_on_termination = true
    }

    tags = {
        Name = "${var.master_instance_name}${count.index+1}"
        NodeType = "${var.master_instance_nodetype}"
    }  

    provisioner "local-exec" {
        command = <<-EOT
            aws ec2 modify-instance-attribute --instance-id ${self.id} --no-source-dest-check
        EOT
    }
}

# Instance EC2 pour les workers
resource "aws_instance" "worker" {
    depends_on = [aws_key_pair.kubernetes]

    count = var.worker_instance_count
    ami = var.ami_id
    instance_type = var.worker_instance_type

    subnet_id = aws_subnet.kubernetes.id
    key_name = aws_key_pair.kubernetes.key_name
    
    associate_public_ip_address = true   
    private_ip = "${var.worker_instance_private_ip}${count.index}"

    security_groups = [aws_security_group.kubernetes.id]

    user_data = <<-EOF
            #!/bin/bash
            echo "name=worker-${count.index}|pod-cidr=10.200.${count.index}.0/24" > /etc/instance-data
            EOF  

    ebs_block_device {
        device_name = "/dev/sda1"
        volume_size = 20
        volume_type = "gp2"
        delete_on_termination = true
    }

    tags = {
        Name = "${var.worker_instance_name}${count.index+1}"
        NodeType = "${var.worker_instance_nodetype}"
    }  

    provisioner "local-exec" {
        command = <<-EOT
            aws ec2 modify-instance-attribute --instance-id ${self.id} --no-source-dest-check
        EOT
    }
}