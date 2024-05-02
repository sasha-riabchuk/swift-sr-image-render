//
//  AspectRatio.swift
//
//
//  Created by Oleksandr Riabchuk on 02.05.2024.
//

import Foundation

/// An enumeration representing different aspect ratios.
public enum AspectRatio: String, CaseIterable, Identifiable {
    
    /// Aspect ratio of 9:16.
    case nineSixteen = "9:16"
    
    /// Aspect ratio of 16:9.
    case sixteenNine = "16:9"
    
    /// Aspect ratio of 4:3.
    case threeFour = "4:3"

    /// A string representation of the aspect ratio, used as an identifier.
    public var id: String { rawValue }

    /// The value of the aspect ratio as a `CGFloat`.
    public var aspectValue: CGFloat {
        switch self {
        /// For 9:16 aspect ratio, the value is 9 / 16.
        case .nineSixteen:
            return 9 / 16
        /// For 16:9 aspect ratio, the value is 16 / 9.
        case .sixteenNine:
            return 16 / 9
        /// For 4:3 aspect ratio, the value is 3 / 4.
        case .threeFour:
            return 3 / 4
        }
    }
}
