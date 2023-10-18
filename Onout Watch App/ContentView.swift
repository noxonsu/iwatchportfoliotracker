import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BalanceViewModel()

    @State private var showingInputDialog = false
    @State private var showWalletInputView = false

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
                        showWalletInputView = true
                    },
                    .default(Text("Enter on Watch")) {
                        // Logic for watch input (if any)
                    },
                    .cancel()
                ])
            }
            .sheet(isPresented: $showWalletInputView) {
                WalletInputView(viewModel: viewModel)
            }
            .padding()
        }
        .padding()
    }
}

struct WalletInputView: View {
    @ObservedObject var viewModel: BalanceViewModel
    @State private var inputString = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            TextField("Enter new wallet", text: $inputString, onCommit: {
                viewModel.updateWallet(wallet: inputString)
                dismiss()
            })
            .textFieldStyle(.roundedBorder)
            .padding()

            Button("Submit") {
                viewModel.updateWallet(wallet: inputString)
                dismiss()
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
