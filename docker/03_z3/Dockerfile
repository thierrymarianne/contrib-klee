FROM ubuntu:latest as intermediate
ENV Z3_VERSION=4.8.4
ENV BASE=/tmp
ENV SANITIZER_BUILD=
ENV LLVM_VERSION=12
COPY . .
RUN ./build.sh --debug --install-system-deps z3
FROM ubuntu:latest as final
COPY --from=intermediate /tmp/z3-4.8.4-install /tmp/z3-4.8.4-install
LABEL maintainer="KLEE Developers"
