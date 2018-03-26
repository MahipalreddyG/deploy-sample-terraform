provider "aws" {
  access_key = "*******************"
  secret_key = "**********************"
  region     = "us-west-2"
}
resource "aws_instance" "sample" {
  ami="ami-4475eb3c"
  instance_type="t2.micro"
  key_name="ec2"
  security_groups=["launch-wizard-1"]
 tags{
   Name="tf_02"
   }
connection {
  user = "ubuntu"
  type = "ssh"
  private_key ="${file("/home/ubuntu/ec2.pem")}"
}
provisioner "file" {
    source      = "/home/ubuntu/tf/script.sh"
    destination = "/tmp/script.sh"
  }
 provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
      "sudo chmod 777 /var/lib/tomcat7/webapps/"
    ]
  }
 provisioner "file" {
    source      = "/home/ubuntu/sample.war"
    destination = "/var/lib/tomcat7/webapps/sample.war"
  }
 provisioner "remote-exec" {
    inline = [
      "sudo service tomcat7 restart"
   ]
  }
}
