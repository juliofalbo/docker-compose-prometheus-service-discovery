# Docker Compose Prometheus Service Discovery - Example

To run this example first you need to install this tool. Since you have installed, let's follow this how-to.

_Note: Considering that you are in the `docker-compose-prometheus-service-discovery` folder._

- `docker-prmt-serv-disc start './example/docker-prometheus-sd.yml'`
- `docker-compose up -d --scale appA=4 --scale appB=3`

Now you can go to your `targets.json` file and check the content.

Note: You can play scaling up/down and checking the `targets.json` content.   

### Monitoring
By default, we already have 2 dashboards showing the metrics from **appA** and **appB**

The dashboards are:
 - JVM Metrics
 - Spring Boot Metrics

When you try to access Grafana it will ask you to login and the credentials are:
- Username: **admin**
- Password: **admin** 