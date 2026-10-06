import SwiftUI
import SwiftData

struct TransactionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Transaction.date,order: .reverse)
    private var transactions: [Transaction]

    @State private var showAddSheet = false
    @State private var searchText = ""
    @State private var showEdit = false
    @State private var transactionToEdit: Transaction? = nil
    
    @State private var sortOrder = [KeyPathComparator(\Transaction.date, order: .reverse)]

    @State private var selectedTransactionIDs = Set<UUID>()
    
    var filteredTransactions: [Transaction] {
        if searchText.isEmpty { return transactions}
        else {
            return transactions.filter { transaction in
                let titleMatch = transaction.title.localizedCaseInsensitiveContains(searchText)
                let categoryMatch = transaction.category.rawValue.localizedCaseInsensitiveContains(searchText)
                let noteMatch = transaction.note?.localizedCaseInsensitiveContains(searchText) ?? false
                return titleMatch || categoryMatch || noteMatch
            }
        }
    }
    
    var sortedTransactions: [Transaction] {filteredTransactions.sorted(using: sortOrder)}
    
    

    
    var body: some View {
        Group {
            #if os(macOS)
            macOSLayout
            #else
            iOSLayout
            #endif
        }
        .environment(\.locale, Locale(identifier: "tr_TR"))
        .searchable(text: $searchText, placement: .toolbar, prompt: "İşlem, kategori veya not ara...")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    showAddSheet = true
                }) {
                    Label("Yeni İşlem", systemImage: "plus")
                }
                .help("Yeni bir işlem ekle")
            }
        }
        .sheet(isPresented: $showAddSheet) { AddTransactionView()}
        
    }
    
    private func deleteSelectedTransactions(ids: Set<UUID>) {
        for id in ids {
            if let transactionToDelete = transactions.first(where: { $0.id == id }) {
                modelContext.delete(transactionToDelete)
            }
        }
        selectedTransactionIDs.removeAll()
    }
}

// MARK: - macOS Layout
private extension TransactionsView {
    var macOSLayout: some View {
        VStack {
            /// HEADER
            Text("İşlemler")
                .font(.system(size: 32)).bold()
                .foregroundStyle(AppColor.primaryText)
            
            /// TABLE
            Table(sortedTransactions, selection: $selectedTransactionIDs, sortOrder: $sortOrder) {
                
                // 1. Tarih Sütunu
                TableColumn("Tarih", value: \.date) { transaction in
                    Text(transaction.date.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year()))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading) // Tüm hücre alanını kapla
                        .contentShape(Rectangle()) // Boşluklara tıklamayı algıla
                        .onTapGesture(count: 2) { transactionToEdit = transaction } // Çift tıklama
                }
                
                // 2. İşlem Sütunu
                TableColumn("İşlem", value: \.title) { transaction in
                    Text(transaction.title)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture(count: 2) { transactionToEdit = transaction }
                }
                
                // 3. Kategori Sütunu
                TableColumn("Kategori", value: \.category.rawValue) { transaction in
                    HStack {
                        Image(systemName: transaction.category.iconName)
                        Text(transaction.category.rawValue)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2) { transactionToEdit = transaction }
                }
                
                // 4. Tür Sütunu
                TableColumn("Tür", value: \.type.rawValue) { transaction in
                    Text(transaction.type.title)
                        .foregroundStyle(transaction.type == .income ? AppColor.income : AppColor.expense)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture(count: 2) { transactionToEdit = transaction }
                }
                
                // 5. Miktar Sütunu
                TableColumn("Miktar", value: \.amount) { transaction in
                    Text(transaction.amount.formatted(.currency(code: "TRY")))
                        .foregroundStyle(transaction.type == .income ? AppColor.income : AppColor.expense)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture(count: 2) { transactionToEdit = transaction }
                }
            }
            // Tablonun dışındaki gereksiz onTapGesture kaldırıldı!
            
            .contextMenu(forSelectionType: UUID.self) { items in
                if !items.isEmpty {
                    Button(role: .destructive) {
                        withAnimation {
                            deleteSelectedTransactions(ids: items)
                        }
                    } label: {
                        Label(items.count == 1 ? "Sil" : "\(items.count) İşlemi Sil", systemImage: "trash")
                    }
                }
            }
            .onDeleteCommand {
                if !selectedTransactionIDs.isEmpty {
                    withAnimation {
                        deleteSelectedTransactions(ids: selectedTransactionIDs)
                    }
                }
            }
            // Sheet'in konumu doğru, burada kalıyor.
            .sheet(item: $transactionToEdit) { tx in
                EditTransactionView(transaction: tx)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    TransactionsView()
}
