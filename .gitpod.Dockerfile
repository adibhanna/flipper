ARG VCS_REF=master
ARG BUILD_DATE
ARG REGISTRY_PATH=paritytech

FROM paritytech/base-ci:latest

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
    io.parity.image.vendor="Parity Technologies" \
    io.parity.image.title="paritytech/ink-ci-linux" \
    io.parity.image.description="Inherits from base-ci-linux:latest. \
    rust nightly, clippy, rustfmt, miri, rust-src grcov, rust-covfix, cargo-contract, xargo, binaryen" \
    io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
    dockerfiles/ink-ci-linux/Dockerfile" \
    io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
    dockerfiles/ink-ci-linux/README.md" \
    io.parity.image.revision="${VCS_REF}" \
    io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

ENV SHELL /bin/bash
ENV CXX=/usr/bin/clang++-10
ENV DEBIAN_FRONTEND=noninteractive

RUN	set -eux; \
    apt-get -y update && \
    apt-get install -y --no-install-recommends \
    python3 hunspell hunspell-en-us && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 100 && \
    rustup toolchain install nightly --target wasm32-unknown-unknown \
    --profile minimal --component rustfmt clippy miri rust-src && \
    rustup default nightly && \
    cargo install grcov rust-covfix xargo cargo-spellcheck && \
    cargo install --features binaryen-as-dependency cargo-contract && \
    # versions
    rustup show && \
    cargo --version && \
    cargo-contract --version && \
    # Clean up and remove compilation artifacts that a cargo install creates (>250M).
    rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache
RUN rustup default nightly