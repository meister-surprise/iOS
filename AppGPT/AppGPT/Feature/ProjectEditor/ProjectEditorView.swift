import SwiftUI
import AppGPTLang

struct ProjectEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var settingsPresented: Bool = false
    @StateObject var viewModel = ProjectEditorViewModel()
    let id: Int
    init(id: Int) {
        self.id = id
    }
    var body: some View {
        VStack(spacing: 0) {
            ProjectEditorHeaderView(name: viewModel.text, toggle: $settingsPresented) {
                presentationMode.wrappedValue.dismiss()
                viewModel.patchDetailDidTap(id: id)
            }
            HStack(spacing: 26) {
                ProjectEditorTaskView(viewModel: viewModel)
                AppGPTView(code: $viewModel.code)
                    .frame(width: 354)
                    .frame(maxHeight: .infinity)
                    .background(Color(uiColor: .systemGray4))
                    .cornerRadius(20)
                    .onChange(of: viewModel.dropView.map { $0.toCode() }) {
                        viewModel.code = $0.joined(separator: "\n")
                    }
            }
            .padding(40)
            .background(Color("BackGroundColor"))
        }
        .onAppear(perform: {
            self.viewModel.getDetailDidTap(id: id)
        })
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $settingsPresented) {
            SettingView(viewModel: viewModel, id: id)
                .onDisappear {
                    if viewModel.isDelete {
                        presentationMode.wrappedValue.dismiss()
                        self.viewModel.isDelete = false
                    }
                }
        }
        .loadingScreen($viewModel.isLoading)
    }
}

#Preview {
    ProjectEditorView(id: 0)
}

struct ProjectEditorHeaderView: View {
    
    @Binding var toggle: Bool
    @State private var position = CGSize.zero
    
    let name: String
    let dismissAction: (() -> ())
    
    init(name: String, toggle: Binding<Bool>, dismissAction: @escaping () -> Void) {
        self.name = name
        self._toggle = toggle
        self.dismissAction = dismissAction
    }
    var body: some View {
        VStack {
            Spacer().frame(height: 81)
            HStack(alignment: .center, spacing: 11) {
                Button(action: dismissAction){
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 17, height: 24)
                        .foregroundColor(.white)
                }
                Text(name)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(Color.white)
                Spacer()
                Button {
                    toggle.toggle()
                } label: {
                    Image(systemName: "square.and.pencil.circle.fill")
                        .resizable()
                        .frame(width: 42,height: 42)
                        .tint(Color.blue)
                        .background(Color.white)
                        .cornerRadius(21)
                }
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 40)
            HStack(spacing: 13) {
                ComponentCell(type: .constant(.button()))
                    .draggable(ComponentType.button().toString())
                ComponentCell(type: .constant(.text()))
                    .draggable(ComponentType.text().toString())
                ComponentCell(type: .constant(.image()))
                    .draggable(ComponentType.image().toString())
                ComponentCell(type: .constant(.spacer))
                    .draggable(ComponentType.spacer.toString())
                Spacer()
            }
            .padding(.bottom, 13)
            .padding(.horizontal, 40)
        }
        .background(Color(uiColor: .systemGray4))
    }
}


struct ProjectEditorTaskView: View {
    @ObservedObject var viewModel: ProjectEditorViewModel
    var body: some View {
        Group {
            if viewModel.dropView.isEmpty {
                Button {
                    viewModel.isGeneratorPresented.toggle()
                } label: {
                    Text("인공지능으로 앱 생성하기")
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.vertical, 13)
                        .frame(width: 361)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(.vertical) {
                    HStack {
                        VStack(spacing: 13) {
                            ForEach(0 ..< viewModel.dropView.count, id: \.self) { index in
                                let data: ComponentType = viewModel.dropView[index]
                                switch data {
                                case .button:
                                    ComponentCell(type: $viewModel.dropView[index], isDrag: true) {
                                        viewModel.removeBlock(index)
                                    }
                                case .text:
                                    ComponentCell(type: $viewModel.dropView[index], isDrag: true) {
                                        viewModel.removeBlock(index)
                                    }
                                case .image:
                                    ComponentCell(type: $viewModel.dropView[index], isDrag: true)  {
                                        viewModel.removeBlock(index)
                                    }
                                case .spacer:
                                    ComponentCell(type: $viewModel.dropView[index], isDrag: true)  {
                                        viewModel.removeBlock(index)
                                    }
                                }
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(40)
                }
            }
        }
        .background(Color(uiColor: .systemGray4))
        .cornerRadius(20)
        .dropDestination(for: String.self) { items , _ in
            withAnimation(.default) {
                viewModel.addBlock(items.first ?? "button")
            }
            return true
        }
        .sheet(isPresented: $viewModel.isGeneratorPresented) {
            VStack {
                Button {
                    viewModel.isGeneratorPresented = false
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
                    Text("인공지능으로 앱 생성하기")
                        .font(.system(size: 36, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 13)
                    HStack {
                        TextField("예) 자기소개 앱 만들어줘", text: $viewModel.prompt)
                            .frame(height: 44)
                            .padding(.leading, 16)
                        Button {
                            viewModel.prompt = ""
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
                    Spacer()
                    Button {
                        viewModel.generatePromptDidTap()
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
}
