//
//  GPUPixelFramebuffer.h
//  GPUPixel Objective-C Wrapper
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Frame types supported by GPUPixel
 */
typedef NS_ENUM(NSInteger, GPUPixelFrameType) {
    GPUPixelFrameTypeRGBA,
    GPUPixelFrameTypeBGRA
};

/**
 * Processing mode formats
 */
typedef NS_ENUM(NSInteger, GPUPixelModeFormat) {
    GPUPixelModeFormatVideo,
    GPUPixelModeFormatPicture
};

/**
 * GPUPixelFramebuffer - Objective-C wrapper for framebuffer management
 * Represents a GPU framebuffer for image processing operations
 */
@interface GPUPixelFramebuffer : NSObject

/**
 * Width of the framebuffer in pixels
 */
@property (nonatomic, readonly) int width;

/**
 * Height of the framebuffer in pixels
 */
@property (nonatomic, readonly) int height;

/**
 * Texture ID for OpenGL operations
 */
@property (nonatomic, readonly) unsigned int textureId;

/**
 * Whether this framebuffer has a depth attachment
 */
@property (nonatomic, readonly) BOOL hasDepthAttachment;

/**
 * Whether this framebuffer has a stencil attachment
 */
@property (nonatomic, readonly) BOOL hasStencilAttachment;

/**
 * Create a framebuffer with specified dimensions
 * @param width Width in pixels
 * @param height Height in pixels
 * @return New framebuffer instance or nil if creation failed
 */
+ (nullable instancetype)framebufferWithWidth:(int)width height:(int)height;

/**
 * Create a framebuffer with depth attachment
 * @param width Width in pixels
 * @param height Height in pixels
 * @param withDepth Whether to include depth attachment
 * @return New framebuffer instance or nil if creation failed
 */
+ (nullable instancetype)framebufferWithWidth:(int)width 
                                       height:(int)height 
                                    withDepth:(BOOL)withDepth;

/**
 * Initialize framebuffer with dimensions
 * @param width Width in pixels
 * @param height Height in pixels
 * @return YES if initialization was successful
 */
- (BOOL)initWithWidth:(int)width height:(int)height;

/**
 * Initialize framebuffer with depth attachment option
 * @param width Width in pixels
 * @param height Height in pixels
 * @param withDepth Whether to include depth attachment
 * @return YES if initialization was successful
 */
- (BOOL)initWithWidth:(int)width height:(int)height withDepth:(BOOL)withDepth;

/**
 * Bind the framebuffer for rendering
 */
- (void)bind;

/**
 * Unbind the framebuffer
 */
- (void)unbind;

/**
 * Clear the framebuffer with specified color
 * @param red Red component (0.0-1.0)
 * @param green Green component (0.0-1.0)
 * @param blue Blue component (0.0-1.0)
 * @param alpha Alpha component (0.0-1.0)
 */
- (void)clearWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;

/**
 * Read pixels from the framebuffer
 * @param x X coordinate to start reading from
 * @param y Y coordinate to start reading from
 * @param width Width of the region to read
 * @param height Height of the region to read
 * @return NSData containing the pixel data or nil if reading failed
 */
- (nullable NSData *)readPixelsAtX:(int)x y:(int)y width:(int)width height:(int)height;

@end

NS_ASSUME_NONNULL_END