//
//  AddTransactionView.swift
//  PennyPath
//
//  Created by Eren Akkoç on 6.10.2026.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var title: String = ""
    @State private var amountText: String = ""
    @State private var date: Date = Date()
    @State private var type: TransactionType = .expense
    @State private var category: Category = .other
    @State private var note: String = ""
    
    @FocusState var isAmountFocused: Bool
    
    private var isFormValid: Bool { !amountText.isEmpty && amountText != "0" && amountText != "0,00"}
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    /// TYPE SELECTOR
                    TypeSelectorView(selectedType: $type)
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    /// AMOUNT INPUT
                    AmountInputView(amountText: $amountText, type: type)
                        .focused($isAmountFocused)
                    
                    /// TITLE INPUT
                    TitleInputView(title: $title)
                        .padding(.horizontal)
                    
                    /// CATEGORY SELECTOR
                    CategorySelectorView(selectedCategory: $category)
                        .padding(.horizontal)
                    
                    // 4. Şık Tarih ve Not Alanları
                    VStack(spacing: 20) {
                        DateSelectorView(date: $date)
                        
                        NoteInputView(note: $note)
                    }
                    .padding(.horizontal)
                    
                    /// Kaydet Butonu
                    Button(action: saveTransaction) {
                            Text("İşlemi Kaydet")
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
        }
        .navigationTitle("Yeni İşlem")
        .toolbar {ToolbarItem(placement: .cancellationAction) {Button("İptal") { dismiss() }}}
            .onAppear {isAmountFocused = true}
            .onTapGesture {isAmountFocused = false}
    }
    private func saveTransaction() {
        let withoutGrouping = amountText.replacingOccurrences(of: ".", with: "")
        let cleanAmountString = withoutGrouping.replacingOccurrences(of: ",", with: ".")
        let amount = Decimal(string: cleanAmountString) ?? 0
        guard amount > 0 else { return }
        
        let newTransaction = Transaction(
            title: title.isEmpty ? category.rawValue : title,
            amount: amount,
            date: date,
            type: type,
            category: category,
            note: note.isEmpty ? nil : note
        )
        modelContext.insert(newTransaction)
        dismiss()
    }
}


//MARK: - TYPE SELECTOR
struct TypeSelectorView: View {
    @Binding var selectedType: TransactionType
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TransactionType.allCases, id: \.self) { buttonType in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                        selectedType = buttonType
                    }
                }) {
                    Text(buttonType.title)
                        .font(AppFont.title)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        // Seçili duruma göre yazı rengi değişimi
                        .foregroundStyle(selectedType == buttonType ? AppColor.background : AppColor.primaryText)
                        .background {
                            if selectedType == buttonType {
                                Capsule()
                                    .fill(Color.accentColor)
                                    .matchedGeometryEffect(id: "ActiveTab", in: animation)
                            }
                        }
                        .contentShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color.gray.opacity(0.15))
        .clipShape(Capsule())
    }
}

//MARK: - AMOUNT
struct AmountInputView: View {
    @Binding var amountText: String
    var type: TransactionType
    
    private let currencySymbol = Locale.current.currencySymbol ?? "₺"
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
    
                Text(currencySymbol)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(type == .income ? AppColor.income : AppColor.expense)
                
                TextField("0", text: $amountText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 56, weight: .bold))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: true, vertical: false)
                    .onChange(of: amountText) { oldValue, newValue in
                        let formatted = formatLiveCurrency(newValue)
                        if amountText != formatted { amountText = formatted}
                    }
            }
            .foregroundStyle(type == .income ? AppColor.income : AppColor.expense)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private func formatLiveCurrency(_ input: String) -> String {
            let decimalSeparator = "," // Kuruş ayracı
            let groupingSeparator = "." // Binlik ayracı
            var sanitizedInput = input
            if !sanitizedInput.contains(decimalSeparator) && sanitizedInput.hasSuffix(".") {
                sanitizedInput = String(sanitizedInput.dropLast()) + decimalSeparator
            }
            let stringWithoutGrouping = sanitizedInput.replacingOccurrences(of: groupingSeparator, with: "")
            let allowedCharacters = "0123456789\(decimalSeparator)"
            let filtered = stringWithoutGrouping.filter { allowedCharacters.contains($0) }
            if filtered.isEmpty { return "" }
            let parts = filtered.split(separator: Character(decimalSeparator), omittingEmptySubsequences: false)
            let integerString = String(parts[0])
            let digitsOnly = integerString.filter { $0.isNumber }
            guard let number = Int(digitsOnly) else { return filtered }
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = groupingSeparator
            formatter.decimalSeparator = decimalSeparator
            guard let formattedInteger = formatter.string(from: NSNumber(value: number)) else { return filtered }
            if parts.count > 1 {
                let decimalString = String(parts[1].prefix(2))
                return "\(formattedInteger)\(decimalSeparator)\(decimalString)"
            } else if filtered.hasSuffix(decimalSeparator) {
                return "\(formattedInteger)\(decimalSeparator)"
            }
            return formattedInteger
        }
}

//MARK - TITLE INPUT
struct TitleInputView: View {
    @Binding var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Başlık")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            
            HStack {
                Image(systemName: "tag")
                    .foregroundStyle(Color.accentColor)
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 24)
                
                TextField("İşlem adı (Örn: Market alışverişi)", text: $title)
                    .textFieldStyle(.plain) // macOS beyaz kutusunu gizle
                    .font(.body)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.gray.opacity(0.1))
            }
        }
    }
}


//MARK: - CATEGORY PICKER
struct CategorySelectorView: View {
    @Binding var selectedCategory: Category
    
    let columns = [
        GridItem(.adaptive(minimum: 60, maximum: 100), spacing: 12)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Kategori")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(Category.allCases) { category in
                    Button(action: {
                        withAnimation(.snappy) {
                            selectedCategory = category
                        }
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: category.iconName)
                                .font(.system(size: 20, weight: .medium))
                            
                            Text(category.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 4)
                        .foregroundStyle(selectedCategory == category ? .white : .primary)
                        .background {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(selectedCategory == category ? Color.accentColor : Color.gray.opacity(0.1))
                        }
                        .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}


// MARK: - DATE PICKER
struct DateSelectorView: View {
    @Binding var date: Date
    @State private var showPicker: Bool = false
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tarih")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            
            Button(action: {
                showPicker.toggle()
            }) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(Color.accentColor)
                        .font(.system(size: 18, weight: .medium))
                        .frame(width: 24)
                    
                    Text(formattedDate)
                        .font(.body)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.gray.opacity(0.1))
                }
                .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showPicker, arrowEdge: .bottom) {
                VStack {
                    DatePicker(
                        "Tarih Seç",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                }
                .padding(16)
                .frame(width: 280)
            }
        }
    }
}

// MARK: - NOTE INPUT
struct NoteInputView: View {
    @Binding var note: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Not (Opsiyonel)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            
            HStack(alignment: .top) {
                Image(systemName: "pencil.and.list.clipboard")
                    .foregroundStyle(Color.accentColor)
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 24)
                    .padding(.top, 2)
                
                TextField("Bu işlemle ilgili bir açıklama yazın...", text: $note, axis: .vertical) // axis:.vertical ile metin uzarsa alt satıra geçer
                    .textFieldStyle(.plain)
                    .font(.body)
                    .lineLimit(1...3)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.gray.opacity(0.1))
            }
        }
    }
}


#Preview {
    AddTransactionView()
}
