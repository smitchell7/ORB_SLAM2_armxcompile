echo "Configuring and building Thirdparty/DBoW2 ..."


export ABI="armeabi-v7a"
export API='android-15'



export CMFLAGS='-DCMAKE_TOOLCHAIN_FILE='${PWD}'/../android-cmake/android.toolchain.cmake -DANDROID_NDK='${PWD}'/../android-ndk-r12b -DCMAKE_BUILD_TYPE=Release -DANDROID_ABI='$ABI' -DANDROID_NATIVE_API_LEVEL='$API' -Wno-dev -DOpenCV_DIR='${PWD}'/Thirdparty/opencv/build/'
echo $CMFLAGS

#export FAST='-j'
export FAST=''
cd Thirdparty
declare -a THIRDPARTY=("opencv" "eigen" "DBoW2" "g2o")
## now loop through the above array
for i in "${THIRDPARTY[@]}"
do
  cd $i
  mkdir build
  cd build
  cmake $CMFLAGS ../
  make install $FAST || make $FAST
  cd ../..
done

cd ../

echo "Uncompress vocabulary ..."

cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building ORB_SLAM2 ..."

mkdir build
cd build
cmake $CMFLAGS ../
make $FAST
