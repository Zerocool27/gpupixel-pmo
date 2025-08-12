//
//  GPUPixelFilter.mm
//  GPUPixel Objective-C Wrapper
//
//  Created by GPUPixel Team
//  Copyright © 2024 PixPark. All rights reserved.
//

#import "GPUPixelFilter.h"
#import "GPUPixelFramebuffer.h"
#import "GPUPixelSource.h"
#import "GPUPixelSink.h"

// C++ includes
#include "gpupixel/filter/filter.h"
#include <memory>
#include <vector>
#include <string>

@interface GPUPixelFilter () {
@private
    std::shared_ptr<gpupixel::Filter> _cppFilter;
}
@end

@implementation GPUPixelFilter

#pragma mark - Factory Methods

+ (nullable instancetype)filterWithClassName:(NSString *)filterClassName {
    GPUPixelFilter *filter = [[self alloc] init];
    std::string cppClassName = [filterClassName UTF8String];
    filter->_cppFilter = gpupixel::Filter::Create(cppClassName);
    
    if (!filter->_cppFilter) {
        return nil;
    }
    
    filter.filterClassName = filterClassName;
    return filter;
}

+ (nullable instancetype)filterWithVertexShader:(NSString *)vertexShader
                                 fragmentShader:(NSString *)fragmentShader {
    GPUPixelFilter *filter = [[self alloc] init];
    std::string vertexStr = [vertexShader UTF8String];
    std::string fragmentStr = [fragmentShader UTF8String];
    
    filter->_cppFilter = gpupixel::Filter::CreateWithShaderString(vertexStr, fragmentStr);
    
    if (!filter->_cppFilter) {
        return nil;
    }
    
    return filter;
}

+ (nullable instancetype)filterWithFragmentShader:(NSString *)fragmentShader {
    GPUPixelFilter *filter = [[self alloc] init];
    std::string fragmentStr = [fragmentShader UTF8String];
    
    filter->_cppFilter = gpupixel::Filter::CreateWithFragmentShaderString(fragmentStr);
    
    if (!filter->_cppFilter) {
        return nil;
    }
    
    return filter;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialize will be done by factory methods or explicit init calls
    }
    return self;
}

- (BOOL)initWithVertexShader:(NSString *)vertexShader
              fragmentShader:(NSString *)fragmentShader
                 inputNumber:(int)inputNumber {
    std::string vertexStr = [vertexShader UTF8String];
    std::string fragmentStr = [fragmentShader UTF8String];
    
    if (!_cppFilter) {
        _cppFilter = std::make_shared<gpupixel::Filter>();
    }
    
    return _cppFilter->InitWithShaderString(vertexStr, fragmentStr, inputNumber);
}

- (BOOL)initWithFragmentShader:(NSString *)fragmentShader
                   inputNumber:(int)inputNumber {
    std::string fragmentStr = [fragmentShader UTF8String];
    
    if (!_cppFilter) {
        _cppFilter = std::make_shared<gpupixel::Filter>();
    }
    
    return _cppFilter->InitWithFragmentShaderString(fragmentStr, inputNumber);
}

#pragma mark - Properties

- (void)setFilterClassName:(NSString *)filterClassName {
    _filterClassName = filterClassName;
    if (_cppFilter) {
        _cppFilter->SetFilterClassName([filterClassName UTF8String]);
    }
}

- (NSString *)filterClassName {
    if (_cppFilter) {
        std::string className = _cppFilter->GetFilterClassName();
        return [NSString stringWithUTF8String:className.c_str()];
    }
    return _filterClassName;
}

#pragma mark - Rendering

- (void)render {
    if (_cppFilter) {
        _cppFilter->Render();
    }
}

- (BOOL)doRenderAndUpdateSinks:(BOOL)updateSinks {
    if (_cppFilter) {
        return _cppFilter->DoRender(updateSinks);
    }
    return NO;
}

#pragma mark - Property Management

- (BOOL)registerIntProperty:(NSString *)name
               defaultValue:(int)defaultValue
                    comment:(nullable NSString *)comment {
    if (!_cppFilter) return NO;
    
    std::string nameStr = [name UTF8String];
    std::string commentStr = comment ? [comment UTF8String] : "";
    
    return _cppFilter->RegisterProperty(nameStr, defaultValue, commentStr);
}

- (BOOL)registerFloatProperty:(NSString *)name
                 defaultValue:(float)defaultValue
                      comment:(nullable NSString *)comment {
    if (!_cppFilter) return NO;
    
    std::string nameStr = [name UTF8String];
    std::string commentStr = comment ? [comment UTF8String] : "";
    
    return _cppFilter->RegisterProperty(nameStr, defaultValue, commentStr);
}

- (BOOL)registerStringProperty:(NSString *)name
                  defaultValue:(NSString *)defaultValue
                       comment:(nullable NSString *)comment {
    if (!_cppFilter) return NO;
    
    std::string nameStr = [name UTF8String];
    std::string defaultValueStr = [defaultValue UTF8String];
    std::string commentStr = comment ? [comment UTF8String] : "";
    
    return _cppFilter->RegisterProperty(nameStr, defaultValueStr, commentStr);
}

- (BOOL)registerVectorProperty:(NSString *)name
                  defaultValue:(NSArray<NSNumber *> *)defaultValue
                       comment:(nullable NSString *)comment {
    if (!_cppFilter) return NO;
    
    std::string nameStr = [name UTF8String];
    std::string commentStr = comment ? [comment UTF8String] : "";
    
    std::vector<float> defaultVector;
    for (NSNumber *number in defaultValue) {
        defaultVector.push_back([number floatValue]);
    }
    
    return _cppFilter->RegisterProperty(nameStr, defaultVector, commentStr);
}

- (BOOL)setIntProperty:(NSString *)name value:(int)value {
    if (!_cppFilter) return NO;
    
    std::string nameStr = [name UTF8String];
    return _cppFilter->SetProperty(nameStr, value);
}

- (BOOL)setFloatProperty:(NSString *)name value:(float)value {
    if (!_cppFilter) return NO;
    
    std::string nameStr = [name UTF8String];
    return _cppFilter->SetProperty(nameStr, value);
}

- (BOOL)setStringProperty:(NSString *)name value:(NSString *)value {
    if (!_cppFilter) return NO;
    
    std::string nameStr = [name UTF8String];
    std::string valueStr = [value UTF8String];
    return _cppFilter->SetProperty(nameStr, valueStr);
}

- (BOOL)setVectorProperty:(NSString *)name value:(NSArray<NSNumber *> *)value {
    if (!_cppFilter) return NO;
    
    std::string nameStr = [name UTF8String];
    std::vector<float> valueVector;
    for (NSNumber *number in value) {
        valueVector.push_back([number floatValue]);
    }
    
    return _cppFilter->SetProperty(nameStr, valueVector);
}

- (int)getIntProperty:(NSString *)name {
    if (!_cppFilter) return 0;
    
    std::string nameStr = [name UTF8String];
    int value = 0;
    _cppFilter->GetProperty(nameStr, value);
    return value;
}

- (float)getFloatProperty:(NSString *)name {
    if (!_cppFilter) return 0.0f;
    
    std::string nameStr = [name UTF8String];
    float value = 0.0f;
    _cppFilter->GetProperty(nameStr, value);
    return value;
}

- (nullable NSString *)getStringProperty:(NSString *)name {
    if (!_cppFilter) return nil;
    
    std::string nameStr = [name UTF8String];
    std::string value;
    if (_cppFilter->GetProperty(nameStr, value)) {
        return [NSString stringWithUTF8String:value.c_str()];
    }
    return nil;
}

- (nullable NSArray<NSNumber *> *)getVectorProperty:(NSString *)name {
    if (!_cppFilter) return nil;
    
    std::string nameStr = [name UTF8String];
    // Note: The C++ API doesn't seem to have a GetProperty for vector<float>
    // This would need to be implemented in the C++ library
    return nil;
}

- (BOOL)hasProperty:(NSString *)name {
    if (!_cppFilter) return NO;
    
    std::string nameStr = [name UTF8String];
    return _cppFilter->HasProperty(nameStr);
}

- (nullable NSString *)getPropertyComment:(NSString *)name {
    if (!_cppFilter) return nil;
    
    std::string nameStr = [name UTF8String];
    std::string comment;
    if (_cppFilter->GetPropertyComment(nameStr, comment)) {
        return [NSString stringWithUTF8String:comment.c_str()];
    }
    return nil;
}

- (nullable NSString *)getPropertyType:(NSString *)name {
    if (!_cppFilter) return nil;
    
    std::string nameStr = [name UTF8String];
    std::string type;
    if (_cppFilter->GetPropertyType(nameStr, type)) {
        return [NSString stringWithUTF8String:type.c_str()];
    }
    return nil;
}

#pragma mark - GPUPixelSourceProtocol

- (id<GPUPixelSourceProtocol>)addSink:(id<GPUPixelSinkProtocol>)sink {
    // Implementation would need access to the sink's C++ object
    // This requires the sink to expose its C++ instance
    return self;
}

- (id<GPUPixelSourceProtocol>)addSink:(id<GPUPixelSinkProtocol>)sink textureIndex:(int)textureIndex {
    // Implementation would need access to the sink's C++ object
    return self;
}

- (void)removeSink:(id<GPUPixelSinkProtocol>)sink {
    // Implementation would need access to the sink's C++ object
}

- (void)removeAllSinks {
    if (_cppFilter) {
        _cppFilter->RemoveAllSinks();
    }
}

- (BOOL)hasSink:(id<GPUPixelSinkProtocol>)sink {
    // Implementation would need access to the sink's C++ object
    return NO;
}

- (void)setFramebuffer:(GPUPixelFramebuffer *)framebuffer rotation:(GPUPixelRotationMode)rotation {
    // Implementation would need access to framebuffer's C++ object
}

- (nullable GPUPixelFramebuffer *)framebuffer {
    // Implementation would need to wrap C++ framebuffer
    return nil;
}

- (void)releaseFramebuffer:(BOOL)returnToCache {
    if (_cppFilter) {
        _cppFilter->ReleaseFramebuffer(returnToCache);
    }
}

- (void)setFramebufferScale:(float)scale {
    if (_cppFilter) {
        _cppFilter->SetFramebufferScale(scale);
    }
}

- (int)rotatedFramebufferWidth {
    if (_cppFilter) {
        return _cppFilter->GetRotatedFramebufferWidth();
    }
    return 0;
}

- (int)rotatedFramebufferHeight {
    if (_cppFilter) {
        return _cppFilter->GetRotatedFramebufferHeight();
    }
    return 0;
}

- (BOOL)doRenderAndUpdateSinks:(BOOL)updateSinks {
    if (_cppFilter) {
        return _cppFilter->DoRender(updateSinks);
    }
    return NO;
}

- (void)updateSinks {
    if (_cppFilter) {
        _cppFilter->DoUpdateSinks();
    }
}

#pragma mark - GPUPixelSinkProtocol

- (void)setInputFramebuffer:(GPUPixelFramebuffer *)framebuffer
                   rotation:(GPUPixelRotationMode)rotation
               textureIndex:(int)textureIndex {
    // Implementation would need access to framebuffer's C++ object
}

- (BOOL)isReady {
    if (_cppFilter) {
        return _cppFilter->IsReady();
    }
    return NO;
}

- (void)resetAndClean {
    if (_cppFilter) {
        _cppFilter->ResetAndClean();
    }
}

- (int)nextAvailableTextureIndex {
    if (_cppFilter) {
        return _cppFilter->NextAvailableTextureIndex();
    }
    return 0;
}

#pragma mark - Internal

- (std::shared_ptr<gpupixel::Filter>)cppFilter {
    return _cppFilter;
}

@end