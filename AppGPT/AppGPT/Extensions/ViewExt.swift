//
//  ViewExt.swift
//  AppGPT
//
//  Created by 박주영 on 10/12/23.
//

import SwiftUI

extension View {
    @ViewBuilder func loadingScreen(_ isPresented: Binding<Bool>) -> some View {
        ZStack {
            self
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            if isPresented.wrappedValue {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                ProgressView()
            }
        }
    }
}
