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

# How the tests are structured ?

The test is structured to simulate a general use case where we need to run a maven build running the same set of plugins, mutliple times, from containers.  
The most basic of such project is where we have ci jobs running on containers, where we build and run tests of a java project.

In these tests we will use a particular project, where we use a single maven plugin, the [vault-maven-plugin](https://homeofthewizard.github.io/vault-maven-plugin/).  
This plugin allows us to fetch credentials from a HashiCorp Vault server. We use mvnd to run this project and its plugin from a docker container.
The idea is to compare the execution time and memory usage of this plugin via mvnd, to another existing solution that serves the same purpose, the native [vault-agent](https://developer.hashicorp.com/vault/docs/agent-and-proxy/agent).
