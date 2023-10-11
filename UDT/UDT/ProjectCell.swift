import SwiftUI

struct ProjectCell: View {
    var name: String
    var color: Color
    var body: some View {
        VStack {
            Image(systemName: "app.badge")
                .resizable()
                .frame(width: 89, height: 90)
                .foregroundColor(color)
                .padding(.vertical, 32)
            HStack {
                Text(name)
                    .font(.system(size: 23, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.leading, 26)
                    .padding(.vertical, 13)
                Spacer()
            }
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
