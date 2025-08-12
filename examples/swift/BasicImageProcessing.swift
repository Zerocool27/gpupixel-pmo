//
//  BasicImageProcessing.swift
//  GPUPixelSwift Examples
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

/// Swift examples demonstrating modern GPUPixel usage
class BasicImageProcessing {
    
    // MARK: - Example 1: Basic brightness adjustment with modern Swift syntax
    
    func basicBrightnessExample() {
        print("=== Basic Brightness Example (Swift) ===")
        
        do {
            // Create image source
            guard let imageSource = try? ImageSource(imagePath: "input.jpg") else {
                print("Failed to load input image")
                return
            }
            
            // Create brightness filter with fluent API
            let brightnessFilter = try BrightnessFilter(brightness: 0.3)
            
            // Create output sink with closure-based handling
            let dataSink = RawDataSink()
                .onRGBAOutput { data, width, height in
                    if let data = data {
                        print("Processed image: \(width)x\(height), data size: \(data.count) bytes")
                        // Here you could save the processed image or use it further
                    }
                }
            
            // Set up pipeline using method chaining
            imageSource
                .addSink(brightnessFilter)
                .addSink(dataSink)
            
            // Render the pipeline
            imageSource.render()
            
            print("Brightness processing completed")
            
        } catch {
            print("Error in brightness example: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Example 2: Filter chain with async/await pattern
    
    func filterChainExample() async {
        print("=== Filter Chain Example (Swift) ===")
        
        do {
            // Create image source
            guard let imageSource = try? ImageSource(imagePath: "input.jpg") else {
                print("Failed to load input image")
                return
            }
            
            // Create filters with Swift-friendly APIs
            let brightnessFilter = try BrightnessFilter(brightness: 0.2)
                .setBrightness(0.25) // Fluent API for adjustments
            
            let blurFilter = try GaussianBlurFilter(radius: 6, sigma: 3.0)
            
            // Create async output handler
            let dataSink = RawDataSink()
            
            // Set up async processing
            await withCheckedContinuation { continuation in
                dataSink.onRGBAOutput { data, width, height in
                    if let data = data {
                        print("Processed chain result: \(width)x\(height), data size: \(data.count) bytes")
                    }
                    continuation.resume()
                }
                
                // Chain filters together
                imageSource
                    .addSink(brightnessFilter)
                    .addSink(blurFilter)
                    .addSink(dataSink)
                
                // Process the image
                imageSource.render()
            }
            
            print("Filter chain processing completed")
            
        } catch {
            print("Error in filter chain example: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Example 3: Modern Swift with Result types
    
    func resultBasedProcessing() {
        print("=== Result-Based Processing Example ===")
        
        let result = processImageWithFilters(imagePath: "input.jpg", filters: [
            { try BrightnessFilter(brightness: 0.3) },
            { try GaussianBlurFilter(radius: 4, sigma: 2.0) }
        ])
        
        switch result {
        case .success(let data):
            print("Successfully processed image with \(data.count) bytes")
        case .failure(let error):
            print("Processing failed: \(error.localizedDescription)")
        }
    }
    
    private func processImageWithFilters(
        imagePath: String,
        filters: [() throws -> Filter]
    ) -> Result<Data, Error> {
        do {
            guard let imageSource = try? ImageSource(imagePath: imagePath) else {
                return .failure(ImageProcessingError.invalidInput("Could not load image"))
            }
            
            // Chain filters
            var currentSource: any SourceProtocol = imageSource
            for filterFactory in filters {
                let filter = try filterFactory()
                currentSource.addSink(filter)
                currentSource = filter
            }
            
            // Add output sink
            let dataSink = RawDataSink()
            currentSource.addSink(dataSink)
            
            // Process synchronously for this example
            imageSource.render()
            
            // Get result data
            if let data = dataSink.rgbaBuffer() {
                return .success(data)
            } else {
                return .failure(ImageProcessingError.processingFailed("No output data"))
            }
            
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Example 4: Property-based configuration with Swift enums
    
    func propertyConfigurationExample() {
        print("=== Property Configuration Example (Swift) ===")
        
        do {
            // Create filter using class name
            let customFilter = try Filter(className: "BrightnessFilter")
            
            // Configure using Swift-friendly property methods
            try customFilter.setProperty(name: "brightness", value: 0.4)
            
            // Get property information with optional chaining
            if customFilter.hasProperty(name: "brightness") {
                let currentBrightness = customFilter.getFloatProperty(name: "brightness")
                let comment = customFilter.getPropertyComment(name: "brightness") ?? "No comment"
                let type = customFilter.getPropertyType(name: "brightness") ?? "Unknown type"
                
                print("Brightness property - Value: \(currentBrightness), Comment: \(comment), Type: \(type)")
            }
            
            print("Property configuration completed")
            
        } catch {
            print("Error in property configuration: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Example 5: Working with raw pixel data and Swift data types
    
    func rawPixelDataExample() {
        print("=== Raw Pixel Data Example (Swift) ===")
        
        do {
            // Create sample RGBA data using Swift data types
            let width = 100
            let height = 100
            let channelCount = 4
            
            var pixels = Array<UInt8>(repeating: 0, count: width * height * channelCount)
            
            // Fill with red color using modern Swift syntax
            for i in 0..<(width * height) {
                pixels[i * 4 + 0] = 255 // Red
                pixels[i * 4 + 1] = 0   // Green
                pixels[i * 4 + 2] = 0   // Blue
                pixels[i * 4 + 3] = 255 // Alpha
            }
            
            // Create image source from raw data
            let imageSource = ImageSource(
                width: width,
                height: height,
                channelCount: channelCount,
                pixels: pixels
            )
            
            // Apply brightness filter with fluent API
            let brightnessFilter = try BrightnessFilter(brightness: 0.5)
                .setBrightness(0.6) // Further adjustment
            
            // Create output sink with Swift closure
            let dataSink = RawDataSink()
                .onRGBAOutput { data, width, height in
                    guard let data = data else { return }
                    
                    print("Raw data processing result: \(width)x\(height), data size: \(data.count) bytes")
                    
                    // Verify the first pixel using Swift data access
                    let outputPixels = data.withUnsafeBytes { $0.bindMemory(to: UInt8.self) }
                    if outputPixels.count >= 4 {
                        print("First pixel RGBA: \(outputPixels[0]), \(outputPixels[1]), \(outputPixels[2]), \(outputPixels[3])")
                    }
                }
            
            // Connect pipeline
            imageSource
                .addSink(brightnessFilter)
                .addSink(dataSink)
            
            // Process the data
            imageSource.render()
            
            print("Raw pixel data processing completed")
            
        } catch {
            print("Error in raw pixel data example: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Example 6: Combining multiple effects with builder pattern
    
    func builderPatternExample() {
        print("=== Builder Pattern Example ===")
        
        do {
            let processor = ImageProcessor()
                .loadImage(path: "input.jpg")
                .addBrightness(0.2)
                .addBlur(radius: 4, sigma: 2.0)
                .addBrightness(0.1) // Can chain multiple of same type
                .onOutput { data, width, height in
                    print("Builder pattern result: \(width)x\(height), data size: \(data?.count ?? 0) bytes")
                }
            
            try processor.process()
            
            print("Builder pattern processing completed")
            
        } catch {
            print("Error in builder pattern example: \(error.localizedDescription)")
        }
    }
}

// MARK: - Supporting Types

/// Custom error types for image processing
enum ImageProcessingError: Error, LocalizedError {
    case invalidInput(String)
    case processingFailed(String)
    case configurationError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .processingFailed(let message):
            return "Processing failed: \(message)"
        case .configurationError(let message):
            return "Configuration error: \(message)"
        }
    }
}

/// Builder pattern implementation for fluent image processing
class ImageProcessor {
    private var imageSource: ImageSource?
    private var filters: [Filter] = []
    private var outputHandler: RawDataSink.RGBAOutputHandler?
    
    @discardableResult
    func loadImage(path: String) -> Self {
        self.imageSource = try? ImageSource(imagePath: path)
        return self
    }
    
    @discardableResult
    func addBrightness(_ value: Float) -> Self {
        if let filter = try? BrightnessFilter(brightness: value) {
            filters.append(filter)
        }
        return self
    }
    
    @discardableResult
    func addBlur(radius: Int, sigma: Float) -> Self {
        if let filter = try? GaussianBlurFilter(radius: radius, sigma: sigma) {
            filters.append(filter)
        }
        return self
    }
    
    @discardableResult
    func onOutput(_ handler: @escaping RawDataSink.RGBAOutputHandler) -> Self {
        self.outputHandler = handler
        return self
    }
    
    func process() throws {
        guard let imageSource = imageSource else {
            throw ImageProcessingError.invalidInput("No image source provided")
        }
        
        guard let outputHandler = outputHandler else {
            throw ImageProcessingError.configurationError("No output handler provided")
        }
        
        // Chain all filters
        var currentSource: any SourceProtocol = imageSource
        for filter in filters {
            currentSource.addSink(filter)
            currentSource = filter
        }
        
        // Add output sink
        let dataSink = RawDataSink().onRGBAOutput(outputHandler)
        currentSource.addSink(dataSink)
        
        // Process
        imageSource.render()
    }
}

// MARK: - Usage Function

func runSwiftExamples() async {
    print("Starting GPUPixel Swift Examples")
    
    let examples = BasicImageProcessing()
    
    examples.basicBrightnessExample()
    await examples.filterChainExample()
    examples.resultBasedProcessing()
    examples.propertyConfigurationExample()
    examples.rawPixelDataExample()
    examples.builderPatternExample()
    
    print("All Swift examples completed")
}