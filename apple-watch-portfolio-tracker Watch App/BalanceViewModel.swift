//
//  BalanceViewModel.swift
//  Onout Watch App
//
//  Created by Никита Иванов on 03.10.2023.
//

import Foundation

class BalanceViewModel: ObservableObject {
    @Published var balance = 0.0
    @Published var wallet = ""
    
    struct Wallet: Codable {
        let address: String
    }
    
    
    init() {
        self.wallet = UserDefaults.standard.string(forKey: "wallet") ?? "0x873351e707257C28eC6fAB1ADbc850480f6e0633"
        self.balance = UserDefaults.standard.double(forKey: "balance")
        fetchBalance()
    }
    
    func updateWallet(wallet: String) {
        UserDefaults.standard.set(wallet, forKey: "wallet")
        self.wallet = wallet
        fetchBalance()
    }
    
    
    func fetchBalance() {
        self.wallet = UserDefaults.standard.string(forKey: "wallet") ?? "0x873351e707257C28eC6fAB1ADbc850480f6e0633"
        
        guard let url = URL(string: "https://dashapi.onout.org/debank?address=\(self.wallet)&app=itracker") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let dict = json as? [String: Any], let totalUsd = dict["total_usd"] as? Double {
                    DispatchQueue.main.async {
                        self.balance = totalUsd
                        UserDefaults.standard.set(totalUsd, forKey: "balance")
                        
                        
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchBalance(completion: @escaping (Double) -> Void) {
        
        self.wallet = UserDefaults.standard.string(forKey: "wallet") ?? "0x873351e707257C28eC6fAB1ADbc850480f6e0633"
        
        
        guard let url = URL(string: "https://dashapi.onout.org/debank?address=\(self.wallet)&app=itracker") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let dict = json as? [String: Any], let totalUsd = dict["total_usd"] as? Double {
                    DispatchQueue.main.async {
                        self.balance = totalUsd
                        UserDefaults.standard.set(totalUsd, forKey: "balance")
                        completion(totalUsd)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
    
    func updateWalletByUUID(uuid: String, completion: @escaping (Wallet?) -> Void) {
        let urlString = "https://tracker.onout.org/?a=getwallet&uuid=\(uuid)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.updateWalletByUUID(uuid: uuid, completion: completion)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.updateWalletByUUID(uuid: uuid, completion: completion)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let wallet = try decoder.decode(Wallet.self, from: data)
                UserDefaults.standard.set(wallet.address, forKey: "wallet")
                self.wallet = wallet.address
                completion(wallet)
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.updateWalletByUUID(uuid: uuid, completion: completion)
                }
            }
        }
        task.resume()
    }
}
