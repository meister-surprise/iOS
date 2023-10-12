import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @State var settingsPresented: Bool = false
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
                        settingsPresented.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 42,height: 42)
                            .tint(Color.blue)
                            .background(Color.white)
                            .cornerRadius(21)
                    }
                }
                .padding(.horizontal, 40)
                ScrollView {
                    LazyVGrid(columns:[
                        GridItem(.adaptive(minimum: 309))
                    ], alignment: .center, spacing: 13) {
                        ForEach(viewModel.projectList, id: \.id) { project in
                            NavigationLink {
                                ProjectEditorView(id: project.id)
                                    .onDisappear(perform: {
                                        self.viewModel.getProjectDidTap()
                                    })
                            } label: {
                                ProjectCell(name: project.title, color: project.color.getColor())
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
        .onAppear(perform: {
            viewModel.getProjectDidTap()
        })
        .animation(.easeInOut)
        .navigationViewStyle(.stack)
        .sheet(isPresented: $settingsPresented) {
            CreateView(isCreate: true)
        }
        .loadingScreen($viewModel.isLoading)
    }
}

#Preview {
    MainView()
}
