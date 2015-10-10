//
//  IFInkwellFilter.m
//  InstaFilters
//
//  Created by Di Wu on 2/28/12.
//  Copyright (c) 2012 twitter:@diwup. All rights reserved.
//

#import "CloverTFFilter.h"

NSString *const kCloverTFFilterShaderString = SHADER_STRING
(
 precision lowp float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 //uniform sampler2D inputImageTexture2;
 //uniform sampler2D inputImageTexture3;
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 outputColor;
     outputColor.r = textureColor.r/2.0;
     outputColor.g = textureColor.g/2.0;
     outputColor.b = textureColor.b/2.0;
     
     // outputColor.r = (textureColor.r * 0.393) + (textureColor.g * 0.769) + (textureColor.b * 0.189);
     // outputColor.g = (textureColor.r * 0.349) + (textureColor.g * 0.686) + (textureColor.b * 0.168);
     // outputColor.b = (textureColor.r * 0.272) + (textureColor.g * 0.534) + (textureColor.b * 0.131);
     outputColor.a = outputColor.r/20.0;
     gl_FragColor = outputColor;
 }
 );

@implementation CloverTFFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kCloverTFFilterShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
