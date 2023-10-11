import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(height: 123)
                HStack {
                    Text("내 프로젝트")
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image("AddImage")
                            .resizable()
                            .frame(width: 42,height: 42)
                            .tint(Color.blue)
                    }
                }
                .padding(.horizontal, 40)
                ScrollView {
                    LazyVGrid(columns:[
                        GridItem(.adaptive(minimum: 309))
                    ], alignment: .center, spacing: 13) {
                        ForEach(1..<10) { index in
                            NavigationLink {
                                ProjectEditorView(name: "새 프로젝트 \(index)")
                            } label: {
                                ProjectCell(name: "새 프로젝트 \(index)", color: Color.red)
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
                Spacer()
                    .frame(height: 50)
            }
            .background(Color("BackGroundColor"))
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    MainView()
}
