//
//  GPUPixel-Bridging-Header.h
//  GPUPixel Objective-C to Swift Bridging Header
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#ifndef GPUPixel_Bridging_Header_h
#define GPUPixel_Bridging_Header_h

// Import the main Objective-C wrapper headers for Swift usage

// Core classes
#import "GPUPixelFramebuffer.h"
#import "GPUPixelSource.h"
#import "GPUPixelSink.h" 
#import "GPUPixelFilter.h"
#import "GPUPixelFilterGroup.h"

// Source classes
#import "GPUPixelSourceImage.h"

// Sink classes
#import "GPUPixelSinkRawData.h"

// Filter classes
#import "GPUPixelBrightnessFilter.h"
#import "GPUPixelGaussianBlurFilter.h"
#import "GPUPixelBeautyFaceFilter.h"

// Face detection
#import "GPUPixelFaceDetector.h"

#endif /* GPUPixel_Bridging_Header_h */