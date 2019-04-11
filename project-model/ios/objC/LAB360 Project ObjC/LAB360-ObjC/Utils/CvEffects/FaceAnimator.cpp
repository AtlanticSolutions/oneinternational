/*****************************************************************************
 *   FaceAnimator.cpp
 ******************************************************************************
 *   by Kirill Kornyakov and Alexander Shishkov, 13th May 2013
 ****************************************************************************** *
 *   Copyright Packt Publishing 2013.
 *   http://bit.ly/OpenCV_for_iOS_book
 *****************************************************************************/

#include "FaceAnimator.hpp"
#include "Processing.hpp"
#include "opencv2/imgproc/imgproc.hpp"

using namespace cv;
using namespace std;

FaceAnimator::FaceAnimator(Parameters parameters)
{
    parameters_ = parameters;

    ExtractAlpha(parameters_.maskImage, maskOrig_);
    ExtractAlpha(parameters_.backgroundImage, maskBackground_);
    ExtractAlpha(parameters_.fixedBackgroundImage, maskFixedBackground_);
}

void FaceAnimator::changeMask(Parameters parameters)
{
    parameters_ = parameters;
    
    ExtractAlpha(parameters_.maskImage, maskOrig_);
    ExtractAlpha(parameters_.backgroundImage, maskBackground_);
    ExtractAlpha(parameters_.fixedBackgroundImage, maskFixedBackground_);
}

void FaceAnimator::putImage(Mat& frame, const Mat& image,
                            const Mat& alpha, Rect face,
                            Rect feature, float shift, float scale)
{
    // Scale animation image
    Size size;
    size.width = scale * feature.width;
    size.height = scale * feature.height;
    Size newSz = Size(size.width,
                      float(image.rows) / image.cols * size.width);
    
    // Find place for animation
    float coeff = (scale - 1.) / 2.;
    Point origin(face.x + feature.x - coeff * feature.width,
                 face.y + feature.y - coeff * feature.height +
                 newSz.height * shift);
    
    if(origin.y + newSz.height < frame.rows && origin.y > 0 && origin.x + newSz.width < frame.cols && origin.x > 0)
    {
        
        Mat glasses;
        Mat mask;
        resize(image, glasses, newSz);
        resize(alpha, mask, newSz);


        Rect roi(origin, newSz);
        Mat roi4glass = frame(roi);
        
        //        cv::Scalar colorScalar = cv::Scalar( 94, 206, 165 );
        //        rectangle(frame, face, colorScalar);
        //        Point p(face.x, face.y);
        //        rectangle(frame, feature + p, colorScalar);
        
        alphaBlendC4(glasses, roi4glass, mask);
        
    }
}

void FaceAnimator::putBackground(Mat& frame, const Mat& image,const Mat& alpha)
{
    // Scale animation image
    Size size;
    size.width = frame.cols;
    size.height = frame.rows;
    Size newSz = size;
    Mat glasses;
    Mat mask;
    resize(image, glasses, newSz);
    resize(alpha, mask, newSz);
    
    // Find place for animation
    Point origin(0 , 0);
        
    Rect roi(origin, newSz);
    
//    cv::Scalar colorScalar = cv::Scalar( 94, 206, 165 );
//    rectangle(frame, roi, colorScalar);
    
    Mat roi4glass = frame(roi);
    
    //        cv::Scalar colorScalar = cv::Scalar( 94, 206, 165 );
    //        rectangle(frame, face, colorScalar);
    //        Point p(face.x, face.y);
    //        rectangle(frame, feature + p, colorScalar);
    
    alphaBlendC4(glasses, roi4glass, mask);
    
}

static bool FaceSizeComparer(const Rect& r1, const Rect& r2)
{
    return r1.area() > r2.area();
}

void FaceAnimator::PreprocessToGray(Mat& frame)
{
    cvtColor(frame, grayFrame_, CV_RGBA2GRAY);
    equalizeHist(grayFrame_, grayFrame_);
}

void FaceAnimator::PreprocessToGray_optimized(Mat& frame)
{
    grayFrame_.create(frame.size(), CV_8UC1);
    accBuffer1_.create(frame.size(), frame.type());
    accBuffer2_.create(frame.size(), CV_8UC1);
        
    cvtColor_Accelerate(frame, grayFrame_, accBuffer1_, accBuffer2_);
    equalizeHist_Accelerate(grayFrame_, grayFrame_);
}

void FaceAnimator::detectAndAnimateFaces(Mat& frame)
{
    TS(Preprocessing);
//    PreprocessToGray(frame);
    PreprocessToGray_optimized(frame);
    TE(Preprocessing);
    
    // Detect faces
    TS(DetectFaces);
    std::vector<Rect> faces;
    parameters_.faceCascade.detectMultiScale(grayFrame_, faces, 1.1,
                                              2, 0, Size(100, 100));
    TE(DetectFaces);
    //printf("Detected %lu faces\n", faces.size());
    
    
    if(parameters_.hasFixedBackground){
        
        TS(DrawFixedBackground);
        putBackground(frame, parameters_.fixedBackgroundImage, maskFixedBackground_);
        TE(DrawFixedBackground);
        
    }

    // Sort faces by size in descending order
    sort(faces.begin(), faces.end(), FaceSizeComparer);

    
    if(faces.size() > 0){
        
        Mat faceROI = grayFrame_( faces[0] );
        
        std::vector<Rect> facialFeature;
        Point origin(0, faces[0].height/4);
        Mat eyesArea = faceROI(Rect(origin,
                                    Size(faces[0].width, faces[0].height/4)));
        
        TS(DetectEyes);
        parameters_.eyesCascade.detectMultiScale(eyesArea,
                                                 facialFeature, 1.1, 2, CV_HAAR_FIND_BIGGEST_OBJECT,
                                                 Size(faces[0].width * 0.55, faces[0].height * 0.13));
        TE(DetectEyes);
        
        
        int delta = 3;
        
        if (facialFeature.size() > 0 && isMaskInsideFrame(frame, parameters_.maskImage, faces[0], facialFeature[0]))
        {
//            printf("faces[0].height = %d , oldFace.height = %d\n", faces[0].height, oldFace.height);
//            printf("faces[0].width = %d , oldFace.width = %d\n\n", faces[0].width, oldFace.width);
            if(!((faces[0].height >= oldFace.height - delta && faces[0].height <= oldFace.height + delta) &&
                 (faces[0].width >= oldFace.width - delta && faces[0].width <= oldFace.width + delta) &&
                 (faces[0].x >= oldFace.x - delta && faces[0].x <= oldFace.x + delta) &&
                 (faces[0].y >= oldFace.y - delta && faces[0].y <= oldFace.y + delta)) ||
               !maskDetected){
                
                
                maskDetected = true;
                oldFace = faces[0];
                oldFeature = facialFeature[0] + origin;
                maskFrameCountdown = 2;
                
                
                
                
                TS(DrawGlasses);
                putImage(frame, parameters_.maskImage, maskOrig_,
                         faces[0], facialFeature[0] + origin, parameters_.shift, parameters_.scale);
                TE(DrawGlasses);
                
                
            }
            else{
                
                TS(DrawGlasses);
                putImage(frame, parameters_.maskImage, maskOrig_,
                         oldFace, oldFeature, parameters_.shift, parameters_.scale);
                TE(DrawGlasses);
                
            }
            
        } else {
            
            
            if(maskDetected){
                
                if(maskFrameCountdown > 0){
                    
                    maskFrameCountdown--;
                    //                    printf("COUNTDOWN: %d\n", maskFrameCountdown);
                    
                    TS(DrawGlasses);
                    putImage(frame, parameters_.maskImage, maskOrig_,
                             oldFace, oldFeature, parameters_.shift, parameters_.scale);
                    TE(DrawGlasses);
                    
                }
                else{
                    
                    //                    printf("SUMIU A IMAGEM\n");
                    
                }
                
            }
            
        }
        
    }
    else {
        
        if(maskDetected){
            
            if(maskFrameCountdown > 0){
                
                maskFrameCountdown--;
                //                printf("COUNTDOWN: %d\n", maskFrameCountdown);
                
                TS(DrawGlasses);
                putImage(frame, parameters_.maskImage, maskOrig_,
                         oldFace, oldFeature, parameters_.shift, parameters_.scale);
                TE(DrawGlasses);
                
            }
            else{
                
                //                printf("SUMIU A IMAGEM\n");
                
            }
        }
    }
}

bool FaceAnimator::isMaskInsideFrame(Mat& frame, const Mat& image, Rect face,
                                     Rect feature){
    
    float scale = parameters_.scale;
    Size size;
    size.width = scale * feature.width;
    size.height = scale * feature.height;
    Size newSz = Size(size.width,
                      float(image.rows) / image.cols * size.width);
    
    float coeff = (scale - 1.) / 2.;
    Point origin(face.x + feature.x - coeff * feature.width,
                 face.y + feature.y - coeff * feature.height +
                 newSz.height * parameters_.shift);
    
    if(origin.y + newSz.height < frame.rows && origin.y > 0 && origin.x + newSz.width < frame.cols && origin.x > 0)
    {
        
        return true;
        
    } else {
        
        printf("FORA DOS LIMITES DO FRAME\n");
        
        return false;
        
    }
    
}
