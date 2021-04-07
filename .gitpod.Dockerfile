FROM paritytech/base-ci:latest

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


WORKDIR /home/coder
RUN cargo contract new flipper
WORKDIR /home/coder/flipper
RUN cargo +nightly contract build