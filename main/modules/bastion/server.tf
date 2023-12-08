resource "aws_key_pair" "key-pair" {
  count      = var.enabled ? 1 : 0
  key_name   = var.cluster-name
  public_key = var.ec2-public-key
}


### bastion

### bastion hosts
module "bastion-asg" {
  count   = var.enabled ? 1 : 0
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"
  name    = "${var.cluster-name}-${var.name}"

  lc_name = "${var.cluster-name}-${var.name}-lc"

  image_id                     = var.image-ami # ami-0b5eea76982371e91
  instance_type                = var.instance-type
  security_groups              = [data.aws_security_group.bastion.0.id]
  associate_public_ip_address  = true
  recreate_asg_when_lc_changes = true

  root_block_device = [
    {
      volume_size           = var.volume-size
      volume_type           = var.volume-type
      delete_on_termination = true
    },
  ]

  # Auto scaling group
  asg_name                  = "${var.cluster-name}-${var.name}"
  vpc_zone_identifier       = data.aws_subnets.public.ids
  health_check_type         = "EC2"
  min_size                  = var.min-size
  max_size                  = var.max-size
  desired_capacity          = var.desired-size
  wait_for_capacity_timeout = 0
  key_name                  = aws_key_pair.key-pair.0.key_name
  
  user_data = <<-EOF
    #!/bin/bash
    echo "[0] Remove aws cli version 1"
    yum remove awscli -y 

    echo "[1] Install aws cli version 2"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    echo "[2] Install Kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    sudo yum install bash-completion -y
    source /usr/share/bash-completion/bash_completion
    echo 'source <(kubectl completion bash)' >>~/.bashrc


    echo "[3] Install Helm"
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    
    echo "[4] Install kns"
    sudo curl https://raw.githubusercontent.com/blendle/kns/master/bin/kns -o /usr/local/bin/kns && sudo chmod +x $_
    
    sudo yum install git -y 
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install

    sudo yum update -y
  
  EOF


  tags = [
    {
      key                 = "kubernetes.io/cluster/${var.cluster-name}"
      value               = "owned"
      propagate_at_launch = true
      Environment         = var.Environment
      CreatedBy           = "Terraform"
    }
  ]
}
