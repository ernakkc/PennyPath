//
//  AddTransactionView.swift
//  PennyPath
//
//  Created by Assistant on 8.08.2026.
//

import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let transaction: Transaction

    @State private var title: String = ""
    @State private var amountText: String = ""
    @State private var date: Date = Date()
    @State private var type: TransactionType = .expense
    @State private var category: Category = .other
    @State private var note: String = ""
    
    init(transaction:Transaction) {
        self.transaction = transaction
        _title = State(initialValue: transaction.title)
        _amountText = State(initialValue: String(transaction.amount))
        _date = State(initialValue: transaction.date)
        _type = State(initialValue: transaction.type)
        _category = State(initialValue: transaction.category)
        _note = State(initialValue: transaction.note ?? "")
        
    }
    
    var body: some View {
        NavigationStack {
            #if os(iOS)
            iOSContent
            #else
            macOSContent
            #endif
        }
    }
}

// MARK: - iOS Layout
#if os(iOS)
private extension EditTransactionView {
    var iOSContent: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 20
            ) {
                amountCard
                typeSelector
                informationCard
                categorySection
                noteSection
                deleteSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background(AppColor.background)
        .navigationTitle("İşlemi Düzenle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Vazgeç") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                saveButton
            }
        }
    }
}
#endif

// MARK: - macOS Layout
private extension EditTransactionView {
    var macOSContent: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {
                    amountCard
                    typeSelector
                    informationCard
                    categorySection
                    noteSection
                }
                .frame(maxWidth: 620)
                .padding(28)
            }
            
            Divider()
            
            HStack {
                Button("Vazgeç") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                Spacer()
                saveButton
                    .keyboardShortcut(.defaultAction)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(AppColor.background)
        .frame(
            minWidth: 520,
            idealWidth: 620,
            minHeight: 600,
            idealHeight: 700
        )
        .navigationTitle("İşlem Ekle")
    }
}


// MARK: - Amount Card
private extension EditTransactionView {
    var amountCard: some View {
        VStack(
            alignment: .center,
            spacing: 8
        ) {
            Text(type == .expense ? "Harcama Tutarı" : "Gelir Tutarı")
                .font(AppFont.caption)
                .foregroundStyle(AppColor.secondaryText)
            HStack(
                alignment: .firstTextBaseline,
                spacing: 4
            ) {
                Text("₺")
                    .font(
                        .system(
                            size: 26,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(AppColor.accent)
                TextField(
                    "0,00",
                    text: $amountText
                )
                .font(
                    .system(
                        size: 42,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .multilineTextAlignment(.center)
                .textFieldStyle(.plain)
                .frame(maxWidth: 260)
                #if os(iOS)
                .keyboardType(.decimalPad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                #endif
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColor.backgroundSecondary)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    AppColor.border,
                    lineWidth: 1
                )
        }
    }
}

// MARK: - Type Selector
private extension EditTransactionView {
    var typeSelector: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            Text("İşlem Türü")
                .font(AppFont.caption)
                .foregroundStyle(AppColor.secondaryText)
            HStack(spacing: 10) {
                typeButton(
                    type: .expense,
                    title: "Gider",
                    icon: "arrow.down.circle.fill"
                )
                typeButton(
                    type: .income,
                    title: "Gelir",
                    icon: "arrow.up.circle.fill"
                )
            }
        }
    }
    
    func typeButton(
        type: TransactionType,
        title: String,
        icon: String
    ) -> some View {
        
        let isSelected = self.type == type
        
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.type = type
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(title)
                    .font(
                        .system(
                            size: 14,
                            weight: .semibold
                        )
                    )
            }
            .frame(maxWidth: .infinity)
            .frame(height: 46)
            .foregroundStyle(
                isSelected
                    ? .white
                    : AppColor.primaryText
            )
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected
                            ? AppColor.accent
                            : AppColor.backgroundSecondary
                    )
            }
            .overlay {
                if !isSelected {
                    RoundedRectangle(cornerRadius: 12)
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


// MARK: - Information Card
private extension EditTransactionView {
    var informationCard: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            Text("Bilgiler")
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
            VStack(
                alignment: .leading,
                spacing: 8
            ) {
                Text("Başlık")
                    .font(AppFont.caption)
                    .foregroundStyle(
                        AppColor.secondaryText
                    )
                TextField(
                    "Örn. Market alışverişi",
                    text: $title
                )
                .textFieldStyle(.plain)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.background)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            AppColor.border,
                            lineWidth: 1
                        )
                }
            }
            VStack(
                alignment: .leading,
                spacing: 8
            ) {
                
                Text("Tarih")
                    .font(AppFont.caption)
                    .foregroundStyle(
                        AppColor.secondaryText
                    )
                
                DatePicker(
                    "",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.background)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            AppColor.border,
                            lineWidth: 1
                        )
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColor.backgroundSecondary)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    AppColor.border,
                    lineWidth: 1
                )
        }
    }
}


// MARK: - Category

private extension EditTransactionView {
    
    var categorySection: some View {
        
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            
            Text("Kategori")
                .font(AppFont.caption)
                .foregroundStyle(
                    AppColor.secondaryText
                )
            
            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {
                
                HStack(spacing: 10) {
                    
                    ForEach(
                        Category.allCases,
                        id: \.self
                    ) { item in
                        
                        categoryButton(item)
                    }
                }
            }
        }
    }
    
    
    func categoryButton(
        _ item: Category
    ) -> some View {
        
        let isSelected = category == item
        
        return Button {
            
            withAnimation(.easeInOut(duration: 0.2)) {
                category = item
            }
            
        } label: {
            
            VStack(spacing: 6) {
                
                Image(
                    systemName: categoryIcon(
                        for: item
                    )
                )
                .font(.system(size: 17))
                
                Text(item.rawValue)
                    .font(
                        .system(
                            size: 11,
                            weight: isSelected
                                ? .semibold
                                : .regular
                        )
                    )
                    .lineLimit(1)
            }
            .frame(
                width: 76,
                height: 68
            )
            .foregroundStyle(
                isSelected
                    ? AppColor.accent
                    : AppColor.secondaryText
            )
            .background {
                
                RoundedRectangle(
                    cornerRadius: 12
                )
                .fill(
                    isSelected
                        ? AppColor.accent.opacity(0.12)
                        : AppColor.backgroundSecondary
                )
            }
            .overlay {
                
                RoundedRectangle(
                    cornerRadius: 12
                )
                .stroke(
                    isSelected
                        ? AppColor.accent.opacity(0.35)
                        : AppColor.border,
                    lineWidth: 1
                )
            }
        }
        .buttonStyle(.plain)
    }
    
    
    func categoryIcon(
        for category: Category
    ) -> String {
        
        switch category {
            
        case .food:
            return "fork.knife"
            
        case .transport:
            return "car.fill"
            
        case .shopping:
            return "bag.fill"
            
        case .entertainment:
            return "gamecontroller.fill"
            
        case .bills:
            return "doc.text.fill"
            
        case .health:
            return "heart.fill"
            
        case .investment:
            return "book.fill"
        
        case .salary:
            return "banknote.fill"
            
        case .other:
            return "ellipsis.circle.fill"
        }
    }
}


// MARK: - Note

private extension EditTransactionView {
    
    var noteSection: some View {
        
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            
            Text("Not")
                .font(AppFont.caption)
                .foregroundStyle(
                    AppColor.secondaryText
                )
            
            TextEditor(text: $note)
                .font(
                    .system(
                        size: 14
                    )
                )
                .scrollContentBackground(.hidden)
                .padding(10)
                .frame(minHeight: 100)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColor.backgroundSecondary)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            AppColor.border,
                            lineWidth: 1
                        )
                }
        }
    }
}


// MARK: - Save Button

private extension EditTransactionView {
    
    var isValid: Bool {
        
        !title
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty
        &&
        parsedAmount != nil
        &&
        parsedAmount! > 0
    }
    
    
    var parsedAmount: Double? {
        
        Double(
            amountText
                .replacingOccurrences(
                    of: ",",
                    with: "."
                )
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
        )
    }
    
    
    var saveButton: some View {
        
        Button("Kaydet") {
            saveChanges()
        }
        .buttonStyle(.borderedProminent)
        .tint(AppColor.accent)
        .disabled(!isValid)
    }
    
    func saveChanges() {
            let normalizedAmount =
                amountText
                    .replacingOccurrences(
                        of: ",",
                        with: "."
                    )
            guard let amount =
                    Double(normalizedAmount)
            else {return}

            transaction.title =
                title.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
            transaction.amount = amount
            transaction.date = date
            transaction.type = type
            transaction.category = category
            transaction.note = note
            
            do {
                try modelContext.save()
                dismiss()
            } catch {
                print(
                    "Transaction update error: \(error)"
                )
            }
    }
}

// MARK: -- Delete Section
private extension EditTransactionView {
    var deleteSection: some View {
        HStack {
            Button("Sil") {
                deleteTransaction(transaction: transaction, in: modelContext)
            }
            .buttonStyle(.borderedProminent)
            .background(AppColor.expense)
        }
    }
}


// MARK: - Preview

#Preview {
    AddTransactionView()
        .preferredColorScheme(.dark)
}
