# Docker Compose Prometheus Service Discovery - Example

To run this example first you need to install this tool. Since you have installed, let's follow this how-to.

_Note: Considering that you are in the `docker-compose-prometheus-service-discovery` folder._

- `docker-prmt-serv-disc start './example/docker-prometheus-sd.yml'`
  - It will start the service discovery responsible to create the `targets.son`
- `./start.sh`
  -  This script is responsible to start the services first, check if the `targets.yml` is ok and then start Grafana and Prometheus

Now you can go to your `targets.json` file and check the content.

Note: You can play scaling up/down and checking the `targets.json` content running:

```shell script
docker-compose -f ./example/docker-compose-services.yml up -d --scale appA=<NUMBER_OF_INSTANCES> --scale appB=<NUMBER_OF_INSTANCES>
```   

## Important Note
We configured in our `prometheus.yml` file that Prometheus will check the `targets.json` file every 5s.

### Monitoring
By default, we already have 2 dashboards showing the metrics from **appA** and **appB**

The dashboards are:
 - JVM Metrics
 - Spring Boot Metrics

When you try to access Grafana it will ask you to login and the credentials are:
- Username: **admin**
- Password: **admin** 