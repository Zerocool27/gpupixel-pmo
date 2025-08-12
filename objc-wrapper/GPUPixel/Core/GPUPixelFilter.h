//
//  GPUPixelFilter.h
//  GPUPixel Objective-C Wrapper
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUPixelSource.h"
#import "GPUPixelSink.h"

NS_ASSUME_NONNULL_BEGIN

@class GPUPixelFramebuffer;

/**
 * GPUPixelFilter - Objective-C wrapper for the C++ Filter class
 * Base class for all GPU-based image processing filters
 */
@interface GPUPixelFilter : NSObject <GPUPixelSourceProtocol, GPUPixelSinkProtocol>

/**
 * Factory method to create a filter by class name
 * @param filterClassName The name of the filter class to create
 * @return A new filter instance or nil if creation failed
 */
+ (nullable instancetype)filterWithClassName:(NSString *)filterClassName;

/**
 * Factory method to create a filter with custom shaders
 * @param vertexShader The vertex shader source code
 * @param fragmentShader The fragment shader source code
 * @return A new filter instance or nil if creation failed
 */
+ (nullable instancetype)filterWithVertexShader:(NSString *)vertexShader
                                 fragmentShader:(NSString *)fragmentShader;

/**
 * Factory method to create a filter with custom fragment shader (uses default vertex shader)
 * @param fragmentShader The fragment shader source code
 * @return A new filter instance or nil if creation failed
 */
+ (nullable instancetype)filterWithFragmentShader:(NSString *)fragmentShader;

/**
 * Initialize with custom shaders
 * @param vertexShader The vertex shader source code
 * @param fragmentShader The fragment shader source code
 * @param inputNumber Number of inputs (default: 1)
 * @return YES if initialization was successful
 */
- (BOOL)initWithVertexShader:(NSString *)vertexShader
              fragmentShader:(NSString *)fragmentShader
                 inputNumber:(int)inputNumber;

/**
 * Initialize with custom fragment shader (uses default vertex shader)
 * @param fragmentShader The fragment shader source code
 * @param inputNumber Number of inputs (default: 1)
 * @return YES if initialization was successful
 */
- (BOOL)initWithFragmentShader:(NSString *)fragmentShader
                   inputNumber:(int)inputNumber;

/**
 * The class name of this filter
 */
@property (nonatomic, strong) NSString *filterClassName;

/**
 * Render the filter
 */
- (void)render;

/**
 * Perform rendering with option to update sinks
 * @param updateSinks Whether to update connected sinks
 * @return YES if rendering was successful
 */
- (BOOL)doRenderAndUpdateSinks:(BOOL)updateSinks;

#pragma mark - Property Management

/**
 * Register an integer property
 * @param name Property name
 * @param defaultValue Default value
 * @param comment Property description
 * @return YES if registration was successful
 */
- (BOOL)registerIntProperty:(NSString *)name
               defaultValue:(int)defaultValue
                    comment:(nullable NSString *)comment;

/**
 * Register a float property
 * @param name Property name
 * @param defaultValue Default value
 * @param comment Property description
 * @return YES if registration was successful
 */
- (BOOL)registerFloatProperty:(NSString *)name
                 defaultValue:(float)defaultValue
                      comment:(nullable NSString *)comment;

/**
 * Register a string property
 * @param name Property name
 * @param defaultValue Default value
 * @param comment Property description
 * @return YES if registration was successful
 */
- (BOOL)registerStringProperty:(NSString *)name
                  defaultValue:(NSString *)defaultValue
                       comment:(nullable NSString *)comment;

/**
 * Register a vector property
 * @param name Property name
 * @param defaultValue Array of float values
 * @param comment Property description
 * @return YES if registration was successful
 */
- (BOOL)registerVectorProperty:(NSString *)name
                  defaultValue:(NSArray<NSNumber *> *)defaultValue
                       comment:(nullable NSString *)comment;

/**
 * Set an integer property value
 * @param name Property name
 * @param value New value
 * @return YES if setting was successful
 */
- (BOOL)setIntProperty:(NSString *)name value:(int)value;

/**
 * Set a float property value
 * @param name Property name
 * @param value New value
 * @return YES if setting was successful
 */
- (BOOL)setFloatProperty:(NSString *)name value:(float)value;

/**
 * Set a string property value
 * @param name Property name
 * @param value New value
 * @return YES if setting was successful
 */
- (BOOL)setStringProperty:(NSString *)name value:(NSString *)value;

/**
 * Set a vector property value
 * @param name Property name
 * @param value Array of float values
 * @return YES if setting was successful
 */
- (BOOL)setVectorProperty:(NSString *)name value:(NSArray<NSNumber *> *)value;

/**
 * Get an integer property value
 * @param name Property name
 * @return Property value or 0 if not found
 */
- (int)getIntProperty:(NSString *)name;

/**
 * Get a float property value
 * @param name Property name
 * @return Property value or 0.0 if not found
 */
- (float)getFloatProperty:(NSString *)name;

/**
 * Get a string property value
 * @param name Property name
 * @return Property value or nil if not found
 */
- (nullable NSString *)getStringProperty:(NSString *)name;

/**
 * Get a vector property value
 * @param name Property name
 * @return Array of float values or nil if not found
 */
- (nullable NSArray<NSNumber *> *)getVectorProperty:(NSString *)name;

/**
 * Check if property exists
 * @param name Property name
 * @return YES if property exists
 */
- (BOOL)hasProperty:(NSString *)name;

/**
 * Get property comment/description
 * @param name Property name
 * @return Property comment or nil if not found
 */
- (nullable NSString *)getPropertyComment:(NSString *)name;

/**
 * Get property type
 * @param name Property name
 * @return Property type string or nil if not found
 */
- (nullable NSString *)getPropertyType:(NSString *)name;

@end

NS_ASSUME_NONNULL_END