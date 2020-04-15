set -v
set -e
path=`pwd` #path to your puma directory
echo $path
cppfile=conv-layer #name for cpp file that you want to compile ex- mlp_l4_mnist.cpp, conv-layer.cpp, convmax-layer.cpp
name=conv #name for the folder generated by compiler
pumaenv=pumaenv #name for the environment 
fileno=0 #variable so that conv folder generated by compilers do not overlap (u might want to change this variable to different int values for different layers)
name=$name$fileno
#layer parameters
inx=9
iny=9
inC=64
outC=64
kx=3
ky=3
p=1
s=1
#copying cnn config file
rm ${path}/puma-simulator/include/config.py #remove existing config file
cp ${path}/puma-simulator/include/example-configs/config-cnn.py  ${path}/puma-simulator/include/config.py #copy the mlp config file to include
#copying model file
rm ${path}/puma-compiler/test/${cppfile}.cpp ${path}/puma-compiler/test/${cppfile}.h   
cp ${path}/puma-simulator/test/cnn/conv-layer-stride.cpp  ${path}/puma-compiler/test/${cppfile}.cpp #copy the mlp config file to include 
cp ${path}/puma-simulator/test/cnn/conv-layer-stride.h  ${path}/puma-compiler/test/${cppfile}.h #copy the mlp config file to include 

cd ${path}/puma-compiler/src
source ~/.bashrc
conda activate ${pumaenv}

make clean
make

cd ${path}/puma-compiler/test
make clean
make ${cppfile}.test
export LD_LIBRARY_PATH=`pwd`/../src:$LD_LIBRARY_PATH
./${cppfile}.test ${inx} ${iny} ${inC} ${outC} ${kx} ${ky} ${p} ${s} ${fileno}
echo $cppfile  
./generate-py.sh 
cp -r ${name} ../../puma-simulator/test/testasm

cd ${path}/puma-simulator/src


python dpe.py -n ${name} 



