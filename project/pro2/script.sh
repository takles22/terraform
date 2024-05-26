     
#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "AWS Region US-EAST-1 from teplate" > /var/www/html/index.html
