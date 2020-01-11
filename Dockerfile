# default image version, override using --build-arg IMAGE_VERSION=otherversion
ARG IMAGE_VERSION=nightly-py3-jupyter
FROM tensorflow/tensorflow:$IMAGE_VERSION
# The default version is the CPU version!
# see: https://www.tensorflow.org/install/docker
# see: https://hub.docker.com/r/tensorflow/tensorflow/

# Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
      bzip2 \
      git \
      wget && \
    pip install --upgrade pip && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /work/

WORKDIR /work

# run pip install with the '--no-deps' argument, to avoid that tensorflowjs installs an old version of tensorflow!
RUN pip install -r requirements.txt --no-deps

RUN git clone https://github.com/patlevin/tfjs-to-tf.git && \
    cd tfjs-to-tf && \
    pip install . --no-deps && \
    cd .. && \
    rm -r tfjs-to-tf

ENV PYTHONPATH='/work/:$PYTHONPATH'

CMD ["bash"]
