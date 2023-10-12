import SwiftUI

struct SettingView: View {
    
    @ObservedObject var viewModel: ProjectEditorViewModel
    @Environment(\.dismiss) var dismiss
    @State var isColor: Bool = false
    @State var alert: Bool = false
    let id: Int
    init(viewModel: ProjectEditorViewModel, id: Int) {
        self.viewModel = viewModel
        self.id = id
    }

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
                Text("프로젝트 수정")
                    .font(.system(size: 36, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 13)
                HStack {
                    TextField("프로젝트 제목...", text: $viewModel.text)
                        .frame(height: 44)
                        .padding(.leading, 16)
                    Button {
                        viewModel.text = ""
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
                    .onChange(of: viewModel.selection) {
                        self.viewModel.scope = ($0 == 0 ? "PUBLIC" : "PRIVATE")
                    }
                    ColorButtonView(color: $viewModel.color, isColor: $isColor)
                }
                .frame(height: 32)
                Spacer()
                Button {
                    alert.toggle()
                } label: {
                    Text("프로젝트 삭제")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.vertical, 11)
                        .frame(width: 302)
                        .background(Color.red)
                        .clipShape(Capsule())
                }
                .alert("정말 삭제하시겠습니까?", isPresented: $alert) {
                    Button("삭제", role: .destructive) {
                        viewModel.deleteProjectDidTap(id: id)
                        dismiss()
                    }
                    Button("취소", role: .cancel) { alert.toggle() }
                }
                
                Button {
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
