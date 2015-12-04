output "subnet_a_id" {
    value = "${module.cluster-net.id_a}"
}
output "subnet_a_cidr" {
    value = "${module.cluster-net.cidr_a}"
}
output "subnet_c_id" {
    value = "${module.cluster-net.id_c}"
}
output "subnet_c_cidr" {
    value = "${module.cluster-net.cidr_c}"
}
output "asg_name" {
    value = "${module.agent-asg.name}"
}
