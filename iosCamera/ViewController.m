//
//  ViewController.m
//  iosCamera
//
//  Created by vk on 15/8/17.
//  Copyright (c) 2015年 Clover. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+IF.h"
@interface ViewController ()
@property(nonatomic , strong) VideoSource *myVideoSource;
@property(nonatomic , strong) UIView *myView;
@property(nonatomic , strong) UIImageView *myImageView;
@property(nonatomic , strong) UIView *myImageViewDown;
@property(nonatomic , strong) UIImageView *bv;
@property(nonatomic , strong) UIImageView *fv;
@property(nonatomic , strong) ImageProcess *imageProcess;
//@property cv::Mat bitMat;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];
    
    self.myImageView = [[UIImageView alloc]init];
    self.myImageViewDown = [[UIView alloc]init];
    
    float height = mainScreenFrame.size.height;
    float width = mainScreenFrame.size.width;
    self.myImageView.frame = CGRectMake(mainScreenFrame.origin.x, mainScreenFrame.origin.y, mainScreenFrame.size.width, mainScreenFrame.size.height/2);
    self.myImageViewDown.frame = CGRectMake(mainScreenFrame.origin.x, mainScreenFrame.origin.y + (mainScreenFrame.size.height/2), mainScreenFrame.size.width, mainScreenFrame.size.height/2);
   
    self.bv = [[UIImageView alloc]init];
    self.fv = [[UIImageView alloc]init];
    self.bv.frame = self.myImageViewDown.bounds;
    self.fv.frame = self.myImageViewDown.bounds;
    [self.myImageViewDown addSubview:self.bv];
    [self.myImageViewDown addSubview:self.fv];
    
    
    self.myView = [[UIView alloc]init];
    self.myVideoSource = [[VideoSource alloc]init];
    
    self.myImageView.backgroundColor = [UIColor redColor];
    self.myImageViewDown.backgroundColor = [UIColor blueColor];
    
    self.myVideoSource.delegate = self;
    [self.myVideoSource startWithDevicePosition:AVCaptureDevicePositionBack];
    
    self.imageProcess = [[ImageProcess alloc]init];
   
    self.imageProcess.delegate = self;
    
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
    
    frame = [frame imageRotatedByDegrees:90];
    
    [self.imageProcess imageProcessWithImage:frame];

        //耗时处理
        dispatch_async( dispatch_get_main_queue(), ^{
        //同步显示
            self.myImageView.image = frame;//[frame imageRotatedByDegrees:90];
            self.bv.image = frame;

//            self.myImageViewDown.image = [self UIImageFromCVMat:canny];
            
        });
}

-(void)imageProcessResultReady:(UIImage *)resultImage
{
    //self.myImageViewDown.image = resultImage;
    self.fv.image = resultImage;
}



@end
