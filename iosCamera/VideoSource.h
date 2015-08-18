//
//  VideoSource.h
//  iosCamera
//
//  Created by vk on 15/8/17.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol VideoSourceDelegate<NSObject>
-(void)frameReady:(UIImage *) frame;
@end

@interface VideoSource : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>
{
}

@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, weak) id<VideoSourceDelegate> delegate;

- (bool) startWithDevicePosition:(AVCaptureDevicePosition)
devicePosition;
//- (CameraCalibration) getCalibration;
- (CGSize) getFrameSize;

@end
