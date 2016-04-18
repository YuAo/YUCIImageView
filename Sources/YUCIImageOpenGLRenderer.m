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

- (instancetype)initWithOpenGLContext:(NSOpenGLContext *)context {
    if (self = [super init]) {
        if (!context) {
            context = [[NSOpenGLContext alloc] initWithFormat:[NSOpenGLView defaultPixelFormat] shareContext:nil];
        }
        self.context = [CIContext contextWithCGLContext:context.CGLContextObj
                                            pixelFormat:nil
                                             colorSpace:nil
                                                options:@{kCIContextWorkingColorSpace: CFBridgingRelease(CGColorSpaceCreateWithName(kCGColorSpaceSRGB))}];
        YUCIImageOpenGLView *openGLView = [[YUCIImageOpenGLView alloc] initWithFrame:CGRectZero pixelFormat:[NSOpenGLView defaultPixelFormat]];
        openGLView.renderDelegate = self;
        self.view = openGLView;
        self.view.openGLContext = context;
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
