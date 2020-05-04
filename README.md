# Helm Image
   Helm image is a dockerized version of our Helm build process.  
   It's aim is to provide a reproducible way of building and packaging Helm chart.
   Helm image can be run in Jenkins using a Jenkinsfile or a Docker-plugin, or it can also be run locally.

## Development

### Requirements
* Docker

Building the Helm builder-docker Image:
```
docker build -t codenest-ltd/helm:latest --cache-from codenest-ltd/helm:latest .
```

To run:
```
docker run -it codenest-ltd/helm:latest
```

## Usage

### Through a Jenkinsfile
   The normal usage of the Helm image is to have a Jenkins pipeline in charge of instantiating the build using the container:


## Contributing
   This project will ultimately be used for each of our Java Projects builds. For any variation of the build 
   and Project-specific build steps, a Jenkinsfile should be added at the root of the related project 
   but **shouldn't in any case be added to the Helm image**, as our goal is to have a project agnostic helm builder.
