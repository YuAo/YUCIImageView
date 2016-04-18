//
//  YUCIImageOpenGLRenderer.m
//  Pods
//
//  Created by YuAo on 4/18/16.
//
//

#import "YUCIImageOpenGLRenderer.h"

#if __has_include(<AppKit/AppKit.h>)

#include <OpenGL/gl.h>

@import CoreImage;

@class YUCIImageOpenGLView;

@protocol YUCIImageOpenGLViewRenderDelegate <NSObject>

- (void)openGLView:(YUCIImageOpenGLView *)view drawRect:(CGRect)rect;

@end

@interface YUCIImageOpenGLView : NSOpenGLView

@property (nonatomic,weak) id<YUCIImageOpenGLViewRenderDelegate> renderDelegate;

@end

@implementation YUCIImageOpenGLView

- (void)drawRect:(NSRect)rect {
    [self.renderDelegate openGLView:self drawRect:rect];
}

@end

@interface YUCIImageOpenGLRenderer () <YUCIImageOpenGLViewRenderDelegate>

@property (nonatomic,strong) NSOpenGLView *view;

@property (nonatomic,strong) CIImage *image;

@end

@implementation YUCIImageOpenGLRenderer

@synthesize context = _context;

- (instancetype)initWithOpenGLContext:(NSOpenGLContext *)openGLContext {
    if (self = [super init]) {
        if (!openGLContext) {
            openGLContext = [[NSOpenGLContext alloc] initWithFormat:[NSOpenGLView defaultPixelFormat] shareContext:nil];
        }
        CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
        self.context = [CIContext contextWithCGLContext:openGLContext.CGLContextObj
                                            pixelFormat:nil
                                             colorSpace:colorSpace
                                                options:@{kCIContextWorkingColorSpace: (__bridge id)colorSpace}];
        CGColorSpaceRelease(colorSpace);
        YUCIImageOpenGLView *openGLView = [[YUCIImageOpenGLView alloc] initWithFrame:CGRectZero pixelFormat:[NSOpenGLView defaultPixelFormat]];
        openGLView.renderDelegate = self;
        self.view = openGLView;
        self.view.openGLContext = openGLContext;
    }
    return self;
}

- (void)openGLView:(YUCIImageOpenGLView *)view drawRect:(CGRect)rect {
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, view.bounds.size.width, view.bounds.size.height);
    [self.context drawImage:self.image inRect:CGRectMake(-1, -1, 2, 2) fromRect:self.image.extent];
    glFlush();
}

- (void)renderImage:(CIImage *)image {
    self.image = image;
    [self.view setNeedsDisplay:YES];
}

@end

#endif
