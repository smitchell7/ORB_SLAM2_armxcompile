#include<iostream>
#include<algorithm>
#include<fstream>
#include<chrono>

#include<opencv2/core/core.hpp>

#include<System.h>

using namespace std;

int main(int argc, char **argv)
{
    if(argc != 4)
    {
        cerr << endl << "Usage: ./mono_tum path_to_vocabulary path_to_settings path_to_sequence" << endl;
        return 1;
    }
    // Create SLAM system. It initializes all system threads and gets ready to process frames.
    ORB_SLAM2::System SLAM(argv[1],argv[2],ORB_SLAM2::System::MONOCULAR,true);

    // Retrieve pointer to images
    // android open camera, or something like that. 
    cv::Mat im;

    cout << endl << "-------" << endl;
    cout << "Start processing images ..." << endl;

    vector<float> xyz;
    cv::Mat rpy;


    // Main loop
    for(int ni=0; ni<nImages; ni++)
    {
        // Read image from android program
        im = cv::imread("..");
        double tframe;

        if(im.empty())
        {
            cerr << endl << "Failed to load image at: "
                 << string(argv[3]) << "/" << vstrImageFilenames[ni] << endl;
            return 1;
        }

#ifdef COMPILEDWITHC11
        std::chrono::steady_clock::time_point t1 = std::chrono::steady_clock::now();
#else
        std::chrono::monotonic_clock::time_point t1 = std::chrono::monotonic_clock::now();
#endif
        tframe = static_cast<double>(t1);

        // Pass the image to the SLAM system
        SLAM.TrackMonocular(im,tframe);
        xyz=SLAM.xyz;
        rpy=SLAM.rpy;

        std::cout << "xyz,rpy="<<xyz[0]<<'\t'<<xyz[1]<<'\t'<<xyz[2]<<'\t'<<rpy<<std::endl;

    }

    // Stop all threads
    SLAM.Shutdown();

    return 0;
}


