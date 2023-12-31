resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "myeks-vpc"
  }
}

# public and private subnet resource
resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = var.public_subnet_cidr_blocks

  tags = {
    Name                                       = "public-subnet"
    "kubernetes.io/cluster/assessment-cluster" = "shared"
    "kubernetes.io/role/elb"                   = 1
  }
}

resource "aws_subnet" "private" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = var.private_subnet_cidr_blocks

  tags = {
    Name = "private-subnet"
    "kubernetes.io/cluster/assessment-cluster" = "shared"
    "kubernetes.io/role/internal-elb"          = 1
  }
}

#internet gateway, NAT gateway, and route tables.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "main-igw"
  }

  depends_on = [aws_vpc.main]
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "10.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "main-rt"
  }
}

resource "aws_route_table_association" "internet_access" {
  count = var.availability_zones_count

  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main.id
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "myngw"
  }
}

# NAT Elastic IP
resource "aws_eip" "main" {
  vpc = true

  tags = {
    Name = "myeip"
  }
}

# Add route to route table
resource "aws_route" "main" {
  route_table_id         = aws_vpc.main.default_route_table_id
  nat_gateway_id         = aws_nat_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

# Security group for public subnet
resource "aws_security_group" "public_sg" {
  name   = "public-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-sg"
  }
}

# Security group traffic rules
resource "aws_security_group_rule" "sg_ingress_https" {
  security_group_id = aws_security_group.public_sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_ingress_http" {
  security_group_id = aws_security_group.public_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_egress_public" {
  security_group_id = aws_security_group.public_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Security group for data plane
resource "aws_security_group" "data_plane_sg" {
  name   = "worker-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "worker-sg"
  }
}

# Security group traffic rules
resource "aws_security_group_rule" "nodes" {
  description       = "Allow nodes to communicate with each other"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["10.0.1.0/24"]
}

resource "aws_security_group_rule" "nodes_inbound" {
  description       = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["10.0.1.0/24"]
}

resource "aws_security_group_rule" "nodes_outbound" {
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Security group for control plane
resource "aws_security_group" "control_sg" {
  name   = "control-plane-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "control-plane-sg"
  }
}

# Security group traffic rules
resource "aws_security_group_rule" "control_inbound" {
  security_group_id = aws_security_group.control_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["10.0.1.0/24"]
}

resource "aws_security_group_rule" "control_outbound" {
  security_group_id = aws_security_group.control_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "db-sg" {
  name   = "mydb-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "mydb-sg"
  }
}

# Security group traffic rules
resource "aws_security_group_rule" "mydb_inbound" {
  security_group_id = aws_security_group.db-sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["10.0.1.0/24"]
}

resource "aws_security_group_rule" "mydb_outbound" {
  security_group_id = aws_security_group.db-sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}