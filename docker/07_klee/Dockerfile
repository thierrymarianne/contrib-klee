FROM safepkt/llvm12:latest as llvm_base
FROM safepkt/gtest:latest as gtest_base
FROM safepkt/uclibc:latest as uclibc_base
FROM safepkt/libcxx:latest as libcxx_base
FROM safepkt/stp:latest as stp_base
FROM safepkt/z3:latest as z3_base
FROM llvm_base as intermediate
COPY --from=gtest_base /tmp /tmp/
COPY --from=uclibc_base /tmp /tmp/
COPY --from=libcxx_base /tmp /tmp/
COPY --from=stp_base /tmp /tmp/
COPY --from=z3_base /tmp /tmp/
ENV COVERAGE=0
ENV KLEE_RUNTIME_BUILD=Release+Debug+Asserts
ENV USE_TCMALLOC=0
ENV USE_LIBCXX=1
ENV ENABLE_DOXYGEN=0
ENV BASE=/tmp
ENV LLVM_VERSION=12
ENV ENABLE_OPTIMIZED=1
ENV ENABLE_DEBUG=1
ENV DISABLE_ASSERTIONS=0
ENV REQUIRES_RTTI=0
ENV SOLVERS=STP:Z3
ENV GTEST_VERSION=1.7.0
ENV UCLIBC_VERSION=klee_0_9_29
ENV LLVM_VERSION=12
ENV LLVM_VERSION=12
ENV SANITIZER_BUILD=
ENV LLVM_VERSION=12
ENV STP_VERSION=master
ENV MINISAT_VERSION=master
ENV Z3_VERSION=4.8.4
COPY . /tmp/klee_src/
RUN /tmp/klee_src//scripts/build/build.sh --debug --install-system-deps klee
LABEL maintainer="KLEE Developers"
# TODO remove adding sudo package
# Create ``klee`` user for container with password ``klee``.
# and give it password-less sudo access (temporarily so we can use the CI scripts)
RUN apt update && DEBIAN_FRONTEND=noninteractive apt -y --no-install-recommends install sudo emacs-nox vim-nox file python3-dateutil && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m klee && \
    echo klee:klee | chpasswd && \
    cp /etc/sudoers /etc/sudoers.bak && \
    echo 'klee  ALL=(root) NOPASSWD: ALL' >> /etc/sudoers

# Copy across source files needed for build
COPY --chown=klee:klee . /tmp/klee_src/

# Build and set klee user to be owner
RUN /tmp/klee_src/scripts/build/build.sh --debug --install-system-deps klee && chown -R klee:klee /tmp/klee_build* && pip3 install flask wllvm && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="$PATH:/tmp/llvm-60-install_O_D_A/bin:/home/klee/klee_build/bin"
ENV BASE=/tmp

USER klee
WORKDIR /home/klee
ENV LD_LIBRARY_PATH /home/klee/klee_build/lib/

# Add KLEE binary directory to PATH
RUN /bin/bash -c 'ln -s ${BASE}/klee_src /home/klee/ && ln -s ${BASE}/klee_build* /home/klee/klee_build'

# TODO Remove when STP is fixed
RUN /bin/bash -c 'echo "export LD_LIBRARY_PATH=$(cd ${BASE}/metaSMT-*-deps/stp-git-basic/lib/ && pwd):$LD_LIBRARY_PATH" >> /home/klee/.bashrc'
