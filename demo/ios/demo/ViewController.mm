//
//  ViewController.m
//  GPUPixelDemo
//
//  Created by PixPark on 2021/3/31.
//
//

#import "ViewController.h"
#import "ImageFilterController.h"
#import "VideoFilterController.h"
#import "WrapperImageFilterController.h"

@interface ViewController ()

@property(weak, nonatomic) IBOutlet UIButton* videoFilterTestBtn;
@property(weak, nonatomic) IBOutlet UIButton* imageFilterTestBtn;
@property(weak, nonatomic) IBOutlet UIButton* wrapperTestBtn;
@property(weak, nonatomic) IBOutlet UIButton* swiftWrapperTestBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"GPUPixel Demo";
  self.view.backgroundColor = [UIColor blackColor];
  
  [self setupUI];
}

- (void)setupUI {
    // Create buttons programmatically if not connected via Interface Builder
    if (!self.imageFilterTestBtn) {
        [self createProgrammaticUI];
    }
    
    // Configure button styles
    [self configureButton:self.imageFilterTestBtn withTitle:@"Original C++ Demo" color:[UIColor systemBlueColor]];
    [self configureButton:self.videoFilterTestBtn withTitle:@"Video Filter Demo" color:[UIColor systemGreenColor]];
    [self configureButton:self.wrapperTestBtn withTitle:@"Objective-C Wrapper Demo" color:[UIColor systemOrangeColor]];
    [self configureButton:self.swiftWrapperTestBtn withTitle:@"Swift Wrapper Demo" color:[UIColor systemPurpleColor]];
    
    // Add button actions
    [self.imageFilterTestBtn addTarget:self action:@selector(imageFilterTestTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoFilterTestBtn addTarget:self action:@selector(videoFilterTestTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.wrapperTestBtn addTarget:self action:@selector(wrapperTestTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.swiftWrapperTestBtn addTarget:self action:@selector(swiftWrapperTestTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createProgrammaticUI {
    // Create title label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"GPUPixel Demo Options";
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:titleLabel];
    
    // Create description label
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"Choose a demo to see GPUPixel in action";
    descLabel.font = [UIFont systemFontOfSize:16];
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.numberOfLines = 0;
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:descLabel];
    
    // Create buttons
    self.imageFilterTestBtn = [self createButtonWithTitle:@"Original C++ Demo"];
    self.videoFilterTestBtn = [self createButtonWithTitle:@"Video Filter Demo"];
    self.wrapperTestBtn = [self createButtonWithTitle:@"Objective-C Wrapper Demo"];
    self.swiftWrapperTestBtn = [self createButtonWithTitle:@"Swift Wrapper Demo"];
    
    // Create stack view for buttons
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 20;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [stackView addArrangedSubview:self.imageFilterTestBtn];
    [stackView addArrangedSubview:self.videoFilterTestBtn];
    [stackView addArrangedSubview:self.wrapperTestBtn];
    [stackView addArrangedSubview:self.swiftWrapperTestBtn];
    
    [self.view addSubview:stackView];
    
    // Layout constraints
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:40],
        [titleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        
        [descLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [descLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [descLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:40],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-40]
    ]];
}

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    button.layer.cornerRadius = 12;
    [button.heightAnchor constraintEqualToConstant:60].active = YES;
    return button;
}

- (void)configureButton:(UIButton *)button withTitle:(NSString *)title color:(UIColor *)color {
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = color;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    button.layer.cornerRadius = 12;
    button.layer.shadowColor = color.CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 2);
    button.layer.shadowOpacity = 0.3;
    button.layer.shadowRadius = 4;
}

#pragma mark - Button Actions

- (IBAction)imageFilterTestTapped:(UIButton *)sender {
    ImageFilterController *imageFilterController = [[ImageFilterController alloc] init];
    imageFilterController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imageFilterController animated:YES completion:nil];
}

- (IBAction)videoFilterTestTapped:(UIButton *)sender {
    VideoFilterController *videoFilterController = [[VideoFilterController alloc] init];
    videoFilterController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:videoFilterController animated:YES completion:nil];
}

- (IBAction)wrapperTestTapped:(UIButton *)sender {
    WrapperImageFilterController *wrapperController = [[WrapperImageFilterController alloc] init];
    wrapperController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:wrapperController animated:YES completion:nil];
}

- (IBAction)swiftWrapperTestTapped:(UIButton *)sender {
    // Create Swift controller - we'll need to import this properly
    NSString *className = @"demo.SwiftImageFilterController";
    Class swiftClass = NSClassFromString(className);
    
    if (swiftClass) {
        UIViewController *swiftController = [[swiftClass alloc] init];
        swiftController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:swiftController animated:YES completion:nil];
    } else {
        NSLog(@"Swift controller class not found. Make sure Swift wrapper is properly integrated.");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Swift Demo"
                                                                       message:@"Swift wrapper demo is not available. Please ensure Swift support is enabled in the project."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
