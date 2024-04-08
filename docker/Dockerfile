FROM ubuntu:22.04

WORKDIR /home

# Install deps for dna-brnn as root
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libz-dev \
    gcc \
    git \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install dna-brnn
RUN git clone https://github.com/logsdon-lab/dna-nn.git && \
    cd dna-nn && \
    make && \
    # Then remove unneeded tools
    apt-get purge gcc git make -y

# Update path for dna-brnn
ENV PATH="${PATH}:/home/dna-nn/"
