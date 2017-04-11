--- Handles an Elisa request.
local function handle_request()
  local args = ngx.req.get_uri_args()
  local body
  local search

  if not args.query then
    ngx.print('{}')
    return
  end

  body = [[
    {
      "query": {
        "match_phrase_prefix": {
          "name": {
            "query":          "]] .. args.query .. [[",
            "max_expansions": 10
          }
        }
      }
    }
  ]]

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
