FROM jupyterhub/k8s-singleuser-sample:v0.4
LABEL maintainer="Sean Johnson <pirogoeth@maio.me>"

ARG JUPYTERHUB_VERSION=0.8

USER root
RUN apt-get update && \
        apt-get install -fy pkg-config libzmq5 libzmq3-dev git wget && \
        apt-get install -fy texlive texlive-science texlive-xetex && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists /var/cache/apt

USER jovyan
ENV GOROOT=/home/jovyan/.go/go
ENV GOPATH=/home/jovyan/.go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

RUN pip install -U pip numpy pandas scikit-learn scipy enum-compat matplotlib requests Jinja2 ipykernel ipython ipython-genutils ipywidgets MarkupSafe msgpack-python ordered-set keras tensorflow jupyter_dashboards tangent
RUN wget -L -O golang.tgz https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz && \
        mkdir -p $GOROOT && \
        tar xzvf golang.tgz -C $GOPATH && \
        rm golang.tgz && \
        go get github.com/gopherdata/gophernotes && \
        mkdir -p $(jupyter --data-dir)/kernels/gophernotes && \
        cp -rv $GOPATH/src/github.com/gopherdata/gophernotes/kernel/* $(jupyter --data-dir)/kernels/gophernotes/
