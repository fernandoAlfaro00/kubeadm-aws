output "nodes_private_ips" {
  description = "ip privada del nodo(s) worker"
  value       = module.ec2_node.private_ip
}

output "master_private_ips" {
  description = "ip privada del nodo(s) master"
  value       = module.ec2_kubemaster.private_ip
}

output "bastion_public_ip" {
  description = "ip publica del bastion"
  value       = "ssh -i kubeadm.pem ec2-user@${module.ec2_bastion.public_ip}"

}