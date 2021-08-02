![build status](https://github.com/mikkelmilo/concert-testing-examples/actions/workflows/build.yml/badge.svg)

Example usage of [ConCert](https://github.com/AU-COBRA/ConCert/)'s property-based testing framework, on various smart contracts.

The [examples](/examples) folder contains tests of different smart contracts. Each example consists of a `*Gen.v` file, containing the test data generator function for the given contract. The `*Spec.v` files contain the QuickChick properties to test. The tests are executed in `RunTests.v`.

## Requirements & Building

### Using `opam`

The development requires the Coq proof assistant version 8.11.2 to compile.
The easiest way to install Coq and the dependencies is through opam.
`opam` opam is a package manager for OCaml; read the installation instructions [here](https://opam.ocaml.org/doc/Install.html).
Read [here](https://coq.inria.fr/opam-using.html) about how to install and manage several versions of Coq (only if there is an existing Coq installation incompatible with ConCert).

If it's a fresh installation (or to a newly created switch/root), the following lines should be sufficient (run `opam init` first, if it is a fresh `opam` installation).

```
opam repo add coq-released https://coq.inria.fr/opam/released
opam pin -j 4 add https://github.com/AU-COBRA/ConCert.git
```

If Coq wasn't installed previously, it will be installed as one of the dependencies.
The process of building all the dependencies is quite time-consuming.

After the process of building dependencies is finished, run `make` in the project root to check that the examples compile and see the resutls of running the tests.

### Using `Docker`

Requires Docker installation. Docker is available for different platforms (Mac, Windows, Linux). Read the instructions [here](https://docs.docker.com/get-docker/).
We use an Ubuntu-based image containing pre-compiled ConCert with all the required dependencies, making the build process much faster.

In the root folder of the project (where the `Dockerfile` is located), run the following (note the period `.` at the end)

```
docker build -t concert-testing-image .
```

After build finishes, one can connect to the image in the interactive mode using the following command:

```
docker run -it concert-testing-image
```

The command will run a terminal session in the image's Ubuntu installation.

Run the following to re-run the tests:


```
cd concert-testing-examples
eval $(opam env --switch=${COMPILER_EDGE} --set-switch)
make clean && make
```

The image comes with the Emacs editor allowing to step through the development.

Run the following, after connecting to the image in the interactive mode:

```
cd concert-testing-examples
eval $(opam env --switch=${COMPILER_EDGE} --set-switch)
emacs ./examples/RunTests.v
```

After the file is open, it is possible to step through the development by moving the cursor to the required line and pressing `Ctrl-C RET`.
See the [Proof General documentation](https://proofgeneral.github.io/) for more details.
