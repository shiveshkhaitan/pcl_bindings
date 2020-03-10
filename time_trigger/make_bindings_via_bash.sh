#!/bin/bash
# # make binding gereration via bash

# # Generate all_includes file
# cd include/
# grep -rl "\#include\s*\"\(.*\)\"" . | xargs sed -i "s/\#include\s*\"\(.*\)\"/\#include \<\1\>/g"
# cd ..

# cd src/
# grep -rl "\#include\s*\"\(.*\)\"" . | xargs sed -i "s/\#include\s*\"\(.*\)\"/\#include \<\1\>/g"
# cd ..
PCL_BUILD_INCLUDE=/home/${USER}/pcl/build/include
PCL_INCLUDE=/home/${USER}/pcl/common/include
EIGEN_INCLUDE=/usr/include/eigen3
PYBIND11_INCLUDE=/home/${USER}/pybind11/include
PYBIND11_SOURCE=/home/${USER}/pybind11/source

grep -rh "#include" include/* | sort -u > all_bash_includes.hpp
# # Makde bindings dir from scratch \
rm -rf ./bindings/ && mkdir bindings/
#  # Make bindings code 

module_name=${PWD##*/}
# # echo $module_name

cd src
g++ -c ${module_name}.cpp -I ${PCL_INCLUDE} -I ${EIGEN_INCLUDE} -I ${PCL_BUILD_INCLUDE} -fPIC -o ${module_name}.o
cd ..

/usr/local/bin/binder \
  --root-module ${module_name} \
  --prefix $PWD/bindings/ \
  --bind "" \
  --config ${module_name}.config \
  all_bash_includes.hpp \
  -- -std=c++14 -I $PWD/include -I ${EIGEN_INCLUDE} -I ${PCL_BUILD_INCLUDE} -I ${PCL_INCLUDE}\
  -DNDEBUG

include_dir=$PWD/include

cd bindings
recursiverm() {
  for file in *; do
    if [ -d "$file" ]; then
      (cd -- "$file" && recursiverm)
    else
        if [[ $file == *.cpp ]]
        then
            pybase=`which python3`
            g++ \
              -O3 \
              -I ${pybase::-12}/include/python3.6m -I ${PYBIND11_INCLUDE} -I ${include_dir}  -I ${EIGEN_INCLUDE} -I ${PCL_BUILD_INCLUDE} -I ${PCL_INCLUDE} -I ${PYBIND11_SOURCE} -shared  \
              -std=c++14 -c ${file::-4}.cpp\
              -o ${file::-4}.o -fPIC
             echo $file
        fi
    fi
  done
}

recursiverm

# Link together compiled bindings
g++ -o ${module_name}.so -shared ${module_name}.o pcl/common/${module_name}.o pcl/pcl_macros.o ../src/${module_name}.o


# Try running via python
python3 -c "import sys; sys.path.append('.'); import ${module_name}; trigger = ${module_name}.pcl.TimeTrigger(); trigger "

# cd ../
