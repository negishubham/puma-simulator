set -v
set -e
path=`pwd` #path to your puma directory
echo $path
cppfile=fully-connected-layer #name for cpp file that you want to compile ex- mlp_l4_mnist.cpp, conv-layer.cpp, convmax-layer.cpp
name=fully #name for the folder generated by compiler
pumaenv=pumaenv #name for the environment 
fileno=0
name=$name$fileno

#layer parameter
in=64
out=10


#copying mlp config file
rm ${path}/puma-simulator/include/config.py #remove existing config file
cp ${path}/puma-simulator/include/example-configs/config-mlp.py  ${path}/puma-simulator/include/config.py #copy the mlp config file to include
#copying model file
rm ${path}/puma-compiler/test/${cppfile}.cpp ${path}/puma-compiler/test/${cppfile}.h   
cp ${path}/puma-simulator/test/mlp_l4_mnist/${cppfile}.cpp  ${path}/puma-compiler/test/${cppfile}.cpp #copy the mlp config file to include 
cp ${path}/puma-simulator/test/mlp_l4_mnist/${cppfile}.h  ${path}/puma-compiler/test/${cppfile}.h #copy the mlp config file to include 

cd ${path}/puma-compiler/src
source ~/.bashrc
conda activate ${pumaenv}

make clean
make

cd ${path}/puma-compiler/test
make clean
make ${cppfile}.test
export LD_LIBRARY_PATH=`pwd`/../src:$LD_LIBRARY_PATH
./${cppfile}.test ${in} ${out} ${fileno}
echo $cppfile  
./generate-py.sh 
cp -r ${name} ../../puma-simulator/test/testasm

cd ${path}/puma-simulator/src


python dpe.py -n ${name} 



