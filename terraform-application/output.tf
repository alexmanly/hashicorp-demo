output "hashiapp_demo_id" {
    value = "${aws_instance.app.id}"
}

output "hashiapp_demo_ip" {
    value = "${aws_instance.app.public_ip}"
}

output "hashiapp_demo_public_dns" {
    value = "${aws_instance.app.public_dns}"
}

output "hashiapp_demo_private_dns" {
    value = "${aws_instance.app.private_dns}"
}