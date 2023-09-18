# Déclaration des variables du projet k8s-thehardway

# Variables pour le provider AWS
variable aws_profile {
    type = string
    description = "Nom du profile AWS"
}

variable aws_region {
    type = string
    description = "Nom de la region AWS"
}

# Variables pour le VPC
variable vpc_cidr {
    type = string
    description = "CIDR du VPC"
}

variable vpc_name {
    type = string
    description = "Nom du VPC"
}

# Variables pour le sous-réseau
variable subnet_cidr {
    type = string
    description = "CIDR du sous-réseau public"
}

variable subnet_name {
    type = string
    description = "Nom du sous-réseau public"
}

# Variables pour la passerelle internet
variable gateway_name {
    type = string
    description = "Nom de la passerelle internet"
}

# Variables pour la table de route
variable route_table_cidr {
    type = string
    description = "CIDR de la de la table de route du sous-réseau public"
}

variable route_table_name {
    type = string
    description = "Nom de la table de route du sous-réseau public"
}

# Variables pour le groupe de sécurité du sous-réseau public jumpnet
variable security_group_name {
    type = string
    description = "Nom du groupe de sécurité du sous-réseau public"
}

variable security_group_description {
    type = string
    description = "Description du groupe de sécurité"
}

# Variables pour les règles de sécurité du groupe de sécurité du sous-réseau
variable egress_cidr {
    type = list(string)
    description = "Liste des CIDR autorisés en sortie"
}

variable ingress_cidr {
    type = list(string)
    description = "Liste des CIDR autorisés pour le traffic entrant"
}

variable ssh_cidr {
    type = list(string)
    description = "Liste des CIDR autorisés pour le SSH"
}

variable cluster_cidr {
    type = list(string)
    description = "Liste des CIDR autorisés pour le cluster"
}

variable https_cidr {
    type = list(string)
    description = "Liste des CIDR autorisés pour le HTTPS"
}

variable "ping_cidr" {
    type = list(string)
    description = "Liste des CIDR autorisés pour le ping"
}

# Variables pour la paire de clés SSH
variable "key_pair_name" {
    type = string
}

# Variables pour les instances EC2
variable "ami_id" {
    type = string
}

# Master
variable "master_instance_count" {
    type = number
}
variable "master_instance_name" {
    type = string
}

variable "master_instance_nodetype" {
    type = string
}

variable "master_instance_type" {
    type = string
}

variable "master_instance_private_ip" {
    type = string
}

# Worker
variable "worker_instance_count" {
    type = number
}

variable "worker_instance_name" {
    type = string
}

variable "worker_instance_nodetype" {
    type = string
}

variable "worker_instance_type" {
    type = string
}

variable "worker_instance_private_ip" {
    type = string
}

# Variables pour le load balancer
variable "lb_name" {
    type = string
}

variable "lb_target_group_name" {
    type = string
}

