//
//  BrightnessFilter.swift
//  GPUPixelSwift
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

import Foundation

/// Swift wrapper for brightness adjustment filter
public class BrightnessFilter: Filter {
    
    // MARK: - Properties
    
    private let objcBrightnessFilter: GPUPixelBrightnessFilter
    
    /// The brightness adjustment value (-1.0 to 1.0)
    /// - Negative values darken the image
    /// - Positive values brighten the image
    /// - 0.0 leaves the image unchanged
    public var brightness: Float {
        get { return objcBrightnessFilter.brightness }
        set { objcBrightnessFilter.brightness = newValue }
    }
    
    // MARK: - Initialization
    
    /// Create a brightness filter with default brightness (0.0)
    /// - Throws: FilterError if creation fails
    public override init() throws {
        guard let filter = GPUPixelBrightnessFilter.brightnessFilter() else {
            throw FilterError.creationFailed("Failed to create brightness filter")
        }
        self.objcBrightnessFilter = filter
        super.init(objcFilter: filter)
    }
    
    /// Create a brightness filter with specified brightness
    /// - Parameter brightness: The brightness adjustment (-1.0 to 1.0)
    /// - Throws: FilterError if creation fails
    public init(brightness: Float) throws {
        guard let filter = GPUPixelBrightnessFilter.brightnessFilter(withBrightness: brightness) else {
            throw FilterError.creationFailed("Failed to create brightness filter with brightness: \(brightness)")
        }
        self.objcBrightnessFilter = filter
        super.init(objcFilter: filter)
    }
}

// MARK: - Convenience Methods

extension BrightnessFilter {
    
    /// Set brightness using a more descriptive method
    /// - Parameter value: Brightness value (-1.0 to 1.0)
    /// - Returns: Self for method chaining
    @discardableResult
    public func setBrightness(_ value: Float) -> Self {
        self.brightness = value
        return self
    }
    
    /// Increase brightness by the specified amount
    /// - Parameter amount: Amount to increase brightness
    /// - Returns: Self for method chaining
    @discardableResult
    public func increaseBrightness(by amount: Float) -> Self {
        self.brightness = min(1.0, self.brightness + amount)
        return self
    }
    
    /// Decrease brightness by the specified amount
    /// - Parameter amount: Amount to decrease brightness
    /// - Returns: Self for method chaining
    @discardableResult
    public func decreaseBrightness(by amount: Float) -> Self {
        self.brightness = max(-1.0, self.brightness - amount)
        return self
    }
    
    /// Reset brightness to default (0.0)
    /// - Returns: Self for method chaining
    @discardableResult
    public func resetBrightness() -> Self {
        self.brightness = 0.0
        return self
    }
}