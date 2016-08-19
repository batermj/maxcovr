
<!-- README.md is generated from README.Rmd. Please edit that file -->
copertura
=========

[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/njtierney/copertura?branch=master&svg=true)](https://ci.appveyor.com/project/njtierney/copertura)[![Travis-CI Build Status](https://travis-ci.org/njtierney/copertura.svg?branch=master)](https://travis-ci.org/njtierney/copertura)

The goal of copertura is to make it easy to solve the Maximal Location Coverage Problem. Currently it uses the `lp` solver from the `lpsolve` package.

Why copertura?
==============

It is named "copertura" as this means "coverage" in Italian, and the research problem that created the need for this package is in Ticino, the Italian speaking canton of Switzerland.

<!-- At this stage I'm strongly considering a renaming - perhaps to `macor` - **ma**ximum **co**verage in **r**. -->
How to Install
==============

``` r

# install.packages("devtools")
devtools::install_github("njtierney/copertura")
```

<!-- # Example Usage -->
<!-- Need to find a good example dataset to use here -->
Speed
=====

At the moment it doesn't seem like `max_coverage` is that fast, but I'm hoping to provide more scalable methods by formulating the model using the fantastic [`ompr`](https://github.com/dirkschumacher/ompr), which will give users the capability to select the solver they want to use. I feel that this solution is best because it means that there is still an open source solver, but people can also use something proprietary like "gurobi" or "CPLEX".

Known Issues
============

There may also be identified bugs, please keep this in mind!

Future Work
===========

In the future we will include a set of functions to allow the user to keep their work within a dataframe and specify the potential locations and the cases that require coverage.
