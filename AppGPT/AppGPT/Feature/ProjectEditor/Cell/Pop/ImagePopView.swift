//
//  ImagePopView.swift
//  AppGPT
//
//  Created by 박주영 on 10/12/23.
//

import SwiftUI

struct ImagePopView: View {
    @Binding var imageUrl: String
    @Binding var isPop: Bool
    @State var isColor: Bool = false
    var body: some View {
        VStack {
            PopUpHeaderView(isPop: $isPop, title: "이미지")
            HStack {
                TextField("이미지 URL...", text: $imageUrl)
                    .frame(height: 44)
                    .padding(.leading, 16)
                Button {
                    imageUrl = ""
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
        }
        .padding(16)
        .frame(width: 270)
        .background(Color.backGround)
    }
}
