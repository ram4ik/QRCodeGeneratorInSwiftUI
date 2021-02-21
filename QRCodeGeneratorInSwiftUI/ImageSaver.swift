//
//  ImageSaver.swift
//  QRCodeGeneratorInSwiftUI
//
//  Created by Ramill Ibragimov on 21.02.2021.
//


import UIKit
import Photos

class ImageSaver: NSObject, ObservableObject {
    
    @Published public var saveResult: ImageSaveResult?
    
    public func saveImage(_ image: UIImage) {
        let imageLabel = "Scan my code!"
        let photoLibraryAuthStatus = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        if photoLibraryAuthStatus == .authorized {
            saveImage(image, withLabel: imageLabel)
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { (status) in
            DispatchQueue.main.async {
                if status == .authorized {
                    self.saveImage(image, withLabel: imageLabel)
                    return
                }
                self.saveResult = ImageSaveResult(savedStatus: .libraryPermisionDenied)
            }
        }
    }
    
    
    
    private func saveImage(_ image: UIImage, withLabel label: String) {
        if let imageWithLabel = addLabel(label, toImage: image) {
            UIImageWriteToSavedPhotosAlbum(imageWithLabel, self, #selector(saveFinished), nil)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveFinished), nil)
    }
    
    private func addLabel(_ label: String, toImage image: UIImage) -> UIImage? {
        let font = UIFont.boldSystemFont(ofSize: 24)
        let text: NSString = NSString(string: label)
        
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue
        ]
        let textPadding: CGFloat = 8
        
        let textSize = text.size(withAttributes: attributes)
        let heightOffset = textSize.height + textPadding * 2
        let width = image.size.width
        let height = image.size.height + heightOffset
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        
        if let context = UIGraphicsGetCurrentContext() {
            UIColor.white.setFill()
            let rect = CGRect(x: 0, y: 0, width: width, height: height)
            context.fill(rect)
        }
        
        image.draw(in: CGRect(x: 0, y: heightOffset, width: width, height: image.size.height))
        
        text.draw(in: CGRect(x: (width / 2) - (textSize.width / 2), y: textPadding, width: width, height: height), withAttributes: attributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @objc private func saveFinished(
        _ imahe: UIImage,
        didFinishSavingWithError error: Error?,
        contextInfo: UnsafeRawPointer
    ) {
        if error != nil {
            saveResult = ImageSaveResult(savedStatus: .error)
        } else {
            saveResult = ImageSaveResult(savedStatus: .success)
        }
    }
}

struct ImageSaveResult: Identifiable {
    let id = UUID()
    let savedStatus: ImageSaveStatus
}

enum ImageSaveStatus {
    case success
    case error
    case libraryPermisionDenied
}
