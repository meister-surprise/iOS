//
//  TextPopView.swift
//  AppGPT
//
//  Created by 박주영 on 10/12/23.
//

import SwiftUI

struct TextPopView: View {
    @Binding var text: ComponentType.Text
    @Binding var color: Color
    @Binding var size: CGFloat
    @Binding var isPop: Bool
    @State var slideSize: CGFloat = 20
    @State var isType: Int = 0
    @State var isColor: Bool = false
    var body: some View {
        VStack {
            PopUpHeaderView(isPop: $isPop, title: "텍스트")
            Picker("", selection: $isType) {
                Text("고정 값").tag(0)
                Text("변수").tag(1)
            }
            .pickerStyle(.segmented)
            .onChange(of: isType) { _ in
                switch isType {
                case 0:
                    text = .constant(value: "")
                case 1:
                    text = .variable(key: "")
                default:
                    return
                }
            }
            HStack {
                TextField(isType == 0 ? "고정 값..":"변수..", text: Binding(get: {
                    switch text {
                    case .constant(let value):
                        return value
                    case .variable(let key):
                        return key
                    }
                }, set: {
                    switch text {
                    case .constant:
                        text = .constant(value: $0)
                    case .variable:
                        text = .variable(key: $0)
                    }
                }))
                .frame(height: 44)
                .padding(.leading, 16)
                Button {
                    switch text {
                    case .constant:
                        text = .constant(value: "")
                    case .variable:
                        text = .variable(key: "")
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 17, height: 17)
                        .foregroundColor(Color(uiColor: .systemGray2))
                }
                .padding(.trailing, 16)
            }
            .background(.black)
            .cornerRadius(8)
            HStack {
                Text("10")
                Slider(value: $slideSize, in: 10...30, step: 1)
                Text("30")
            }
            .onChange(of: slideSize) {
                self.size = $0
            }
            Text("\(Int(slideSize))")
                .padding(.bottom, 17)
            ColorButtonView(color: $color, isColor: $isColor)
        }
        .padding(16)
        .frame(width: 270)
        .background(Color.backGround)
    }
}
