local cjson = require('cjson.safe')
local stdquery = [[{
  "query": {
    "match_phrase_prefix": {
      "name": {
        "query":          "!!!query!!!",
        "max_expansions": 10
      }
    }
  }
}]]

--- Handles an Elisa request.
local function handle_request()
  local args = ngx.req.get_uri_args()
  local body
  local search

  if not args.query then
    ngx.print('{}')
    return
  end

  -- cjson encode adds quotes around a string
  -- prevent table placeholder to create double quotes
  query = query:gsub('"!!!query!!!"', '!!!query!!!')

  body   = stdquery:gsub('!!!query!!!', cjson.encode(args.query))
  search = ngx.location.capture(
    '/__elisa__/upstream/test_data/_search',
    { body = body }
  )

  ngx.print(search.body)
end

-- export module
return {
  handle = handle_request
}
