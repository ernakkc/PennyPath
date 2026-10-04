import SwiftUI
import SwiftData

struct RootView: View {
    @State private var selection: SidebarItem? = .dashboard
    
    var body: some View {

        #if os(iOS)
        TabView(selection: $selection) {
            NavigationStack {DashboardView()}
            .tabItem {
                Label(
                    SidebarItem.dashboard.title,
                    systemImage: SidebarItem.dashboard.systemImage
                )
            }
            .tag(SidebarItem.dashboard as SidebarItem?)
            
            NavigationStack {
                TransactionsView()
            }
            .tabItem {
                Label(
                    SidebarItem.transactions.title,
                    systemImage: SidebarItem.transactions.systemImage
                )
            }
            .tag(SidebarItem.transactions as SidebarItem?)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label(
                    SidebarItem.settings.title,
                    systemImage: SidebarItem.settings.systemImage
                )
            }
            .tag(SidebarItem.settings as SidebarItem?)
        }
        
        #else
        NavigationSplitView {
            SidebarView(
                selection: $selection
            )
            .navigationSplitViewColumnWidth(
                min: 180,
                ideal: 220,
                max: 280
            )
        } detail: {
            Group {
                switch selection {
                case .dashboard: DashboardView()
                case .transactions: TransactionsView()
                case nil: DashboardView()
                }
            }
            .frame(
                minWidth: 600,
                minHeight: 350
            )
        }
        .navigationSplitViewStyle(.prominentDetail)
        #endif
    }
}


// MARK: - Sidebar Item
enum SidebarItem: String, CaseIterable, Identifiable {
    case dashboard
    case transactions
    
    var id: String {rawValue}
    var title: String {
        
        switch self {
        case .dashboard: return "Kontrol Paneli"
        case .transactions: return "İşlemler"
        }
    }
    
    var systemImage: String {
        switch self {
        case .dashboard: return "house"
        case .transactions: return "list.bullet"
        }
    }
}

#Preview {
    RootView()
        .tint(AppColor.accent)
        .background(AppColor.background)
}
