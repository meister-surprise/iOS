import SwiftUI

struct ComponentCell: View {
    @State private var isDrag: Bool?
    @State private var isPop: Bool = false
    let title: String
    let color: Color
    let image: Image
    @Binding var type: ComponentType
    let deleteAction: (() -> ())?
    init(
        type: Binding<ComponentType>,
        isDrag: Bool? = false,
        deleteAction: (() -> ())? = nil
    ) {
        self._type = type
        self.isDrag = isDrag
        self.title = { () -> String in
            switch type.wrappedValue {
            case .button: "동작 버튼"
            case .text: "텍스트"
            case .image: "이미지"
            case .spacer: "간격"
            }
        }()
        self.color = { () -> Color in
            switch type.wrappedValue {
            case .button: .blue
            case .text: .indigo
            case .image: .pink
            case .spacer: .green
            }
        }()
        self.image = Image(systemName: { () -> String in
            switch type.wrappedValue {
            case .button: "button.horizontal.top.press.fill"
            case .text: "text.bubble.fill"
            case .image: "photo"
            case .spacer: "space"
            }
        }())
        self.deleteAction = deleteAction
    }
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                image
                    .resizable()
                    .scaledToFit()
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
                if !type.isSpacer() {
                    Button {
                        self.isPop.toggle()
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .frame(width: 20.28, height: 19.93)
                            .foregroundColor(color)
                            .padding(.leading, 13)
                    }.popover(isPresented: $isPop, arrowEdge: .bottom) {
                        switch type {
                        case .button(action: let action, text: let text, color: let color):
                            ButtonPopView(
                                action: Binding(get: { action }, set: { type = .button(action: $0, text: text, color: color)}),
                                text: Binding(get: { text }, set: { type = .button(action: action, text: $0, color: color)}),
                                color: Binding(get: { color }, set: { type = .button(action: action, text: text, color: $0)}),
                                isPop: $isPop
                            )
                        case .text(text: let text, size: let size, color: let color):
                            TextPopView(
                                text: Binding(get: { text }, set: { type = .text(text: $0, size: size, color: color)}),
                                color: Binding(get: { color }, set: { type = .text(text: text, size: size, color: $0)}),
                                size: Binding(get: { size }, set: { type = .text(text: text, size: $0, color: color)}),
                                isPop: $isPop
                            )
                        case .image(url: let url):
                            ImagePopView(imageUrl: Binding(get: { url }, set: { type = .image(url: $0) }), isPop: $isPop)
                        case .spacer:
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
                Image(systemName: "xmark.circle.fill")
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

struct ColorButtonView: View {
    @Binding var color: Color
    @Binding var isColor: Bool
    let colorList: [Color] = [.red, .yellow, .green,. blue, .white]
    
    var body: some View {
        Button {
            self.isColor.toggle()
        } label: {
            Text("색상 선택")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(color.textColor)
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
