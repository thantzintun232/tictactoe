# AWS Deployment and Monitoring

My notes from deploying a Node.js application on AWS during the Sparta Global Cloud DevOps programme. These guides cover automating deployment, creating reusable machine images, connecting MongoDB, and monitoring the application.

## Guides

| Guide | What it covers |
|---|---|
| [App deployment with user data](app-user-data-automation.md) | Automating application setup when an EC2 instance launches. |
| [Creating an AMI](creating-ami-documentation.md) | Saving a configured instance as an image and launching new instances from it. |
| [MongoDB deployment](mongodb_deployment.md) | Setting up MongoDB on EC2, connecting it to the application, and enabling automatic startup. |
| [Monitoring and CPU alerts](monitoring.md) | CloudWatch dashboards, ApacheBench load testing, and email notifications for high CPU usage. |

Start with app deployment, then follow the AMI, MongoDB, and monitoring guides.

## Tools used

AWS EC2, AMIs, user data, Bash, Node.js, Nginx, PM2, MongoDB, CloudWatch, SNS, and ApacheBench.

