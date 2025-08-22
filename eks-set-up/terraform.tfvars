aws_region = "ap-south-1"

vpc_id = "vpc-0114f80fc60f57e9a"

public_subnet_ids = [
  "subnet-0eecfa527631671e9",
  "subnet-05ce859e6ed12144f"
]

private_subnet_ids = [
  "subnet-0e6d10968b340c4fe",
  "subnet-0f8e2c062110b349b"
]

cluster_security_group_ids = ["sg-0ca58afc00365e384"]
node_security_group_ids    = ["sg-0ca58afc00365e384"]

eks_cluster_role_name = "eks-cluster-manage-role"
eks_node_role_name    = "eks-node-role"

cluster_name       = "poc-eks-cluster-1"
node_group_name    = "worker-node-group"
node_instance_type = "t3.medium"

desired_capacity = 2
min_size         = 1
max_size         = 4

ssh_key_name = "mykeypai"

cluster_ip_family = "ipv4"

