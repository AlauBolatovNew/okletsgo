

# Define the Launch Template for Worker Nodes



resource "aws_iam_instance_profile" "example" {
  name = "alau-instance-profile"
  role = "alau-AmazonEKSNodeGroupRole"
}

resource "aws_launch_template" "eks_launch_template" {
  iam_instance_profile {
    name = aws_iam_instance_profile.example.name
  }

  name_prefix            = "eks-node-"
  instance_type          = "t3.medium"
  image_id               = "ami-06915c069b7e75bb8" # You can use this as a dynamic value if specified in TFVars

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 8
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  user_data = base64encode(<<EOF
  #!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh alau-cluster 
/opt/aws/bin/cfn-signal --exit-code $? \
         --stack  alau-cluster-workers \
         --resource NodeGroup  \
         --region us-east-1
EOF
  )

  network_interfaces {
    device_index    = 0
    security_groups = var.security_group_ids
    associate_public_ip_address = true
  }

  tags = {
    "Name"   = "temporary-eks-cluster-dev-temporary-eks-cluster-dev-workers-Node"
    "KubernetesCluster" = "temporary-eks-cluster-dev"
    "kubernetes.io/cluster/temporary-eks-cluster-dev" = "owned"
  }
}

# Define the Auto Scaling Group for EKS Worker Nodes
resource "aws_autoscaling_group" "eks_asg" {
  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 3
  vpc_zone_identifier       = var.subnets
  health_check_type         = "EC2"
  health_check_grace_period = 300

  # Define Mixed Instances Policy with On-Demand and Spot Instances
  mixed_instances_policy {
    instances_distribution {
      on_demand_percentage_above_base_capacity = 20
      spot_allocation_strategy                 = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.eks_launch_template.id
        version            = "$Latest"
      }
    }
  }

  # Define Tags for Auto Scaling Group (Note the use of "tag" block)
  tag {
    key                 = "Name"
    value               = "temporary-eks-cluster-dev-temporary-eks-cluster-dev-workers-Node"
    propagate_at_launch = true
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = true
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/temporary-eks-cluster-dev"
    value               = "true"
    propagate_at_launch = true
  }
  tag {
    key                 = "kubernetes.io/cluster/temporary-eks-cluster-dev"
    value               = "owned"
    propagate_at_launch = true
  }

  service_linked_role_arn = "arn:aws:iam::864899873372:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
}
