//
//  SwiftImageFilterController.swift
//  GPUPixel Swift Wrapper Demo
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

import UIKit

/**
 * Swift demo controller showcasing the modern GPUPixel Swift wrapper
 * This demonstrates type-safe, error-handling Swift APIs with modern patterns
 */
class SwiftImageFilterController: UIViewController {
    
    // MARK: - Properties
    
    // Swift wrapper objects - type-safe and modern!
    private var imageSource: ImageSource?
    private var brightnessFilter: BrightnessFilter?
    private var blurFilter: GaussianBlurFilter?
    private var beautyFilter: BeautyFaceFilter?
    private var dataSink: RawDataSink?
    private var faceDetector: FaceDetector?
    
    // UI Components
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var processButton: UIButton!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var blurSlider: UISlider!
    @IBOutlet weak var beautySlider: UISlider!
    @IBOutlet weak var brightnessLabel: UILabel!
    @IBOutlet weak var blurLabel: UILabel!
    @IBOutlet weak var beautyLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Swift Wrapper Demo"
        view.backgroundColor = .black
        
        setupUI()
        initializeFilters()
        loadSampleImage()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        // Create UI programmatically if outlets are not connected
        if imageView == nil {
            setupProgrammaticUI()
        }
        
        // Configure sliders
        brightnessSlider?.minimumValue = -1.0
        brightnessSlider?.maximumValue = 1.0
        brightnessSlider?.value = 0.0
        brightnessSlider?.addTarget(self, action: #selector(brightnessChanged(_:)), for: .valueChanged)
        
        blurSlider?.minimumValue = 0.0
        blurSlider?.maximumValue = 10.0
        blurSlider?.value = 0.0
        blurSlider?.addTarget(self, action: #selector(blurChanged(_:)), for: .valueChanged)
        
        beautySlider?.minimumValue = 0.0
        beautySlider?.maximumValue = 1.0
        beautySlider?.value = 0.0
        beautySlider?.addTarget(self, action: #selector(beautyChanged(_:)), for: .valueChanged)
        
        // Configure button
        processButton?.setTitle("Process Image", for: .normal)
        processButton?.backgroundColor = .systemBlue
        processButton?.layer.cornerRadius = 8
        processButton?.addTarget(self, action: #selector(processImageTapped(_:)), for: .touchUpInside)
        
        updateLabels()
        
        statusLabel?.text = "Ready"
        statusLabel?.textColor = .green
    }
    
    private func setupProgrammaticUI() {
        // Create image view
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .darkGray
        view.addSubview(imageView)
        
        // Create sliders and labels
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Brightness controls
        let brightnessStack = createSliderStack(title: "Brightness", tag: 0)
        brightnessSlider = brightnessStack.arrangedSubviews[1] as? UISlider
        brightnessLabel = brightnessStack.arrangedSubviews[2] as? UILabel
        stackView.addArrangedSubview(brightnessStack)
        
        // Blur controls
        let blurStack = createSliderStack(title: "Blur", tag: 1)
        blurSlider = blurStack.arrangedSubviews[1] as? UISlider
        blurLabel = blurStack.arrangedSubviews[2] as? UILabel
        stackView.addArrangedSubview(blurStack)
        
        // Beauty controls
        let beautyStack = createSliderStack(title: "Beauty", tag: 2)
        beautySlider = beautyStack.arrangedSubviews[1] as? UISlider
        beautyLabel = beautyStack.arrangedSubviews[2] as? UILabel
        stackView.addArrangedSubview(beautyStack)
        
        // Process button
        processButton = UIButton(type: .system)
        processButton.translatesAutoresizingMaskIntoConstraints = false
        processButton.setTitle("Process Image", for: .normal)
        processButton.setTitleColor(.white, for: .normal)
        processButton.backgroundColor = .systemBlue
        processButton.layer.cornerRadius = 8
        processButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        stackView.addArrangedSubview(processButton)
        
        // Buttons stack
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 16
        
        let detectFacesButton = UIButton(type: .system)
        detectFacesButton.setTitle("Detect Faces", for: .normal)
        detectFacesButton.backgroundColor = .systemGreen
        detectFacesButton.setTitleColor(.white, for: .normal)
        detectFacesButton.layer.cornerRadius = 8
        detectFacesButton.addTarget(self, action: #selector(detectFacesTapped(_:)), for: .touchUpInside)
        
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.backgroundColor = .systemRed
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 8
        resetButton.addTarget(self, action: #selector(resetTapped(_:)), for: .touchUpInside)
        
        buttonStack.addArrangedSubview(detectFacesButton)
        buttonStack.addArrangedSubview(resetButton)
        stackView.addArrangedSubview(buttonStack)
        
        // Status label
        statusLabel = UILabel()
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .lightGray
        stackView.addArrangedSubview(statusLabel)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func createSliderStack(title: String, tag: Int) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        let slider = UISlider()
        slider.tag = tag
        
        let valueLabel = UILabel()
        valueLabel.textColor = .lightGray
        valueLabel.font = .systemFont(ofSize: 14)
        valueLabel.textAlignment = .center
        
        // Set up slider actions
        switch tag {
        case 0: slider.addTarget(self, action: #selector(brightnessChanged(_:)), for: .valueChanged)
        case 1: slider.addTarget(self, action: #selector(blurChanged(_:)), for: .valueChanged)
        case 2: slider.addTarget(self, action: #selector(beautyChanged(_:)), for: .valueChanged)
        default: break
        }
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(slider)
        stack.addArrangedSubview(valueLabel)
        
        return stack
    }
    
    // MARK: - Filter Initialization
    
    private func initializeFilters() {
        do {
            // Initialize filters using Swift wrapper with error handling
            brightnessFilter = try BrightnessFilter(brightness: 0.0)
            blurFilter = try GaussianBlurFilter(radius: 0, sigma: 0.0)
            beautyFilter = try BeautyFaceFilter()
            
            // Configure beauty filter
            beautyFilter?.blurAlpha = 0.0
            beautyFilter?.white = 0.0
            beautyFilter?.sharpen = 0.5
            
            // Initialize face detector
            faceDetector = try FaceDetector()
            
            // Create data sink with modern closure syntax
            dataSink = RawDataSink()
                .onRGBAOutput { [weak self] data, width, height in
                    DispatchQueue.main.async {
                        self?.handleProcessedImage(data: data, width: width, height: height)
                    }
                }
            
            statusLabel?.text = "Filters initialized successfully"
            statusLabel?.textColor = .green
            
            print("✅ Swift filters initialized successfully")
            
        } catch {
            statusLabel?.text = "Failed to initialize filters: \(error.localizedDescription)"
            statusLabel?.textColor = .red
            print("❌ Filter initialization error: \(error)")
        }
    }
    
    // MARK: - Image Loading
    
    private func loadSampleImage() {
        guard let sampleImage = UIImage(named: "sample_face.png") else {
            statusLabel?.text = "Failed to load sample image"
            statusLabel?.textColor = .red
            print("❌ Failed to load sample_face.png")
            return
        }
        
        imageView?.image = sampleImage
        
        do {
            imageSource = try ImageSource(image: sampleImage)
            statusLabel?.text = "Sample image loaded"
            statusLabel?.textColor = .green
            print("✅ Sample image loaded successfully")
        } catch {
            statusLabel?.text = "Failed to create image source: \(error.localizedDescription)"
            statusLabel?.textColor = .red
            print("❌ Image source creation error: \(error)")
        }
    }
    
    // MARK: - Image Processing
    
    @objc private func processImageTapped(_ sender: UIButton) {
        guard let imageSource = imageSource,
              let dataSink = dataSink else {
            statusLabel?.text = "Image source or sink not available"
            statusLabel?.textColor = .red
            return
        }
        
        sender.isEnabled = false
        sender.setTitle("Processing...", for: .disabled)
        statusLabel?.text = "Processing image..."
        statusLabel?.textColor = .orange
        
        Task {
            do {
                try await processImageWithFilters(source: imageSource, sink: dataSink)
            } catch {
                await MainActor.run {
                    statusLabel?.text = "Processing failed: \(error.localizedDescription)"
                    statusLabel?.textColor = .red
                    print("❌ Processing error: \(error)")
                }
            }
            
            await MainActor.run {
                sender.isEnabled = true
                sender.setTitle("Process Image", for: .normal)
            }
        }
    }
    
    private func processImageWithFilters(source: ImageSource, sink: RawDataSink) async throws {
        // Remove all existing connections
        source.removeAllSinks()
        
        var currentSource: any SourceProtocol = source
        var hasFilters = false
        
        // Build filter chain based on current settings
        if let brightnessFilter = brightnessFilter, brightnessFilter.brightness != 0.0 {
            currentSource.addSink(brightnessFilter)
            currentSource = brightnessFilter
            hasFilters = true
            print("✅ Added brightness filter: \(brightnessFilter.brightness)")
        }
        
        if let blurFilter = blurFilter, blurFilter.radius > 0 {
            currentSource.addSink(blurFilter)
            currentSource = blurFilter
            hasFilters = true
            print("✅ Added blur filter: radius=\(blurFilter.radius), sigma=\(blurFilter.sigma)")
        }
        
        if let beautyFilter = beautyFilter, beautyFilter.blurAlpha > 0.0 {
            currentSource.addSink(beautyFilter)
            currentSource = beautyFilter
            hasFilters = true
            print("✅ Added beauty filter: blurAlpha=\(beautyFilter.blurAlpha)")
        }
        
        // Connect to output sink
        currentSource.addSink(sink)
        
        // Process the image
        source.render()
        
        await MainActor.run {
            let filterCount = hasFilters ? "with filters" : "without filters"
            statusLabel?.text = "Processing completed \(filterCount)"
            statusLabel?.textColor = .green
        }
        
        print("✅ Image processing completed using Swift wrapper")
    }
    
    private func handleProcessedImage(data: Data?, width: Int, height: Int) {
        guard let data = data else {
            statusLabel?.text = "No processed image data received"
            statusLabel?.textColor = .red
            return
        }
        
        // Convert RGBA data to UIImage (using existing ImageConverter)
        let processedImage = ImageConverter.image(fromRGBAData: data, width: Int32(width), height: Int32(height))
        
        if let processedImage = processedImage {
            imageView?.image = processedImage
            statusLabel?.text = "Image processed: \(width)×\(height)"
            statusLabel?.textColor = .green
            print("✅ Processed image displayed: \(width)×\(height)")
        } else {
            statusLabel?.text = "Failed to convert processed data"
            statusLabel?.textColor = .red
            print("❌ Failed to convert processed data to UIImage")
        }
    }
    
    // MARK: - Face Detection
    
    @objc private func detectFacesTapped(_ sender: UIButton) {
        guard let currentImage = imageView?.image,
              let faceDetector = faceDetector else {
            statusLabel?.text = "No image or face detector available"
            statusLabel?.textColor = .red
            return
        }
        
        statusLabel?.text = "Detecting faces..."
        statusLabel?.textColor = .orange
        
        Task {
            do {
                let faces = try await detectFaces(in: currentImage, using: faceDetector)
                
                await MainActor.run {
                    let message = "Detected \(faces.count) face(s) in the image"
                    statusLabel?.text = message
                    statusLabel?.textColor = .green
                    
                    // Show alert with results
                    let alert = UIAlertController(title: "Face Detection", 
                                                message: message, 
                                                preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alert, animated: true)
                }
                
                print("✅ Face detection completed: \(faces.count) face(s)")
                
            } catch {
                await MainActor.run {
                    statusLabel?.text = "Face detection failed: \(error.localizedDescription)"
                    statusLabel?.textColor = .red
                }
                print("❌ Face detection error: \(error)")
            }
        }
    }
    
    private func detectFaces(in image: UIImage, using detector: FaceDetector) async throws -> [FaceResult] {
        return await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    // Detect faces using our Swift wrapper
                    let faces = detector.detectFaces(in: image)
                    
                    // Log face information
                    for (index, face) in faces.enumerated() {
                        let boundingBox = detector.boundingBox(from: face)
                        let confidence = detector.confidence(from: face)
                        let landmarks = detector.landmarkPoints(from: face)
                        
                        print("Face \(index + 1): confidence=\(confidence), box=\(boundingBox), landmarks=\(landmarks.count)")
                    }
                    
                    continuation.resume(returning: faces)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Slider Actions
    
    @objc private func brightnessChanged(_ slider: UISlider) {
        brightnessFilter?.brightness = slider.value
        updateLabels()
        print("🔆 Brightness changed to: \(slider.value)")
    }
    
    @objc private func blurChanged(_ slider: UISlider) {
        let radius = Int(slider.value)
        let sigma = slider.value * 0.5
        
        blurFilter?.radius = radius
        blurFilter?.sigma = sigma
        updateLabels()
        print("🌊 Blur changed to: radius=\(radius), sigma=\(sigma)")
    }
    
    @objc private func beautyChanged(_ slider: UISlider) {
        beautyFilter?.blurAlpha = slider.value
        beautyFilter?.white = slider.value * 0.3
        updateLabels()
        print("✨ Beauty changed to: \(slider.value)")
    }
    
    @objc private func resetTapped(_ sender: UIButton) {
        // Reset all filters to default values
        brightnessFilter?.brightness = 0.0
        blurFilter?.radius = 0
        blurFilter?.sigma = 0.0
        beautyFilter?.blurAlpha = 0.0
        beautyFilter?.white = 0.0
        
        // Reset sliders
        brightnessSlider?.value = 0.0
        blurSlider?.value = 0.0
        beautySlider?.value = 0.0
        
        // Reset to original image
        if let originalImage = UIImage(named: "sample_face.png") {
            imageView?.image = originalImage
        }
        
        updateLabels()
        statusLabel?.text = "All filters reset"
        statusLabel?.textColor = .green
        
        print("🔄 All filters reset to default values")
    }
    
    // MARK: - Helper Methods
    
    private func updateLabels() {
        brightnessLabel?.text = String(format: "%.2f", brightnessSlider?.value ?? 0.0)
        blurLabel?.text = String(format: "%.1f", blurSlider?.value ?? 0.0)
        beautyLabel?.text = String(format: "%.2f", beautySlider?.value ?? 0.0)
    }
}

// MARK: - Extensions

extension SwiftImageFilterController {
    
    /// Example of using the builder pattern for complex processing
    private func processWithBuilderPattern() async throws {
        guard let imagePath = Bundle.main.path(forResource: "sample_face", ofType: "png") else {
            throw ProcessingError.invalidInput("Sample image not found")
        }
        
        let processor = ImageProcessor()
            .loadImage(path: imagePath)
            .addBrightness(0.2)
            .addBlur(radius: 4, sigma: 2.0)
            .onOutput { data, width, height in
                print("Builder pattern result: \(width)×\(height)")
            }
        
        try processor.process()
    }
}

// MARK: - Error Types

enum ProcessingError: Error, LocalizedError {
    case invalidInput(String)
    case processingFailed(String)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .processingFailed(let message):
            return "Processing failed: \(message)"
        case .noData:
            return "No data received from processing"
        }
    }
}

// MARK: - Face Result Type

struct FaceResult {
    let boundingBox: CGRect
    let confidence: Float
    let landmarks: [CGPoint]
}

// Temporary protocol definitions until we have the complete Swift wrapper
protocol SourceProtocol {
    func addSink<T: SinkProtocol>(_ sink: T)
    func removeAllSinks()
    func render()
}

protocol SinkProtocol {
    // Base sink protocol
}

// Temporary implementations until we have the complete Swift wrapper
extension ImageSource: SourceProtocol {
    func addSink<T: SinkProtocol>(_ sink: T) {
        // Implementation would call the Objective-C wrapper
    }
    
    func removeAllSinks() {
        // Implementation would call the Objective-C wrapper
    }
    
    func render() {
        // Implementation would call the Objective-C wrapper
    }
}

extension BrightnessFilter: SourceProtocol {
    func addSink<T: SinkProtocol>(_ sink: T) {
        // Implementation would call the Objective-C wrapper
    }
    
    func removeAllSinks() {
        // Implementation would call the Objective-C wrapper
    }
    
    func render() {
        // Implementation would call the Objective-C wrapper
    }
}

extension RawDataSink: SinkProtocol {
    // Already conforms to SinkProtocol
}