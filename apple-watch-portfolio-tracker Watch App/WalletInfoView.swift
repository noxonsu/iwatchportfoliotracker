//
//  WalletInfoView.swift
//  apple-watch-portfolio-tracker Watch App
//
//  Created by Никита Иванов on 24.10.2023.
//

import SwiftUI
import WatchKit
import EFQRCode



struct WalletInfoView: View {
    @ObservedObject  var viewModel: BalanceViewModel
    @State private var inputString = ""
    @State private var showingInputDialog = false
    
    
    
    
    var body: some View {
        ScrollView{
            VStack {
                
                Text(viewModel.wallet)
                    .allowsTightening(true)
                    .font(.system(size: 12))
                    .padding()
                
                
                
                TextField("Enter new Address", text: $inputString, onCommit: {
                    viewModel.updateWallet(wallet: inputString)
                    
                })
                .textFieldStyle(.plain)
                Text("or")
                NavigationLink(destination: QRCodeView(viewModel: self.viewModel)) {
                    Text("Input New by QR Code")
                }
                
                
            }
        }
        .navigationTitle("Your Address")
    }
    
    
    
    
    
}

struct QRCodeView: View {
    
    @ObservedObject  var viewModel: BalanceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private let uuidString = UUID().uuidString
    
    var body: some View {
        VStack {
            Text("Scan via Phone")
            Image(uiImage: generateQRCode(from: uuidString))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
        }
        .onAppear(){
            viewModel.updateWalletByUUID(uuid: uuidString, completion: {wallet in
                DispatchQueue.main.async {
                    viewModel.updateWallet(wallet: wallet?.address ?? "")
                    presentationMode.wrappedValue.dismiss()
                }
                
            })
        }
    }
    
    
    func generateQRCode(from string: String) -> UIImage {
        let content = "https://tracker.onout.org/?a=form&uuid=\(string)"
        let generator = EFQRCodeGenerator(content: content)
        generator.withMode(Optional.none)
        do {
            let image =  generator.generate()!
            return UIImage(cgImage: image)
        } catch {
            print(error.localizedDescription)
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }
    }
}

#Preview {
    WalletInfoView(viewModel: BalanceViewModel())
}
