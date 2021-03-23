//
//  UIImage+Helper.swift
//  
//
//  Created by Tùng Xuân on 8/16/20.
//  Copyright © 2020 Tung Xuan. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    // MARK: - Quality
    var highestQualityJPEG: UIImage {
        return jpegImage(quality: 1)
    }
    var highQualityJPEG: UIImage {
        return jpegImage(quality: 0.75)
    }
    var mediumQualityJPEG: UIImage {
        return jpegImage(quality: 0.5)
    }
    var lowQualityJPEG: UIImage {
        return jpegImage(quality: 0.25)
    }
    var lowestQualityJPEG: UIImage {
        return jpegImage(quality: 0.05)
    }
    
    func jpegImage(quality: CGFloat) -> UIImage {
        guard let data = self.jpegData(compressionQuality: quality) else { return UIImage() }
        guard let image = UIImage(data: data) else { return UIImage() }
        return image
    }
    
    // MARK: - base64
	func toBase64String(quality: CGFloat = 0.5, resize: Bool = true, maxHeight: CGFloat = 1920) -> String {
		// convert the image to NSData first
		let originHeight = self.size.height
		let originWidth = self.size.width
		var image = self
		
		if maxHeight < originHeight && resize {
			let newHeight: CGFloat = maxHeight
			let newWidth = newHeight / originHeight * originWidth
			image = self.resizeImage(targetSize: CGSize(width: newWidth, height: newHeight))
		}
		
		if let imageData: NSData = image.jpegData(compressionQuality: quality) as NSData? {
			// convert the NSData to base64 encoding
			let strBase64: String = imageData.base64EncodedString(options: .lineLength64Characters)
			
			return strBase64
		}
		return ""
	}
	
	func toBase64Data(quality: CGFloat = 0.25, resize: Bool = true, maxHeight: CGFloat = 1920) -> Data {
		let originHeight = self.size.height
		let originWidth = self.size.width
		var image = self
		
		if maxHeight < originHeight && resize {
			let newHeight: CGFloat = maxHeight
			let newWidth = newHeight / originHeight * originWidth
			image = self.resizeImage(targetSize: CGSize(width: newWidth, height: newHeight))
		}
		if let imageData: NSData = image.jpegData(compressionQuality: 0.25) as NSData? {
			// convert the NSData to base64 encoding
			let data = imageData.base64EncodedData(options: .lineLength64Characters)
			return data
		}
		return Data()
	}
	
	// MARK: - Resize
	func resizeImage(targetSize: CGSize) -> UIImage {
		let size = self.size
		
		let widthRatio  = targetSize.width  / size.width
		let heightRatio = targetSize.height / size.height
		
		// Figure out what our orientation is, and use that to form the rectangle
		var newSize: CGSize
		if(widthRatio > heightRatio) {
			newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
		} else {
			newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
		}
		
		// This is the rect that we've calculated out and this is what is actually used below
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		
		// Actually do the resizing to the rect using the ImageContext stuff
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		self.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
	}
    
    // MARK: - Scale Image
    func scaleImage(size: CGSize, alpha: Bool = true) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height).integral
        UIGraphicsBeginImageContextWithOptions(size, !alpha, self.scale)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    
    func scaleImage(scale: CGFloat, alpha: Bool = true) -> UIImage? {
        let oldSize = self.size
        let newSize = CGSize(width: oldSize.width * scale, height: oldSize.height * scale)
        return self.scaleImage(size: newSize, alpha: alpha)
    }
    
    // MARK: - get CIImage
    func getCIImage() -> CIImage? {
        var ciImage: CIImage? = nil
        if let ci = self.ciImage {
            ciImage = ci
        }
        else {
            if let cg = self.cgImage {
                ciImage = CIImage(cgImage: cg)
            }
        }
        return ciImage
    }
    
    // MARK: - Crop Image
    func crop(rect: CGRect) -> UIImage? {
        guard let cg = self.cgImage else { return nil }
        if let image = cg.cropping(to: rect) {
            return UIImage(cgImage: image)
        }
        return nil
    }
    
    func cropCenter(size: CGSize) -> UIImage? {
        let originSize = self.size
        let x = (originSize.width - size.width) / 2
        let y = (originSize.height - size.height) / 2
        if x < 0 || y < 0 { return nil }
        
        return self.crop(rect: .init(origin: .init(x: x, y: y), size: size))
    }
    
    func cropCenter(ratio: CGFloat) -> UIImage? {
        let originRatio = self.size.width / self.size.height
        if ratio == originRatio {
            return self
        }
        if ratio < originRatio {
            // new height = self.height
            let height = self.size.height
            let width = height * ratio
            return self.cropCenter(size: .init(width: width, height: height))
        }
        else {
            // new width = self.width
            let width = self.size.width
            let height = width / ratio
            
            return self.cropCenter(size: .init(width: width, height: height))
        }
    }
    
    // MARK: - fix Orientation
    func fixOrientation() -> UIImage {
        
        if imageOrientation == .up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi/2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -.pi/2)
        default: //.up, .upMirrored
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        default: //.up, .down, .left, .right
            break
        }
        
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: (self.cgImage?.colorSpace)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        let cgImage: CGImage = ctx.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }
    
    // MARK: - rotate
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}

// MARK: - CGImage + Scale
extension CGImage {
    func scaleImage(size: CGSize) -> CGImage? {
        let width = size.width
        let height = size.height
        guard let colorS = self.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: self.bitsPerComponent, bytesPerRow: 0, space: colorS, bitmapInfo: self.bitmapInfo.rawValue) else { return nil }
        context.interpolationQuality = .high
        context.draw(self, in: .init(origin: .zero, size: size))
        return context.makeImage()
    }
    
    func scaleImage(scale: CGFloat) -> CGImage? {
        let newSize = CGSize(width: CGFloat(self.width) * scale, height: CGFloat(self.height) * scale)
        return self.scaleImage(size: newSize)
    }
}
