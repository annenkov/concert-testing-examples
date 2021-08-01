FROM aucobra/concert:deps-coq-8.11

LABEL maintainer="Cobra Team"

RUN ["/bin/bash", "--login", "-c", "set -x \
  && eval $(opam env --switch=${COMPILER_EDGE} --set-switch) \
  && opam repo add coq-released https://coq.inria.fr/opam/released \
  && opam pin -y -j ${NJOBS} add https://github.com/AU-COBRA/ConCert.git \
  && cd ~ && git clone https://github.com/mikkelmilo/concert-testing-examples.git && cd concert-testing-examples && make \
  && opam clean -a -c -s --logs \
  && opam config list \
  && opam list"]
