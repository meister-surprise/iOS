import SwiftUI

struct ProjectEditorView: View {
    @ObservedObject var viewModel = ProjectEditorViewModel()
    let name: String
    init(name: String) {
        self.name = name
    }
    var body: some View {
        VStack(spacing: 0) {
            ProjectEditorHeaderView(name: name)
            HStack(spacing: 26) {
                ProjectEditorTaskView(viewModel: viewModel)
                ProjectEditorCanvasView()
            }
            .padding(40)
            .background(Color("BackGroundColor"))
            .animation(.easeIn)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ProjectEditorView(name: "asdf")
}

struct ProjectEditorHeaderView: View {
    
    @State private var position = CGSize.zero
    @Environment(\.presentationMode) var presentationMode
    let name: String
    
    init(name: String) {
        self.name = name
    }
    var body: some View {
        VStack {
            Spacer().frame(height: 81)
            HStack(spacing: 11) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 17, height: 24)
                }
                Text(name)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(Color.white)
                Spacer()
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 40)
            ScrollView(.horizontal) {
                HStack(spacing: 13) {
                    ComponentCell(type: .button)
                        .draggable(ComponentType.button.toString())
                    ComponentCell(type: .text)
                        .draggable(ComponentType.text.toString())
                    ComponentCell(type: .image)
                        .draggable(ComponentType.image.toString())
                    ComponentCell(type: .spacer)
                        .draggable(ComponentType.spacer.toString())
                    Spacer()
                }
                .padding(.bottom, 13)
                .padding(.horizontal, 40)
            }
        }
        .background(Color(uiColor: .systemGray4))
    }
}


struct ProjectEditorTaskView: View {
    @ObservedObject var viewModel: ProjectEditorViewModel
    var body: some View {
        ScrollView(.vertical) {
            HStack {
                VStack(spacing: 13) {
                    ForEach(0 ..< viewModel.dropView.count, id: \.self) { index in
                        let data: ComponentType = viewModel.dropView[index]
                        switch data {
                        case .button:
                            ComponentCell(type: .button, isDrag: true) {
                                viewModel.removeBlock(index)
                            }
                        case .text:
                            ComponentCell(type: .text, isDrag: true) {
                                viewModel.removeBlock(index)
                            }
                        case .image:
                            ComponentCell(type: .image, isDrag: true)  {
                                viewModel.removeBlock(index)
                            }
                        case .spacer:
                            ComponentCell(type: .spacer, isDrag: true)  {
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
        .background(Color(uiColor: .systemGray4))
        .cornerRadius(20)
        .dropDestination(for: String.self) { items ,_ in
            viewModel.addBlock(items.first ?? "button")
            return true
        }
    }
}


struct ProjectEditorCanvasView: View {
    var body: some View {
        VStack {
            Spacer()
        }
        .frame(width: 354)
        .background(Color(uiColor: .systemGray4))
        .cornerRadius(20)
    }
}
