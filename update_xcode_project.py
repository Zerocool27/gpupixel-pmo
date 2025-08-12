#!/usr/bin/env python3
"""
Script to update the Xcode project file to include GPUPixel wrapper files
This script adds Objective-C wrapper files and Swift files to the demo project
"""

import os
import re
import uuid
import sys

def generate_uuid():
    """Generate a random UUID for Xcode file references"""
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

def update_xcode_project():
    """Update the Xcode project to include wrapper files"""
    
    project_path = "demo/ios/demo.xcodeproj/project.pbxproj"
    
    if not os.path.exists(project_path):
        print(f"Error: Xcode project file not found at {project_path}")
        return False
    
    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()
    
    print("Updating Xcode project with wrapper files...")
    
    # File references to add
    wrapper_files = [
        # Objective-C wrapper headers
        ("GPUPixelWrapper/Core/GPUPixelFilter.h", "sourcecode.c.h"),
        ("GPUPixelWrapper/Core/GPUPixelSource.h", "sourcecode.c.h"),
        ("GPUPixelWrapper/Core/GPUPixelSink.h", "sourcecode.c.h"),
        ("GPUPixelWrapper/Core/GPUPixelFilterGroup.h", "sourcecode.c.h"),
        ("GPUPixelWrapper/Core/GPUPixelFramebuffer.h", "sourcecode.c.h"),
        
        # Objective-C wrapper implementations
        ("GPUPixelWrapper/Core/GPUPixelFilter.mm", "sourcecode.cpp.objcpp"),
        
        # Filter wrappers
        ("GPUPixelWrapper/Filter/GPUPixelBrightnessFilter.h", "sourcecode.c.h"),
        ("GPUPixelWrapper/Filter/GPUPixelGaussianBlurFilter.h", "sourcecode.c.h"),
        ("GPUPixelWrapper/Filter/GPUPixelBeautyFaceFilter.h", "sourcecode.c.h"),
        
        # Source/Sink wrappers
        ("GPUPixelWrapper/Source/GPUPixelSourceImage.h", "sourcecode.c.h"),
        ("GPUPixelWrapper/Sink/GPUPixelSinkRawData.h", "sourcecode.c.h"),
        
        # Face detector
        ("GPUPixelWrapper/FaceDetector/GPUPixelFaceDetector.h", "sourcecode.c.h"),
        
        # Demo controllers
        ("ImageFilter/WrapperImageFilterController.h", "sourcecode.c.h"),
        ("ImageFilter/WrapperImageFilterController.m", "sourcecode.c.objc"),
        
        # Swift files
        ("ImageFilter/SwiftImageFilterController.swift", "sourcecode.swift"),
        ("SwiftWrapper/Core/ImageSource.swift", "sourcecode.swift"),
        ("SwiftWrapper/Filter/GaussianBlurFilter.swift", "sourcecode.swift"),
        
        # Bridging header
        ("demo-Bridging-Header.h", "sourcecode.c.h"),
    ]
    
    # Generate UUIDs for new files
    file_refs = {}
    build_files = {}
    
    for file_path, file_type in wrapper_files:
        file_refs[file_path] = generate_uuid()
        if file_path.endswith(('.m', '.mm', '.swift')):
            build_files[file_path] = generate_uuid()
    
    # Find the PBXFileReference section
    pbx_file_ref_pattern = r'(/\* Begin PBXFileReference section \*/.*?/\* End PBXFileReference section \*/)'
    match = re.search(pbx_file_ref_pattern, content, re.DOTALL)
    
    if not match:
        print("Error: Could not find PBXFileReference section")
        return False
    
    # Add new file references
    new_file_refs = []
    for file_path, file_type in wrapper_files:
        filename = os.path.basename(file_path)
        ref_line = f'\t\t{file_refs[file_path]} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = {file_type}; path = "{filename}"; sourceTree = "<group>"; }};'
        new_file_refs.append(ref_line)
    
    # Insert new file references before the end comment
    file_ref_section = match.group(1)
    end_comment_pos = file_ref_section.rfind('/* End PBXFileReference section */')
    new_file_ref_section = (file_ref_section[:end_comment_pos] + 
                           '\n'.join(new_file_refs) + '\n\t\t' +
                           file_ref_section[end_comment_pos:])
    
    content = content.replace(file_ref_section, new_file_ref_section)
    
    # Find and update PBXBuildFile section
    pbx_build_file_pattern = r'(/\* Begin PBXBuildFile section \*/.*?/\* End PBXBuildFile section \*/)'
    match = re.search(pbx_build_file_pattern, content, re.DOTALL)
    
    if match:
        new_build_files = []
        for file_path, _ in wrapper_files:
            if file_path in build_files:
                filename = os.path.basename(file_path)
                build_line = f'\t\t{build_files[file_path]} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_refs[file_path]} /* {filename} */; }};'
                new_build_files.append(build_line)
        
        build_file_section = match.group(1)
        end_comment_pos = build_file_section.rfind('/* End PBXBuildFile section */')
        new_build_file_section = (build_file_section[:end_comment_pos] + 
                                 '\n'.join(new_build_files) + '\n\t\t' +
                                 build_file_section[end_comment_pos:])
        
        content = content.replace(build_file_section, new_build_file_section)
    
    # Find and update PBXSourcesBuildPhase section
    sources_build_pattern = r'(/\* Begin PBXSourcesBuildPhase section \*/.*?/\* End PBXSourcesBuildPhase section \*/)'
    match = re.search(sources_build_pattern, content, re.DOTALL)
    
    if match:
        sources_section = match.group(1)
        # Find the files array within the sources build phase
        files_array_pattern = r'(files = \(\s*)(.*?)(\s*\);)'
        files_match = re.search(files_array_pattern, sources_section, re.DOTALL)
        
        if files_match:
            new_source_refs = []
            for file_path, _ in wrapper_files:
                if file_path in build_files:
                    filename = os.path.basename(file_path)
                    source_line = f'\t\t\t\t{build_files[file_path]} /* {filename} in Sources */,'
                    new_source_refs.append(source_line)
            
            new_files_array = (files_match.group(1) + 
                              files_match.group(2) + 
                              '\n' + '\n'.join(new_source_refs) + 
                              files_match.group(3))
            
            new_sources_section = sources_section.replace(files_match.group(0), new_files_array)
            content = content.replace(sources_section, new_sources_section)
    
    # Add Swift configuration to build settings
    if 'SWIFT_OBJC_BRIDGING_HEADER' not in content:
        # Find build configuration sections and add Swift settings
        config_pattern = r'(buildSettings = \{[^}]*PRODUCT_NAME = ".*?";[^}]*)\};'
        
        swift_settings = '''
				SWIFT_OBJC_BRIDGING_HEADER = "demo/demo-Bridging-Header.h";
				SWIFT_VERSION = 5.0;
				CLANG_ENABLE_MODULES = YES;'''
        
        def add_swift_settings(match):
            return match.group(1) + swift_settings + '\n\t\t\t};'
        
        content = re.sub(config_pattern, add_swift_settings, content)
    
    # Write the updated project file
    backup_path = project_path + ".backup"
    print(f"Creating backup at {backup_path}")
    
    with open(backup_path, 'w') as f:
        f.write(content)
    
    with open(project_path, 'w') as f:
        f.write(content)
    
    print("✅ Xcode project updated successfully!")
    print("📝 Added the following files:")
    for file_path, _ in wrapper_files:
        print(f"   - {file_path}")
    
    print("\n🔧 Swift configuration added:")
    print("   - Bridging header: demo/demo-Bridging-Header.h")
    print("   - Swift version: 5.0")
    print("   - Modules enabled: YES")
    
    return True

def main():
    """Main function"""
    if not update_xcode_project():
        sys.exit(1)
    
    print("\n🎉 Project update completed!")
    print("📋 Next steps:")
    print("   1. Open the Xcode project")
    print("   2. Build the project (⌘+B)")
    print("   3. Run the demo and test the wrapper functionality")
    print("   4. If there are build errors, check the console output")

if __name__ == "__main__":
    main()