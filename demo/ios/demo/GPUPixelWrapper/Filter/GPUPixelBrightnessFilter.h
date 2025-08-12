//
//  GPUPixelBrightnessFilter.h
//  GPUPixel Objective-C Wrapper
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUPixelFilter.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * GPUPixelBrightnessFilter - Adjusts the brightness of an image
 * 
 * The brightness ranges from -1.0 to 1.0:
 * - Negative values darken the image
 * - Positive values brighten the image 
 * - 0.0 leaves the image unchanged
 */
@interface GPUPixelBrightnessFilter : GPUPixelFilter

/**
 * Create a brightness filter with default brightness (0.0)
 * @return A new brightness filter instance
 */
+ (instancetype)brightnessFilter;

/**
 * Create a brightness filter with specified brightness
 * @param brightness The brightness adjustment (-1.0 to 1.0)
 * @return A new brightness filter instance
 */
+ (instancetype)brightnessFilterWithBrightness:(float)brightness;

/**
 * Initialize with specified brightness
 * @param brightness The brightness adjustment (-1.0 to 1.0)
 * @return YES if initialization was successful
 */
- (BOOL)initWithBrightness:(float)brightness;

/**
 * The brightness adjustment value (-1.0 to 1.0)
 * Default: 0.0 (no change)
 */
@property (nonatomic, assign) float brightness;

@end

NS_ASSUME_NONNULL_END