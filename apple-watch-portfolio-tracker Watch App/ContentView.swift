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
        NavigationView {
            
            VStack {
                Text("Balance:")
                    .font(.headline)
                    .padding()
                Text("$\(Int(viewModel.balance))")
                    .font(.title)
                    .padding()
                
                NavigationLink(destination: WalletInfoView(viewModel: self.viewModel)){
                    Text("Wallet Information")
                }
                .padding()
            }
        }
    }
    
    
}


#Preview {
    ContentView()
}
