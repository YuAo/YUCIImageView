//
//  YUCIImageView.h
//  CoreImageView
//
//  Created by YuAo on 2/24/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

#import "YUCIImageRenderer.h"

#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
    #define YUCI_VIEW UIView
#else
    #import <AppKit/AppKit.h>
    #define YUCI_VIEW NSView
#endif

typedef NS_ENUM(NSUInteger, YUCIImageViewContentMode) {
    YUCIImageViewContentModeDefault,
    YUCIImageViewContentModeScaleAspectFit,
    YUCIImageViewContentModeScaleAspectFill,
    YUCIImageViewContentModeCenter
};

@interface YUCIImageView : YUCI_VIEW

@property (nonatomic,strong) id<YUCIImageRenderer> renderer;

@property (nonatomic,strong) CIImage *image;

@property (nonatomic) YUCIImageViewContentMode imageContentMode;

@end

#undef YUCI_VIEW

#if TARGET_OS_IPHONE

FOUNDATION_EXPORT CGAffineTransform YUCIImageRenderingPreferredCIImageTransformFromUIImage(UIImage *image);

#endif

FOUNDATION_EXPORT id<YUCIImageRenderer> YUCIImageRenderingSuggestedRenderer(void);