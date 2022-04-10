FROM ubuntu:20.04 as builder

## Deps
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang curl
RUN curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN ${HOME}/.cargo/bin/rustup default nightly
RUN ${HOME}/.cargo/bin/cargo install -f cargo-fuzz

## src
ADD . /rustc-demangle
WORKDIR /rustc-demangle

RUN ${HOME}/.cargo/bin/cargo fuzz build

FROM ubuntu:20.04

COPY --from=builder rustc-demangle/target/x86_64-unknown-linux-gnu/release/demangle /
