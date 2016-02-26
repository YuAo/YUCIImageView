//
//  YUCIImageCoreGraphicRenderer.h
//  Pods
//
//  Created by YuAo on 2/26/16.
//
//

#import <Foundation/Foundation.h>

#import "YUCIImageRenderer.h"

#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
    #define YUCI_IMAGE_VIEW UIImageView
#else
    #import <AppKit/AppKit.h>
    #define YUCI_IMAGE_VIEW NSImageView
#endif

@interface YUCIImageCoreGraphicsRenderer : NSObject <YUCIImageRenderer>

@property (nonatomic,strong,readonly) YUCI_IMAGE_VIEW *view;

@end

#undef YUCI_IMAGE_VIEW
