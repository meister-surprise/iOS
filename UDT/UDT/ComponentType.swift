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
    case text(text: TextType = .constant(value: ""), size: CGFloat = 20, color: Color = Color(.label))
    case image(url: String = "")
    case spacer
    
    func isSpacer() -> Bool {
        switch self {
        case .button, .text, .image:
            false
        case .spacer:
            true
        }
    }

    func toCode() -> String {
        switch self {
        case .button(action: let action, text: let text, color: let color):
            var execute = ""
            switch action {
            case .variable(key: let key, value: let value):
                execute = "var(\(key)=\"\(value)\")"
            case .open(url: let url):
                execute = "open(\"\(url)\")"
            }
            return "Button({\(execute)},\(text),\(color.toKeyword))"
        case .text(text: let text, size: let size, color: let color):
            var string = ""
            switch text {
            case .variable(key: let key):
                string = "$\(key)"
            case .constant(value: let value):
                string = "\"\(value)\""
            }
            return "Text(\(string),\(size),\(color.toKeyword))"
        case .image(url: let url):
            return "Image(\"\(url)\")"
        case .spacer:
            return "Spacer()"
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
