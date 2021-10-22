# Lightweight GPX file parser for R

[![Build Status](https://travis-ci.org/bmewing/gpx.svg?branch=master)](https://travis-ci.org/bmewing/gpx) [![Coverage Status](https://img.shields.io/codecov/c/github/bmewing/gpx/master.svg)](https://codecov.io/github/bmewing/gpx?branch=master) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/gpx)](https://CRAN.R-project.org/package=gpx) ![](http://cranlogs.r-pkg.org/badges/gpx)

## Install it!

```r
install.packages('gpx')
#Install the latest version from GitHub
#devtools::install_github("bmewing/gpx")
```

## Usage

Pass in the path to a GPX file to the `read_gpx` function to get back a list of routes and tracks as data frames.

```r
hike = gpx::read_gpx('example-hike.gpx')
hike$tracks #list of data frames of tracks in the file
hike$routes #lits of data frames or routes in the file
```
