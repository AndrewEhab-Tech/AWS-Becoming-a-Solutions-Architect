#!/bin/bash
dnf update -y
dnf install -y httpd php php-mysqli mariadb105

cat << 'EOF' > /var/www/html/index.php
<!DOCTYPE html>
<html>
<head>
    <title>AWS SAA Graduation Project 1</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f8; margin: 40px; color: #232f3e; }
        .card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); max-width: 650px; margin: auto; }
        h1 { color: #ff9900; }
        .badge { background: #0073bb; color: white; padding: 4px 8px; border-radius: 4px; font-weight: bold; }
        .success { color: #1d8102; font-weight: bold; }
    </style>
</head>
<body>
    <div class="card">
        <h1>AWS Architecture in Action</h1>
        <h3>Project 1: Scalable Web Application with ALB and Auto Scaling</h3>
        <hr>
        <p><strong>Instance ID:</strong> <span class="badge"><?php echo file_get_contents('http://169.254.169.254/latest/meta-data/instance-id'); ?></span></p>
        <p><strong>Availability Zone:</strong> <span class="badge"><?php echo file_get_contents('http://169.254.169.254/latest/meta-data/placement/availability-zone'); ?></span></p>
        <p><strong>Private IP:</strong> <?php echo file_get_contents('http://169.254.169.254/latest/meta-data/local-ipv4'); ?></p>
        <p><strong>Load Balancer Forwarding:</strong> <span class="success">&#10004; Operational</span></p>
        <p><strong>Database Connection:</strong> <span class="success">&#10004; Multi-AZ MySQL Ready</span></p>
    </div>
</body>
</html>
EOF

systemctl start httpd
systemctl enable httpd
