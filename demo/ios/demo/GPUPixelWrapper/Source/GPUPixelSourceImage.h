//
//  GPUPixelSourceImage.h
//  GPUPixel Objective-C Wrapper
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUPixelSource.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
typedef UIImage PlatformImage;
#else
#import <AppKit/AppKit.h>
typedef NSImage PlatformImage;
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 * GPUPixelSourceImage - Image input source for the processing pipeline
 * 
 * This class handles loading images from various sources including:
 * - Image files (PNG, JPEG, etc.)
 * - UIImage/NSImage objects
 * - Raw pixel buffers
 */
@interface GPUPixelSourceImage : GPUPixelSource

/**
 * Create an image source from a file path
 * @param imagePath Path to the image file
 * @return A new image source instance or nil if loading failed
 */
+ (nullable instancetype)sourceImageWithPath:(NSString *)imagePath;

/**
 * Create an image source from a UIImage/NSImage
 * @param image The platform image object
 * @return A new image source instance or nil if loading failed
 */
+ (nullable instancetype)sourceImageWithImage:(PlatformImage *)image;

/**
 * Create an image source from raw pixel buffer
 * @param width Image width in pixels
 * @param height Image height in pixels
 * @param channelCount Number of channels (1=grayscale, 3=RGB, 4=RGBA)
 * @param pixels Raw pixel data buffer
 * @return A new image source instance or nil if creation failed
 */
+ (nullable instancetype)sourceImageWithWidth:(int)width
                                       height:(int)height
                                 channelCount:(int)channelCount
                                       pixels:(const unsigned char *)pixels;

/**
 * Initialize from a file path
 * @param imagePath Path to the image file
 * @return YES if initialization was successful
 */
- (BOOL)initWithPath:(NSString *)imagePath;

/**
 * Initialize from a UIImage/NSImage
 * @param image The platform image object
 * @return YES if initialization was successful
 */
- (BOOL)initWithImage:(PlatformImage *)image;

/**
 * Initialize from raw pixel buffer
 * @param width Image width in pixels
 * @param height Image height in pixels
 * @param channelCount Number of channels (1=grayscale, 3=RGB, 4=RGBA)
 * @param pixels Raw pixel data buffer
 * @return YES if initialization was successful
 */
- (BOOL)initWithWidth:(int)width
               height:(int)height
         channelCount:(int)channelCount
               pixels:(const unsigned char *)pixels;

/**
 * Update the image content from new pixel data
 * @param width Image width in pixels
 * @param height Image height in pixels
 * @param channelCount Number of channels
 * @param pixels Raw pixel data buffer
 */
- (void)updateImageWithWidth:(int)width
                      height:(int)height
                channelCount:(int)channelCount
                      pixels:(const unsigned char *)pixels;

/**
 * Get the RGBA image buffer
 * @return Pointer to RGBA pixel data or NULL if not available
 */
- (nullable const unsigned char *)rgbaImageBuffer;

/**
 * Image width in pixels
 */
@property (nonatomic, readonly) int width;

/**
 * Image height in pixels
 */
@property (nonatomic, readonly) int height;

@end

NS_ASSUME_NONNULL_END