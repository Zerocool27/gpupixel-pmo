//
//  ImageSource.swift
//  GPUPixel Swift Wrapper Demo
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

import Foundation
import UIKit

/// Swift wrapper for image input source
public class ImageSource {
    
    // MARK: - Properties
    
    /// The underlying Objective-C source object
    internal let objcSource: GPUPixelSourceImage
    
    /// Image width in pixels
    public var width: Int {
        return Int(objcSource.width)
    }
    
    /// Image height in pixels
    public var height: Int {
        return Int(objcSource.height)
    }
    
    // MARK: - Initialization
    
    /// Create an image source from file path
    /// - Parameter imagePath: Path to the image file
    /// - Throws: ImageSourceError if creation fails
    public init(imagePath: String) throws {
        guard let source = GPUPixelSourceImage.sourceImage(withPath: imagePath) else {
            throw ImageSourceError.creationFailed("Failed to create image source from path: \(imagePath)")
        }
        self.objcSource = source
    }
    
    /// Create an image source from UIImage
    /// - Parameter image: The UIImage to use as source
    /// - Throws: ImageSourceError if creation fails
    public init(image: UIImage) throws {
        guard let source = GPUPixelSourceImage.sourceImage(with: image) else {
            throw ImageSourceError.creationFailed("Failed to create image source from UIImage")
        }
        self.objcSource = source
    }
    
    /// Create an image source from raw pixel data
    /// - Parameters:
    ///   - width: Image width in pixels
    ///   - height: Image height in pixels
    ///   - channelCount: Number of channels (1=grayscale, 3=RGB, 4=RGBA)
    ///   - pixels: Raw pixel data
    public init(width: Int, height: Int, channelCount: Int, pixels: [UInt8]) {
        let source = GPUPixelSourceImage.sourceImage(withWidth: Int32(width),
                                                    height: Int32(height),
                                                    channelCount: Int32(channelCount),
                                                    pixels: pixels)!
        self.objcSource = source
    }
    
    // MARK: - Source Operations
    
    /// Add a sink to receive output from this source
    /// - Parameter sink: The sink to add
    /// - Returns: Self for method chaining
    @discardableResult
    public func addSink<T: SinkProtocol>(_ sink: T) -> Self {
        if let rawDataSink = sink as? RawDataSink {
            objcSource.addSink(rawDataSink.objcSink)
        } else if let filter = sink as? BrightnessFilter {
            objcSource.addSink(filter.objcFilter)
        } else if let filter = sink as? GaussianBlurFilter {
            objcSource.addSink(filter.objcFilter)
        } else if let filter = sink as? BeautyFaceFilter {
            objcSource.addSink(filter.objcFilter)
        }
        return self
    }
    
    /// Remove all sinks from this source
    public func removeAllSinks() {
        objcSource.removeAllSinks()
    }
    
    /// Render the source
    public func render() {
        objcSource.render()
    }
}

// MARK: - Error Types

/// Errors that can occur when working with image sources
public enum ImageSourceError: Error, LocalizedError {
    case creationFailed(String)
    case invalidInput(String)
    
    public var errorDescription: String? {
        switch self {
        case .creationFailed(let message):
            return "Image source creation failed: \(message)"
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        }
    }
}