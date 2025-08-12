//
//  GaussianBlurFilter.swift
//  GPUPixel Swift Wrapper Demo
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

import Foundation

/// Swift wrapper for Gaussian blur filter
public class GaussianBlurFilter {
    
    // MARK: - Properties
    
    /// The underlying Objective-C filter object
    internal let objcFilter: GPUPixelGaussianBlurFilter
    
    /// The blur radius (higher values = more blur)
    public var radius: Int {
        get { return Int(objcFilter.radius) }
        set { objcFilter.radius = Int32(newValue) }
    }
    
    /// The Gaussian sigma value (controls blur falloff)
    public var sigma: Float {
        get { return objcFilter.sigma }
        set { objcFilter.sigma = newValue }
    }
    
    // MARK: - Initialization
    
    /// Create a Gaussian blur filter with default parameters
    /// - Throws: FilterError if creation fails
    public init() throws {
        guard let filter = GPUPixelGaussianBlurFilter.gaussianBlurFilter() else {
            throw FilterError.creationFailed("Failed to create Gaussian blur filter")
        }
        self.objcFilter = filter
    }
    
    /// Create a Gaussian blur filter with specified parameters
    /// - Parameters:
    ///   - radius: The blur radius (higher values = more blur)
    ///   - sigma: The Gaussian sigma value (controls blur falloff)
    /// - Throws: FilterError if creation fails
    public init(radius: Int, sigma: Float) throws {
        guard let filter = GPUPixelGaussianBlurFilter.gaussianBlurFilter(withRadius: Int32(radius), sigma: sigma) else {
            throw FilterError.creationFailed("Failed to create Gaussian blur filter with radius: \(radius), sigma: \(sigma)")
        }
        self.objcFilter = filter
    }
}

/// Swift wrapper for beauty face filter
public class BeautyFaceFilter {
    
    // MARK: - Properties
    
    /// The underlying Objective-C filter object
    internal let objcFilter: GPUPixelBeautyFaceFilter
    
    /// Blur alpha for skin smoothing
    public var blurAlpha: Float {
        get { return objcFilter.blurAlpha }
        set { objcFilter.blurAlpha = newValue }
    }
    
    /// Skin whitening intensity
    public var white: Float {
        get { return objcFilter.white }
        set { objcFilter.white = newValue }
    }
    
    /// Sharpening intensity
    public var sharpen: Float {
        get { return objcFilter.sharpen }
        set { objcFilter.sharpen = newValue }
    }
    
    /// High-pass filter delta value
    public var highPassDelta: Float {
        get { return objcFilter.highPassDelta }
        set { objcFilter.highPassDelta = newValue }
    }
    
    /// Blur radius for skin smoothing
    public var radius: Float {
        get { return objcFilter.radius }
        set { objcFilter.radius = newValue }
    }
    
    // MARK: - Initialization
    
    /// Create a beauty face filter with default settings
    /// - Throws: FilterError if creation fails
    public init() throws {
        guard let filter = GPUPixelBeautyFaceFilter.beautyFaceFilter() else {
            throw FilterError.creationFailed("Failed to create beauty face filter")
        }
        self.objcFilter = filter
    }
}

/// Swift wrapper for face detector
public class FaceDetector {
    
    // MARK: - Properties
    
    /// The underlying Objective-C face detector object
    internal let objcDetector: GPUPixelFaceDetector
    
    // MARK: - Initialization
    
    /// Create a face detector
    /// - Throws: FaceDetectorError if creation fails
    public init() throws {
        guard let detector = GPUPixelFaceDetector.faceDetector() else {
            throw FaceDetectorError.creationFailed("Failed to create face detector")
        }
        self.objcDetector = detector
    }
    
    // MARK: - Face Detection
    
    /// Detect faces in a UIImage
    /// - Parameter image: The image to process
    /// - Returns: Array of face results
    public func detectFaces(in image: UIImage) -> [NSValue] {
        return objcDetector.detectFaces(in: image) ?? []
    }
    
    /// Get bounding box from face result
    /// - Parameter faceResult: The face result value
    /// - Returns: CGRect representing the face bounding box
    public func boundingBox(from faceResult: NSValue) -> CGRect {
        return objcDetector.boundingBox(fromFaceResult: faceResult)
    }
    
    /// Get confidence score from face result
    /// - Parameter faceResult: The face result value
    /// - Returns: Confidence score (0.0 to 1.0)
    public func confidence(from faceResult: NSValue) -> Float {
        return objcDetector.confidence(fromFaceResult: faceResult)
    }
    
    /// Get landmark points from face result
    /// - Parameter faceResult: The face result value
    /// - Returns: Array of landmark points
    public func landmarkPoints(from faceResult: NSValue) -> [NSValue] {
        return objcDetector.landmarkPoints(fromFaceResult: faceResult) ?? []
    }
}

/// Builder pattern for image processing
public class ImageProcessor {
    private var imageSource: ImageSource?
    private var filters: [Any] = []
    private var outputHandler: RawDataSink.RGBAOutputHandler?
    
    @discardableResult
    public func loadImage(path: String) -> Self {
        self.imageSource = try? ImageSource(imagePath: path)
        return self
    }
    
    @discardableResult
    public func addBrightness(_ value: Float) -> Self {
        if let filter = try? BrightnessFilter(brightness: value) {
            filters.append(filter)
        }
        return self
    }
    
    @discardableResult
    public func addBlur(radius: Int, sigma: Float) -> Self {
        if let filter = try? GaussianBlurFilter(radius: radius, sigma: sigma) {
            filters.append(filter)
        }
        return self
    }
    
    @discardableResult
    public func onOutput(_ handler: @escaping RawDataSink.RGBAOutputHandler) -> Self {
        self.outputHandler = handler
        return self
    }
    
    public func process() throws {
        guard let imageSource = imageSource else {
            throw ProcessingError.invalidInput("No image source provided")
        }
        
        guard let outputHandler = outputHandler else {
            throw ProcessingError.invalidInput("No output handler provided")
        }
        
        // Chain filters (simplified implementation)
        let dataSink = RawDataSink().onRGBAOutput(outputHandler)
        imageSource.addSink(dataSink)
        imageSource.render()
    }
}

// MARK: - Error Types

public enum FilterError: Error, LocalizedError {
    case creationFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .creationFailed(let message):
            return "Filter creation failed: \(message)"
        }
    }
}

public enum FaceDetectorError: Error, LocalizedError {
    case creationFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .creationFailed(let message):
            return "Face detector creation failed: \(message)"
        }
    }
}

public enum ProcessingError: Error, LocalizedError {
    case invalidInput(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        }
    }
}