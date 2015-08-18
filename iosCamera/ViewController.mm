//
//  ViewController.m
//  iosCamera
//
//  Created by vk on 15/8/17.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+IF.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
@interface ViewController ()
@property(nonatomic , strong) VideoSource *myVideoSource;
@property(nonatomic , strong) UIView *myView;
@property(nonatomic , strong) UIImageView *myImageView;
@property(nonatomic , strong) UIImageView *myImageViewDown;
@property cv::Mat bitMat;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];
    
    self.myImageView = [[UIImageView alloc]init];
    self.myImageViewDown = [[UIImageView alloc]init];
    
    float height = mainScreenFrame.size.height;
    float width = mainScreenFrame.size.width;
    self.myImageView.frame = CGRectMake(mainScreenFrame.origin.x, mainScreenFrame.origin.y, mainScreenFrame.size.width, mainScreenFrame.size.height/2);
    self.myImageViewDown.frame = CGRectMake(mainScreenFrame.origin.x, mainScreenFrame.origin.y + (mainScreenFrame.size.height/2), mainScreenFrame.size.width, mainScreenFrame.size.height/2);
    
    self.myView = [[UIView alloc]init];
    self.myVideoSource = [[VideoSource alloc]init];
    
    self.myImageView.backgroundColor = [UIColor redColor];
    self.myImageViewDown.backgroundColor = [UIColor blueColor];
    
    self.myVideoSource.delegate = self;
    [self.myVideoSource startWithDevicePosition:AVCaptureDevicePositionBack];
    [self.view addSubview:self.myImageView];
    [self.view addSubview:self.myImageViewDown];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) frameReady:(UIImage *)frame
{
    //self.bitMat;
        cv::Mat img = [self CVMat:[frame imageRotatedByDegrees:90]];
        cv::Mat grayImg;
        cv::cvtColor(img, grayImg, CV_BGRA2GRAY);
        cv::Mat bit;
        cv::adaptiveThreshold(grayImg, bit, 255, CV_ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY, 25, 10);
    cv::Mat canny;
    cv::Canny(grayImg, canny, 100, 100);
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        //耗时处理
        dispatch_async( dispatch_get_main_queue(), ^{
        //同步显示
            self.myImageView.image = [frame imageRotatedByDegrees:90];
            self.myImageViewDown.image = [self UIImageFromCVMat:canny];
            
        });
    });
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
