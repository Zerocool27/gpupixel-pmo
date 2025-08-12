//
//  GPUPixelFilterGroup.h
//  GPUPixel Objective-C Wrapper
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUPixelFilter.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * GPUPixelFilterGroup - Objective-C wrapper for the C++ FilterGroup class
 * Allows grouping and chaining multiple filters together
 */
@interface GPUPixelFilterGroup : GPUPixelFilter

/**
 * Create a new empty filter group
 * @return A new filter group instance
 */
+ (instancetype)filterGroup;

/**
 * Create a filter group with an array of filters
 * @param filters Array of filters to include in the group
 * @return A new filter group instance
 */
+ (instancetype)filterGroupWithFilters:(NSArray<GPUPixelFilter *> *)filters;

/**
 * Initialize an empty filter group
 * @return YES if initialization was successful
 */
- (BOOL)init;

/**
 * Initialize with an array of filters
 * @param filters Array of filters to include in the group
 * @return YES if initialization was successful
 */
- (BOOL)initWithFilters:(NSArray<GPUPixelFilter *> *)filters;

/**
 * Check if the group contains a specific filter
 * @param filter The filter to check for
 * @return YES if the filter is in the group
 */
- (BOOL)hasFilter:(GPUPixelFilter *)filter;

/**
 * Add a filter to the group
 * @param filter The filter to add
 */
- (void)addFilter:(GPUPixelFilter *)filter;

/**
 * Remove a filter from the group
 * @param filter The filter to remove
 */
- (void)removeFilter:(GPUPixelFilter *)filter;

/**
 * Remove all filters from the group
 */
- (void)removeAllFilters;

/**
 * Manually specify the terminal filter (final output filter)
 * Usually not necessary as it's determined automatically
 * @param filter The filter to use as terminal
 */
- (void)setTerminalFilter:(GPUPixelFilter *)filter;

/**
 * Get the terminal filter
 * @return The terminal filter or nil if not set
 */
- (nullable GPUPixelFilter *)terminalFilter;

/**
 * Get all filters in the group
 * @return Array of filters in the group
 */
- (NSArray<GPUPixelFilter *> *)filters;

/**
 * Number of filters in the group
 */
@property (nonatomic, readonly) NSUInteger filterCount;

@end

NS_ASSUME_NONNULL_END