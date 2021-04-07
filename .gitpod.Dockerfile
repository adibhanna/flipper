FROM paritytech/ink-ci-linux:latest

USER 1000
ENV USER=gitpod
WORKDIR /workspace
RUN cargo contract new flipper
WORKDIR /workspace/flipper
RUN cargo +nightly contract build