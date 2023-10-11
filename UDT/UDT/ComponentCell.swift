import SwiftUI

struct ComponentCell: View {
    let color: Color
    let image: Image
    let text: String
    let isDrag: Bool?
    init(
        type: ComponentType,
        isDrag: Bool? = false
    ) {
        self.isDrag = isDrag
        self.color = type.bindComponent().2
        self.image = type.bindComponent().1
        self.text = type.bindComponent().0
    }
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                image
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(color)
                    .padding(8)
                    .background(.white)
                    .cornerRadius(21)
                Text(text)
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
                Image(systemName: "ellipsis.circle")
                    .frame(width: 20.28, height: 19.93)
                    .foregroundColor(color)
                    .padding(.leading, 13)
                Spacer()
                Image(systemName: "trash")
                    .frame(width: 19.27, height: 23.49)
                    .foregroundColor(color)
                    .padding(.trailing, 13)
            }
        }
        .background(Color.white)
        .clipShape(Capsule())
    }
}

#Preview {
    ComponentCell(type: .button)
}
