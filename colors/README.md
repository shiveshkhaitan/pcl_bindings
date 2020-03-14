## OVERVIEW
Python binding for `colors` in pcl/common

## REQUIREMENTS
- [pybind11](https://github.com/pybind/pybind11)
- [binder](https://github.com/shiveshkhaitan/binder)

## USAGE
Set the correct paths for the following in `make_bindings_via_bash.sh`
- PCL_BUILD_INCLUDE (Required for pcl_config.h)
- PCL_INCLUDE
- EIGEN_INCLUDE
- PYBIND11_INCLUDE
- PYBIND11_SOURCE

Execute `./make_bindings_via_cmake.py`
