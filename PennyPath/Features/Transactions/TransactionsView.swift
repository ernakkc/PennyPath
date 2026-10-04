import SwiftUI
import SwiftData

struct TransactionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        sort: \Transaction.date,
        order: .reverse
    )
    private var transactions: [Transaction]

    @State private var showAddSheet = false
    @State private var showEdit = false

    var body: some View {
        
        Group {
            
            #if os(macOS)
            macOSLayout
            #else
            iOSLayout
            #endif
        }
    }
}



// MARK: - macOS Layout
private extension TransactionsView {
    var macOSLayout: some View {
        Button("Transactions") {
            print("Tıklandı")
        }
        .buttonStyle(.primary)
        
    }
}



// MARK: - Preview

#Preview {
    TransactionsView()
}
