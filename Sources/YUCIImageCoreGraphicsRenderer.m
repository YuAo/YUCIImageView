//
//  YUCIImageCoreGraphicRenderer.m
//  Pods
//
//  Created by YuAo on 2/26/16.
//
//

#import "YUCIImageCoreGraphicsRenderer.h"

#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
    #define YUCI_IMAGE_VIEW UIImageView
#else
    #import <AppKit/AppKit.h>
    #define YUCI_IMAGE_VIEW NSImageView
#endif

@import CoreImage;

@interface YUCIImageCoreGraphicsRenderer ()

@property (nonatomic,strong) YUCI_IMAGE_VIEW *view;

@end

@implementation YUCIImageCoreGraphicsRenderer

@synthesize context = _context;

- (instancetype)init {
    if (self = [super init]) {
        self.view = [[YUCI_IMAGE_VIEW alloc] initWithFrame:CGRectZero];
#if TARGET_OS_IPHONE
        
#else
        [self.view setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationVertical];
        [self.view setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
        [self.view setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationVertical];
        [self.view setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
#endif
        self.context = [CIContext contextWithOptions:@{kCIContextWorkingColorSpace: CFBridgingRelease(CGColorSpaceCreateDeviceRGB())}];
    }
    return self;
}

- (void)renderImage:(CIImage *)image {
    CGImageRef outputImage = [self.context createCGImage:image fromRect:image.extent];
#if TARGET_OS_IPHONE
    UIImage *outputUIImage = [UIImage imageWithCGImage:outputImage];
    self.view.image = outputUIImage;
#else
    NSImage *outputUIImage = [[NSImage alloc] initWithCGImage:outputImage size:image.extent.size];
    self.view.image = outputUIImage;
#endif
    CGImageRelease(outputImage);
}

@end

#undef YUCI_IMAGE_VIEW