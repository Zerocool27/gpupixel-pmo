//
//  GPUPixelSource.h
//  GPUPixel Objective-C Wrapper
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GPUPixelFramebuffer;
@protocol GPUPixelSinkProtocol;

/**
 * Rotation modes for image processing
 */
typedef NS_ENUM(NSInteger, GPUPixelRotationMode) {
    GPUPixelRotationModeNone = 0,
    GPUPixelRotationModeLeft,
    GPUPixelRotationModeRight,
    GPUPixelRotationModeFlipVertical,
    GPUPixelRotationModeFlipHorizontal,
    GPUPixelRotationModeRightFlipVertical,
    GPUPixelRotationModeRightFlipHorizontal,
    GPUPixelRotationModeRotate180
};

/**
 * Protocol for objects that can act as sources in the processing pipeline
 */
@protocol GPUPixelSourceProtocol <NSObject>

/**
 * Add a sink to receive output from this source
 * @param sink The sink to add
 * @return self for method chaining
 */
- (id<GPUPixelSourceProtocol>)addSink:(id<GPUPixelSinkProtocol>)sink;

/**
 * Add a sink with specific texture index
 * @param sink The sink to add
 * @param textureIndex The texture input index for the sink
 * @return self for method chaining
 */
- (id<GPUPixelSourceProtocol>)addSink:(id<GPUPixelSinkProtocol>)sink
                         textureIndex:(int)textureIndex;

/**
 * Remove a sink from this source
 * @param sink The sink to remove
 */
- (void)removeSink:(id<GPUPixelSinkProtocol>)sink;

/**
 * Remove all sinks from this source
 */
- (void)removeAllSinks;

/**
 * Check if a sink is connected to this source
 * @param sink The sink to check
 * @return YES if the sink is connected
 */
- (BOOL)hasSink:(id<GPUPixelSinkProtocol>)sink;

/**
 * Set the framebuffer for this source
 * @param framebuffer The framebuffer to set
 * @param rotation The output rotation mode
 */
- (void)setFramebuffer:(GPUPixelFramebuffer *)framebuffer
              rotation:(GPUPixelRotationMode)rotation;

/**
 * Get the current framebuffer
 * @return The current framebuffer or nil
 */
- (nullable GPUPixelFramebuffer *)framebuffer;

/**
 * Release the current framebuffer
 * @param returnToCache Whether to return the framebuffer to the cache
 */
- (void)releaseFramebuffer:(BOOL)returnToCache;

/**
 * Set the framebuffer scale factor
 * @param scale The scale factor (1.0 = original size)
 */
- (void)setFramebufferScale:(float)scale;

/**
 * Get the rotated framebuffer width
 * @return Width in pixels
 */
- (int)rotatedFramebufferWidth;

/**
 * Get the rotated framebuffer height
 * @return Height in pixels
 */
- (int)rotatedFramebufferHeight;

/**
 * Perform rendering and optionally update sinks
 * @param updateSinks Whether to update connected sinks
 * @return YES if rendering was successful
 */
- (BOOL)doRenderAndUpdateSinks:(BOOL)updateSinks;

/**
 * Update all connected sinks
 */
- (void)updateSinks;

@end

/**
 * GPUPixelSource - Objective-C wrapper for the C++ Source class
 */
@interface GPUPixelSource : NSObject <GPUPixelSourceProtocol>

/**
 * Initialize a new source
 * @return Initialized source instance
 */
- (instancetype)init;

@end

NS_ASSUME_NONNULL_END