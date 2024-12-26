resource "aws_eks_cluster" "eks" {
    name = "node-cluster"
    role_arn = aws_iam_role.cluster.arn
    vpc_config {
      subnet_ids = [aws_subnet.subnets[0].id,aws_subnet.subnets[1].id,aws_subnet.subnets[2].id]
    }
  
  depends_on = [ aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy ]
}