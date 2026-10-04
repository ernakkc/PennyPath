import SwiftUI
import SwiftData

struct TransactionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        sort: \Transaction.date,
        order: .reverse
    )
    private var transactions: [Transaction]

    @State private var selectedPeriod: Period = .all
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


// MARK: - iOS Layout
#if os(iOS)
private extension TransactionsView {
    var iOSLayout: some View {
        NavigationStack {
            
            List {
                
                // Header
                Section {
                    mobileHeader
                        .listRowInsets(
                            EdgeInsets(
                                top: 8,
                                leading: 16,
                                bottom: 8,
                                trailing: 16
                            )
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                
                // Periods
                Section {
                    periodChips
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .listRowInsets(
                            EdgeInsets(
                                top: 0,
                                leading: 16,
                                bottom: 12,
                                trailing: 16
                            )
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                
                // Transactions
                Section {
                    ForEach(
                        filteredTransactions,
                        id: \.id
                    ) { transaction in
                        
                        TransactionCard(
                            transaction: transaction
                        )
                        .onTapGesture {
                            showEdit = true
                        }
                        .sheet(isPresented: $showEdit) {EditTransactionView(transaction: transaction)}
                        .listRowInsets(
                            EdgeInsets(
                                top: 8,
                                leading: 16,
                                bottom: 8,
                                trailing: 16
                            )
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .swipeActions(
                            edge: .trailing,
                            allowsFullSwipe: false
                        ) {
                            
                            Button(role: .destructive) {
                                deleteTransaction(
                                    transaction: transaction,
                                    in: modelContext
                                )
                            } label: {
                                Label(
                                    "Sil",
                                    systemImage: "trash"
                                )
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(AppColor.background)
            .navigationTitle("İşlemler")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showAddSheet) {
            AddTransactionView()
        }
    }
}


// MARK: - macOS Layout
#else
private extension TransactionsView {
    
    var macOSLayout: some View {
        
        VStack(
            alignment: .leading,
            spacing: Spacing.md
        ) {
            
            headerBar
                .padding(.top, Spacing.sm)
            
            ScrollView {
                listContent
            }
        }
        .padding(Spacing.sm)
        .sheet(isPresented: $showAddSheet) {
            AddTransactionView()
        }
    }
}
#endif

// MARK: - Mobile Header

private extension TransactionsView {
    
    var mobileHeader: some View {
        
        HStack(alignment: .center) {
            
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                
                Text("İşlemler")
                    .font(AppFont.title)
                    .bold()
                
                Text("Tüm işlemlerin listesi")
                    .font(AppFont.caption)
                    .foregroundStyle(
                        AppColor.secondaryText
                    )
            }
            
            Spacer()
            
            Button {
                showAddSheet = true
            } label: {
                
                Image(systemName: "plus")
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.white)
                    .frame(
                        width: 40,
                        height: 40
                    )
                    .background(
                        Circle()
                            .fill(AppColor.accent)
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("İşlem Ekle")
        }
    }
}


// MARK: - macOS Header

private extension TransactionsView {
    
    var headerBar: some View {
        
        HStack(spacing: Spacing.md) {
            
            VStack(
                alignment: .leading,
                spacing: 6
            ) {
                
                HStack(spacing: Spacing.sm) {
                    
                    Text("İşlemler")
                        .font(AppFont.title)
                        .bold()
                    
                    periodChips
                }
                
                Text("Tüm işlemlerin listesi")
                    .font(AppFont.caption)
                    .foregroundStyle(
                        AppColor.secondaryText
                    )
            }
            
            Spacer()
            
            Button(
                "İşlem Ekle",
                systemImage: "plus"
            ) {
                showAddSheet = true
            }
            .frame(maxWidth: 140)
            .buttonStyle(.borderedProminent)
            .tint(AppColor.accent)
        }
        .padding(.vertical, Spacing.xs)
    }
}


// MARK: - Period Chips

private extension TransactionsView {
    
    var periodChips: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(spacing: 8) {
                
                ForEach(
                    Period.allCases,
                    id: \.self
                ) { period in
                    
                    let isSelected =
                        selectedPeriod == period
                    
                    Button {
                        
                        withAnimation(
                            .easeInOut(duration: 0.2)
                        ) {
                            selectedPeriod = period
                        }
                        
                    } label: {
                        
                        Text(period.title)
                            .font(
                                .system(
                                    size: 13,
                                    weight: isSelected
                                        ? .semibold
                                        : .regular
                                )
                            )
                            .foregroundStyle(
                                isSelected
                                    ? .white
                                    : AppColor.secondaryText
                            )
                            .padding(.horizontal, 13)
                            .frame(height: 32)
                            .background {
                                
                                Capsule()
                                    .fill(
                                        isSelected
                                            ? AppColor.accent
                                            : AppColor.backgroundSecondary
                                    )
                            }
                            .overlay {
                                
                                if !isSelected {
                                    Capsule()
                                        .stroke(
                                            AppColor.border,
                                            lineWidth: 1
                                        )
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}


// MARK: - Filter Transactions

private extension TransactionsView {
    
    var filteredTransactions: [Transaction] {
        
        switch selectedPeriod {
            
        case .day:
            return transactions.filter {
                Calendar.current.isDateInToday($0.date)
            }
            
        case .week:
            guard let weekAgo =
                    Calendar.current.date(
                        byAdding: .day,
                        value: -7,
                        to: Date()
                    )
            else {
                return transactions
            }
            
            return transactions.filter {
                $0.date >= weekAgo
            }
            
        case .month:
            guard let monthAgo =
                    Calendar.current.date(
                        byAdding: .month,
                        value: -1,
                        to: Date()
                    )
            else {
                return transactions
            }
            
            return transactions.filter {
                $0.date >= monthAgo
            }
            
        case .year:
            guard let yearAgo =
                    Calendar.current.date(
                        byAdding: .year,
                        value: -1,
                        to: Date()
                    )
            else {
                return transactions
            }
            
            return transactions.filter {
                $0.date >= yearAgo
            }
            
        case .all:
            return transactions
        }
    }
}


// MARK: - List Content

private extension TransactionsView {
    
    @ViewBuilder
    var listContent: some View {
        
        if filteredTransactions.isEmpty {
            
            ContentUnavailableView(
                "Henüz İşlem Yok",
                systemImage: "receipt",
                description: Text(
                    "İşlem ekleyerek başlayın."
                )
            )
            .frame(
                maxWidth: .infinity,
                minHeight: 300
            )
            
        } else {
            
            LazyVStack(
                alignment: .leading,
                spacing: 0
            ) {
                
                ForEach(
                    filteredTransactions,
                    id: \.id
                ) { transaction in
                    
                    TransactionCard(
                        transaction: transaction
                    )
                    
                    if transaction.id !=
                        filteredTransactions.last?.id {
                        
                        Divider()
                            .foregroundStyle(
                                AppColor.divider
                            )
                            .padding(.vertical, 8)
                    }
                }
            }
        }
    }
}


// MARK: - Preview

#Preview {
    TransactionsView()
}
