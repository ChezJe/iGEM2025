# Building on MATLAB Docker image

The Dockerfile in this subfolder builds on the [MATLAB Container Image on Docker Hub](https://hub.docker.com/r/mathworks/matlab)
by installing MATLAB&reg; toolboxes and support packages using [MATLAB Package Manager (*mpm*)](https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/MPM.md).

Use the Dockerfile as an example of how to build a custom image that contains the features of the MATLAB image on Docker&reg; Hub.
These features include accessing the dockerised MATLAB through a browser, batch mode, or an interactive command prompt.
For details of the features in that image, see [MATLAB Container Image on Docker Hub](https://hub.docker.com/r/mathworks/matlab).

### Requirements
* Docker
* VNC client like TigerVNC

## Instructions

### Build the container
Build a container with a name and tag.
```bash
docker build -t bioinfo_chipseqdemo:r2024a . --network=host
```
## Run the Container
The Docker container you build using this Dockerfile inherits run options from its base image.
See the documentation for the base image, [MATLAB Container Image on Docker Hub](https://hub.docker.com/r/mathworks/matlab) (hosted on Docker Hub) for instructions on how to use those features,
which include interacting with MATLAB using a web browser, batch mode, or an interactive command prompt,
as well as how to provide license information when running the container.
Run the commands described there with the name of the Docker image that you build using this Dockerfile. 

To run the container interactively type the following in a bash shell:
```bash
docker run --init -it --rm -p 5901:5901 -p 6080:6080 --network=host --shm-size=512M bioinfo_chipseqdemo:r2024a -vnc
```
Then start your VNC client and type `localhost:1`.
The default password is `matlab`.

## Run demo
This demo requires Add-ons that were included in the container and need to be installed manually.
To install them, you need to open MATLAB, navigate to the folder `/home/matlab/mltbx` and double-click on each mltbx file to install the Add-ons with their dependencies.
Now, change the current folder to `/home/matlab/Chipseq` and either open the `chipseq.plprj` file to open a pipeline that already contains partial results or run the `awsChipseqDemo.m` script to recreate the pipeline programmatically.


----

Copyright 2023-2025 The MathWorks, Inc.

----
