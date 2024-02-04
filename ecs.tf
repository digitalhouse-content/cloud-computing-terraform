locals {
  launch-type = "FARGATE"
  public-ip = true
}

resource "aws_ecr_repository" "ecr_cloud" {
  name                 = "${var.subject}-webapp-rickandmorty"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.subject}-webapp-rickandmorty"
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.subject}-ecs-cluster"
}

resource "aws_cloudwatch_log_group" "logs_cloud_webapp" {
  name              = "/ecs/${var.subject}-ecs-cluster"
  retention_in_days = 3
}

resource "aws_iam_role" "task_role" {
  name = "${var.subject}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_role_policy" {
  role = aws_iam_role.task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "task" {
  family = "${var.subject}-rickandmorty"
  network_mode = "awsvpc"
  requires_compatibilities = [ local.launch-type ]
  cpu = "256"
  memory = "512"
  container_definitions = jsonencode([{
    name = "rickandmorty-webapp",
    image = "${aws_ecr_repository.ecr_cloud.repository_url}:latest",
    portMappings = [
      {
        containerPort = "${var.port}",
        hostPort = "${var.port}"
      }
    ],
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group = "/ecs/${var.subject}-ecs-cluster"
        awslogs-region = "${var.region}"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])

  execution_role_arn = aws_iam_role.task_role.arn

  depends_on = [ aws_iam_role.task_role, aws_ecr_repository.ecr_cloud ]
}

resource "aws_security_group" "ecs_sg_cloud" {
  name = "ecs-sg-${var.subject}"
  description = "Grupo de seguridad para el cluster de ECS Cloud 2"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "ecs-sg-${var.subject}"
  }
}

resource "aws_ecs_service" "service" {
  name = "${var.subject}-rickandmorty"
  cluster = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type = local.launch-type

  network_configuration {
    subnets = [ aws_subnet.subnet_public_1.id, aws_subnet.subnet_public_2.id ]
    security_groups = [ aws_security_group.ecs_sg_cloud.id ]
    assign_public_ip = local.public-ip
  }

  depends_on = [ aws_ecs_cluster.cluster, aws_ecs_task_definition.task, aws_subnet.subnet_public_1, aws_subnet.subnet_public_2, aws_security_group.ecs_sg_cloud ]

  desired_count = 1
}