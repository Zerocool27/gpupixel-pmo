//
//  WrapperImageFilterController.m
//  GPUPixel Wrapper Demo
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import "WrapperImageFilterController.h"
#import "FilterToolbarView.h"
#import "FilterResultViewController.h"
#import "ImageConverter.h"

// Import our Objective-C wrapper classes
#import "GPUPixelSourceImage.h"
#import "GPUPixelBrightnessFilter.h"
#import "GPUPixelGaussianBlurFilter.h"
#import "GPUPixelBeautyFaceFilter.h"
#import "GPUPixelSinkRawData.h"
#import "GPUPixelFaceDetector.h"
#import "GPUPixelFilterGroup.h"

@interface WrapperImageFilterController () <FilterToolbarViewDelegate>

// Wrapper objects - much cleaner than C++ pointers!
@property (nonatomic, strong) GPUPixelSourceImage *sourceImage;
@property (nonatomic, strong) GPUPixelBeautyFaceFilter *beautyFilter;
@property (nonatomic, strong) GPUPixelBrightnessFilter *brightnessFilter;
@property (nonatomic, strong) GPUPixelGaussianBlurFilter *blurFilter;
@property (nonatomic, strong) GPUPixelSinkRawData *dataSink;
@property (nonatomic, strong) GPUPixelFaceDetector *faceDetector;
@property (nonatomic, strong) GPUPixelFilterGroup *filterGroup;

// Filter intensity properties
@property (nonatomic, assign) CGFloat sharpenValue;
@property (nonatomic, assign) CGFloat blurValue;
@property (nonatomic, assign) CGFloat whitenValue;
@property (nonatomic, assign) CGFloat saturationValue;
@property (nonatomic, assign) CGFloat faceSlimValue;
@property (nonatomic, assign) CGFloat eyeEnlargeValue;

// UI components
@property (nonatomic, strong) FilterToolbarView *filterToolbarView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *processButton;

@end

@implementation WrapperImageFilterController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Wrapper Demo";
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupUI];
    [self initializeFilters];
    [self loadSampleImage];
}

#pragma mark - UI Setup

- (void)setupUI {
    // Create image view
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.backgroundColor = [UIColor darkGrayColor];
        [self.view addSubview:self.imageView];
    }
    
    // Create process button
    if (!self.processButton) {
        self.processButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.processButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.processButton setTitle:@"Process Image" forState:UIControlStateNormal];
        [self.processButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.processButton.backgroundColor = [UIColor systemBlueColor];
        self.processButton.layer.cornerRadius = 8;
        [self.processButton addTarget:self action:@selector(processImageTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.processButton];
    }
    
    // Create filter toolbar
    NSArray *filterTitles = @[
        @"Beauty", @"Brightness", @"Blur", @"Detect Faces", @"Reset"
    ];
    
    self.filterToolbarView = [[FilterToolbarView alloc] initWithFrame:CGRectZero filterTitles:filterTitles];
    self.filterToolbarView.delegate = self;
    self.filterToolbarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.filterToolbarView];
    
    // Setup constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.imageView.heightAnchor constraintEqualToConstant:300],
        
        [self.processButton.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:20],
        [self.processButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.processButton.widthAnchor constraintEqualToConstant:150],
        [self.processButton.heightAnchor constraintEqualToConstant:44],
        
        [self.filterToolbarView.topAnchor constraintEqualToAnchor:self.processButton.bottomAnchor constant:20],
        [self.filterToolbarView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.filterToolbarView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.filterToolbarView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

#pragma mark - Filter Initialization

- (void)initializeFilters {
    // Initialize face detector
    self.faceDetector = [GPUPixelFaceDetector faceDetector];
    
    // Initialize filters using our wrapper
    self.beautyFilter = [GPUPixelBeautyFaceFilter beautyFaceFilter];
    self.beautyFilter.blurAlpha = 0.7f;
    self.beautyFilter.white = 0.3f;
    self.beautyFilter.sharpen = 0.5f;
    
    self.brightnessFilter = [GPUPixelBrightnessFilter brightnessFilter];
    self.brightnessFilter.brightness = 0.0f;
    
    self.blurFilter = [GPUPixelGaussianBlurFilter gaussianBlurFilter];
    self.blurFilter.radius = 0;
    self.blurFilter.sigma = 0.0f;
    
    // Create filter group for chaining
    self.filterGroup = [GPUPixelFilterGroup filterGroup];
    
    // Create data sink for output
    self.dataSink = [GPUPixelSinkRawData rawDataSink];
    
    // Set up output callback
    __weak typeof(self) weakSelf = self;
    [self.dataSink setRGBAOutputBlock:^(NSData *rgbaData, int width, int height) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf handleProcessedImageData:rgbaData width:width height:height];
        });
    }];
    
    NSLog(@"Filters initialized using Objective-C wrapper");
}

#pragma mark - Image Loading

- (void)loadSampleImage {
    // Load the sample face image
    UIImage *sampleImage = [UIImage imageNamed:@"sample_face.png"];
    if (sampleImage) {
        self.imageView.image = sampleImage;
        
        // Create source image using our wrapper
        self.sourceImage = [GPUPixelSourceImage sourceImageWithImage:sampleImage];
        if (self.sourceImage) {
            NSLog(@"Sample image loaded successfully using wrapper");
        } else {
            NSLog(@"Failed to create source image from UIImage");
        }
    } else {
        NSLog(@"Failed to load sample_face.png");
    }
}

#pragma mark - Image Processing

- (IBAction)processImageTapped:(UIButton *)sender {
    if (!self.sourceImage) {
        NSLog(@"No source image available");
        return;
    }
    
    sender.enabled = NO;
    [sender setTitle:@"Processing..." forState:UIControlStateDisabled];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self processImageWithCurrentSettings];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.enabled = YES;
            [sender setTitle:@"Process Image" forState:UIControlStateNormal];
        });
    });
}

- (void)processImageWithCurrentSettings {
    // Clear previous filter chain
    [self.sourceImage removeAllSinks];
    [self.filterGroup removeAllFilters];
    
    // Build filter chain based on current settings
    id<GPUPixelSourceProtocol> currentSource = self.sourceImage;
    
    // Add brightness filter if needed
    if (self.brightnessFilter.brightness != 0.0f) {
        [self.filterGroup addFilter:self.brightnessFilter];
    }
    
    // Add blur filter if needed
    if (self.blurFilter.radius > 0) {
        [self.filterGroup addFilter:self.blurFilter];
    }
    
    // Add beauty filter if enabled
    if (self.beautyFilter.blurAlpha > 0.0f) {
        [self.filterGroup addFilter:self.beautyFilter];
    }
    
    // Connect the pipeline
    if (self.filterGroup.filterCount > 0) {
        [currentSource addSink:self.filterGroup];
        [self.filterGroup addSink:self.dataSink];
    } else {
        [currentSource addSink:self.dataSink];
    }
    
    // Process the image
    [self.sourceImage render];
    
    NSLog(@"Image processing completed using wrapper pipeline");
}

- (void)handleProcessedImageData:(NSData *)rgbaData width:(int)width height:(int)height {
    if (!rgbaData) {
        NSLog(@"No processed image data received");
        return;
    }
    
    // Convert RGBA data back to UIImage
    UIImage *processedImage = [ImageConverter imageFromRGBAData:rgbaData width:width height:height];
    if (processedImage) {
        self.imageView.image = processedImage;
        NSLog(@"Processed image displayed: %dx%d", width, height);
    } else {
        NSLog(@"Failed to convert processed data to UIImage");
    }
}

#pragma mark - Face Detection

- (void)detectFacesInCurrentImage {
    UIImage *currentImage = self.imageView.image;
    if (!currentImage || !self.faceDetector) {
        NSLog(@"No image or face detector available");
        return;
    }
    
    // Detect faces using our wrapper
    NSArray<NSValue *> *faces = [self.faceDetector detectFacesInUIImage:currentImage];
    
    NSLog(@"Detected %lu face(s) using wrapper", (unsigned long)faces.count);
    
    for (NSValue *faceValue in faces) {
        CGRect boundingBox = [self.faceDetector boundingBoxFromFaceResult:faceValue];
        float confidence = [self.faceDetector confidenceFromFaceResult:faceValue];
        NSArray *landmarks = [self.faceDetector landmarkPointsFromFaceResult:faceValue];
        
        NSLog(@"Face detected - Confidence: %.2f, Box: %@, Landmarks: %lu",
              confidence, NSStringFromCGRect(boundingBox), (unsigned long)landmarks.count);
    }
    
    // Show alert with detection results
    NSString *message = [NSString stringWithFormat:@"Detected %lu face(s) in the image", (unsigned long)faces.count];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Face Detection"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - FilterToolbarViewDelegate

- (void)filterToolbarView:(FilterToolbarView *)toolbarView didSelectFilterAtIndex:(NSInteger)index {
    switch (index) {
        case 0: // Beauty
            [self toggleBeautyFilter];
            break;
        case 1: // Brightness
            [self adjustBrightness];
            break;
        case 2: // Blur
            [self adjustBlur];
            break;
        case 3: // Detect Faces
            [self detectFacesInCurrentImage];
            break;
        case 4: // Reset
            [self resetFilters];
            break;
        default:
            break;
    }
}

- (void)filterToolbarView:(FilterToolbarView *)toolbarView didChangeValue:(CGFloat)value forFilterAtIndex:(NSInteger)index {
    switch (index) {
        case 0: // Beauty intensity
            self.beautyFilter.blurAlpha = value;
            self.beautyFilter.white = value * 0.5f;
            break;
        case 1: // Brightness
            self.brightnessFilter.brightness = (value - 0.5f) * 2.0f; // Range: -1.0 to 1.0
            break;
        case 2: // Blur
            self.blurFilter.radius = (int)(value * 10); // Range: 0 to 10
            self.blurFilter.sigma = value * 5.0f; // Range: 0 to 5.0
            break;
        default:
            break;
    }
}

#pragma mark - Filter Controls

- (void)toggleBeautyFilter {
    if (self.beautyFilter.blurAlpha > 0.0f) {
        self.beautyFilter.blurAlpha = 0.0f;
        self.beautyFilter.white = 0.0f;
        NSLog(@"Beauty filter disabled");
    } else {
        self.beautyFilter.blurAlpha = 0.7f;
        self.beautyFilter.white = 0.3f;
        NSLog(@"Beauty filter enabled");
    }
}

- (void)adjustBrightness {
    // Cycle through brightness values
    float currentBrightness = self.brightnessFilter.brightness;
    if (currentBrightness < 0.1f) {
        self.brightnessFilter.brightness = 0.3f;
    } else if (currentBrightness < 0.4f) {
        self.brightnessFilter.brightness = 0.6f;
    } else {
        self.brightnessFilter.brightness = 0.0f;
    }
    NSLog(@"Brightness adjusted to: %.2f", self.brightnessFilter.brightness);
}

- (void)adjustBlur {
    // Cycle through blur values
    int currentRadius = self.blurFilter.radius;
    if (currentRadius == 0) {
        self.blurFilter.radius = 4;
        self.blurFilter.sigma = 2.0f;
    } else if (currentRadius == 4) {
        self.blurFilter.radius = 8;
        self.blurFilter.sigma = 4.0f;
    } else {
        self.blurFilter.radius = 0;
        self.blurFilter.sigma = 0.0f;
    }
    NSLog(@"Blur adjusted - Radius: %d, Sigma: %.2f", self.blurFilter.radius, self.blurFilter.sigma);
}

- (void)resetFilters {
    self.brightnessFilter.brightness = 0.0f;
    self.blurFilter.radius = 0;
    self.blurFilter.sigma = 0.0f;
    self.beautyFilter.blurAlpha = 0.0f;
    self.beautyFilter.white = 0.0f;
    
    // Reset to original image
    UIImage *originalImage = [UIImage imageNamed:@"sample_face.png"];
    if (originalImage) {
        self.imageView.image = originalImage;
    }
    
    NSLog(@"All filters reset to default values");
}

#pragma mark - Memory Management

- (void)dealloc {
    NSLog(@"WrapperImageFilterController deallocated");
}

@end