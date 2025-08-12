//
//  Filter.swift
//  GPUPixelSwift
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#else
import AppKit
#endif

/// Swift wrapper for GPUPixel Filter functionality with modern Swift APIs
public class Filter {
    
    // MARK: - Properties
    
    /// The underlying Objective-C filter object
    internal let objcFilter: GPUPixelFilter
    
    /// The class name of this filter
    public var className: String {
        get { return objcFilter.filterClassName }
        set { objcFilter.filterClassName = newValue }
    }
    
    // MARK: - Initialization
    
    /// Create a filter with the specified class name
    /// - Parameter className: The filter class name
    /// - Throws: FilterError if creation fails
    public init(className: String) throws {
        guard let filter = GPUPixelFilter.filterWithClassName(className) else {
            throw FilterError.creationFailed("Failed to create filter with class name: \(className)")
        }
        self.objcFilter = filter
    }
    
    /// Create a filter with custom shaders
    /// - Parameters:
    ///   - vertexShader: Vertex shader source code
    ///   - fragmentShader: Fragment shader source code
    /// - Throws: FilterError if creation fails
    public init(vertexShader: String, fragmentShader: String) throws {
        guard let filter = GPUPixelFilter.filterWithVertexShader(vertexShader, fragmentShader: fragmentShader) else {
            throw FilterError.creationFailed("Failed to create filter with custom shaders")
        }
        self.objcFilter = filter
    }
    
    /// Create a filter with custom fragment shader (uses default vertex shader)
    /// - Parameter fragmentShader: Fragment shader source code
    /// - Throws: FilterError if creation fails
    public init(fragmentShader: String) throws {
        guard let filter = GPUPixelFilter.filterWithFragmentShader(fragmentShader) else {
            throw FilterError.creationFailed("Failed to create filter with fragment shader")
        }
        self.objcFilter = filter
    }
    
    /// Internal initializer with existing Objective-C filter
    internal init(objcFilter: GPUPixelFilter) {
        self.objcFilter = objcFilter
    }
    
    // MARK: - Rendering
    
    /// Render the filter
    public func render() {
        objcFilter.render()
    }
    
    /// Perform rendering with option to update sinks
    /// - Parameter updateSinks: Whether to update connected sinks
    /// - Returns: true if rendering was successful
    @discardableResult
    public func render(updateSinks: Bool) -> Bool {
        return objcFilter.doRenderAndUpdateSinks(updateSinks)
    }
    
    // MARK: - Property Management
    
    /// Set an integer property
    /// - Parameters:
    ///   - name: Property name
    ///   - value: Property value
    /// - Throws: FilterError if setting fails
    public func setProperty(name: String, value: Int) throws {
        guard objcFilter.setIntProperty(name, value: Int32(value)) else {
            throw FilterError.propertyError("Failed to set int property '\(name)'")
        }
    }
    
    /// Set a float property
    /// - Parameters:
    ///   - name: Property name
    ///   - value: Property value
    /// - Throws: FilterError if setting fails
    public func setProperty(name: String, value: Float) throws {
        guard objcFilter.setFloatProperty(name, value: value) else {
            throw FilterError.propertyError("Failed to set float property '\(name)'")
        }
    }
    
    /// Set a string property
    /// - Parameters:
    ///   - name: Property name
    ///   - value: Property value
    /// - Throws: FilterError if setting fails
    public func setProperty(name: String, value: String) throws {
        guard objcFilter.setStringProperty(name, value: value) else {
            throw FilterError.propertyError("Failed to set string property '\(name)'")
        }
    }
    
    /// Set a vector property
    /// - Parameters:
    ///   - name: Property name
    ///   - value: Array of float values
    /// - Throws: FilterError if setting fails
    public func setProperty(name: String, value: [Float]) throws {
        let nsNumbers = value.map { NSNumber(value: $0) }
        guard objcFilter.setVectorProperty(name, value: nsNumbers) else {
            throw FilterError.propertyError("Failed to set vector property '\(name)'")
        }
    }
    
    /// Get an integer property
    /// - Parameter name: Property name
    /// - Returns: Property value
    public func getIntProperty(name: String) -> Int {
        return Int(objcFilter.getIntProperty(name))
    }
    
    /// Get a float property
    /// - Parameter name: Property name
    /// - Returns: Property value
    public func getFloatProperty(name: String) -> Float {
        return objcFilter.getFloatProperty(name)
    }
    
    /// Get a string property
    /// - Parameter name: Property name
    /// - Returns: Property value or nil if not found
    public func getStringProperty(name: String) -> String? {
        return objcFilter.getStringProperty(name)
    }
    
    /// Get a vector property
    /// - Parameter name: Property name
    /// - Returns: Array of float values or nil if not found
    public func getVectorProperty(name: String) -> [Float]? {
        guard let nsNumbers = objcFilter.getVectorProperty(name) else { return nil }
        return nsNumbers.map { $0.floatValue }
    }
    
    /// Check if property exists
    /// - Parameter name: Property name
    /// - Returns: true if property exists
    public func hasProperty(name: String) -> Bool {
        return objcFilter.hasProperty(name)
    }
    
    /// Get property comment/description
    /// - Parameter name: Property name
    /// - Returns: Property comment or nil if not found
    public func getPropertyComment(name: String) -> String? {
        return objcFilter.getPropertyComment(name)
    }
    
    /// Get property type
    /// - Parameter name: Property name
    /// - Returns: Property type string or nil if not found
    public func getPropertyType(name: String) -> String? {
        return objcFilter.getPropertyType(name)
    }
}

// MARK: - Filter Chain Support

extension Filter {
    
    /// Add a sink to receive output from this filter
    /// - Parameter sink: The sink to add
    /// - Returns: Self for method chaining
    @discardableResult
    public func addSink<T: Sink>(_ sink: T) -> Self {
        objcFilter.addSink(sink.objcSink)
        return self
    }
    
    /// Remove a sink from this filter
    /// - Parameter sink: The sink to remove
    public func removeSink<T: Sink>(_ sink: T) {
        objcFilter.removeSink(sink.objcSink)
    }
    
    /// Remove all sinks from this filter
    public func removeAllSinks() {
        objcFilter.removeAllSinks()
    }
    
    /// Check if a sink is connected to this filter
    /// - Parameter sink: The sink to check
    /// - Returns: true if the sink is connected
    public func hasSink<T: Sink>(_ sink: T) -> Bool {
        return objcFilter.hasSink(sink.objcSink)
    }
}

// MARK: - Error Types

/// Errors that can occur when working with filters
public enum FilterError: Error, LocalizedError {
    case creationFailed(String)
    case propertyError(String)
    case renderingError(String)
    
    public var errorDescription: String? {
        switch self {
        case .creationFailed(let message):
            return "Filter creation failed: \(message)"
        case .propertyError(let message):
            return "Property error: \(message)"
        case .renderingError(let message):
            return "Rendering error: \(message)"
        }
    }
}