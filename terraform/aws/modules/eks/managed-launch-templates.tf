resource "aws_launch_template" "managed_node_group" {
  name_prefix            = "${var.name}-eks-mng-lt-"
  description            = "Launch Template for ${var.name} EKS Managed Node Group"
  update_default_version = true
  image_id               = ""

  network_interfaces {
    security_groups = [aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_size           = var.disk_size
      volume_type           = "gp3"
      iops                  = 3000
      throughput            = 125
    }
  }

  ebs_optimized = true

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  lifecycle {
    create_before_destroy = true
  }
}