//
//  GPUPixelSinkRawData.h
//  GPUPixel Objective-C Wrapper
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUPixelSink.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Completion block for raw data output
 * @param rgbaData RGBA pixel data (32-bit per pixel)
 * @param width Image width in pixels
 * @param height Image height in pixels
 */
typedef void (^GPUPixelRawDataOutputBlock)(NSData * _Nullable rgbaData, int width, int height);

/**
 * YUV data completion block for raw data output
 * @param i420Data I420 (YUV) pixel data
 * @param width Image width in pixels
 * @param height Image height in pixels
 */
typedef void (^GPUPixelYUVDataOutputBlock)(NSData * _Nullable i420Data, int width, int height);

/**
 * GPUPixelSinkRawData - Raw pixel data output sink
 * 
 * This sink captures processed images as raw pixel data in various formats:
 * - RGBA format (32-bit per pixel)
 * - I420/YUV format for video encoding
 */
@interface GPUPixelSinkRawData : GPUPixelSink

/**
 * Create a raw data sink
 * @return A new raw data sink instance
 */
+ (instancetype)rawDataSink;

/**
 * Initialize the raw data sink
 * @return YES if initialization was successful
 */
- (BOOL)init;

/**
 * Get the current RGBA buffer
 * @return NSData containing RGBA pixel data or nil if not available
 */
- (nullable NSData *)rgbaBuffer;

/**
 * Get the current I420 (YUV) buffer
 * @return NSData containing I420 pixel data or nil if not available
 */
- (nullable NSData *)i420Buffer;

/**
 * Set completion block for RGBA data output
 * @param outputBlock Block to call when new RGBA data is available
 */
- (void)setRGBAOutputBlock:(nullable GPUPixelRawDataOutputBlock)outputBlock;

/**
 * Set completion block for YUV data output
 * @param outputBlock Block to call when new YUV data is available
 */
- (void)setYUVOutputBlock:(nullable GPUPixelYUVDataOutputBlock)outputBlock;

/**
 * Current image width in pixels
 */
@property (nonatomic, readonly) int width;

/**
 * Current image height in pixels
 */
@property (nonatomic, readonly) int height;

/**
 * RGBA data output completion block
 */
@property (nonatomic, copy, nullable) GPUPixelRawDataOutputBlock rgbaOutputBlock;

/**
 * YUV data output completion block
 */
@property (nonatomic, copy, nullable) GPUPixelYUVDataOutputBlock yuvOutputBlock;

@end

NS_ASSUME_NONNULL_END