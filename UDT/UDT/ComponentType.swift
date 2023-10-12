//
//  ComponentType.swift
//  UDT
//
//  Created by 박주영 on 10/11/23.
//

import Foundation
import SwiftUI

// 버튼 액션 종류
enum ActionType {
    case variable(key: String, value: String) // 변수 설정
    case open(url: String) // 하이퍼링크
}

// 텍스트 종류
enum TextType {
    case variable(key: String) // 변수
    case constant(value: String) // 고정 값
}

enum ComponentType {
    case button(action: ActionType = .open(url: ""), text: String = "", color: Color = .blue)
    case text(text: String = "", size: CGFloat = 20, color: Color = Color(.label))
    case image(url: String = "")
    case spacer
    
    func isSpacer() -> Bool {
        switch self {
        case .button(action: _, text: _, color: _):
            false
        case .text(text: _, size: _, color: _):
            false
        case .image(url: _):
            false
        case .spacer:
            true
        }
    }

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
            return .button()
        case "image":
            return .image()
        case "spacer":
            return .spacer
        case "text":
            return .text()
        default:
            return .button()
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
