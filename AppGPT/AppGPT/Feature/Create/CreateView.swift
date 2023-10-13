//
//  SettingsView.swift
//  AppGPT
//
//  Created by 박주영 on 10/12/23.
//

import SwiftUI

struct CreateView: View {
    
    @StateObject var viewModel = CreateViewModel()
    @Environment(\.dismiss) var dismiss
    let isCreate: Bool
    @State var isColor: Bool = false
    @State var alert: Bool = false

    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .background(Color(uiColor: .systemGray2))
                    .foregroundColor(Color(uiColor: .systemGray4))
                    .clipShape(Circle())
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding([.top, .trailing], 30)
            VStack(spacing: 13) {
                Text("프로젝트 생성")
                    .font(.system(size: 36, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 13)
                HStack {
                    TextField("프로젝트 제목...", text: $viewModel.title)
                        .frame(height: 44)
                        .padding(.leading, 16)
                    Button {
                        viewModel.title = ""
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
                HStack(spacing: 8) {
                    Picker("", selection: $viewModel.selection) {
                        Text("공개")
                            .tag(0)
                        Text("비공개")
                            .tag(1)
                    }
                    .pickerStyle(.segmented)
                    ColorButtonView(color: $viewModel.color, isColor: $isColor)
                }
                .frame(height: 32)
                Spacer()
                Button {
                    viewModel.createProjectDidTap()
                    dismiss()
                } label: {
                    Text("완료")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.vertical, 11)
                        .frame(width: 302)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }
            .padding(.top, -20)
            .padding(50)
        }
        .background(Color.backGround)
    }
}

#Preview {
    CreateView(isCreate: false)
}
