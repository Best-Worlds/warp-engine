# Deployment

## Releases

There are several steps to perform in order to generate a new Warp release:
<ul>
	<li>Apply the changes into .warp directory files based (or the warp binary) on the features/bugfixes you want to introduce.</li>
	<li>Commit those changes with a comment description of what it has been done.</li>
	<li>Create a new GitHub tag based on the current date following this pattern <i>[yyyy.mm.dd].</i></li>
	<li>Execute Jenkins deployment process in order to generate the new release associated with the last tag created.</li>
</ul>

### Behind the curtains
When the Jenkins deployment task is triggered, a bash script is executed. This script compresses everything that the ".warp" directory contains and paste it (like sort of a string encrypted) within a new generated warp binary file (a copy of the one versioned in that tag) at the bottom of it, right after the markdown mentioned [here](framework.md).

After that it executes the following actions:
<ul>
<li>Renames that binary by using a suffix like this one: <i>warp_2024.08.21</i></li>
<li>Locates that file within the Warp Engine server (Satis) under the "/dist" folder.</li>
<li>Creates a symlink in a way that the "release/latest" points to the last release created within the "dist" folder. This makes the latest release available for download.</li>
</ul>

## Docker Images
The Docker images are located under our own [DockerHub Account](https://hub.docker.com/). The namespace is "devbestworlds" and there is a repository (that contains tags/versions) for each of the framework services.

### How to upload an image?
To be able to upload an image to the Docker Hub account is necessary to execute the following steps:
<ul>
	<li>Under the framework "images" repository is necessary to create a <b>Dockerfile</b> following the next pattern:

```plain
[service] -> [version] -> Dockerfile

Translated to a concrete case:

php -> 8.1.3-fpm -> Dockerfile
```
</li>
<li>
The Dockerfile is kind of the recipe for building a new image. It contains the instructions for Docker to be able to construct it. The most important instruction is the one that points to the image to mirror for starting. This should be located in the first line of the file and this is the syntax:

```Dockerfile
FROM php:8.1.3-fpm
```
After that you can use the <b>"RUN"</b> instruction to execute several commands for the image building process. These are a few among many others:
<ul>
	<li>Adding extra libraries</li>
	<li>Setting specific permissions for users/groups</li>
	<li>Creating bash aliases</li>
	<li>Installing programs/commands</li>
	<li>Creating custom files/folders</li>
</ul>

```Dockerfile
# Create .ssh folder  
RUN mkdir -p /var/www/.ssh  
  
# Set www-data as owner for /var/www  
RUN chown -R www-data:www-data /var/www/  
RUN chmod -R g+w /var/www/
```
<li>
Once the entire recipe is finished you need to execute a command to actually build that specific image before uploading it. It helps verifying there are no errors on its initialization (make sure to connect to Docker Hub from console)

```bash
docker build -t devbestworlds/redis:6.0 ./images/redis/6.0
```

</li>
<li>
After the build finishes correctly, you can check your own image by executing the following commands:

```bash
# Run image locally
docker run -d --name [my-container-name] devbestworlds/redis:6.0
# Enter to the container
docker exec -it [my-container-name] /bin/bash
```

</li>
<li>
Once you've checked everything is working, no errors, you can just push that image into the Docker Hub specific repository.

```bash
docker push devbestworlds/redis:6.0
```
</li>
</ul>

