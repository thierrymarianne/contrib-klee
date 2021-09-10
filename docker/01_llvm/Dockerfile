FROM ubuntu:latest as intermediate
ENV LLVM_VERSION=12
ENV ENABLE_OPTIMIZED=1
ENV ENABLE_DEBUG=1
ENV DISABLE_ASSERTIONS=0
ENV REQUIRES_RTTI=0
ENV BASE=/tmp
ENV SANITIZER_BUILD=
COPY . .
RUN ./build.sh --debug --install-system-deps llvm
FROM ubuntu:latest as final
COPY --from=intermediate /tmp/llvm-120-install_O_D_A /tmp/llvm-120-install_O_D_A
COPY --from=intermediate /tmp/llvm-120 /tmp/llvm-120
LABEL maintainer="KLEE Developers"
