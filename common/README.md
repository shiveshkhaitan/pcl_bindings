## OVERVIEW
Python binding for `common` module

## REQUIREMENTS
- [pcl](https://github.com/shiveshkhaitan/pcl/tree/bindings)
- [pybind11](https://github.com/pybind/pybind11)
- [binder](https://github.com/shiveshkhaitan/binder)

## USAGE
Set the correct paths for the following in `make_bindings_via_cmake.py` and terminal (for some reason `binder` is not getting executed correctly from python script)
- PCL_BUILD_INCLUDE (Required for pcl_config.h)
- PCL_INCLUDE
- EIGEN_INCLUDE
- PYBIND11_INCLUDE
- PYBIND11_SOURCE

Execute `/path/to/binder --root-module common --prefix cmake_bindings/ --bind "" --config common.config all_cmake_includes.hpp -- -std=c++14 -I include -I ${PCL_BUILD_INCLUDE} -I ${PCL_INCLUDE} -I ${EIGEN_INCLUDE} -DNDEBUG`

Execute `./make_bindings_via_cmake.py`

The bindings would be built inside `cmake_bindings`.
To check 
```
cd cmake_bindings
python3 <<< "import common; print(common.pcl.common)"
```