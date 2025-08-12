//
//  BasicImageProcessing.m
//  GPUPixel Objective-C Examples
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUPixelSourceImage.h"
#import "GPUPixelBrightnessFilter.h"
#import "GPUPixelGaussianBlurFilter.h"
#import "GPUPixelSinkRawData.h"
#import "GPUPixelFilterGroup.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

@interface BasicImageProcessing : NSObject
@end

@implementation BasicImageProcessing

/**
 * Example 1: Basic brightness adjustment
 */
- (void)basicBrightnessExample {
    NSLog(@"=== Basic Brightness Example ===");
    
    // Create an image source
    GPUPixelSourceImage *imageSource = [GPUPixelSourceImage sourceImageWithPath:@"input.jpg"];
    if (!imageSource) {
        NSLog(@"Failed to load input image");
        return;
    }
    
    // Create a brightness filter
    GPUPixelBrightnessFilter *brightnessFilter = [GPUPixelBrightnessFilter brightnessFilter];
    brightnessFilter.brightness = 0.3f; // Increase brightness by 30%
    
    // Create a raw data sink to capture output
    GPUPixelSinkRawData *dataSink = [GPUPixelSinkRawData rawDataSink];
    
    // Set up the processing pipeline
    [imageSource addSink:brightnessFilter];
    [brightnessFilter addSink:dataSink];
    
    // Set up output handler
    [dataSink setRGBAOutputBlock:^(NSData *rgbaData, int width, int height) {
        if (rgbaData) {
            NSLog(@"Processed image: %dx%d, data size: %lu bytes", width, height, (unsigned long)rgbaData.length);
            // Here you could save the processed image or use it further
        }
    }];
    
    // Render the pipeline
    [imageSource render];
    
    NSLog(@"Brightness processing completed");
}

/**
 * Example 2: Filter chain with brightness and blur
 */
- (void)filterChainExample {
    NSLog(@"=== Filter Chain Example ===");
    
    // Create an image source
    GPUPixelSourceImage *imageSource = [GPUPixelSourceImage sourceImageWithPath:@"input.jpg"];
    if (!imageSource) {
        NSLog(@"Failed to load input image");
        return;
    }
    
    // Create filters
    GPUPixelBrightnessFilter *brightnessFilter = [GPUPixelBrightnessFilter brightnessFilterWithBrightness:0.2f];
    GPUPixelGaussianBlurFilter *blurFilter = [GPUPixelGaussianBlurFilter gaussianBlurFilterWithRadius:6 sigma:3.0f];
    
    // Create output sink
    GPUPixelSinkRawData *dataSink = [GPUPixelSinkRawData rawDataSink];
    
    // Chain filters together
    [imageSource addSink:brightnessFilter];
    [brightnessFilter addSink:blurFilter];
    [blurFilter addSink:dataSink];
    
    // Set up output handler
    [dataSink setRGBAOutputBlock:^(NSData *rgbaData, int width, int height) {
        if (rgbaData) {
            NSLog(@"Processed chain result: %dx%d, data size: %lu bytes", width, height, (unsigned long)rgbaData.length);
        }
    }];
    
    // Process the image
    [imageSource render];
    
    NSLog(@"Filter chain processing completed");
}

/**
 * Example 3: Using FilterGroup for complex processing
 */
- (void)filterGroupExample {
    NSLog(@"=== Filter Group Example ===");
    
    // Create an image source
    GPUPixelSourceImage *imageSource = [GPUPixelSourceImage sourceImageWithPath:@"input.jpg"];
    if (!imageSource) {
        NSLog(@"Failed to load input image");
        return;
    }
    
    // Create individual filters
    GPUPixelBrightnessFilter *brightnessFilter = [GPUPixelBrightnessFilter brightnessFilterWithBrightness:0.25f];
    GPUPixelGaussianBlurFilter *blurFilter = [GPUPixelGaussianBlurFilter gaussianBlurFilterWithRadius:4 sigma:2.5f];
    
    // Create a filter group and add filters
    GPUPixelFilterGroup *filterGroup = [GPUPixelFilterGroup filterGroup];
    [filterGroup addFilter:brightnessFilter];
    [filterGroup addFilter:blurFilter];
    
    // Create output sink
    GPUPixelSinkRawData *dataSink = [GPUPixelSinkRawData rawDataSink];
    
    // Connect source to filter group to sink
    [imageSource addSink:filterGroup];
    [filterGroup addSink:dataSink];
    
    // Set up output handler
    [dataSink setRGBAOutputBlock:^(NSData *rgbaData, int width, int height) {
        if (rgbaData) {
            NSLog(@"Filter group result: %dx%d, data size: %lu bytes", width, height, (unsigned long)rgbaData.length);
        }
    }];
    
    // Process the image
    [imageSource render];
    
    NSLog(@"Filter group processing completed");
}

/**
 * Example 4: Working with raw pixel data
 */
- (void)rawPixelDataExample {
    NSLog(@"=== Raw Pixel Data Example ===");
    
    // Create some sample RGBA data (100x100 red square)
    int width = 100;
    int height = 100;
    int channelCount = 4; // RGBA
    
    NSMutableData *pixelData = [NSMutableData dataWithLength:width * height * channelCount];
    unsigned char *pixels = (unsigned char *)pixelData.mutableBytes;
    
    // Fill with red color
    for (int i = 0; i < width * height; i++) {
        pixels[i * 4 + 0] = 255; // Red
        pixels[i * 4 + 1] = 0;   // Green
        pixels[i * 4 + 2] = 0;   // Blue
        pixels[i * 4 + 3] = 255; // Alpha
    }
    
    // Create image source from raw data
    GPUPixelSourceImage *imageSource = [GPUPixelSourceImage sourceImageWithWidth:width
                                                                           height:height
                                                                     channelCount:channelCount
                                                                           pixels:pixels];
    if (!imageSource) {
        NSLog(@"Failed to create image source from raw data");
        return;
    }
    
    // Apply brightness filter
    GPUPixelBrightnessFilter *brightnessFilter = [GPUPixelBrightnessFilter brightnessFilterWithBrightness:0.5f];
    
    // Create output sink
    GPUPixelSinkRawData *dataSink = [GPUPixelSinkRawData rawDataSink];
    
    // Connect pipeline
    [imageSource addSink:brightnessFilter];
    [brightnessFilter addSink:dataSink];
    
    // Set up output handler
    [dataSink setRGBAOutputBlock:^(NSData *rgbaData, int width, int height) {
        if (rgbaData) {
            NSLog(@"Raw data processing result: %dx%d, data size: %lu bytes", width, height, (unsigned long)rgbaData.length);
            
            // Verify the first pixel is now brighter red
            const unsigned char *outputPixels = (const unsigned char *)rgbaData.bytes;
            NSLog(@"First pixel RGBA: %d, %d, %d, %d", outputPixels[0], outputPixels[1], outputPixels[2], outputPixels[3]);
        }
    }];
    
    // Process the data
    [imageSource render];
    
    NSLog(@"Raw pixel data processing completed");
}

/**
 * Example 5: Property-based filter configuration
 */
- (void)propertyConfigurationExample {
    NSLog(@"=== Property Configuration Example ===");
    
    // Create a generic filter using property system
    GPUPixelFilter *customFilter = [GPUPixelFilter filterWithClassName:@"BrightnessFilter"];
    if (!customFilter) {
        NSLog(@"Failed to create custom filter");
        return;
    }
    
    // Configure using properties
    if (![customFilter setFloatProperty:@"brightness" value:0.4f]) {
        NSLog(@"Failed to set brightness property");
        return;
    }
    
    // Get property information
    if ([customFilter hasProperty:@"brightness"]) {
        float currentBrightness = [customFilter getFloatProperty:@"brightness"];
        NSString *comment = [customFilter getPropertyComment:@"brightness"];
        NSString *type = [customFilter getPropertyType:@"brightness"];
        
        NSLog(@"Brightness property - Value: %.2f, Comment: %@, Type: %@", 
              currentBrightness, comment ?: @"No comment", type ?: @"Unknown type");
    }
    
    NSLog(@"Property configuration completed");
}

@end

// Example usage function
void runObjectiveCExamples(void) {
    @autoreleasepool {
        NSLog(@"Starting GPUPixel Objective-C Examples");
        
        BasicImageProcessing *examples = [[BasicImageProcessing alloc] init];
        
        [examples basicBrightnessExample];
        [examples filterChainExample];
        [examples filterGroupExample];
        [examples rawPixelDataExample];
        [examples propertyConfigurationExample];
        
        NSLog(@"All Objective-C examples completed");
    }
}