FROM ubuntu:latest as intermediate
ENV STP_VERSION=master
ENV MINISAT_VERSION=master
ENV BASE=/tmp
ENV SANITIZER_BUILD=
ENV LLVM_VERSION=12
COPY . .
RUN ./build.sh --debug --install-system-deps stp
FROM ubuntu:latest as final
COPY --from=intermediate /tmp/minisat-install /tmp/minisat-install
COPY --from=intermediate /tmp/stp-master-install /tmp/stp-master-install
LABEL maintainer="KLEE Developers"
