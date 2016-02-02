//
//  ImageProcess.h
//  iosCamera
//
//  Created by vk on 15/10/9.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImageProcessDelegate <NSObject>

-(void)imageProcessResultReady:(UIImage *) resultImage;

@end

@interface ImageProcess : NSObject

-(id)init;
-(void)imageProcessWithImage:(UIImage *)inputImage;
@property (nonatomic, weak) id<ImageProcessDelegate> delegate;

@end
