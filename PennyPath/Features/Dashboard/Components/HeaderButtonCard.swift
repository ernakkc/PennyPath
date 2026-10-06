//
//  HeaderButtonView.swift
//  PennyPath
//
//  Created by Eren Akkoç on 5.10.2026.
//

import SwiftUI

struct HeaderButtonCard : View {
    @Binding var showAddSheet: Bool
    
    var body: some View{
        HStack {
            Text("Ana Sayfa")
                .font(.system(size: 32)).bold()
                .foregroundStyle(AppColor.primaryText)
            Spacer()
            Button("+ İşlem Ekle", action: {showAddSheet = true}).buttonStyle(.primary).cornerRadius(.cornerLarge)
        }
    }
}


#Preview {
    HeaderButtonCard(showAddSheet: .constant(false))
}

