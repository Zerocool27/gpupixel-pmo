//
//  GPUPixelSink.h
//  GPUPixel Objective-C Wrapper
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUPixelSource.h"

NS_ASSUME_NONNULL_BEGIN

@class GPUPixelFramebuffer;

/**
 * Protocol for objects that can act as sinks in the processing pipeline
 */
@protocol GPUPixelSinkProtocol <NSObject>

/**
 * Set the input framebuffer for this sink
 * @param framebuffer The input framebuffer
 * @param rotation The rotation mode to apply
 * @param textureIndex The texture index (for multi-input sinks)
 */
- (void)setInputFramebuffer:(GPUPixelFramebuffer *)framebuffer
                   rotation:(GPUPixelRotationMode)rotation
               textureIndex:(int)textureIndex;

/**
 * Check if the sink is ready for processing
 * @return YES if ready, NO otherwise
 */
- (BOOL)isReady;

/**
 * Reset and clean up the sink
 */
- (void)resetAndClean;

/**
 * Render the sink (subclasses should override)
 */
- (void)render;

/**
 * Get the next available texture index for multi-input sinks
 * @return The next available texture index
 */
- (int)nextAvailableTextureIndex;

@end

/**
 * GPUPixelSink - Objective-C wrapper for the C++ Sink class
 */
@interface GPUPixelSink : NSObject <GPUPixelSinkProtocol>

/**
 * Initialize a new sink
 * @param inputNumber Number of inputs this sink accepts (default: 1)
 * @return Initialized sink instance
 */
- (instancetype)initWithInputNumber:(int)inputNumber;

/**
 * Convenience initializer with single input
 * @return Initialized sink instance with single input
 */
- (instancetype)init;

/**
 * Number of inputs this sink accepts
 */
@property (nonatomic, readonly) int inputCount;

@end

NS_ASSUME_NONNULL_END