# What is it about ?

The aim of this project is to test the performance of maven builds via [mvnd](https://github.com/apache/maven-mvnd) and validate its usage for applications running on K8s or other containerized environments, where the minimal execution time and memory footprint is important.

The main goal of `mvnd` is exactly to improve those aspects of maven builds. From the [documentation]():
```
  * The actual builds happen inside a long living background process, a.k.a. daemon.
  * The mvnd client is a native executable built using GraalVM. It starts faster and uses less memory compared to starting a traditional JVM.
  * Multiple daemons can be spawned in parallel if there is no idle daemon to serve a build request.

This architecture brings the following advantages:
  * The JVM for running the actual builds does not need to get started anew for each build.
  * The classloaders holding classes of Maven plugins are cached over multiple builds. The plugin jars are thus read and parsed just once.
  * The native code produced by the Just-In-Time (JIT) compiler inside the JVM is kept too.
```

This new process heavily reduce the execution time and memory footprint of repeated maven builds running the same set of plugins.



# How and what do we test precisely ?

Maven being a build tool, is mostly used on CI environments, which today are as well containerized.
A general use case is where we need to run a maven build running the same set of plugins to build/package our application, multiple times, from containers.
This topic is discussed as well under this [issue](https://github.com/apache/maven-mvnd/issues/496) on mvnd repo.  

While this test helps to validate this general use case, we will use a particular project, where we use a single maven plugin, the [vault-maven-plugin](https://homeofthewizard.github.io/vault-maven-plugin/).  
This plugin allows us to fetch credentials from a HashiCorp Vault server. We use mvnd to run this project and its plugin from a docker container.  

This project and its plugin, while having the same requirement as a classic CI build discussed above (needed to be executed multiple times from different containers), also have a specific requirement:  
_It can be used for CI and in production, to provide credentials to the application that requires it._  
Hence, at the en of the tests we will compare the execution time and memory usage of this plugin via mvnd, to another existing solution that serves the same purpose, a native executable called [vault-agent](https://developer.hashicorp.com/vault/docs/agent-and-proxy/agent), that is today the standard solution for that requirement in production use.

The tests uses the following containers to simulate this use case in production.
1. A container with a Vault server where the credentials required by the application is stored
2. A vault agent container that runs as a sidecar next to the application
3. A container running vault plugin project via mvnd to do the same as the agent container
4. A container running [cAdvisor](https://hub.docker.com/r/google/cadvisor) for monitoring the resource usage of the above containers.

![Untitled Diagram.drawio.png](docs%2FUntitled%20Diagram.drawio.png)

For simplicity of the tests we will not run any application to consume the fetched credentials (grayed in the diagram above).  
We will base our tests on the start-stop time of the containers which ends only when the credentials are fetched and ready to be consumed by the app.

:warning: It is currently not possible with mvnd to create a pre-warmed daemon for a maven project during "docker build". So we cannot have a container that can run our maven build super fast right from the start.  
In order to work around that, the solution for the moment is to run a container and warm a daemon for our build, and run multiple containers that run the mvnd client which will call that daemon container when needed to trigger a maven build.
See the discussion [here](https://github.com/apache/maven-mvnd/issues/496).

# How to run ?
You will need a Docker engine to run the tests.   

Once installed and setup, then run simply the `benchmark.sh` script in the root of the project. This will launch the containers and start the test.  
You can also start the containers listed above separately if you need to debug or test step by step, using the scripts (`launch-<component>.sh`) under `/docker` folder.

Once the test launched, in the output console you will see the start/stop/execution times of the agent and mvnd container to compare them.  
In cAdvisor UI (http://localhost:8080) you will be able to see the CPU and memory consumption of both containers.  

Once the results analysed you can stop the containers and cleanup the generated files by running the `cleanup.sh` script in the root of the project.



# Results

Executed environment:
* OS: Ubuntu 24.10
* Hardware: 
  * RAM: 32GB DDR3 
  * CPU: intel Core i7 8-core
* Docker: v27.0.3

Agent container:
* Runs in ~1.2 seconds to fetch the secrets and shut down.
* Uses ~400MB of RAM.
* Uses ~0.2 CPU

Vault maven plugin via mvnd:
* daemon starts and warms up in ~2 seconds the first time.
* mvn vault:pull runs in 0.02 seconds if the daemon is already running and warmed up.
* daemon container uses ~200MB of RAM.
* daemon container uses ~0.2 CPU


