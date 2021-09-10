FROM ubuntu:latest as intermediate
ENV UCLIBC_VERSION=klee_0_9_29
ENV LLVM_VERSION=12
ENV BASE=/tmp
ENV LLVM_VERSION=12
COPY . .
RUN ./build.sh --debug --install-system-deps uclibc
FROM ubuntu:latest as final
COPY --from=intermediate /tmp/klee-uclibc-120 /tmp/klee-uclibc-120
LABEL maintainer="KLEE Developers"
