//
//  Copyright  All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject private var viewModel = HomeViewModel()
    @State var showAlert: Bool = false
    @State private var toast: CoolToastData? = nil
    var body: some View {
        NavigationView {
            List {
                // MARK: Custom Menu
//
//                HStack {
//                    Text(NSLocalizedString("jailbroken-status", comment: "Jailbroken Status"))
//                    Spacer()
//                    Text(viewModel.isJailBroken ? "Broken" : "Not Broken")
//                        .foregroundColor(viewModel.isJailBroken ? Color(.systemRed) : Color(.systemGreen))
//                }
//
//                // MARK: Custom Menu
//
//                Button {
//                    fatalError("Hello, Crashed!")
//                } label: {
//                    Text("Crash App 💥")
//                }
//                .foregroundColor(Color.theme.black)
//
//                // MARK: Custom Menu
//
//                Button {
//                    UNUserNotificationCenter.current().sendDummyNotification()
//                } label: {
//                    Text("Push Notification 🔔")
//                }
//                .foregroundColor(Color.theme.black)
//
//                // MARK: Screens
//
//                ForEach(Screen.screens) { screen in
//                    NavigationLink {
//                        screen.destination
//                            .if(screen.showTitle, transform: { view in
//                                view.navigationTitle(screen.name)
//                            })
//                    } label: {
//                        Text(screen.name)
//                    }
//                }
                Button{
                    toast = CoolToastData(
                        icon: "",
                        iconColor: .systemRed,
                        message: "Process complete",
                        type: .success,
                        anchor: .trailing
                    )
                }label: {
                    Text("success")
                }
                
                Button{
                    toast = CoolToastData(
                        icon: "",
                        iconColor: .systemRed,
                        message: "This is an information",
                        type: .info,
                        anchor: .trailing
                    )
                }label: {
                    Text("info")
                }
                Button{
                    
                    toast = CoolToastData(
                        icon: "",
                        iconColor: .systemRed,
                        message: "This is a error",
                        type: .error,
                        anchor: .top
                    )
                    
                }label: {
                    Text("error")
                }
                Button{
                    toast = CoolToastData(
                        icon: "",
                        iconColor: .systemRed,
                        message: "This is a warning",
                        type: .warning,
                        anchor: .top
                    )

                    
                }label: {
                    Text("warning")
                }
                
                Button{
                    toast = CoolToastData(
                        icon: "",
                        iconColor: .systemRed,
                        message: "This is a warning",
                        type: .regular,
                        anchor: .top
                    )
                    
                }label: {
                    Text("regular")
                }
               
                
                
            }
            .fontStyle(size: 16)
            .navigationTitle("Why Not SwiftUI!")
            . coolToast(data:$toast, padding: 0 )
        }
        .navigationViewStyle(.stack)
        .onAppear {
            // viewModel.getPosts()
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .previewDevice("iPhone 14 Pro Max")

        MainScreen()
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
