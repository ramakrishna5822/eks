resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.cluster.arn
  subnet_ids      = aws_subnet.subnets[*].id

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t2.micro"]

  launch_template {
    id      = aws_launch_template.eks_launch_template.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "eks_launch_template" {
  name          = "eks-launch-template"
  image_id =   var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data = <<-EOF
  #!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
  EOF
  tags = {
    Name = "${var.vpc_name}-servers"
  }
}

