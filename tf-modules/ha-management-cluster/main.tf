# create management cluster, the cluster to manage the others
module "management-cluster" {
    source = "../consul-cluster"
    public_ip = "${var.public_ip}"
    ami = "${var.ami}"
    name = "${var.name}-management-tier"
    instance_type = "${var.instance_type}"
    max_nodes = "5"
    min_nodes = "2"
    desired_capacity = "3"
    key_name = "${var.key_name}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
    cidr_minions_a = "${var.cidr_a}"
    cidr_minions_c = "${var.cidr_c}"
    vpc_id = "${var.vpc_id}"
    route_table_id = "${var.route_table_id}"
    cluster_security_group_ids = "${var.security_group_ids}, ${aws_security_group.management_services.id}, ${module.nomad-server-sg.id}, ${module.nomad-agent-sg.id}"
    user_data = "${module.manage_init.user_data}"
}
# Security Group, for management-tier service
resource "aws_security_group" "management_services" {
    name = "${var.name}-management-services"
    vpc_id = "${var.vpc_id}"
    # salt-master
#   ingress {
#       from_port = 4505
#       to_port = 4506
#       protocol = "tcp"
#       cidr_blocks = ["${split(",", var.minion_cidr_blocks)}"]
#   }
    # open port 123 (NTP) tcp/udp for the VPC
    ingress {
        from_port = 123
        to_port = 123
        protocol = "tcp"
        cidr_blocks = ["${split(",", replace(var.worker_cidr_blocks, " ", ""))}"]
    }
    ingress {
        from_port = 123
        to_port = 123
        protocol = "udp"
        cidr_blocks = ["${split(",", replace(var.worker_cidr_blocks, " ", ""))}"]
    }
    # open egress
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Description = "VPC access to services in the management tier"
    }
}
# provision the management cluster
module "manage_init" {
    source = "../consul-agent-generic-init"
    region = "${var.region}"
    service = "manage"
    consul_secret_key = "${var.consul_secret_key}"
    consul_client_token = "${var.consul_client_token}"
    leader_dns = "${var.consul_leader_dns}"
    extra_init = "${template_file.extra_init.rendered}"
    extra_pillar = "${template_file.extra_pillar.rendered}"
}
resource "template_file" "extra_init" {
    template = "${path.module}/init.tpl"
    vars {
    }
}
resource "template_file" "extra_pillar" {
    template = "${path.module}/pillar.tpl"
    vars {
    }
}
# boxed security group for nomad leader services, no egress/custom rules
module "nomad-server-sg" {
    source = "../nomad-server-sg"
    name = "${var.name}-nomad-server-services"
    vpc_id = "${var.vpc_id}"
    region = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    cidr_blocks = "${var.cidr_a}, ${var.cidr_c}"
}
# boxed security group for nomad agents (leaders included), no egress/custom rules
module "nomad-agent-sg" {
    source = "../nomad-agent-sg"
    name = "${var.name}-nomad-agent"
    vpc_id = "${var.vpc_id}"
    region = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    cidr_blocks = "${replace(var.worker_cidr_blocks, " ", "")}"
}
# boxed DNS set - zone / records for clusters of consul / nomad leaders
module "nomad-server-dns" {
    source = "../leader-dns"
    name = "leaders"
    domain = "nomad-server"
    vpc_id = "${var.vpc_id}"
    region = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    cidr_a = "${var.cidr_a}"
    cidr_c = "${var.cidr_c}"
}
