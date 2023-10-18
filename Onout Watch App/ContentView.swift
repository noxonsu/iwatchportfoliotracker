import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BalanceViewModel()

    @State private var inputString = ""
    @State private var showingInputDialog = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text("Balance:")
                .font(.headline)
                .padding()
            Text("$\(Int(viewModel.balance))")
                .font(.title)
                .padding()

            Button("Add new wallet") {
                showingInputDialog = true
            }
            .actionSheet(isPresented: $showingInputDialog) {
                ActionSheet(title: Text("Choose input method"), buttons: [
                    .default(Text("Enter on iPhone")) {
                        // Present a view or a screen on iPhone for input
                    },
                    .default(Text("Enter on Watch")) {
                        // Here you can retain the existing logic or modify as needed for the watch input
                    },
                    .cancel()
                ])
            }
            .padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
