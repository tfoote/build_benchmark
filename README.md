

Compare two repos files build time.

use run_benchmark.sh as an example

To setup an isolated environmnet


rocker --user --volume `pwd`:/tmp/benchmark -- osrf/ros:rolling-desktop

Inside
* `sudo apt-get update`
* `rosdep update`
* `bash run_benchmark.sh`

The first run will be very slow needing to do checkouts and rosdep updates. 