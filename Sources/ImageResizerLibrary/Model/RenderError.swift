//
//  RenderError.swift
//
//
//  Created by Oleksandr Riabchuk on 02.05.2024.
//

import Foundation

/// An enumeration representing different errors that can occur during the image rendering process.
public enum RenderError: Error {
    /// An error that indicates a problem occurred during the image rendering process.
    case imageRenderError

    /// An error that indicates a problem occurred while saving the image.
    case imageSaveError

    /// An error that indicates a problem occurred while resizing the image.
    case imageResizeError
}
