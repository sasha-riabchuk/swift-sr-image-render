//
//  Render.swift
//
//
//  Created by Oleksandr Riabchuk on 02.05.2024.
//

import Foundation
import SwiftUI
import UIKit

/// A protocol that defines the requirements for an object that can render images.
public protocol ImageRenderProtocol {
    /// Renders an image with a specified modifier and aspect ratio.
    /// - Parameters:
    ///   - modifier: The modifier to apply to the image.
    ///   - aspectRatio: The aspect ratio to use when rendering the image.
    ///   - originalImage: The original image to render.
    /// - Returns: The rendered image.
    /// - Throws: If there is an error during the rendering process.
    func renderImage(modifier: Modifiers, aspectRatio: AspectRatio, originalImage: UIImage) async throws -> UIImage

    /// Renders an image with a specified modifier and aspect ratio, and saves the result.
    /// - Parameters:
    ///   - modifier: The modifier to apply to the image.
    ///   - aspectRatio: The aspect ratio to use when rendering the image.
    ///   - originalImage: The original image to render.
    /// - Throws: If there is an error during the rendering or saving process.
    func renderImageAndSave(modifier: Modifiers, aspectRatio: AspectRatio, originalImage: UIImage) async throws

    /// Saves an image in the gallery without resizing it.
    /// - Parameter image: The image to save.
    func saveInGalleryImageWithoutResizing(_ image: UIImage) async
}

public actor ImageRender {
    public init() {}

    public func renderImageAndSave(modifier: Modifiers, aspectRation: AspectRatio, originalImage: UIImage) async throws {
        guard let blurredImage = convertImage(originalImage: originalImage, modifier: modifier, targetAspectRatio: aspectRation) else {
            throw RenderError.imageRenderError
        }
        await saveInGaleryImageWithoutResizing(blurredImage)
    }

    public func renderImage(modifier: Modifiers, aspectRation: AspectRatio, originalImage: UIImage) async throws -> UIImage {
        guard let blurredImage = convertImage(originalImage: originalImage, modifier: modifier, targetAspectRatio: aspectRation) else {
            throw RenderError.imageRenderError
        }
        return blurredImage
    }

    public func saveInGaleryImageWithoutResizing(_ image: UIImage) async {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }

    // Function to calculate the adjusted blur radius
    private func adjustedBlurRadius(originalSize: CGSize, previewSize: CGSize, baseBlurRadius: CGFloat) -> CGFloat {
        let scaleFactor = previewSize.width / originalSize.width
        return (baseBlurRadius / scaleFactor) * 7
    }

    private func convertImage(originalImage: UIImage, modifier: Modifiers, targetAspectRatio: AspectRatio) -> UIImage? {
        let originalSize = originalImage.size
        let targetSize = CGSize(width: originalSize.width, height: originalSize.width * (targetAspectRatio.aspectValue))

        let widthRatio = targetSize.width / originalSize.width
        let heightRatio = targetSize.height / originalSize.height

        let scale = min(widthRatio, heightRatio)
        let newSize = CGSize(width: originalSize.width * scale, height: originalSize.height * scale)
        let origin = CGPoint(x: (targetSize.width - newSize.width) / 2, y: (targetSize.height - newSize.height) / 2)

        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)

        switch modifier {
        case .blur(let blur):
            let adjustBlurRadius = adjustedBlurRadius(originalSize: originalSize, previewSize: targetSize, baseBlurRadius: blur)
            if let ciImage = CIImage(image: originalImage) {
                let filter = CIFilter(name: "CIGaussianBlur")
                filter?.setValue(ciImage, forKey: kCIInputImageKey)
                filter?.setValue(adjustBlurRadius, forKey: kCIInputRadiusKey)
                if let output = filter?.outputImage, let cgImage = CIContext().createCGImage(output, from: ciImage.extent) {
                    UIImage(cgImage: cgImage).draw(in: CGRect(origin: .zero, size: targetSize))
                }
            }

            originalImage.draw(in: CGRect(origin: origin, size: newSize))

            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return resultImage

        case .color(let backgroundColor):
            // Fill the background with the specified color
            backgroundColor.setFill()
            UIRectFill(CGRect(origin: .zero, size: targetSize))

            originalImage.draw(in: CGRect(origin: origin, size: newSize))

            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return resultImage

        case .gradient(let gradient):
            // Create a gradient from the start color to the end color
            let colors = [UIColor.red.cgColor, UIColor.blue.cgColor] as CFArray
            if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: nil) {
                let context = UIGraphicsGetCurrentContext()
                context?.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: targetSize.height), options: [])
            }

            originalImage.draw(in: CGRect(origin: origin, size: newSize))

            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return resultImage
        }
    }
}
