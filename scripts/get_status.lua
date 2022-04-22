local res = ngx.location.capture(
  '/',
  { 
    method = ngx.HTTP_POST, 
    body = '{"jsonrpc": "2.0","method": "net_version"}' 
  }
)
ngx.status = res.status
ngx.exit(ngx.OK)