//
//  GPUImageProcessClass.m
//  iosCamera
//
//  Created by vk on 15/10/9.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "GPUImageProcessClass.h"
//#import <GPUImage/GPUImage.h>
#import <GPUImage.h>
#import "CloverTFFilter.h"

@implementation GPUImageProcessClass


+ (UIImage *) aGPUImageProcess:(UIImage *)inputImage{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    GPUImageFilter *myf = [[CloverTFFilter alloc]init];
    [stillImageSource addTarget:myf];
    [myf useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *currentFilteredVideoFrame = [myf imageFromCurrentFramebuffer];
    return currentFilteredVideoFrame;
}

@end
