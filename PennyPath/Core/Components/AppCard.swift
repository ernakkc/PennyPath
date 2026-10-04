import SwiftUI

struct AppCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(.spMD)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                // Arka plan ve çerçeve hatasız şekilde birleşti
                RoundedRectangle(cornerRadius: .cornerMedium, style: .continuous)
                    .fill(AppColor.backgroundSecondary)
                    .overlay {
                        RoundedRectangle(cornerRadius: .cornerMedium, style: .continuous)
                            .stroke(AppColor.border, lineWidth: 1) // Sizin kendi renk sabitiniz
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: .cornerMedium, style: .continuous))
    }
}


#Preview {
    AppCard(content: {
        Button("Merhaba") {
            print("Buton Tetiklendi.")
        }
        .buttonStyle(.primary)
        
        
    })
}
