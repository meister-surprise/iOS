import SwiftUI

struct ComponentCell: View {
    @State private var color: Color
    @State private var image: Image
    @State private var text: String = ""
    @State private var isDrag: Bool?
    @State private var isPop: Bool = false
    let title: String
    let type: ComponentType
    let deleteAction: (() -> ())?
    init(
        type: ComponentType,
        isDrag: Bool? = false,
        deleteAction: (() -> ())? = nil
    ) {
        self.type = type
        self.isDrag = isDrag
        self.color = type.bindComponent().2
        self.image = type.bindComponent().1
        self.title = type.bindComponent().0
        self.deleteAction = deleteAction
    }
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                image
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(color)
                    .padding(8)
                    .background(.white)
                    .cornerRadius(21)
                Text(title)
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading, 13)
                Spacer()
            }
            .padding(4)
            .background(color)
            .clipShape(Capsule())
            .frame(width: 236)
            
            if isDrag! {
                if type != .spacer  {
                    Button {
                        self.isPop.toggle()
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .frame(width: 20.28, height: 19.93)
                            .foregroundColor(color)
                            .padding(.leading, 13)
                    }.popover(isPresented: $isPop, arrowEdge: .bottom) {
                        switch type {
                        case .button:
                            ButtonPopView(text: $text, color: $color, isPop: $isPop)
                        case .text:
                            TextPopView(text: $text, color: $color, isPop: $isPop)
                        case .image:
                            ImagePopView(imageUrl: $text, color: $color, isPop: $isPop)
                        default:
                            Spacer()
                        }
                    }
                }
                Spacer()
                Button(action: deleteAction!) {
                    Image(systemName: "trash")
                        .frame(width: 19.27, height: 23.49)
                        .foregroundColor(color)
                        .padding(.trailing, 13)
                }
            }
        }
        .background(Color.white)
        .clipShape(Capsule())
    }
}

#Preview {
    ComponentCell(type: .button)
}

struct ButtonPopView: View {
    @Binding var text: String
    @Binding var color: Color
    @Binding var isPop: Bool
    @State var isColor: Bool = false
    var body: some View {
        VStack {
            PopUpHeaderView(isPop: $isPop, title: "동작 버튼")
            ButtonTextFieldView(text: $text, placeholder: "버튼 제목..")
            ColorButtonView(color: $color, isColor: $isColor)
        }
        .padding(16)
        .frame(width: 270)
        .background(Color.backGround)
    }
}

struct TextPopView: View {
    @Binding var text: String
    @Binding var color: Color
    @Binding var isPop: Bool
    @State var isColor: Bool = false
    var body: some View {
        VStack {
            PopUpHeaderView(isPop: $isPop, title: "텍스트")
            ButtonTextFieldView(text: $text, placeholder: "텍스트..")
            ColorButtonView(color: $color, isColor: $isColor)
        }
        .padding(16)
        .frame(width: 270)
        .background(Color.backGround)
    }
}
    
struct ImagePopView: View {
    @Binding var imageUrl: String
    @Binding var color: Color
    @Binding var isPop: Bool
    @State var isColor: Bool = false
    var body: some View {
        VStack {
            PopUpHeaderView(isPop: $isPop, title: "이미지")
            ButtonTextFieldView(text: $imageUrl, placeholder: "이미지 url..")
            ColorButtonView(color: $color, isColor: $isColor)
        }
        .padding(16)
        .frame(width: 270)
        .background(Color.backGround)
    }
}

struct PopUpHeaderView: View {
    @Binding var isPop: Bool
    let title: String
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.white)
            Spacer()
            Button {
                isPop.toggle()
            } label: {
                Image(systemName: "x.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .background(Color(uiColor: .systemGray2))
                    .foregroundColor(Color(uiColor: .systemGray4))
                    .cornerRadius(15)
            }
        }
        .padding(.horizontal, 4)
    }
}


struct ButtonTextFieldView: View {
    @Binding var text: String
    let placeholder: String
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .frame(height: 44)
                .padding(.leading, 16)
            Button {
                self.text = ""
            } label: {
                Image(systemName: "x.circle.fill")
                    .resizable()
                    .frame(width: 17, height: 17)
                    .foregroundColor(Color(uiColor: .systemGray2))
            }
            .padding(.trailing, 16)
        }
        .background(.black)
        .cornerRadius(8)
    }
}

struct ColorButtonView: View {
    @Binding var color: Color
    @Binding var isColor: Bool
    let colorList: [Color] = [.red, .yellow, .green,. blue]
    
    var body: some View {
        Button {
            self.isColor.toggle()
        } label: {
            Text("색상 선택")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.white)
                .padding(.vertical, 11)
                .padding(.horizontal, 86)
                .background(color)
                .cornerRadius(8)
        }
        .popover(isPresented: $isColor) {
            VStack {
                ForEach(colorList, id: \.self) { color in
                    Button {
                        self.color = color
                        self.isColor.toggle()
                    } label: {
                        HStack {
                            Text(color.toString())
                                .font(.system(size: 12.53, weight: .regular))
                                .foregroundStyle(.white)
                                .padding(.leading, 12)
                                .padding(.vertical, 8)
                            Spacer()
                        }
                    }
                }
            }
            .frame(width: 120)
        }
        
    }
}

extension Color {
    func toString() -> String {
        switch self {
        case .red:
            return "빨강"
        case .yellow:
            return "노랑"
        case .green:
            return "초록"
        case .blue:
            return "파랑"
        default:
            return "없음"
        }
    }
}
