# Création de l'infrastructure réseau

# Création du VPC
resource "aws_vpc" "kubernetes" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}"
    } 
}

# Création du sous-réseau public kubernetes
resource "aws_subnet" "kubernetes" {
    vpc_id     = aws_vpc.kubernetes.id
    cidr_block = var.subnet_cidr
    tags = {
        Name = "${var.subnet_name}"
    } 
}

# Création de la passerelle internet
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.kubernetes.id
    tags = {
        Name = "${var.gateway_name}"
    }  
}

# Création de la table de route du sous-réseau public kubernetes et association avec le sous-réseau
resource "aws_route_table" "kubernetes" {
    vpc_id = aws_vpc.kubernetes.id
    route {
        cidr_block = var.route_table_cidr
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "${var.route_table_name}"
    }  
}

resource "aws_route_table_association" "kubernetes" {
    subnet_id      = aws_subnet.kubernetes.id
    route_table_id = aws_route_table.kubernetes.id
}

# Création du groupe de sécurité pour le sous-réseau public kubernetes et définition des règles de sécurité
resource "aws_security_group" "kubernetes" {
    name = var.security_group_name
    description = var.security_group_description
    vpc_id = aws_vpc.kubernetes.id
    tags = {
        Name = "${var.security_group_name}"
    }
}

resource "aws_security_group_rule" "autoriser_tous_le_traffic_sortant" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = var.egress_cidr
    security_group_id = "${aws_security_group.kubernetes.id}"
}

resource "aws_security_group_rule" "autoriser_tous_le_traffic_entrant_entre_les_instances" {
    type = "ingress"
    from_port = -1
    to_port = -1
    protocol = "-1"
    cidr_blocks = var.ingress_cidr
    security_group_id = "${aws_security_group.kubernetes.id}"
}

resource "aws_security_group_rule" "autoriser_le_traffic_entrant_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.ssh_cidr
    security_group_id = "${aws_security_group.kubernetes.id}"
}

resource "aws_security_group_rule" "autoriser_le_traffic_entrant_entre_les_clusters" {
    type = "ingress"
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = var.cluster_cidr
    security_group_id = "${aws_security_group.kubernetes.id}"
}

resource "aws_security_group_rule" "autoriser_le_traffic_entrant_https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = var.https_cidr
    security_group_id = "${aws_security_group.kubernetes.id}"
}

resource "aws_security_group_rule" "autoriser_les_requetes_ping" {
    type = "ingress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = var.ping_cidr
    security_group_id = "${aws_security_group.kubernetes.id}"
}

# Création d'un load balancer pour le cluster
resource "aws_lb" "kubernetes" {
    name = var.lb_name
    internal = false
    load_balancer_type = "network"
    subnets = [aws_subnet.kubernetes.id]
    tags = {
        Name = "${var.lb_name}"
    }  
}

# Création d'un groupe de cibles pour le load balancer
resource "aws_lb_target_group" "kubernetes" {
    name = var.lb_target_group_name
    port = 6443
    protocol = "TCP"
    vpc_id = aws_vpc.kubernetes.id
    target_type = "ip"
    tags = {
        Name = "${var.lb_target_group_name}"
    }  
}

# Création d'une cible pour le groupe
resource "aws_lb_target_group_attachment" "kubernetes" {
    count           = var.master_instance_count
    target_group_arn = aws_lb_target_group.kubernetes.arn
    target_id       = aws_instance.master[count.index].private_ip
    port            = 6443
}

# Association du groupe de cibles au load balancer
resource "aws_lb_listener" "kubernetes" {
    load_balancer_arn = aws_lb.kubernetes.arn
    port = 443
    protocol = "TCP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.kubernetes.arn
    }
}

# Récupération de l'adresse IP du load balancer
data "aws_lb" "kubernetes" {
    arn = aws_lb.kubernetes.arn
}
