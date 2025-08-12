//
//  GPUPixelFaceDetector.h
//  GPUPixel Objective-C Wrapper
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUPixelFramebuffer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Structure representing a detected face landmark point
 */
typedef struct {
    float x;  ///< X coordinate (normalized 0-1)
    float y;  ///< Y coordinate (normalized 0-1)
} GPUPixelLandmarkPoint;

/**
 * Structure representing face detection results
 */
typedef struct {
    float confidence;                      ///< Detection confidence (0-1)
    CGRect boundingBox;                   ///< Face bounding box (normalized coordinates)
    GPUPixelLandmarkPoint *landmarks;     ///< Array of landmark points
    NSUInteger landmarkCount;             ///< Number of landmark points
} GPUPixelFaceResult;

/**
 * GPUPixelFaceDetector - AI-powered face detection and landmark extraction
 * 
 * This class provides real-time face detection capabilities including:
 * - Face bounding box detection
 * - 68-point facial landmark detection
 * - Multiple face support
 * - Optimized for real-time processing
 */
@interface GPUPixelFaceDetector : NSObject

/**
 * Create a new face detector instance
 * @return A new face detector instance or nil if creation failed
 */
+ (nullable instancetype)faceDetector;

/**
 * Initialize the face detector
 * @return YES if initialization was successful
 */
- (BOOL)init;

/**
 * Detect faces in raw image data
 * @param data Raw image data buffer
 * @param width Image width in pixels
 * @param height Image height in pixels
 * @param stride Row stride in bytes
 * @param format Image format (video or picture)
 * @param frameType Frame type (RGBA or BGRA)
 * @return Array of detected faces with landmarks
 */
- (NSArray<NSValue *> *)detectFacesInData:(const uint8_t *)data
                                    width:(int)width
                                   height:(int)height
                                   stride:(int)stride
                                   format:(GPUPixelModeFormat)format
                                frameType:(GPUPixelFrameType)frameType;

/**
 * Detect faces in NSData
 * @param imageData Image data
 * @param width Image width in pixels
 * @param height Image height in pixels
 * @param format Image format (video or picture)
 * @param frameType Frame type (RGBA or BGRA)
 * @return Array of detected faces with landmarks
 */
- (NSArray<NSValue *> *)detectFacesInImageData:(NSData *)imageData
                                         width:(int)width
                                        height:(int)height
                                        format:(GPUPixelModeFormat)format
                                     frameType:(GPUPixelFrameType)frameType;

#if TARGET_OS_IPHONE
/**
 * Detect faces in UIImage (iOS only)
 * @param image UIImage to process
 * @return Array of detected faces with landmarks
 */
- (NSArray<NSValue *> *)detectFacesInUIImage:(UIImage *)image;
#else
/**
 * Detect faces in NSImage (macOS only)
 * @param image NSImage to process
 * @return Array of detected faces with landmarks
 */
- (NSArray<NSValue *> *)detectFacesInNSImage:(NSImage *)image;
#endif

/**
 * Extract landmark points from detection result
 * @param faceResult NSValue containing GPUPixelFaceResult
 * @return Array of NSValue objects containing CGPoint structures
 */
- (NSArray<NSValue *> *)landmarkPointsFromFaceResult:(NSValue *)faceResult;

/**
 * Get bounding box from detection result
 * @param faceResult NSValue containing GPUPixelFaceResult
 * @return CGRect representing the face bounding box
 */
- (CGRect)boundingBoxFromFaceResult:(NSValue *)faceResult;

/**
 * Get confidence score from detection result
 * @param faceResult NSValue containing GPUPixelFaceResult
 * @return Confidence score (0.0 to 1.0)
 */
- (float)confidenceFromFaceResult:(NSValue *)faceResult;

@end

/**
 * Category for NSValue to wrap GPUPixelFaceResult
 */
@interface NSValue (GPUPixelFaceResult)

/**
 * Create NSValue from GPUPixelFaceResult
 * @param faceResult The face result structure
 * @return NSValue containing the face result
 */
+ (NSValue *)valueWithGPUPixelFaceResult:(GPUPixelFaceResult)faceResult;

/**
 * Extract GPUPixelFaceResult from NSValue
 * @return The face result structure
 */
- (GPUPixelFaceResult)gpuPixelFaceResultValue;

@end

NS_ASSUME_NONNULL_END