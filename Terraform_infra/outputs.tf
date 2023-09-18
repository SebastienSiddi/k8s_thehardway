output "kubernetes_vpc_id" {
    value = aws_vpc.kubernetes.id
}

output "kubernetes_subnet_id" {
    value = aws_subnet.kubernetes.id
}

output "kubernetes_gateway_id" {
    value = aws_internet_gateway.igw.id
}

output "kubernetes_route_table_id" {
    value = aws_route_table.kubernetes.id
}

output "kubernetes_security_group_id" {
    value = aws_security_group.kubernetes.id
}

output "kubernetes_load_balancer_arn" {
    value = aws_lb.kubernetes.arn
}

output "kubernetes_target_group_arn" {
    value = aws_lb_target_group.kubernetes.arn
}

output "kubernetes_listener_arn" {
    value = aws_lb_listener.kubernetes.arn
}

output "kubernetes_load_balancer_dns_name" {
    value = aws_lb.kubernetes.dns_name
}

output "kubernetes_master_instance__id" {
    value = aws_instance.master.*.id
}

output "kubernetes_master_instance_public_ip" {
    value = aws_instance.master.*.public_ip
}

output "kubernetes_worker_instance_id" {
    value = aws_instance.worker.*.id
}

output "kubernetes_worker_instance_public_ip" {
    value = aws_instance.worker.*.public_ip
}

