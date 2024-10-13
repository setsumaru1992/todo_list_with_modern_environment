terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "values" {
  source = "../"
}

module "global_network" {
  source = "../../network/modules"
}

resource "aws_ecs_cluster" "new_cluster" {
  name  = module.values.cluster_name
}

resource "aws_iam_role" "ecs_task_execution" {
  name = module.values.ecs_task_execution_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# ECRとS3へのアクセス権限を付与するポリシーの作成
resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "ecsTaskExecutionPolicy"
  description = "Policy for ECS task to access ECR and S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_cloudwatch_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_cloudwatch_log_group" "ecs_fargate" {
  name              = "/ecs/fargate-task"
  retention_in_days = 7
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.global_network.vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [module.global_network.private_rt_id]
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id       = module.global_network.vpc_id
  service_name = "com.amazonaws.ap-northeast-1.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids   = [module.global_network.private_subnet_id, module.global_network.private_subnet_id2]
  security_group_ids = [aws_security_group.ecr_endpoint_sg.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id       = module.global_network.vpc_id
  service_name = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids   = [module.global_network.private_subnet_id, module.global_network.private_subnet_id2]
  security_group_ids = [aws_security_group.ecr_endpoint_sg.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id             = module.global_network.vpc_id
  service_name       = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [module.global_network.private_subnet_id, module.global_network.private_subnet_id2]
  security_group_ids = [aws_security_group.ecr_endpoint_sg.id]
  private_dns_enabled = true
}

resource "aws_security_group" "ecr_endpoint_sg" {
  vpc_id = module.global_network.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${module.values.appname}-vpc_endpoint-sg"
  }
}

resource "aws_cloudwatch_log_group" "vpc_endpoint_logs" {
  name = "vpc-endpoint-logs"
  retention_in_days = 7
}

resource "aws_iam_role" "vpc_endpoint_logs_role" {
  name = "vpc-endpoint-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "vpc_endpoint_logs_policy" {
  name = "vpc-endpoint-logs-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "logs:CreateLogStream",
        Resource = "${aws_cloudwatch_log_group.vpc_endpoint_logs.arn}:*"
      },
      {
        Effect = "Allow",
        Action = "logs:PutLogEvents",
        Resource = "${aws_cloudwatch_log_group.vpc_endpoint_logs.arn}:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vpc_endpoint_logs_role_attachment" {
  role       = aws_iam_role.vpc_endpoint_logs_role.name
  policy_arn = aws_iam_policy.vpc_endpoint_logs_policy.arn
}

resource "aws_flow_log" "vpc_endpoint_flow_log" {
  vpc_id        = module.global_network.vpc_id
  log_destination     = aws_cloudwatch_log_group.vpc_endpoint_logs.arn
  log_destination_type = "cloud-watch-logs"
  iam_role_arn   = aws_iam_role.vpc_endpoint_logs_role.arn
  traffic_type   = "ALL"
}
