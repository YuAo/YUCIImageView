//
//  YUCIImageRenderer.h
//  CoreImageView
//
//  Created by YuAo on 2/24/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
    #define YUCI_VIEW UIView
#else
    #import <AppKit/AppKit.h>
    #define YUCI_VIEW NSView
#endif

@protocol YUCIImageRenderer <NSObject>

@property (nonatomic,strong,readonly) YUCI_VIEW *view;

@property (nonatomic,strong) CIContext *context;

- (void)renderImage:(CIImage *)image;

@end

#undef YUCI_VIEW
