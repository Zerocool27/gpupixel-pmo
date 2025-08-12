# GPUPixel Objective-C & Swift Wrappers

This document provides comprehensive documentation for using the GPUPixel library in Objective-C and Swift applications.

## Overview

The GPUPixel wrapper provides complete Objective-C and Swift bindings for the GPUPixel C++ library, enabling developers to leverage GPU-accelerated image processing in iOS and macOS applications with native APIs.

### Key Features

- **Complete C++ Binding**: All major GPUPixel classes wrapped with Objective-C interfaces
- **Modern Swift APIs**: Type-safe, error-handling Swift wrapper with modern language features
- **Filter Pipeline**: Support for complex filter chains and groups
- **Face Detection**: AI-powered face detection and landmark extraction
- **Platform Support**: iOS 12.0+, macOS 10.15+, Mac Catalyst 13.0+
- **Memory Management**: Automatic memory management with ARC
- **Performance**: Direct GPU processing with minimal overhead

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Swift App     │    │  Objective-C    │    │   C++ GPUPixel  │
│                 │◄──►│    Wrapper      │◄──►│     Library     │
│  Modern APIs    │    │  Native Bridge  │    │  Core Engine    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Installation

### Prerequisites

- Xcode 14.0+ (for Swift 5.7+ support)
- iOS 12.0+ / macOS 10.15+
- GPUPixel C++ library built for your target platform

### Using CMake (Recommended)

1. **Build the Objective-C wrapper:**
```bash
cd objc-wrapper
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
```

2. **Install the wrapper:**
```bash
make install
```

### Using Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(path: "./swift-wrapper")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["GPUPixelSwift"]
    )
]
```

### Using Xcode

1. Add the `objc-wrapper` folder to your Xcode project
2. Add the bridging header to your project settings
3. Link against required frameworks (Metal, OpenGL, etc.)

## Quick Start

### Objective-C

```objc
#import "GPUPixelSourceImage.h"
#import "GPUPixelBrightnessFilter.h"
#import "GPUPixelSinkRawData.h"

// Load an image
GPUPixelSourceImage *source = [GPUPixelSourceImage sourceImageWithPath:@"input.jpg"];

// Create a brightness filter
GPUPixelBrightnessFilter *brightnessFilter = [GPUPixelBrightnessFilter brightnessFilter];
brightnessFilter.brightness = 0.3f;

// Create output sink
GPUPixelSinkRawData *sink = [GPUPixelSinkRawData rawDataSink];

// Set up the pipeline
[source addSink:brightnessFilter];
[brightnessFilter addSink:sink];

// Process
[source render];
```

### Swift

```swift
import GPUPixelSwift

do {
    // Load an image
    let source = try ImageSource(imagePath: "input.jpg")
    
    // Create a brightness filter with fluent API
    let brightnessFilter = try BrightnessFilter(brightness: 0.3)
    
    // Create output sink with closure
    let sink = RawDataSink()
        .onRGBAOutput { data, width, height in
            print("Processed: \(width)x\(height)")
        }
    
    // Set up pipeline with method chaining
    source
        .addSink(brightnessFilter)
        .addSink(sink)
    
    // Process
    source.render()
    
} catch {
    print("Error: \(error)")
}
```

## Core Classes

### Filter

The base class for all image processing filters.

#### Objective-C
```objc
// Create by class name
GPUPixelFilter *filter = [GPUPixelFilter filterWithClassName:@"BrightnessFilter"];

// Create with custom shaders
GPUPixelFilter *customFilter = [GPUPixelFilter filterWithVertexShader:vertexShader 
                                                       fragmentShader:fragmentShader];

// Set properties
[filter setFloatProperty:@"brightness" value:0.5f];
float brightness = [filter getFloatProperty:@"brightness"];
```

#### Swift
```swift
// Create by class name with error handling
let filter = try Filter(className: "BrightnessFilter")

// Create with custom shaders
let customFilter = try Filter(vertexShader: vertexShader, fragmentShader: fragmentShader)

// Set properties with type safety
try filter.setProperty(name: "brightness", value: 0.5)
let brightness = filter.getFloatProperty(name: "brightness")
```

### Source

Input sources for the processing pipeline.

#### Objective-C
```objc
// From file
GPUPixelSourceImage *imageSource = [GPUPixelSourceImage sourceImageWithPath:@"image.jpg"];

// From UIImage
GPUPixelSourceImage *uiImageSource = [GPUPixelSourceImage sourceImageWithImage:uiImage];

// From raw data
GPUPixelSourceImage *rawSource = [GPUPixelSourceImage sourceImageWithWidth:640 
                                                                    height:480 
                                                              channelCount:4 
                                                                    pixels:pixelData];
```

#### Swift
```swift
// From file with error handling
let imageSource = try ImageSource(imagePath: "image.jpg")

// From UIImage
let uiImageSource = try ImageSource(image: uiImage)

// From raw data with Swift arrays
let rawSource = ImageSource(width: 640, height: 480, channelCount: 4, pixels: pixelArray)
```

### Sink

Output destinations for processed images.

#### Objective-C
```objc
GPUPixelSinkRawData *sink = [GPUPixelSinkRawData rawDataSink];

// Set output handler
[sink setRGBAOutputBlock:^(NSData *data, int width, int height) {
    // Handle processed data
    NSLog(@"Got %dx%d image", width, height);
}];

// Get data directly
NSData *rgbaData = [sink rgbaBuffer];
```

#### Swift
```swift
let sink = RawDataSink()

// Set output handler with closure
sink.onRGBAOutput { data, width, height in
    print("Got \(width)x\(height) image")
}

// Get data directly
let rgbaData = sink.rgbaBuffer()
```

## Filter Types

### Brightness Filter

Adjusts image brightness (-1.0 to 1.0).

#### Objective-C
```objc
GPUPixelBrightnessFilter *filter = [GPUPixelBrightnessFilter brightnessFilterWithBrightness:0.3f];
filter.brightness = 0.5f; // Adjust later
```

#### Swift
```swift
let filter = try BrightnessFilter(brightness: 0.3)
    .setBrightness(0.5) // Fluent API
    .increaseBrightness(by: 0.1) // Convenience methods
```

### Gaussian Blur Filter

High-quality blur using two-pass algorithm.

#### Objective-C
```objc
GPUPixelGaussianBlurFilter *blur = [GPUPixelGaussianBlurFilter gaussianBlurFilterWithRadius:6 sigma:3.0f];
blur.radius = 8;
blur.sigma = 4.0f;
```

#### Swift
```swift
let blur = try GaussianBlurFilter(radius: 6, sigma: 3.0)
blur.radius = 8
blur.sigma = 4.0
```

### Beauty Face Filter

AI-powered face beautification.

#### Objective-C
```objc
GPUPixelBeautyFaceFilter *beauty = [GPUPixelBeautyFaceFilter beautyFaceFilter];
beauty.blurAlpha = 0.8f;
beauty.white = 0.3f;
beauty.sharpen = 0.5f;
```

#### Swift
```swift
let beauty = try BeautyFaceFilter()
beauty.blurAlpha = 0.8
beauty.white = 0.3
beauty.sharpen = 0.5
```

## Filter Groups

Combine multiple filters into a single processing unit.

#### Objective-C
```objc
GPUPixelFilterGroup *group = [GPUPixelFilterGroup filterGroup];
[group addFilter:brightnessFilter];
[group addFilter:blurFilter];

// Use like any other filter
[source addSink:group];
[group addSink:sink];
```

#### Swift
```swift
let group = try FilterGroup()
group.addFilter(brightnessFilter)
group.addFilter(blurFilter)

// Chain with other filters
source
    .addSink(group)
    .addSink(sink)
```

## Face Detection

AI-powered face detection with 68-point landmarks.

#### Objective-C
```objc
GPUPixelFaceDetector *detector = [GPUPixelFaceDetector faceDetector];

NSArray<NSValue *> *faces = [detector detectFacesInUIImage:uiImage];
for (NSValue *faceValue in faces) {
    CGRect boundingBox = [detector boundingBoxFromFaceResult:faceValue];
    float confidence = [detector confidenceFromFaceResult:faceValue];
    NSArray *landmarks = [detector landmarkPointsFromFaceResult:faceValue];
    
    NSLog(@"Face: confidence=%.2f, box=%@, landmarks=%lu", 
          confidence, NSStringFromCGRect(boundingBox), landmarks.count);
}
```

#### Swift
```swift
let detector = try FaceDetector()

let faces = detector.detectFaces(in: uiImage)
for face in faces {
    let boundingBox = detector.boundingBox(from: face)
    let confidence = detector.confidence(from: face)
    let landmarks = detector.landmarkPoints(from: face)
    
    print("Face: confidence=\(confidence), box=\(boundingBox), landmarks=\(landmarks.count)")
}
```

## Advanced Usage

### Complex Filter Chains

#### Objective-C
```objc
// Create filters
GPUPixelBrightnessFilter *brightness = [GPUPixelBrightnessFilter brightnessFilterWithBrightness:0.2f];
GPUPixelGaussianBlurFilter *blur = [GPUPixelGaussianBlurFilter gaussianBlurFilterWithRadius:4 sigma:2.0f];
GPUPixelBeautyFaceFilter *beauty = [GPUPixelBeautyFaceFilter beautyFaceFilter];

// Chain them
[source addSink:brightness];
[brightness addSink:blur];
[blur addSink:beauty];
[beauty addSink:sink];

// Process
[source render];
```

#### Swift
```swift
do {
    let brightness = try BrightnessFilter(brightness: 0.2)
    let blur = try GaussianBlurFilter(radius: 4, sigma: 2.0)
    let beauty = try BeautyFaceFilter()
    
    // Method chaining
    source
        .addSink(brightness)
        .addSink(blur)
        .addSink(beauty)
        .addSink(sink)
    
    source.render()
} catch {
    print("Error: \(error)")
}
```

### Builder Pattern (Swift)

```swift
let processor = ImageProcessor()
    .loadImage(path: "input.jpg")
    .addBrightness(0.2)
    .addBlur(radius: 4, sigma: 2.0)
    .addBrightness(0.1)
    .onOutput { data, width, height in
        print("Result: \(width)x\(height)")
    }

try processor.process()
```

### Async Processing (Swift)

```swift
func processImageAsync() async throws -> Data {
    return await withCheckedThrowingContinuation { continuation in
        let sink = RawDataSink()
            .onRGBAOutput { data, width, height in
                if let data = data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: ProcessingError.noData)
                }
            }
        
        source
            .addSink(filter)
            .addSink(sink)
        
        source.render()
    }
}
```

### Property-Based Configuration

#### Objective-C
```objc
GPUPixelFilter *filter = [GPUPixelFilter filterWithClassName:@"CustomFilter"];

// Register properties
[filter registerFloatProperty:@"intensity" defaultValue:1.0f comment:@"Effect intensity"];
[filter registerVectorProperty:@"color" defaultValue:@[@1.0, @0.0, @0.0] comment:@"RGB color"];

// Use properties
[filter setFloatProperty:@"intensity" value:0.8f];
[filter setVectorProperty:@"color" value:@[@0.5, @0.5, @1.0]];
```

#### Swift
```swift
let filter = try Filter(className: "CustomFilter")

// Use properties with type safety
try filter.setProperty(name: "intensity", value: 0.8)
try filter.setProperty(name: "color", value: [0.5, 0.5, 1.0])

// Get properties
let intensity = filter.getFloatProperty(name: "intensity")
let color = filter.getVectorProperty(name: "color")
```

## Error Handling

### Objective-C
```objc
GPUPixelBrightnessFilter *filter = [GPUPixelBrightnessFilter brightnessFilter];
if (!filter) {
    NSLog(@"Failed to create brightness filter");
    return;
}

BOOL success = [filter setFloatProperty:@"brightness" value:0.5f];
if (!success) {
    NSLog(@"Failed to set brightness property");
}
```

### Swift
```swift
enum ProcessingError: Error {
    case filterCreationFailed
    case propertySetFailed
    case renderingFailed
}

do {
    let filter = try BrightnessFilter(brightness: 0.5)
    try filter.setProperty(name: "brightness", value: 0.7)
    
    let success = filter.render(updateSinks: true)
    if !success {
        throw ProcessingError.renderingFailed
    }
} catch {
    print("Processing error: \(error)")
}
```

## Performance Tips

1. **Reuse Filters**: Create filters once and reuse them for multiple images
2. **Filter Groups**: Use `FilterGroup` for complex pipelines to optimize GPU usage
3. **Memory Management**: Release framebuffers when not needed with `releaseFramebuffer:`
4. **Background Processing**: Perform image processing on background queues
5. **GPU Context**: Ensure proper OpenGL/Metal context setup

## Platform Considerations

### iOS
- Supports OpenGL ES and Metal
- UIImage integration
- Camera input support
- Background processing limitations

### macOS
- Supports OpenGL and Metal
- NSImage integration
- File system access
- High-performance computing

### Mac Catalyst
- iOS API compatibility
- Desktop-class performance
- Shared codebase benefits

## Troubleshooting

### Common Issues

1. **Linking Errors**: Ensure all required frameworks are linked
2. **Missing Headers**: Check bridging header configuration
3. **Runtime Crashes**: Verify GPU context and memory management
4. **Performance Issues**: Profile GPU usage and optimize filter chains

### Debug Tips

```objc
// Enable debug logging
[filter setProperty:@"debug" value:@YES];

// Check filter readiness
if (![sink isReady]) {
    NSLog(@"Sink not ready for processing");
}

// Verify pipeline connections
if ([source hasSink:filter]) {
    NSLog(@"Source connected to filter");
}
```

## Examples

Complete examples are available in:
- `examples/objective-c/` - Objective-C examples
- `examples/swift/` - Swift examples

## API Reference

For detailed API documentation, see:
- [Objective-C API Reference](docs/objc-api.md)
- [Swift API Reference](docs/swift-api.md)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Submit a pull request

## License

This wrapper maintains the same license as the original GPUPixel library.

## Support

For issues and questions:
1. Check the [troubleshooting section](#troubleshooting)
2. Review [examples](#examples)
3. Open an issue on GitHub