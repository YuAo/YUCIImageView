//
//  YUCIImageMetalRender.h
//  CoreImageView
//
//  Created by YuAo on 2/24/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MetalKit/MetalKit.h>)

#import <MetalKit/MetalKit.h>
#import "YUCIImageRenderer.h"

@interface YUCIImageMetalRenderer : NSObject <YUCIImageRenderer>

@property (nonatomic,strong,readonly) MTKView *view;

- (instancetype)initWithDevice:(id<MTLDevice>)device NS_DESIGNATED_INITIALIZER;

@end

#endif