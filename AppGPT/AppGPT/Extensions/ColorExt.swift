//
//  ColorExt.swift
//  AppGPT
//
//  Created by 박주영 on 10/12/23.
//

import SwiftUI

extension Color {
    func toString() -> String {
        switch self {
        case .red:
            return "빨강"
        case .yellow:
            return "노랑"
        case .green:
            return "초록"
        case .blue:
            return "파랑"
        case .white:
            return "하양"
        default:
            return "없음"
        }
    }
    
    var toKeyword: String {
        switch self {
        case .red: return "red"
        case .orange: return "orange"
        case .yellow: return "yellow"
        case .green: return "green"
        case .blue: return "blue"
        case .indigo: return "indigo"
        case .purple: return "purple"
        default: return "label"
        }
    }
    
    var textColor: Color {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        guard UIColor(self)
            .getRed(&red, green: &green, blue: &blue, alpha: nil) else {
            return .white
        }
        let lum = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        return lum < 0.5 ? .white : .black
    }
}
