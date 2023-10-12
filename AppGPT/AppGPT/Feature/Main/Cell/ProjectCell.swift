import SwiftUI

struct ProjectCell: View {
    var name: String
    var color: Color
    var body: some View {
        VStack {
            Image(systemName: "app.badge")
                .resizable()
                .frame(width: 89, height: 90)
                .foregroundColor(color == Color(uiColor: .label) ? .black : color)
                .padding(.vertical, 32)
                .frame(maxHeight: .infinity)
            Text(name)
                .font(.system(size: 23, weight: .regular))
                .foregroundColor(color.textColor)
                .padding(.leading, 26)
                .padding(.vertical, 13)
                .frame(height: 54)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(color)
        }
        .frame(width: 311, height: 209)
        .background(Color.white)
        .cornerRadius(20)
    }
}

#Preview {
    ProjectCell(name: "sdf", color: .red)
}
