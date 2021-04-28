FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

# Deps.
RUN apt-get -y update && \
    apt-get install -y git unzip python3-dev python3-pip wget curl vim

# Python 3.7
ARG PYTHON_VERSION=3.7
ENV PATH="/opt/conda/bin:${PATH}"
ENV PYTHONUNBUFFERED=1 PYTHONFAULTHANDLER=1 PYTHONHASHSEED=0
COPY install_python.sh /tmp/install_python.sh
RUN /tmp/install_python.sh ${PYTHON_VERSION}
RUN ln -s `which pip` /usr/local/bin/pip3.7

# Bazel
ENV USE_BAZEL_VERSION=0.26.1
RUN wget 'https://github.com/bazelbuild/bazelisk/releases/download/v1.8.0/bazelisk-linux-amd64' -O /tmp/bazel && \
    chmod a+x /tmp/bazel && \
    mv /tmp/bazel /usr/local/bin/bazel

# Patched tensorflow.
WORKDIR /tmp/tensorflow-build
COPY cuda10_2.patch /tmp/
RUN git clone --depth 1 --branch v1.15.5 https://github.com/tensorflow/tensorflow.git && \
    cd tensorflow && \
    git apply /tmp/cuda10_2.patch

WORKDIR /tmp/tensorflow-build/tensorflow

CMD bash tensorflow/tools/ci_build/release/ubuntu_16/gpu_py37_full/pip.sh
