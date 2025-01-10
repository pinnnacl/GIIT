resource "aws_instance" "nandu-instance-pub" {
    ami           = "ami-0657605d763ac72a8"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.nandu-pub-subnet-1.id
    key_name      = "ubuntu_pem"
    security_groups = [aws_security_group.nandu-pubSub-sg.id]
    count = var.instance_count["nandu-instance-pub"]
    associate_public_ip_address = true
    tags = {
        Name = "nandu-web${count.index + 1}"
        Env = "Dev"
    }
}

resource "aws_instance" "nandu-instance-pub" {
    ami           = "ami-0657605d763ac72a8"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.nandu-pvt-subnet-1.id
    key_name      = "ubuntu_pem"
    security_groups = [aws_security_group.nandu-pvtSub-sg.id]
    count = var.instance_count["nandu-instance-pvt"]
    associate_public_ip_address = true
    tags = {
        Name = "nandu-web${count.index + 1}"
        Env = "Dev"
    }
}