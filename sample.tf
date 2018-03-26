provider "aws" {
  access_key = "*******************"
  secret_key = "**********************"
  region     = "us-west-2"
}

# Launch AWS instance

resource "aws_instance" "sample" {
  ami="ami-4475eb3c"
  instance_type="t2.micro"
  key_name="ec2"
  security_groups=["launch-wizard-1"]
 tags{
   Name="tf_02"
   }

# Copy the pem key from local to Remote machine

connection {
  user = "ubuntu"
  type = "ssh"
  private_key ="${file("/home/ubuntu/ec2.pem")}"
}
  
# copy script.sh file from Loacal to remote machine for installing Java and tomcat
  
  provisioner "file" {
    source      = "/home/ubuntu/tf/script.sh"
    destination = "/tmp/script.sh"
  }
  
# Give the execute permission to script.sh and give full permissions to /var /lib/tomcat7/webapps folder
  
 provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
      "sudo chmod 777 /var/lib/tomcat7/webapps/"
    ]
  }
  
#Copy the war file from Local machine to remote machine tomcat webapps folder
  
 provisioner "file" {
    source      = "/home/ubuntu/sample.war"
    destination = "/var/lib/tomcat7/webapps/sample.war"
  }
  
# Restart the tomcat 
 
 provisioner "remote-exec" {
    inline = [
      "sudo service tomcat7 restart"
   ]
  }
}
