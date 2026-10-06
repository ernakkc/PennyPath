//
//  EditTransactionView.swift
//  PennyPath
//
//  Created by Eren Akkoç on 6.10.2026.
//


import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let transaction: Transaction
    
    @State private var title: String
    @State private var amountText: String
    @State private var date: Date
    @State private var type: TransactionType
    @State private var category: Category
    @State private var note: String
    
    @FocusState var isAmountFocused: Bool
    
    private var isFormValid: Bool { !amountText.isEmpty && amountText != "0" && amountText != "0,00" }
    
    init(transaction: Transaction) {
        self.transaction = transaction
        
        _title = State(initialValue: transaction.title)
        _date = State(initialValue: transaction.date)
        _type = State(initialValue: transaction.type)
        _category = State(initialValue: transaction.category)
        _note = State(initialValue: transaction.note ?? "")
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        
        let formattedAmount = formatter.string(from: transaction.amount as NSDecimalNumber) ?? "0"
        _amountText = State(initialValue: formattedAmount)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    TypeSelectorView(selectedType: $type)
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    AmountInputView(amountText: $amountText, type: type)
                        .focused($isAmountFocused)
                    
                    TitleInputView(title: $title)
                        .padding(.horizontal)
                    
                    CategorySelectorView(selectedCategory: $category)
                        .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        DateSelectorView(date: $date)
                        NoteInputView(note: $note)
                    }
                    .padding(.horizontal)
                    
                    Button(action: updateTransaction) {
                        Text("Değişiklikleri Kaydet")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(isFormValid ? Color.accentColor : Color.gray.opacity(0.2))
                            .foregroundStyle(isFormValid ? .white : .secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .disabled(!isFormValid)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                }
                .padding(.bottom, 24)
            }
            .navigationTitle("İşlemi Düzenle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { dismiss() }
                }
            }
        }
        .frame(minWidth: 400, idealWidth: 450, minHeight: 700)
    }
    
    private func updateTransaction() {
        let withoutGrouping = amountText.replacingOccurrences(of: ".", with: "")
        let cleanAmountString = withoutGrouping.replacingOccurrences(of: ",", with: ".")
        let amount = Decimal(string: cleanAmountString) ?? 0
        guard amount > 0 else { return }
        
        // Yeni kayıt açmak (insert) yerine, elimizdeki objenin değerlerini değiştiriyoruz
        transaction.title = title.isEmpty ? category.rawValue : title
        transaction.amount = amount
        transaction.date = date
        transaction.type = type
        transaction.category = category
        transaction.note = note.isEmpty ? nil : note
        
        dismiss()
    }
}
