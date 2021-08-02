FROM aucobra/concert-testing:sefm-snapshot

LABEL maintainer="Cobra Team"

RUN ["/bin/bash", "--login", "-c", "set -x \
     && eval $(opam env --switch=${COMPILER_EDGE} --set-switch) \
     && cd ~ && rm -f -r concert-testing-examples && git clone https://github.com/mikkelmilo/concert-testing-examples.git && cd concert-testing-examples && make"]
