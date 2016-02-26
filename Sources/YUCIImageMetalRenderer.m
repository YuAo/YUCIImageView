//
//  YUCIImageMetalRender.m
//  CoreImageView
//
//  Created by YuAo on 2/24/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

#import "YUCIImageMetalRenderer.h"

#if __has_include(<MetalKit/MetalKit.h>)

@import CoreImage;

@interface YUCIImageMetalRenderer () <MTKViewDelegate>

@property (nonatomic,strong) id<MTLDevice> device;

@property (nonatomic,strong) id<MTLCommandQueue> commandQueue;

@property (nonatomic,strong) MTKView *view;

@property (nonatomic,strong) CIImage *image;

@end

@implementation YUCIImageMetalRenderer

@synthesize context = _context;

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    if (self = [super init]) {
        if (!device) {
            device = MTLCreateSystemDefaultDevice();
        }
        self.device = device;
        self.view = [[MTKView alloc] initWithFrame:CGRectZero device:device];
        self.view.clearColor = MTLClearColorMake(0, 0, 0, 0);
#if TARGET_OS_IPHONE
        self.view.backgroundColor = [UIColor clearColor];
#endif
        self.view.delegate = self;
        self.view.framebufferOnly = NO;
        self.view.enableSetNeedsDisplay = YES;
        
        self.context = [CIContext contextWithMTLDevice:self.device
                                               options:@{kCIContextWorkingColorSpace: CFBridgingRelease(CGColorSpaceCreateWithName(kCGColorSpaceSRGB))}];
        self.commandQueue = [device newCommandQueue];
    }
    return self;
}

- (instancetype)init {
    return [self initWithDevice:nil];
}

- (void)drawInMTKView:(MTKView *)view {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    id<MTLTexture> outputTexture = self.view.currentDrawable.texture;
    CGColorSpaceRef colorspace = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
    [self.context render:self.image
            toMTLTexture:outputTexture
           commandBuffer:commandBuffer
                  bounds:self.image.extent
              colorSpace:colorspace];
    CGColorSpaceRelease(colorspace);
    [commandBuffer presentDrawable:self.view.currentDrawable];
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
#if TARGET_OS_IPHONE
    [view setNeedsDisplay];
#else 
    view.needsDisplay = YES;
#endif
}

- (void)renderImage:(CIImage *)image {
    self.image = image;
#if TARGET_OS_IPHONE
    [self.view setNeedsDisplay];
#else
    self.view.needsDisplay = YES;
#endif
}

@end

#endif