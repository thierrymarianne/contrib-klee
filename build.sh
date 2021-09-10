# manual builds
docker build -t safepkt/llvm12:latest -f ./docker/01_llvm/Dockerfile ./docker/01_llvm
docker build -t safepkt/stp:latest -f ./docker/02_stp/Dockerfile ./docker/02_stp
docker build -t safepkt/z3:latest -f ./docker/03_z3/Dockerfile ./docker/03_z3
docker build -t safepkt/gtest:latest -f ./docker/04_gtest/Dockerfile ./docker/04_gtest
docker build -t safepkt/uclibc:latest -f ./docker/05_uclibc/Dockerfile ./docker/05_uclibc
docker build -t safepkt/libcxx:latest -f docker/06_libcxx/Dockerfile docker/06_libcxx
docker build -t safepkt/klee:latest -f docker/07_klee/Dockerfile ./
