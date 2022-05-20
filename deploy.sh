#!/bin/bash

cat <<EOF>main.tf



resource "aws_instance" "server" {

  count           = $2
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = var.security_groups
  key_name        = var.key_name

  tags = {
    Name = "Akhil"
  }
}


resource "aws_ebs_volume" "akhil-volume" {
  availability_zone = var.availability_zone
  size              = "$3"
  count             = length(aws_instance.server)
  #   instance          = aws_instance.server.*.id[count.index]

  tags = {
    Name = "akhilebs"
  }
}

resource "aws_volume_attachment" "akhil-volumeattachment" {
  device_name = var.device_name
  count       = length(aws_ebs_volume.akhil-volume)
  volume_id   = element(aws_ebs_volume.akhil-volume.*.id, count.index)
  instance_id = element(aws_instance.server.*.id, count.index)
}


EOF

terraform $1
