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
            HStack {
                Text("Ana Sayfa")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button("+ İşlem Ekle", action: {showAddSheet = true}).buttonStyle(.borderedProminent)
            }
            
            HStack {
                
            }
            .padding(16)
            .sheet(isPresented: $showAddSheet) {
                
            }
            .ignoresSafeArea(.container, edges: .top)
        }
    }
}


/*
struct DashboardView: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @Environment(\.verticalSizeClass) private var vSizeClass
    @State private var selectedPeriod: Period = .month
    @State private var showAddSheet = false
    @State private var showSearch = false
    @State private var showFilters = false

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

private extension DashboardView {
    // MARK: - Header Bar (Common)
    var headerBar: some View {
        HStack(alignment: .center, spacing: Spacing.md) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: Spacing.sm) {
                    Text("Dashboard")
                        .font(AppFont.title)
                        .bold()
                    periodChips
                }
                Text("Akıllı • Basit • Şeffaf")
                    .font(AppFont.caption)
                    .foregroundStyle(AppColor.secondaryText)
                    .accessibilityHidden(true)
            }

            Spacer()

            HStack(spacing: Spacing.sm) {
                headerIcon(systemName: "magnifyingglass", action: openSearch)
                headerIcon(systemName: "line.3.horizontal.decrease.circle", action: openFilters)
                ButtonComp(title: "İşlem Ekle", action: { showAddSheet = true }, systemImage: "plus")
                    .accessibilityLabel(Text("İşlem ekle"))
                    .frame(maxWidth: 240)
            }
        }
        .padding(.vertical, Spacing.xs)
    }

    var periodChips: some View {
        HStack(spacing: 6) {
            ForEach(Period.allCases, id: \.self) { period in
                let isSelected = period == selectedPeriod
                Text(period.title)
                    .font(AppFont.caption)
                    .foregroundStyle(isSelected ? .white : AppColor.secondaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(isSelected ? AppColor.accent : AppColor.backgroundSecondary)
                    )
                    .overlay(
                        Capsule().stroke(AppColor.border, lineWidth: isSelected ? 0 : 1)
                    )
                    .onTapGesture { selectedPeriod = period }
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .accessibilityLabel(Text("Dönem seçimi"))
    }

    @ViewBuilder
    func headerIcon(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppColor.primaryText)
                .frame(width: 36, height: 36)
                .background(AppColor.backgroundSecondary, in: Circle())
                .overlay(Circle().stroke(AppColor.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Actions (placeholders)
    func addTransaction() {
        // TODO: Implement navigation to add transaction flow
    }

    func openSearch() {
        // TODO: Implement search presentation
        showSearch = true
    }

    func openFilters() {
        // TODO: Implement filter sheet
        showFilters = true
    }

    func openSettings() {
        // TODO: Implement settings navigation
    }

    // MARK: - macOS Layout
    var macOSLayout: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: Spacing.md) {
                headerBar
                    .padding(.top, Spacing.sm)

                BalanceCard()

                HStack(spacing: Spacing.md) {
                    IncomingCard()
                    ExpenseCard()
                }

                Spacer(minLength: 0)
            }
            .padding(Spacing.sm)

            Divider()
                .padding(.vertical, Spacing.sm)

            // Right column: Last Transactions
            VStack(alignment: .leading, spacing: Spacing.md) {
                LastTransactions()
                Spacer(minLength: 0)
            }
            .frame(minWidth: 360)
            .padding(Spacing.sm)
        }
        .sheet(isPresented: $showAddSheet) {
            AddTransactionView()
        }
    }
}

#if os(iOS)
private extension DashboardView {
    // MARK: - iOS / iPadOS Layout
    var iOSLayout: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    headerBar
                        .padding(.top, Spacing.sm)

                    // Content Grid
                    VStack(spacing: Spacing.md) {
                        BalanceCard()

                        HStack(spacing: Spacing.md) {
                            IncomingCard()
                            ExpenseCard()
                        }

                        LastTransactions()
                    }
                }
                .padding(.horizontal, Spacing.sm)
                .padding(.bottom, Spacing.md)
            }
            .sheet(isPresented: $showAddSheet) {
                AddTransactionView()
            }
        }
    }
}
#endif

private extension DashboardView {
    // MARK: - Period Enum
    enum Period: CaseIterable {
        case day, week, month, year, all

        var title: String {
            switch self {
            case .day: return "Bugün"
            case .week: return "Hafta"
            case .month: return "Bu Ay"
            case .year: return "Bu Yıl"
            case .all: return "Tümü"
            }
        }
    }
}
*/
#Preview {
    DashboardView()
}
