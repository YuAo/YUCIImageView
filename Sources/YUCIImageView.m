//
//  YUCIImageView.m
//  CoreImageView
//
//  Created by YuAo on 2/24/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

#import "YUCIImageView.h"
#import <AVFoundation/AVFoundation.h>

static CGRect YUCIMakeRectWithAspectRatioInsideRect(CGSize aspectRatio, CGRect boundingRect) {
    return AVMakeRectWithAspectRatioInsideRect(aspectRatio, boundingRect);
}

static CGRect YUCIMakeRectWithAspectRatioFillRect(CGSize aspectRatio, CGRect boundingRect) {
    CGFloat horizontalRatio = boundingRect.size.width / aspectRatio.width;
    CGFloat verticalRatio = boundingRect.size.height / aspectRatio.height;
    CGFloat ratio;
    
    ratio = MAX(horizontalRatio, verticalRatio);
    //ratio = MIN(horizontalRatio, verticalRatio);
    
    CGSize newSize = CGSizeMake(floor(aspectRatio.width * ratio), floor(aspectRatio.height * ratio));
    CGRect rect = CGRectMake(boundingRect.origin.x + (boundingRect.size.width - newSize.width)/2, boundingRect.origin.y + (boundingRect.size.height - newSize.height)/2, newSize.width, newSize.height);
    return rect;
}

@implementation YUCIImageView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.imageContentMode = YUCIImageViewContentModeScaleAspectFit;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageContentMode = YUCIImageViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)setRenderer:(id<YUCIImageRenderer>)renderer {
    [_renderer.view removeFromSuperview];
    _renderer = renderer;
    [self addSubview:_renderer.view];
    _renderer.view.frame = CGRectIntegral(self.bounds);
}

#if !TARGET_OS_IPHONE

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize {
    [self layoutSubviews];
}

#endif

- (void)layoutSubviews{
#if TARGET_OS_IPHONE
    [super layoutSubviews];
#endif
    CGSize imageSize = self.image.extent.size;
    if (CGSizeEqualToSize(imageSize, CGSizeZero) || CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        [self.renderer renderImage:nil];
        return;
    }
    
    switch (self.imageContentMode) {
        case YUCIImageViewContentModeScaleAspectFill: {
            self.renderer.view.frame = CGRectIntegral(YUCIMakeRectWithAspectRatioFillRect(imageSize, self.bounds));
        }
            break;
        case YUCIImageViewContentModeScaleAspectFit: {
            self.renderer.view.frame = CGRectIntegral(YUCIMakeRectWithAspectRatioInsideRect(imageSize, self.bounds));
        }
            break;
        case YUCIImageViewContentModeCenter: {
            CGSize viewSize = CGSizeMake(imageSize.width/self.screenScaleFactor, imageSize.height/self.screenScaleFactor);
            self.renderer.view.frame = CGRectIntegral(CGRectMake((CGRectGetWidth(self.bounds) - viewSize.width)/2, (CGRectGetHeight(self.bounds) - viewSize.height)/2, viewSize.width, viewSize.height));
        }
            break;
        default:
            self.renderer.view.frame = CGRectIntegral(self.bounds);
            break;
    }
    [self updateContent];
}

- (void)setImage:(CIImage *)image {
    if (_image == image) {
        return;
    }
    _image = image;
#if TARGET_OS_IPHONE
    [self setNeedsLayout];
#else
    self.needsLayout = YES;
#endif
}

- (void)setImageContentMode:(YUCIImageViewContentMode)imageContentMode {
    _imageContentMode = imageContentMode;
#if TARGET_OS_IPHONE
    [self setNeedsLayout];
#else
    self.needsLayout = YES;
#endif
}

- (void)updateContent {
    [self.renderer renderImage:[self scaledImageForDisplay:self.image]];
}

- (CGFloat)screenScaleFactor {
    CGFloat screenScaleFactor = 1.0;
#if TARGET_OS_IPHONE
    screenScaleFactor = UIScreen.mainScreen.nativeScale;
#else
    screenScaleFactor = NSScreen.mainScreen.backingScaleFactor;
#endif
    return screenScaleFactor;
}

- (CIImage *)scaledImageForDisplay:(CIImage *)image {
    if (!image) {
        return nil;
    }
    
    CGRect scaledBounds = CGRectApplyAffineTransform(self.bounds, CGAffineTransformMakeScale(self.screenScaleFactor, self.screenScaleFactor));
    CGSize imageSize = image.extent.size;
    
    switch (self.imageContentMode) {
        case YUCIImageViewContentModeScaleAspectFill: {
            CGRect targetRect = YUCIMakeRectWithAspectRatioFillRect(imageSize, scaledBounds);
            CGFloat horizontalScale = targetRect.size.width/imageSize.width;
            CGFloat verticalScale = targetRect.size.height/imageSize.height;
            return [image imageByApplyingTransform:CGAffineTransformMakeScale(horizontalScale, verticalScale)];
        }
        case YUCIImageViewContentModeScaleAspectFit: {
            CGRect targetRect = YUCIMakeRectWithAspectRatioInsideRect(imageSize, scaledBounds);
            CGFloat horizontalScale = targetRect.size.width/imageSize.width;
            CGFloat verticalScale = targetRect.size.height/imageSize.height;
            return [image imageByApplyingTransform:CGAffineTransformMakeScale(horizontalScale, verticalScale)];
        }
        default: {
            return image;
        }
    }
}

@end

#if TARGET_OS_IPHONE

CGAffineTransform YUCIImageRenderingPreferredCIImageTransformFromUIImage(UIImage *image) {
    if (image.imageOrientation == UIImageOrientationUp) {
        return CGAffineTransformIdentity;
    }
    
    CGSize imageSizeInPixels = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(image.scale, image.scale));
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imageSizeInPixels.width, imageSizeInPixels.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, imageSizeInPixels.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, imageSizeInPixels.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imageSizeInPixels.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, imageSizeInPixels.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    return transform;
}

#endif

#import "YUCIImageMetalRenderer.h"
#import "YUCIImageGLKRenderer.h"
#import "YUCIImageOpenGLRenderer.h"
#import "YUCIImageCoreGraphicsRenderer.h"

id<YUCIImageRenderer> YUCIImageRenderingSuggestedRenderer(void) {
#if __has_include(<MetalKit/MetalKit.h>)
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    if (device) {
        return [[YUCIImageMetalRenderer alloc] initWithDevice:device];
    }
#endif
    
#if __has_include(<AppKit/AppKit.h>)
    return [[YUCIImageOpenGLRenderer alloc] initWithOpenGLContext:nil];
#endif
    
#if __has_include(<GLKit/GLKView.h>)
    return [[YUCIImageGLKRenderer alloc] initWithEAGLContext:nil];
#endif
    
    return [[YUCIImageCoreGraphicsRenderer alloc] init];
}
