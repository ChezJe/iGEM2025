# Copyright 2023-2024 The MathWorks, Inc.

# To specify which MATLAB release to install in the container, edit the value of the MATLAB_RELEASE argument.
# Use lower case to specify the release, for example: ARG MATLAB_RELEASE=r2021b
ARG MATLAB_RELEASE=r2024a

# Specify the extra products to install into the image. These products can either be toolboxes or support packages.
ARG ADDITIONAL_PRODUCTS="Bioinformatics_Toolbox Statistics_and_Machine_Learning_Toolbox Parallel_Computing_Toolbox --no-gpu"

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
    unzip \
    ca-certificates \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* 

# Install 3rd party tools: samtools + MACS3
# MACS3 is installed in a python virtual environment, this needs to be done in a bash shell instead of sh
WORKDIR /home/matlab
RUN ["/bin/bash", "-c", "apt-get update && apt-get install --yes pip samtools python3.10-venv git vim && python3 -m venv MACS3env/ && source MACS3env/bin/activate && pip install macs3"]  


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
        --destination ${EXISTING_MATLAB_LOCATION} \
        --release ${MATLAB_RELEASE} \
        --products ${ADDITIONAL_PRODUCTS} \
    || (echo "MPM Installation Failure. See below for more information:" && cat /tmp/mathworks_root.log && false) \
    && sudo rm -rf mpm /tmp/mathworks_root.log ${HOME}/.MathWorks


# Copy add-ons
# These will need to be installed manually by double-clicking on each mltbx file within MATLAB unfortunately
# Installing automatically in MATLAB with matlab.addons.install does not work because this method does not installed dependent 3rd
# party tools
WORKDIR /home/matlab/mltbx
RUN wget -q https://github.com/mathworks/bowtie2/releases/download/23.2.0/Bowtie.2.Support.Package.for.Bioinformatics.Toolbox.mltbx
RUN wget -q https://github.com/mathworks/BWA/releases/download/v22.1.0/BWA.Support.Package.for.Bioinformatics.Toolbox.mltbx
RUN wget -q https://github.com/mathworks/sra/releases/download/v24.1.0/SRA.Toolkit.Support.Package.for.Bioinformatics.Toolbox.mltbx
RUN wget -q https://github.com/mathworks/blastplus/releases/download/v24.1.0/BLASTPlus.Support.Package.for.Bioinformatics.Toolbox.mltbx
RUN wget -q https://github.com/mathworks/cufflinks/releases/download/v22.1.0/Cufflinks.Support.Package.for.the.Bioinformatics.Toolbox.mltbx


# Copy the Chip-seq demo by cloning the repo into /home/matlab/Chipseq
WORKDIR /home/matlab
RUN git clone https://jhuard:fNWSbmif7VXExFsiz-Sb@insidelabs-git.mathworks.com/jhuard/docker-chipseq-demo.git Chipseq

# When running the container a license file can be mounted,
# or a license server can be provided as an environment variable.
# For more information, see https://hub.docker.com/r/mathworks/matlab

# Alternatively, you can provide a license server to use
# with the docker image while building the image.
# Specify the host and port of the machine that serves the network licenses 
# if you want to bind in the license info as an environment variable.
# You can also build with something like --build-arg LICENSE_SERVER=27000@MyServerName,
# in which case you should uncomment the following two lines.
# If these lines are uncommented, $LICENSE_SERVER must be a valid license
# server or browser mode will not start successfully.
# ARG LICENSE_SERVER
# ENV MLM_LICENSE_FILE=$LICENSE_SERVER

# The following environment variables allow MathWorks to understand how this MathWorks 
# product is being used. This information helps us make MATLAB even better. 
# Your content, and information about the content within your files, is not shared with MathWorks. 
# To opt out of this service, delete the environment variables defined in the following line.
# See the Help Make MATLAB Even Better section in the accompanying README to learn more: 
# https://github.com/mathworks-ref-arch/matlab-dockerfile#help-make-matlab-even-better
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=$MW_CONTEXT_TAGS,MATLAB:TOOLBOXES:DOCKERFILE:V1

# Inherit ENTRYPOINT and CMD from base image.
