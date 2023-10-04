//
//  ContentView.swift
//  Onout Watch App
//
//  Created by Никита Иванов on 03.10.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BalanceViewModel()

    @State private var inputString = ""
    @State private var showingInputDialog = false
    
    var body: some View {
        VStack {
            Text("Balance:")
                .font(.headline)
                .padding()
            Text("$\(Int(viewModel.balance))")
                .font(.title)
                .padding()
            
            TextField("Enter new wallet", text: $inputString, onCommit: {
                viewModel.updateWallet(wallet: inputString)
                
            })
            .textFieldStyle(.plain)
    
            .padding()
        }
    }
}


#Preview {
    ContentView()
}
