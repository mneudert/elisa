#!/usr/bin/env bash

cd "${0%/*}"

moduledir=$(pwd)
nocompile=0

if [ "${1}" == "--nocompile" ]; then
  nocompile=1

  shift
fi


echo "==> Checking parameters"

[ -z "${VER_LUA_NGINX}" ] && echo 'parameter VER_LUA_NGINX missing' && exit 1
[ -z "${VER_NGINX}" ]     && echo 'parameter VER_NGINX missing'     && exit 1

[ -z "${LUAJIT_INC}" ] && echo 'parameter LUAJIT_INC missing' && exit 1
[ -z "${LUAJIT_LIB}" ] && echo 'parameter LUAJIT_LIB missing' && exit 1


if [ 0 -eq ${nocompile} ]; then
  echo "==> Downloading sources"

  [ -z $(which wget) ] && echo 'can not find "wget" to download libraries' && exit 2

  mkdir -p "${moduledir}/vendor"

  cd "${moduledir}/vendor"

  if [ ! -d "nginx-${VER_NGINX}" ]; then
    wget -q "http://nginx.org/download/nginx-${VER_NGINX}.tar.gz" -O nginx.tar.gz \
      && tar -xf nginx.tar.gz
  fi

  if [ ! -d "lua-nginx-module-${VER_LUA_NGINX}" ]; then
    wget -q "https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX}.tar.gz" -O lua-nginx-module.tar.gz \
      && tar -xf lua-nginx-module.tar.gz
  fi


  echo "==> Building NGINX"

  cd "${moduledir}/vendor/nginx-${VER_NGINX}"

  ./configure \
      --add-module="${moduledir}/vendor/lua-nginx-module-${VER_LUA_NGINX}"
  make || exit $?
fi


export PATH="$PATH:${moduledir}/vendor/nginx-${VER_NGINX}/objs"


echo "==> Testing!"

cd "${moduledir}" && prove $@
