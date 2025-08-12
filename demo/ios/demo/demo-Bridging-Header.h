//
//  demo-Bridging-Header.h
//  GPUPixel Demo Bridging Header
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#ifndef demo_Bridging_Header_h
#define demo_Bridging_Header_h

// Import Foundation and UIKit
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Import existing demo utilities
#import "ImageConverter.h"
#import "FilterToolbarView.h"

// Import GPUPixel Objective-C wrapper classes
#import "GPUPixelFramebuffer.h"
#import "GPUPixelSource.h"
#import "GPUPixelSink.h"
#import "GPUPixelFilter.h"
#import "GPUPixelFilterGroup.h"

// Import Source classes
#import "GPUPixelSourceImage.h"

// Import Sink classes
#import "GPUPixelSinkRawData.h"

// Import Filter classes
#import "GPUPixelBrightnessFilter.h"
#import "GPUPixelGaussianBlurFilter.h"
#import "GPUPixelBeautyFaceFilter.h"

// Import Face detection
#import "GPUPixelFaceDetector.h"

#endif /* demo_Bridging_Header_h */