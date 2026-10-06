//
//  DashboardView.swift
//  PennyPath
//
//  Created by Eren Akkoç on 7.08.2026.
//

import SwiftUI


struct DashboardView: View {
    @State private var showAddSheet = false
    
    var body: some View {
        Group {
            #if os(macOS)
            macosLayout
            #else
            iosLayout
            #endif
        }
    }
}


private extension DashboardView {
    var macosLayout: some View {
        VStack {
            
            HeaderButtonCard(showAddSheet: $showAddSheet)
            HStack {
                VStack {
                    GraphCard()
                    
                    HStack {
                        IncomeCard()
                        ExpenseCard()
                    }
                }
                TodayTransactions()
            }
            
            .padding(16)
            .sheet(isPresented: $showAddSheet) {
                AddTransactionView()
            }
            .ignoresSafeArea(.container, edges: .top)
        }
    }
}


#Preview {
    DashboardView()
        .background(AppColor.background)
}
