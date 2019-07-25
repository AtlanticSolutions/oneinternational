/*****************************************************************************
 *   FaceAnimator.hpp
 ******************************************************************************
 *   by Kirill Kornyakov and Alexander Shishkov, 13th May 2013
 ****************************************************************************** *
 *   Copyright Packt Publishing 2013.
 *   http://bit.ly/OpenCV_for_iOS_book
 *****************************************************************************/

#pragma once

#include <opencv2/core/core.hpp>
#include <opencv2/objdetect/objdetect.hpp>

class FaceAnimator
{
public:
    struct Parameters
    {
        cv::Mat maskImage;
        cv::Mat backgroundImage;
        cv::Mat fixedBackgroundImage;
        cv::CascadeClassifier faceCascade;
        cv::CascadeClassifier eyesCascade;
        float shift;
        float scale;
        bool hasBackground;
        bool hasFixedBackground;
    };

    Parameters parameters_;
    void changeMask(Parameters parameters);
    FaceAnimator(Parameters params);
    virtual ~FaceAnimator() {};
    

    void detectAndAnimateFaces(cv::Mat& frame);

protected:
    cv::Mat maskOrig_;
    cv::Mat grayFrame_;
    cv::Mat maskBackground_;
    cv::Mat maskFixedBackground_;
    
    bool maskDetected;
    cv::Rect oldFace;
    cv::Rect oldFeature;
    int maskFrameCountdown;
    
    void putImage(cv::Mat& frame, const cv::Mat& image,
                  const cv::Mat& alpha, cv::Rect face,
                  cv::Rect facialFeature, float shift, float scale);
    
    void putBackground(cv::Mat& frame, const cv::Mat& image, const cv::Mat& alpha);
    
    void PreprocessToGray(cv::Mat& frame);
    
    bool isMaskInsideFrame(cv::Mat& frame, const cv::Mat& image, cv::Rect face,
                           cv::Rect feature);

    // Members needed for optimization with Accelerate Framework
    void PreprocessToGray_optimized(cv::Mat& frame);
    cv::Mat accBuffer1_;
    cv::Mat accBuffer2_;
};
