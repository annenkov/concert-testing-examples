Example usage of [ConCert](https://github.com/AU-COBRA/ConCert/)'s property-based testing framework, on various smart contracts.

The [examples](/examples) folder contains tests of different smart contracts. Each example consists of a `*Gen.v` file, containing the test data generator function for the given contract. The `*.Spec` file contains the QuickChick properties to test. The tests are executed in `RunTests.v`.   

## Requirements & Building

Requires Coq 8.11.2 to compile.
The easiest way to install Coq and the dependencies is through opam.
Read [here](https://coq.inria.fr/opam-using.html) about how to install and manage several versions of Coq.

If it's a fresh installation (or to a newly created switch/root), the following lines should be sufficient.

```
opam repo add coq-released https://coq.inria.fr/opam/released
opam pin -j 4 add https://github.com/AU-COBRA/ConCert.git
```

If Coq wasn't installed previously, it will be installed as one of the dependencies.
The process of building all the dependencies is quite time-consuming.

After the process of building dependencies is finished, run `make` in the project root to check that the examples compile.
