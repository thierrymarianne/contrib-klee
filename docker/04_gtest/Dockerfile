FROM ubuntu:latest as intermediate
ENV GTEST_VERSION=1.7.0
ENV BASE=/tmp
COPY . .
RUN ./build.sh --debug --install-system-deps gtest
FROM ubuntu:latest as final
COPY --from=intermediate /tmp/googletest-release-1.7.0 /tmp/googletest-release-1.7.0
LABEL maintainer="KLEE Developers"
