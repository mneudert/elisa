# Elisa

## Usage

To activate the module you have to extend your server configuration:

```nginx
lua_package_path './src/?.lua;;';

init_by_lua_block {
    elisa = require('elisa')
}
```

Then you can process requests in your host configuration:

```nginx
# elasticsearch upstream location
location ~* ^/__elisa__/upstream/(.*) {
    internal;
    proxy_pass http://127.0.0.1:9200/$1;
}

# public elisa endpoint
location /searchproxy {
    content_by_lua_block {
        elisa.handle()
    }
}
```

### Customized Queries

By default a query passed using the GET parameter `query` (i.e. when opening
`http://my.host/searchproxy?query=foo-bar`) is converted to the following
Elasticsearch query:

```json
{
  "query": {
    "match_phrase_prefix": {
      "name": {
        "query":          "foo-bar",
        "max_expansions": 10
      }
    }
  }
}
```

You can however modify what is getting send to Elasticsearch:

```lua
elisa.handle({ query = '!!!query!!!' })
elisa.handle('{"query":"!!!query!!!"}')
```

Both a table and a plain string are accepted. Despite the minimal example the
full query has to be passed in.

The value `!!!query!!!` will automatically be replaced with the actual search.


## Testing

The unit tests use [Test::Nginx](http://github.com/agentzh/test-nginx) and Lua.

Please ensure your environment meets the following:

- `prove` (perl) is available
- `libluajit` is installed

To be able to run them using `prove` (perl).


## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
