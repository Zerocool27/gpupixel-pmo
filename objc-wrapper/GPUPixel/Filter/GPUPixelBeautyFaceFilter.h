//
//  GPUPixelBeautyFaceFilter.h
//  GPUPixel Objective-C Wrapper
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUPixelFilterGroup.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * GPUPixelBeautyFaceFilter - AI-powered face beautification filter
 * 
 * This filter applies real-time face beautification effects including:
 * - Skin smoothing
 * - Skin whitening
 * - Sharpening
 * - High-pass filtering for detail enhancement
 */
@interface GPUPixelBeautyFaceFilter : GPUPixelFilterGroup

/**
 * Create a beauty face filter with default settings
 * @return A new beauty face filter instance
 */
+ (instancetype)beautyFaceFilter;

/**
 * Initialize the beauty face filter
 * @return YES if initialization was successful
 */
- (BOOL)init;

/**
 * High-pass filter delta value for detail enhancement
 * Higher values enhance more details
 * Range: typically 0.0 to 1.0
 */
@property (nonatomic, assign) float highPassDelta;

/**
 * Sharpening intensity
 * Higher values increase sharpening effect
 * Range: typically 0.0 to 1.0
 */
@property (nonatomic, assign) float sharpen;

/**
 * Blur alpha for skin smoothing
 * Higher values increase smoothing effect
 * Range: typically 0.0 to 1.0
 */
@property (nonatomic, assign) float blurAlpha;

/**
 * Skin whitening intensity
 * Higher values increase whitening effect
 * Range: typically 0.0 to 1.0
 */
@property (nonatomic, assign) float white;

/**
 * Blur radius for skin smoothing
 * Higher values create more smoothing
 * Range: typically 0.0 to 10.0
 */
@property (nonatomic, assign) float radius;

@end

NS_ASSUME_NONNULL_END