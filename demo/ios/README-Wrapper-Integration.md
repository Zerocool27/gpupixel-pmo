# GPUPixel Wrapper Demo Integration

This document describes the integration of GPUPixel Objective-C and Swift wrappers into the iOS demo project.

## Overview

The demo project now includes three different approaches to using GPUPixel:

1. **Original C++ Demo** - Direct C++ API usage (existing)
2. **Objective-C Wrapper Demo** - Modern Objective-C wrapper with ARC
3. **Swift Wrapper Demo** - Type-safe Swift APIs with error handling

## Project Structure

```
demo/ios/demo/
├── ImageFilter/
│   ├── ImageFilterController.mm           # Original C++ demo
│   ├── WrapperImageFilterController.h     # Objective-C wrapper demo header
│   ├── WrapperImageFilterController.m     # Objective-C wrapper demo implementation
│   └── SwiftImageFilterController.swift   # Swift wrapper demo
├── GPUPixelWrapper/                        # Objective-C wrapper files
│   ├── Core/                              # Core wrapper classes
│   ├── Filter/                            # Filter wrapper classes
│   ├── Source/                            # Source wrapper classes
│   ├── Sink/                              # Sink wrapper classes
│   └── FaceDetector/                      # Face detection wrapper
├── SwiftWrapper/                          # Swift wrapper files
│   ├── Core/                              # Core Swift classes
│   └── Filter/                            # Filter Swift classes
└── demo-Bridging-Header.h                 # Swift-Objective-C bridging header
```

## Integration Features

### ✅ Completed Features

1. **Objective-C Wrapper Integration**
   - Complete Objective-C wrapper classes with ARC support
   - Modern Objective-C APIs with proper memory management
   - Type-safe property access and method calls
   - Block-based callbacks for asynchronous operations

2. **Swift Wrapper Integration**
   - Type-safe Swift APIs with error handling
   - Modern Swift patterns (async/await, Result types, closures)
   - Fluent interface design with method chaining
   - Builder pattern for complex image processing pipelines

3. **Demo Controllers**
   - **WrapperImageFilterController**: Showcases Objective-C wrapper usage
   - **SwiftImageFilterController**: Demonstrates modern Swift APIs
   - Side-by-side comparison with original C++ implementation

4. **Build System Integration**
   - Xcode project automatically updated with wrapper files
   - Swift bridging header configured
   - Proper build settings for mixed language support

## Demo Features

### Objective-C Wrapper Demo

The `WrapperImageFilterController` demonstrates:

- **Filter Management**: Easy creation and configuration of filters
  ```objc
  self.beautyFilter = [GPUPixelBeautyFaceFilter beautyFaceFilter];
  self.beautyFilter.blurAlpha = 0.7f;
  self.beautyFilter.white = 0.3f;
  ```

- **Pipeline Construction**: Intuitive filter chaining
  ```objc
  [imageSource addSink:brightnessFilter];
  [brightnessFilter addSink:blurFilter];
  [blurFilter addSink:dataSink];
  ```

- **Memory Management**: Automatic memory management with ARC
- **Block-based Callbacks**: Modern asynchronous pattern
  ```objc
  [dataSink setRGBAOutputBlock:^(NSData *rgbaData, int width, int height) {
      // Handle processed image data
  }];
  ```

### Swift Wrapper Demo

The `SwiftImageFilterController` showcases:

- **Type-Safe APIs**: Swift-native error handling
  ```swift
  do {
      let brightnessFilter = try BrightnessFilter(brightness: 0.3)
      let source = try ImageSource(image: uiImage)
  } catch {
      print("Error: \(error)")
  }
  ```

- **Modern Patterns**: Async/await support
  ```swift
  Task {
      try await processImageWithFilters(source: source, sink: sink)
  }
  ```

- **Fluent Interface**: Method chaining for clean code
  ```swift
  let dataSink = RawDataSink()
      .onRGBAOutput { data, width, height in
          print("Processed: \(width)x\(height)")
      }
  ```

- **Builder Pattern**: Complex pipeline construction
  ```swift
  let processor = ImageProcessor()
      .loadImage(path: "input.jpg")
      .addBrightness(0.2)
      .addBlur(radius: 4, sigma: 2.0)
      .onOutput { data, width, height in
          print("Result: \(width)x\(height)")
      }
  ```

## Building and Running

### Prerequisites

- Xcode 14.0+ (for Swift 5.7+ support)
- iOS 12.0+ deployment target
- GPUPixel C++ library built for iOS

### Build Instructions

1. **Open the Project**
   ```bash
   open demo/ios/demo.xcodeproj
   ```

2. **Build the Project**
   - Press `⌘+B` to build
   - The project should compile without errors

3. **Run the Demo**
   - Select a simulator or device
   - Press `⌘+R` to run
   - Choose from the demo options in the main menu

### Demo Options

1. **Original C++ Demo** - Shows direct C++ API usage
2. **Video Filter Demo** - Real-time video processing (existing)
3. **Objective-C Wrapper Demo** - Modern Objective-C wrapper APIs
4. **Swift Wrapper Demo** - Type-safe Swift APIs

## Key Differences

### Code Comparison

**Original C++ Approach:**
```cpp
std::shared_ptr<BeautyFaceFilter> beautyFilter = BeautyFaceFilter::Create();
beautyFilter->SetBlurAlpha(0.7f);
beautyFilter->SetWhite(0.3f);
```

**Objective-C Wrapper Approach:**
```objc
GPUPixelBeautyFaceFilter *beautyFilter = [GPUPixelBeautyFaceFilter beautyFaceFilter];
beautyFilter.blurAlpha = 0.7f;
beautyFilter.white = 0.3f;
```

**Swift Wrapper Approach:**
```swift
let beautyFilter = try BeautyFaceFilter()
beautyFilter.blurAlpha = 0.7
beautyFilter.white = 0.3
```

### Benefits of Wrappers

1. **Memory Management**: Automatic with ARC (no manual memory management)
2. **Type Safety**: Compile-time type checking in Swift
3. **Error Handling**: Swift's try/catch mechanism
4. **Modern Patterns**: Closures, async/await, method chaining
5. **Developer Experience**: Xcode integration, code completion, documentation

## Troubleshooting

### Common Build Issues

1. **Missing Headers**
   - Ensure all wrapper header files are properly included
   - Check bridging header configuration

2. **Swift Compilation Errors**
   - Verify Swift version is set to 5.0+
   - Check bridging header path: `demo/demo-Bridging-Header.h`

3. **Linking Errors**
   - Ensure GPUPixel framework is properly linked
   - Check framework search paths

4. **Runtime Crashes**
   - Verify GPU context is properly initialized
   - Check memory management in wrapper implementations

### Debug Tips

```objc
// Enable debug logging
NSLog(@"Filter created: %@", filter);

// Check object states
if (![sink isReady]) {
    NSLog(@"Sink not ready for processing");
}
```

```swift
// Swift error handling
do {
    let filter = try BrightnessFilter(brightness: 0.5)
    print("✅ Filter created successfully")
} catch {
    print("❌ Filter creation failed: \(error)")
}
```

## Performance Considerations

1. **Wrapper Overhead**: Minimal - wrappers are thin bridges to C++
2. **Memory Usage**: Comparable to direct C++ usage
3. **GPU Performance**: No impact on GPU processing performance
4. **CPU Overhead**: Negligible wrapper method call overhead

## Future Enhancements

Potential improvements to the wrapper integration:

1. **Complete Filter Coverage**: Wrap all 40+ filter types
2. **Advanced Features**: Support for custom shaders and complex pipelines
3. **SwiftUI Integration**: Native SwiftUI components
4. **Combine Framework**: Reactive programming support
5. **Core Image Integration**: Interoperability with Core Image

## Contributing

To add new wrapper functionality:

1. Add C++ class wrapper in `GPUPixelWrapper/`
2. Create corresponding Swift class in `SwiftWrapper/`
3. Update bridging header
4. Add to Xcode project via script
5. Create demo usage in controllers

## Support

For issues related to the wrapper integration:

1. Check console output for build/runtime errors
2. Verify all wrapper files are properly included
3. Test with original C++ demo first to isolate issues
4. Review wrapper implementation for proper C++ bridge code