//
//  Sink.swift
//  GPUPixelSwift
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

import Foundation

/// Protocol for objects that can act as sinks in the processing pipeline
public protocol Sink: AnyObject {
    /// The underlying Objective-C sink object
    var objcSink: GPUPixelSink { get }
}

/// Base Swift wrapper for GPUPixel Sink functionality
public class BaseSink: Sink {
    
    // MARK: - Properties
    
    /// The underlying Objective-C sink object
    public let objcSink: GPUPixelSink
    
    /// Number of inputs this sink accepts
    public var inputCount: Int {
        return Int(objcSink.inputCount)
    }
    
    // MARK: - Initialization
    
    /// Initialize with specified number of inputs
    /// - Parameter inputCount: Number of inputs this sink accepts
    public init(inputCount: Int = 1) {
        self.objcSink = GPUPixelSink(inputNumber: Int32(inputCount))
    }
    
    /// Internal initializer with existing Objective-C sink
    internal init(objcSink: GPUPixelSink) {
        self.objcSink = objcSink
    }
    
    // MARK: - Sink Operations
    
    /// Check if the sink is ready for processing
    /// - Returns: true if ready, false otherwise
    public func isReady() -> Bool {
        return objcSink.isReady()
    }
    
    /// Reset and clean up the sink
    public func resetAndClean() {
        objcSink.resetAndClean()
    }
    
    /// Render the sink (subclasses should override)
    public func render() {
        objcSink.render()
    }
    
    /// Get the next available texture index for multi-input sinks
    /// - Returns: The next available texture index
    public func nextAvailableTextureIndex() -> Int {
        return Int(objcSink.nextAvailableTextureIndex())
    }
}

// MARK: - Raw Data Sink

/// Swift wrapper for raw pixel data output
public class RawDataSink: BaseSink {
    
    // MARK: - Type Aliases
    
    /// Completion handler for RGBA data output
    public typealias RGBAOutputHandler = (Data?, Int, Int) -> Void
    
    /// Completion handler for YUV data output
    public typealias YUVOutputHandler = (Data?, Int, Int) -> Void
    
    // MARK: - Properties
    
    private let objcRawDataSink: GPUPixelSinkRawData
    
    /// Current image width in pixels
    public var width: Int {
        return Int(objcRawDataSink.width)
    }
    
    /// Current image height in pixels
    public var height: Int {
        return Int(objcRawDataSink.height)
    }
    
    /// RGBA data output completion handler
    public var rgbaOutputHandler: RGBAOutputHandler? {
        didSet {
            if let handler = rgbaOutputHandler {
                objcRawDataSink.setRGBAOutputBlock { data, width, height in
                    handler(data, Int(width), Int(height))
                }
            } else {
                objcRawDataSink.setRGBAOutputBlock(nil)
            }
        }
    }
    
    /// YUV data output completion handler
    public var yuvOutputHandler: YUVOutputHandler? {
        didSet {
            if let handler = yuvOutputHandler {
                objcRawDataSink.setYUVOutputBlock { data, width, height in
                    handler(data, Int(width), Int(height))
                }
            } else {
                objcRawDataSink.setYUVOutputBlock(nil)
            }
        }
    }
    
    // MARK: - Initialization
    
    /// Create a new raw data sink
    /// - Throws: SinkError if creation fails
    public override init(inputCount: Int = 1) {
        guard let rawDataSink = GPUPixelSinkRawData.rawDataSink() else {
            fatalError("Failed to create GPUPixelSinkRawData")
        }
        self.objcRawDataSink = rawDataSink
        super.init(objcSink: rawDataSink)
    }
    
    // MARK: - Data Access
    
    /// Get the current RGBA buffer
    /// - Returns: RGBA pixel data or nil if not available
    public func rgbaBuffer() -> Data? {
        return objcRawDataSink.rgbaBuffer()
    }
    
    /// Get the current I420 (YUV) buffer  
    /// - Returns: I420 pixel data or nil if not available
    public func i420Buffer() -> Data? {
        return objcRawDataSink.i420Buffer()
    }
}

// MARK: - Convenience Extensions

extension RawDataSink {
    
    /// Set RGBA output handler using Swift closure syntax
    /// - Parameter handler: Closure to call when new RGBA data is available
    @discardableResult
    public func onRGBAOutput(_ handler: @escaping RGBAOutputHandler) -> Self {
        self.rgbaOutputHandler = handler
        return self
    }
    
    /// Set YUV output handler using Swift closure syntax
    /// - Parameter handler: Closure to call when new YUV data is available
    @discardableResult
    public func onYUVOutput(_ handler: @escaping YUVOutputHandler) -> Self {
        self.yuvOutputHandler = handler
        return self
    }
}

// MARK: - Error Types

/// Errors that can occur when working with sinks
public enum SinkError: Error, LocalizedError {
    case creationFailed(String)
    case configurationError(String)
    case renderingError(String)
    
    public var errorDescription: String? {
        switch self {
        case .creationFailed(let message):
            return "Sink creation failed: \(message)"
        case .configurationError(let message):
            return "Configuration error: \(message)"
        case .renderingError(let message):
            return "Rendering error: \(message)"
        }
    }
}