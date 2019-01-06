FROM ocaml/opam2:debian-stable

RUN sudo apt-get install -y libgmp3-dev m4 git

RUN opam update
RUN opam install dune cohttp cohttp-lwt-unix tls

COPY --chown=opam:opam server /home/opam/server
WORKDIR /home/opam/server

RUN openssl req -x509 -newkey rsa:4096 -keyout server.key -out server.crt -days 3650 -nodes -subj "/C=UK/ST=foo/L=bar/O=baz/OU= Department/CN=example.com"
RUN eval $(opam env) && dune build example_server.exe


# Build ocaml-tls

RUN git clone https://github.com/hannesm/ocaml-tls.git /home/opam/ocaml-tls
WORKDIR /home/opam/ocaml-tls

RUN git checkout lwt-resp-semantics
RUN opam install -y topkg-care ounit cstruct-unix
RUN sed -ie '/test_client/a Pkg.test ~run:false ~cond:lwt "lwt/examples/http_client" ;' pkg/pkg.ml
RUN eval $(opam env) && bash build

COPY run.sh /home/opam
CMD bash /home/opam/run.sh
