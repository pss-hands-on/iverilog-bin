#!/bin/sh

cwd=$(pwd)

if "x${CONTAINER}" != "x"; then
    yum install -y flex bison gperf autoconf
fi

if "x${TARGET}" = "x"; then
    TARGET=linux
fi

iverilog_version=12.0
iverilog_tgz=${cwd}/v12_0.tar.gz
iverilog_dir=${cwd}/iverilog-12_0

if test ! -f ${iverilog_tgz}; then
    wget https://github.com/steveicarus/iverilog/archive/refs/tags/v12_0.tar.gz
    if test $? -ne 0; then exit 1; fi
fi

if test -d ${iverilog_dir}; then
    rm -rf ${iverilog_dir}
fi

tar xvf ${iverilog_tgz}
if test $? -ne 0; then exit 1; fi

cd ${iverilog_dir}

autoconf
if test $? -ne 0; then exit 1; fi

./configure --prefix=${cwd}/iverilog-${TARGET}-${iverilog_version}
if test $? -ne 0; then exit 1; fi

make -j$(nproc)
if test $? -ne 0; then exit 1; fi

make install
if test $? -ne 0; then exit 1; fi

cd ${cwd}

tar czf iverilog-${TARGET}-${iverilog_version}.tar.gz iverilog-${TARGET}-${iverilog_version}
if test $? -ne 0; then exit 1; fi
