#!/bin/bash

cd /home/opam/server
./_build/default/example_server.exe &

sleep 2

cd /home/opam/ocaml-tls
_build/lwt/examples/http_client.native localhost 4433 NONE
