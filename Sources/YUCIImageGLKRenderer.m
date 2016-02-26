//
//  YUCIImageGLKRender.m
//  CoreImageView
//
//  Created by YuAo on 2/24/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

#import "YUCIImageGLKRenderer.h"

#if __has_include(<GLKit/GLKView.h>)

@interface YUCIImageGLKRenderer () <GLKViewDelegate>

@property (nonatomic,strong) EAGLContext *GLContext;

@property (nonatomic,strong) GLKView *view;

@property (nonatomic,strong) CIImage *image;

@end

@implementation YUCIImageGLKRenderer

@synthesize context = _context;

- (instancetype)initWithEAGLContext:(EAGLContext *)GLContext {
    if (self = [super init]) {
        if (!GLContext) {
            GLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        }
        self.context = [CIContext contextWithEAGLContext:GLContext
                                                 options:@{kCIContextWorkingColorSpace: CFBridgingRelease(CGColorSpaceCreateWithName(kCGColorSpaceSRGB))}];
        self.view = [[GLKView alloc] initWithFrame:CGRectZero context:GLContext];
        self.view.delegate = self;
        self.view.contentScaleFactor = UIScreen.mainScreen.scale;
    }
    return self;
}

- (instancetype)init {
    return [self initWithEAGLContext:nil];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    [self.context drawImage:self.image inRect:self.image.extent fromRect:self.image.extent];
}

- (void)renderImage:(CIImage *)image {
    self.image = image;
    [self.view setNeedsDisplay];
}

@end

#endif
