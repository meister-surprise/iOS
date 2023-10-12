import SwiftUI
import AppGPTLang

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
                AppGPTView(code: Binding(get: {
                    let codes = viewModel.dropView.map { $0.toCode() }
                    return codes.joined(separator: "\n")
                }, set: { _ in }))
                .frame(width: 354)
                .frame(maxHeight: .infinity)
                .background(Color(uiColor: .systemGray4))
                .cornerRadius(20)
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
            HStack(alignment: .center, spacing: 11) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 17, height: 24)
                        .foregroundColor(.white)
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
        .background(Color(uiColor: .systemGray4))
        .cornerRadius(20)
        .dropDestination(for: String.self) { items ,_ in
            viewModel.addBlock(items.first ?? "button")
            return true
        }
    }
}
