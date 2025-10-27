# Copyright 2023-2024 The MathWorks, Inc.

# To specify which MATLAB release to install in the container, edit the value of the MATLAB_RELEASE argument.
# Use uppercase to specify the release, for example: ARG MATLAB_RELEASE=R2021b
ARG MATLAB_RELEASE=R2024b

# Specify the extra products to install into the image. These products can either be toolboxes or support packages.
ARG ADDITIONAL_PRODUCTS="Bioinformatics_Toolbox Parallel_Computing_Toolbox"

# This Dockerfile builds on the Ubuntu-based mathworks/matlab image.
# To check the available matlab images, see: https://hub.docker.com/r/mathworks/matlab
FROM mathworks/matlab:$MATLAB_RELEASE

# Declare the global argument to use at the current build stage
ARG MATLAB_RELEASE
ARG ADDITIONAL_PRODUCTS

# By default, the MATLAB container runs as user "matlab". To install mpm dependencies, switch to root.
USER root

# Install mpm dependencies
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends --yes \
        wget \
        ca-certificates \
        zlib1g-dev \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Run mpm to install MathWorks products into the existing MATLAB installation directory,
# and delete the mpm installation afterwards.
# Modify it by setting the ADDITIONAL_PRODUCTS defined above,
# e.g. ADDITIONAL_PRODUCTS="Statistics_and_Machine_Learning_Toolbox Parallel_Computing_Toolbox MATLAB_Coder".
# If mpm fails to install successfully then output the logfile to the terminal, otherwise cleanup.

# Switch to user matlab, and pass in $HOME variable to mpm,
# so that mpm can set the correct root folder for the support packages.
WORKDIR /tmp
USER matlab
RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm \
    && chmod +x mpm \
    && EXISTING_MATLAB_LOCATION=$(dirname $(dirname $(readlink -f $(which matlab)))) \
    && sudo HOME=${HOME} ./mpm install \
        --destination=${EXISTING_MATLAB_LOCATION} \
        --release=${MATLAB_RELEASE} \
        --products ${ADDITIONAL_PRODUCTS} \
    || (echo "MPM Installation Failure. See below for more information:" && cat /tmp/mathworks_root.log && false) \
    && sudo rm -rf mpm /tmp/mathworks_root.log

COPY . /home/matlab/singleCellRnaseq

USER root
RUN chmod -R 777 /home/matlab/singleCellRnaseq

USER matlab
WORKDIR /home/matlab
# Inherit ENTRYPOINT and CMD from base image.