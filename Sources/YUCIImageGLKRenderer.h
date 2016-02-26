//
//  YUCIImageGLKRender.h
//  CoreImageView
//
//  Created by YuAo on 2/24/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<GLKit/GLKView.h>)

#import <GLKit/GLKit.h>
#import "YUCIImageRenderer.h"

@interface YUCIImageGLKRenderer : NSObject <YUCIImageRenderer>

@property (nonatomic,strong,readonly) GLKView *view;

- (instancetype)initWithEAGLContext:(EAGLContext *)GLContext NS_DESIGNATED_INITIALIZER;

@end

#endif
