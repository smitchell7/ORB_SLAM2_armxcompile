echo "Configuring and building Thirdparty/DBoW2 ..."


export ABI="armeabi-v7a"
export API='android-15'
export ANDROID_NDK_VERSION='android-ndk-r12b'
export PROJ_DIR=${PWD}  
export BUILD_OPENCV=0   


# Get extra files
cd Thirdparty
wget http://bitbucket.org/eigen/eigen/get/3.2.10.tar.gz
mkdir eigen && tar xzf 3.2.10.tar.gz -C eigen --strip-components 1

if [$BUILD_OPENCV==1]; then
  # if we build opencv, then we should point to the correct installation.
  # if not, then let cmake try to figure it out for itself.
  # note that we are using the opencv setup that's specific for the ABI and API
  export OPENCV_DIR_FLAG=' -DOpenCV_DIR='{PWD}'/Thirdparty/opencv/build/'
  git clone https://github.com/opencv/opencv.git
fi


cd ../..
git clone https://github.com/taka-no-me/android-cmake
wget https://dl.google.com/android/repository/$ANDROID_NDK_VERSION-linux-x86_64.zip
unzip $ANDROID_NDK_VERSION-linux-x86_64.zip
cd $PROJ_DIR

# define all of the cmake config files. This plays heavily with the android-cmake setup that's downloaded above.
export CMFLAGS='-DCMAKE_TOOLCHAIN_FILE='${PWD}'/../android-cmake/android.toolchain.cmake -DANDROID_NDK='${PWD}'/../'$ANDROID_NDK_VERSION' -DCMAKE_BUILD_TYPE=Release -DANDROID_ABI='$ABI' -DANDROID_NATIVE_API_LEVEL='$API' -Wno-dev '$OPENCV_DIR_FLAG

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
