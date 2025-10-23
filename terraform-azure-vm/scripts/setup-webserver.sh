#!/bin/bash
# scripts/setup-webserver.sh - Cloud-init script for Azure VM

# Set strict mode and logging
set -e
exec > /var/log/cloud-init-output.log 2>&1

echo "=== Starting cloud-init script ==="
date

# Update system
echo "=== Updating system packages ==="
apt-get update
apt-get upgrade -y

# Install basic packages
echo "=== Installing basic packages ==="
apt-get install -y \
    curl \
    wget \
    vim \
    htop \
    tree \
    unzip \
    git \
    ufw \
    unattended-upgrades \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install Nginx
echo "=== Installing Nginx ==="
apt-get install -y nginx

# Create web directory
mkdir -p /var/www/html

# Create custom index.html
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terraform Azure VM</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            background: white;
            padding: 3rem;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            max-width: 800px;
            width: 90%;
            text-align: center;
        }
        h1 {
            color: #0078d4;
            margin-bottom: 1.5rem;
            font-size: 2.5rem;
        }
        .status-badge {
            display: inline-block;
            background: #28a745;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            margin-bottom: 2rem;
            font-weight: bold;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }
        .info-card {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 10px;
            border-left: 4px solid #0078d4;
            text-align: left;
        }
        .info-card h3 {
            color: #0078d4;
            margin-bottom: 0.5rem;
        }
        .feature-list {
            text-align: left;
            margin: 2rem 0;
        }
        .feature-list li {
            margin: 0.5rem 0;
            padding-left: 1.5rem;
            position: relative;
        }
        .feature-list li:before {
            content: "✅";
            position: absolute;
            left: 0;
        }
        .deployment-info {
            background: #e7f3ff;
            padding: 1rem;
            border-radius: 8px;
            margin: 1.5rem 0;
            border: 1px solid #b3d9ff;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Successfully Deployed!</h1>
        <div class="status-badge">Status: Active & Healthy</div>
        
        <div class="deployment-info">
            <p><strong>Deployment Method:</strong> Terraform + Azure</p>
            <p><strong>Timestamp:</strong> <span id="timestamp"></span></p>
        </div>

        <div class="info-grid">
            <div class="info-card">
                <h3>🖥️ Server Info</h3>
                <p><strong>Hostname:</strong> <span id="hostname"></span></p>
                <p><strong>OS:</strong> Ubuntu 22.04 LTS</p>
            </div>
            <div class="info-card">
                <h3>🌐 Services</h3>
                <p><strong>Web Server:</strong> Nginx</p>
                <p><strong>SSH Access:</strong> Enabled</p>
            </div>
            <div class="info-card">
                <h3>⚙️ Configuration</h3>
                <p><strong>Automation:</strong> Cloud-init</p>
                <p><strong>Security:</strong> UFW Enabled</p>
            </div>
        </div>

        <div class="feature-list">
            <h3>✅ What's Installed & Configured:</h3>
            <ul>
                <li>Nginx Web Server with custom configuration</li>
                <li>Automatic security updates</li>
                <li>UFW firewall with SSH & HTTP rules</li>
                <li>System monitoring tools (htop, vim, curl)</li>
                <li>Custom health check endpoint</li>
                <li>Log rotation configuration</li>
                <li>SSL-ready configuration</li>
            </ul>
        </div>

        <p><strong>Next Steps:</strong> This server is ready for your application deployment!</p>
    </div>

    <script>
        // Add dynamic content
        document.getElementById('hostname').textContent = window.location.hostname;
        document.getElementById('timestamp').textContent = new Date().toLocaleString();
        
        // Add some interactive elements
        document.addEventListener('DOMContentLoaded', function() {
            const container = document.querySelector('.container');
            container.style.opacity = '0';
            container.style.transition = 'opacity 0.5s ease-in';
            
            setTimeout(() => {
                container.style.opacity = '1';
            }, 100);
        });
    </script>
</body>
</html>
EOF

# Set proper permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Configure Nginx
cat > /etc/nginx/sites-available/default << 'NGINXCONF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm;

    server_name _;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    location / {
        try_files $uri $uri/ =404;
    }

    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }

    # Basic security - hide nginx version
    server_tokens off;
}
NGINXCONF

# Enable and start Nginx
echo "=== Starting Nginx service ==="
systemctl enable nginx
systemctl start nginx

# Configure firewall
echo "=== Configuring firewall ==="
ufw --force enable
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw --force reload

# Configure automatic security updates
echo "=== Configuring automatic updates ==="
cat > /etc/apt/apt.conf.d/20auto-upgrades << 'AUTOUPGRADE'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
AUTOUPGRADE

# Create admin tools directory
mkdir -p /opt/scripts

# Create system info script
cat > /opt/scripts/system-info.sh << 'SYSINFO'
#!/bin/bash
echo "=== System Information ==="
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"
echo "OS: $(lsb_release -d | cut -f2)"
echo "Kernel: $(uname -r)"
echo "CPU: $(nproc) cores"
echo "Memory: $(free -h | awk '/^Mem:/ {print $2}')"
echo "Disk: $(df -h / | awk 'NR==2 {print $4}') free"
echo "IP Address: $(hostname -I)"
echo "=== Nginx Status ==="
systemctl is-active nginx
echo "=== Recent Logins ==="
last -5
SYSINFO

chmod +x /opt/scripts/system-info.sh

# Create log rotation for application logs
cat > /etc/logrotate.d/app-logs << 'LOGROTATE'
/var/log/admin-tasks.log {
    weekly
    missingok
    rotate 4
    compress
    notifempty
    create 644 root root
}
LOGROTATE

# Set up motd (Message of the Day)
cat > /etc/motd << 'MOTD'
------------------------------------------------------------------------------
        Azure VM Managed by Terraform | Environment: ${ENVIRONMENT}
------------------------------------------------------------------------------
        Important: This system is automated and managed by Terraform.
        Manual changes may be overwritten by the next deployment.
------------------------------------------------------------------------------

MOTD

# Final system update and cleanup
echo "=== Performing final system cleanup ==="
apt-get autoremove -y
apt-get clean

# Display deployment summary
echo "=== Deployment Summary ==="
echo "✅ System updated and upgraded"
echo "✅ Nginx installed and configured"
echo "✅ Firewall configured and enabled"
echo "✅ Automatic updates enabled"
echo "✅ Security headers configured"
echo "✅ Admin tools installed"
echo "✅ Custom web page deployed"

# Get public IP (for Azure metadata service)
IP=$(curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2021-02-01&format=text" 2>/dev/null || echo "unknown")

echo "=== Access Information ==="
echo "🌐 Website: http://$IP"
echo "🔧 SSH Access: ssh ${ADMIN_USERNAME}@$IP"
echo "❤️ Health Check: http://$IP/health"

echo "=== Cloud-init script completed successfully ==="
date