//
//  Modifier.swift
//
//
//  Created by Oleksandr Riabchuk on 02.05.2024.
//

import Foundation
import SwiftUI
import UIKit

/// An enumeration representing different modifiers that can be applied.
public enum Modifiers: Equatable {
    /// A modifier that applies a blur effect with a specified radius.
    /// - Parameter radius: The radius of the blur effect as a `CGFloat`.
    case blur(CGFloat)

    /// A modifier that applies a color overlay with a specified color.
    /// - Parameter color: The color of the overlay as a `UIColor`.
    case color(UIColor)

    /// A modifier that applies a gradient overlay with a specified gradient.
    /// - Parameter gradient: The gradient to be applied as a `Gradient`.
    case gradient(Gradient)
}
