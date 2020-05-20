# Docker Compose Prometheus Service Discovery.

This tool was created to solve this [issue](https://github.com/prometheus/prometheus/issues/7268).
Basically when we are using the `--scale` docker-compose option to scale a service, Prometheus gets completely confused and starts tracking incorrect values, probably because each scraping is going to a different container since we only can specify the name of the service in the `scrape_configs`.

## How it works?
To create this docker-compose service discovery for Prometheus we are using the [File-based service discovery](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#file_sd_config) strategy.

Briefly description of this strategy:

> File-based service discovery provides a more generic way to configure static targets and serves as an interface to plug in custom service discovery mechanisms. It reads a set of files containing a list of zero or more <static_config>s. Changes to all defined files are detected via disk watches and applied immediately. Files may be provided in YAML or JSON format. Only changes resulting in well-formed target groups are applied.

So, this tool will check your yaml file every **5 seconds** and will update the Prometheus `targets.json` file based on the docker containers that are running, it means that you can scale up/down or stop/start containers manually and this tool will automatically update the servers that Prometheus should monitor. 

## Important Info
This Service Discovery was created in a MacOS so, if you want to use it in a Linux or Windows you should adapt the script and tools.
## Requirements
- [gnu-sed](https://www.gnu.org/software/sed/)
  - Using gnu-sed to manipulate the `targets.json` file.
- [yq](https://github.com/mikefarah/yq)
  - Using to parse the yml file
  
You can easily install them running the script `./install.sh`. It will create an alias in your `.bash_profile` called `docker-prmt-serv-disc`. It means that you can call `docker-prmt-serv-disc` from anywhere.
 

## Usage

First thing that you need to configure is the `prometheus.yml` to enable the File-based service discovery. The only thing that you need to do is add this `scrape_configs`:

```$xslt
- job_name: 'instances-service-discovery'
    file_sd_configs:
      - files:
          - targets.json
```

Now that we already have Prometheus configured let's configure the Docker Compose Service Discovery.

This mechanism is based on a yml file called `docker-prometheus-sd.yml` and your file must have this structure.

```yaml
target_json_path: "<YOUR_TARGETS_JSON_PATH>"
services:
  - name: <SERVICE_NAME>
    container_prefix: <YOUR_CONTAINER_PREFIX>
    internal_port: <CONTAINER_INTERNAL_PORT>

```

If you want to track more than 1 service you can add more services like in the example below:

```yaml
target_json_path: "<YOUR_TARGETS_JSON_PATH>"
services:
  - name: appA
    container_prefix: appA_
    internal_port: 8080
  - name: appB
    container_prefix: appB_
    internal_port: 8081
  ...
```
 
 
## Start
To start this tool you can use the `start` command.

`docker-prmt-serv-disc start <PATH_TO_YOUR_YML_FILE>`

## Stop
To start this tool you can use the `stop` command.

`docker-prmt-serv-disc stop

## Debug
This script will send the outpus (like `echo` commando) to a file called `debug.log.file`. Feel free to add your logs.

## Example

There is a folder here called `example`. There you can find a simple example about how to use this tool.

