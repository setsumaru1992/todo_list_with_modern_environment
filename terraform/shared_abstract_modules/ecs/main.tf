terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "network" {
  source = "../../global/network/modules"
}

module "global_ecs" {
  source = "../../global/ecs/modules"
}

locals {
  application_port = var.application_port
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.service_name}_task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.total_cpu
  memory                   = var.total_memory
  execution_role_arn       = module.global_ecs.ecs_task_execution_iam_role_arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = var.cpu_architecture
  }

  container_definitions = jsonencode([{
    name  = var.service_name
    image = var.docker_image_name
    essential = true
    portMappings = [{
      containerPort = local.application_port
      hostPort      = local.application_port
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/fargate-task"    # CloudWatch Logsのロググループ
        "awslogs-region"        = "ap-northeast-1"       # リージョン
        "awslogs-stream-prefix" = "ecs"                  # ストリームのプレフィックス
        "awslogs-create-group"  = "true"                 # ロググループの自動作成
        "mode"                  = "non-blocking"         # モード
        "max-buffer-size"       = "25m"                  # 最大バッファサイズ
      }
    }
    cpu    = var.cpu_per_task
    memory = var.memory_per_task
    healthCheck = {
      command     = ["CMD-SHELL", "curl -f ${var.healthcheck_url} || exit 1"]
      interval    = 30  # ヘルスチェックの間隔（秒）
      timeout     = 5   # タイムアウト（秒）
      retries     = 3   # リトライ回数
      startPeriod = 60  # 起動後の初回ヘルスチェックまでの待機時間（秒）
    }
  }])
}

resource "aws_ecs_service" "app" {
  name            = "${var.service_name}-service"
  cluster         = module.global_ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_circuit_breaker {
    enable   = true   # サーキットブレーカーを有効化
    rollback = true   # 失敗時のロールバックを有効化
  }

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.main.id]
    assign_public_ip = true
  }

  #   load_balancer {
  #     target_group_arn = aws_lb_target_group.main.arn
  #     container_name   = "app"
  #     container_port   = 80
  #   }
  #
  #   depends_on = [
  #     aws_lb_listener.main
  #   ]
}

resource "aws_security_group" "main" {
  vpc_id = module.network.vpc_id

  ingress {
    from_port   = local.application_port
    to_port     = local.application_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-sg"
  }
}

module "fetch_ip_address_of_task" {
  count = var.skip_displaying_ip ? 0 : 1
  source = "./fetch_ip_address_of_task"

  ecs_cluster_id = module.global_ecs.ecs_cluster_id
  ecs_service_name = aws_ecs_service.app.name
}

output "ecs_task_public_ip" {
  value = var.skip_displaying_ip ? "(skip)" : module.fetch_ip_address_of_task[0].ecs_task_public_ip
}