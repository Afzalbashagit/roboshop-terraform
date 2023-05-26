resource "aws_instance" "instance" {
  ami           = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids=[data.aws_security_group.allow-all.id]
  tags = {
    Name=local.name}
}

resource "null_resource" "provisioner" {
  depends_on = [aws_instance.instance, aws_route53_record.records]

  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_instance.instance.private_ip
    }

  }
}


resource "aws_route53_record" "records" {
  zone_id = "Z01635288KBXSY9TJV2R"
  name    = "${var.component_name}-dev.afzalbasha.cloud"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.private_ip]
}

