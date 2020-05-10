module('http', package.seeall)

http.request = {
  method = os.getenv('REQUEST_METHOD'),
  query = os.getenv('QUERY_STRING'),
  uri = os.getenv('REQUEST_URI'),
  headers = {
    contentLength = tonumber(os.getenv('CONTENT_LENGTH')),
    contentType = os.getenv('CONTENT_TYPE'),
    host = os.getenv('HTTP_HOST'),
    userAgent = os.getenv('HTTP_USER_AGENT'),
    accept = os.getenv('HTTP_ACCEPT'),
  },
  remoteAddr = os.getenv('REMOTE_ADDR'),
  remotePort = os.getenv('REMOTE_PORT'),
}

if http.request.headers.contentLength ~= nil then
  http.request.body = io.read(http.request.headers.contentLength)
end

http.response = {}
function http.response.status(code, reason)
  reason = reason or ''
  io.write('Status: ' .. code .. ' ' .. reason .. '\n')
end

function http.response.header(key, value)
  io.write(key .. ': ' .. value .. '\n')
end

function http.response.send(str)
  io.write('\n')
  return io.write(str)
end
