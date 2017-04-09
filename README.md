# Elisa

## Testing

### Prerequisites

The unit tests use [Test::Nginx](http://github.com/agentzh/test-nginx) and Lua.

Please ensure your environment meets the following:

- `prove` (perl) is available
- `libluajit` is installed

To be able to run them using `prove` (perl).

### Testing Script

If you fulfill the prerequisites you can use the script `./compile_and_test.sh`
to download, compile and test in on go:

```shell
VER_LUA_NGINX=0.10.7 \
    VER_NGINX=1.11.10 \
    LUAJIT_LIB=/usr/lib/x86_64-linux-gnu/ \
    LUAJIT_INC=/usr/include/luajit-2.0/ \
    ./compile_and_test.sh
```

The two passed variables `VER_LUA_NGINX` and `VER_NGINX` define the module
versions your are using for compilation. If a variable is not passed to the
script it will be automatically taken from your environment. An error
message will be printed if no value is available.

All dependencies will automatically be downloaded to the `./vendor` subfolder.

To skip the compilation (and download) step you can pass the `--nocompile` flag:

```shell
ALL_THE_CONFIGURATION_VARIABLES \
    ./compile_and_test.sh --nocompile
```

Please be aware that (for now) all the variables are still required for the
script to run.

If you want to only run a single test from the testing folder you can pass it
as a parameter to the script (and therefore on to `prove`):

```shell
# single test
ALL_THE_CONFIGURATION_VARIABLES \
    ./compile_and_test.sh t/hello_world.t

# single test and --nocompile
ALL_THE_CONFIGURATION_VARIABLES \
    ./compile_and_test.sh --nocompile t/hello_world.t
```


## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
