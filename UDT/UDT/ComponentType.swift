//
//  ComponentType.swift
//  UDT
//
//  Created by 박주영 on 10/11/23.
//

import Foundation
import SwiftUI

enum ComponentType: Codable{
    case button
    case text
    case image
    case spacer

    func bindComponent() -> (String, Image, Color) {
        switch self {
        case .button:
            return ("동작버튼", Image(systemName: "button.horizontal.top.press.fill"), .blue)
        case .image:
            return ("이미지", Image(systemName: "photo"), .pink)
        case .spacer:
            return ("간격", Image(systemName: "space"), .green)
        case .text:
            return ("텍스트", Image(systemName: "text.bubble.fill"), .indigo)
        }
    }
    static func formString(_ string: String) -> ComponentType {
        switch string {
        case "button":
            return .button
        case "image":
            return .image
        case "spacer":
            return .spacer
        case "text":
            return .text
        default:
            return .button
        }
    }
    
    func toString() -> String {
        switch self {
        case .button:
            return "button"
        case .image:
            return "image"
        case .spacer:
            return "spacer"
        case .text:
            return "text"
        }
    }
}
