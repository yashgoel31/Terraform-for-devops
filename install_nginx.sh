#!/bin/bash

sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1> Welcome to Nginx Server by YASH GOEL <h1>" | sudo tee /var/www/html/index.html

#echo "<h1> Welcome to Nginx Server by YASH GOEL <h1>" > /var/www/html/index.html