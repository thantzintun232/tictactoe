# AWS Deployment, Monitoring and Auto Scaling

My notes from deploying a Node.js application on AWS during the Sparta Global Cloud DevOps programme. These guides cover automated deployment, reusable machine images, MongoDB, monitoring, load balancing and Auto Scaling.

## Guides

| Guide | What it covers |
|---|---|
| [App deployment with user data](app-user-data-automation.md) | Automating application setup when an EC2 instance launches. |
| [Creating an AMI](creating-ami-documentation.md) | Saving a configured instance as an image and launching new instances from it. |
| [MongoDB deployment](mongodb_deployment.md) | Setting up MongoDB, connecting the app and enabling automatic startup. |
| [Monitoring and CPU alerts](monitoring.md) | CloudWatch dashboards, ApacheBench load testing and email alerts for high CPU usage. |
| [Auto Scaling and load balancing](autoscaling.md) | Launch templates, load balancing, CPU-based scaling and automatic instance replacement. |

Start with app deployment, then follow the AMI, MongoDB, monitoring and Auto Scaling guides.

## Tools used

AWS EC2, AMIs, User Data, Auto Scaling Groups, Application Load Balancer, CloudWatch, SNS, Bash, Node.js, Nginx, PM2, MongoDB and ApacheBench.
