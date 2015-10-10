//
//  ImageProcess.m
//  iosCamera
//
//  Created by vk on 15/10/9.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "ImageProcess.h"
#import "UIImage+IF.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import "GPUImageProcessClass.h"

@interface ImageProcess()

@property (nonatomic, strong) dispatch_queue_t imageProcessQueue;
@property (nonatomic, strong) UIImage *processImage;

@end

@implementation ImageProcess

-(id)init{
    if(self = [super init]){
        self.imageProcessQueue = dispatch_queue_create("com.clover.iosCamareImageProcessQueue", NULL);
    }
    return  self;
}

-(UIImage *)opencvImageProcess:(UIImage *)inputImage
{
    
//    cv::Mat img = [self CVMat:[inputImage imageRotatedByDegrees:90]];
    cv::Mat img = [self CVMat:inputImage];
    cv::Mat grayImg;
    cv::cvtColor(img, grayImg, CV_BGRA2GRAY);
    cv::Mat bit;
    cv::adaptiveThreshold(grayImg, bit, 255, CV_ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY, 25, 10);
    cv::cvtColor(bit, bit, CV_GRAY2RGB);
    //cv::Mat canny;
    //cv::Canny(grayImg, canny, 100, 100);
    
    UIImage *oi = [self UIImageFromCVMat:bit];
    return oi;
}

-(void)imageProcessWithImage:(UIImage *)inputImage{
   // dispatch_async(self.imageProcessQueue, ^{
    self.processImage = [self opencvImageProcess:inputImage];
    self.processImage = [GPUImageProcessClass aGPUImageProcess:self.processImage]; //[self aGPUImageProcess:inputImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.delegate && [self.delegate respondsToSelector:@selector(imageProcessResultReady:)]){
                [self.delegate imageProcessResultReady:self.processImage];
            }
        });
   // });
}


-(cv::Mat)CVMat:( UIImage *)uiiameg
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(uiiameg.CGImage);
    CGFloat cols = uiiameg.size.width;
    CGFloat
    rows = uiiameg.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                      // Width of bitmap
                                                    rows,                     // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), uiiameg.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}




@end
