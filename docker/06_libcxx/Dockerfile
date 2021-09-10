FROM ubuntu:latest as intermediate
ENV LLVM_VERSION=12
ENV BASE=/tmp
ENV LLVM_VERSION=12
COPY . .
RUN ./build.sh --debug --install-system-deps libcxx
FROM ubuntu:latest as final
COPY --from=intermediate /tmp/libc++-install-120 /tmp/libc++-install-120
LABEL maintainer="KLEE Developers"
