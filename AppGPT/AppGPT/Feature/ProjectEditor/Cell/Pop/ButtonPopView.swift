//
//  ButtonPopView.swift
//  AppGPT
//
//  Created by 박주영 on 10/12/23.
//

import SwiftUI

struct ButtonPopView: View {
    @Binding var action: ComponentType.Action
    @Binding var text: String
    @Binding var color: Color
    @Binding var isPop: Bool
    @State var isType: Int
    @State var isColor: Bool = false
    
    init(action: Binding<ComponentType.Action>,
         text: Binding<String>,
         color: Binding<Color>,
         isPop: Binding<Bool>) {
        self._action = action
        self._text = text
        self._color = color
        self._isPop = isPop
        switch action.wrappedValue {
        case .open:
            self.isType = 1
        case .variable:
            self.isType = 0
        }
    }
    var body: some View {
        VStack {
            PopUpHeaderView(isPop: $isPop, title: "동작 버튼")
            HStack {
                TextField("버튼 제목...", text: $text)
                    .frame(height: 44)
                    .padding(.leading, 16)
                Button {
                    text = ""
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
            Picker("What is your favorite color?", selection: $isType) {
                Text("변수 설정").tag(0)
                Text("하이퍼링크").tag(1)
            }
            .pickerStyle(.segmented)
            .onChange(of: isType) { _ in
                switch isType {
                case 0:
                    action = .variable(key: "", value: "")
                case 1:
                    action = .open(url: "")
                default:
                    return
                }
            }
            switch action {
            case .open(let url):
                HStack {
                    TextField("URL...", text: Binding(get: { url }, set: {
                        action = .open(url: $0)
                    }))
                        .frame(height: 44)
                        .padding(.leading, 16)
                    Button {
                        action = .open(url: "")
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
                .padding(.bottom, 27)
            case .variable(let key, let value):
                HStack(spacing: 8) {
                    HStack {
                        TextField("키", text: Binding(get: { key }, set: {
                            action = .variable(key: $0, value: value)
                        }))
                        .frame(height: 44)
                        .padding(.leading, 16)
                        Button {
                            action = .variable(key: "", value: value)
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
                        TextField("값", text: Binding(get: { value }, set: {
                            action = .variable(key: key, value: $0)
                        }))
                        .frame(height: 44)
                        .padding(.leading, 16)
                        Button {
                            action = .variable(key: key, value: "")
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
                }
                .padding(.bottom, 27)
            }
                
            ColorButtonView(color: $color, isColor: $isColor)
        }
        .padding(16)
        .frame(width: 270)
        .background(Color.backGround)
    }
}
