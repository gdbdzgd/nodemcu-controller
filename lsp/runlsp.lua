require "http"
require "lsp"

server=newHttpServer()
server.map("default",newLSPHandler())
