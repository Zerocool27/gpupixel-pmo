//
//  GPUPixelGaussianBlurFilter.h
//  GPUPixel Objective-C Wrapper
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUPixelFilterGroup.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * GPUPixelGaussianBlurFilter - Applies Gaussian blur to an image
 * 
 * This filter uses a two-pass algorithm (horizontal and vertical) for efficient blurring.
 * The blur effect is controlled by radius and sigma parameters.
 */
@interface GPUPixelGaussianBlurFilter : GPUPixelFilterGroup

/**
 * Create a Gaussian blur filter with default parameters (radius: 4, sigma: 2.0)
 * @return A new Gaussian blur filter instance
 */
+ (instancetype)gaussianBlurFilter;

/**
 * Create a Gaussian blur filter with specified parameters
 * @param radius The blur radius (higher values = more blur)
 * @param sigma The Gaussian sigma value (controls blur falloff)
 * @return A new Gaussian blur filter instance
 */
+ (instancetype)gaussianBlurFilterWithRadius:(int)radius sigma:(float)sigma;

/**
 * Initialize with specified parameters
 * @param radius The blur radius (higher values = more blur)
 * @param sigma The Gaussian sigma value (controls blur falloff)
 * @return YES if initialization was successful
 */
- (BOOL)initWithRadius:(int)radius sigma:(float)sigma;

/**
 * The blur radius (higher values = more blur)
 * Default: 4
 */
@property (nonatomic, assign) int radius;

/**
 * The Gaussian sigma value (controls blur falloff)
 * Default: 2.0
 */
@property (nonatomic, assign) float sigma;

@end

NS_ASSUME_NONNULL_END