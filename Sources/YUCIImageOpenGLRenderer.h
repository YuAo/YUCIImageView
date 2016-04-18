//
//  YUCIImageOpenGLRenderer.h
//  Pods
//
//  Created by YuAo on 4/18/16.
//
//

#import <Foundation/Foundation.h>

#if __has_include(<AppKit/AppKit.h>)

#import <AppKit/AppKit.h>
#import "YUCIImageRenderer.h"

@interface YUCIImageOpenGLRenderer : NSObject <YUCIImageRenderer>

@property (nonatomic,strong,readonly) NSOpenGLView *view;

- (instancetype)initWithOpenGLContext:(NSOpenGLContext *)openGLContext NS_DESIGNATED_INITIALIZER;

@end

#endif
