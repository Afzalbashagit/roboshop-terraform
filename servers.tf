

resource "aws_instance" "instance" {
  for_each=var.components
  ami           = data.aws_ami.centos.image_id
  instance_type = each.value["instance_type"]
  vpc_security_group_ids=[data.aws_security_group.allow-all.id]
  tags = {
    Name =each.value["name"]
  }
}

variable "instance_type"{
  default="t3.small"
}

resource "null_resource" "provisioner"{
  depends_on = [aws_instance,aws_route53_record]
  for_each=var.components
  provisioner "remote-exec"{
    connection{
      type="ssh"
      user="centos"
      password="DevOps321"
      host=self.private_ip
    }
    inline=[
    "rm -rf roboshop-shell",
    "git clone https://github.com/Afzalbashagit/roboshop-terraform.git",
    "cd roboshop-shell",
    "sudo bash ${each.value["name"]}.sh ${each.value["password"]}"
    ]
  }
}



resource "aws_route53_record" "records" {
  for_each = var.components
  zone_id = "Z01635288KBXSY9TJV2R"
  name    = "${each.value["name"]}-dev.afzalbasha.cloud"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance[each.value["name"]].private_ip]
}



