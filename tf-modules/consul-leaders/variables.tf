variable "name" {
    default = ""
    description = "The name of this cluster of consul leaders, this should be unique"
}
variable "key_name" {
    default = ""
    description = "The name of the (AWS) SSH key to associate with the instance"
}
variable "ami" {
    description = "The base AMI for each AWS instance created"
}
variable "instance_type" {
    default = "t2.micro"
    description = "The type of AWS instance (size)"
}
variable "user_data" {
    default = ""
    description = "The user_data string to pass to cloud-init"
}
variable "leader_security_group_ids" {
    default = ""
    description = "String-list of ids, the security groups to assign to the leaders"
}
variable "max_nodes" {
    default = 9
    description = "The maximum number of nodes in the auto-scaling group"
}
variable "min_nodes" {
    default = 3
    description = "The minimum number of nodes in the auto-scaling group"
}
variable "desired_capacity" {
    default = 7
    description = "The desired number of nodes in the auto-scaling group"
}
variable "access_key" {
    description = "AWS key id"
}
variable "secret_key" {
    description = "AWS key secret"
}
variable "consul_secret_key" {
    description = "Secret key to secure cluster communication, generate this with `consul keygen`"
}
variable "consul_master_token" {
    description = "Master token for the ACL system in Consul"
}
variable "leader_count" {
    default = "'3'"
    description = "The number of leaders to form majority consensus, better to leave this as is"
}
variable "cidr_prefix_a" {
    default = "10.100.3"
    description = "The prefix to use for the CIDR block and IP details in the formula, subnet a"
}
variable "cidr_prefix_c" {
    default = "10.100.4"
    description = "The prefix to use for the CIDR block and IP details in the formula, subnet c"
}
variable "cidr_mask" {
    default = "28"
    description = "The CIDR mask to use for CIDR block definitions, better to leave this as is"
}
variable "region" {
    description = "AWS region to deploy to"
}
variable "vpc_id" {
    description = "The ID of the experimental VPC to deploy to, depends on the AWS region"
}
variable "route_table_id" {
    description = "The ID of the experimental routing table to use, depends on the AWS region"
}
variable "public_ip" {
    default = "true"
    description = "Boolean flag to enable/disable map_public_ip_on_launch in each aws_subnet"
}