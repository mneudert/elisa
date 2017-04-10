--- Handles an Elisa request.
local function handle_request()
  ngx.print('hello world')
end

-- export module
return {
  handle = handle_request
}
