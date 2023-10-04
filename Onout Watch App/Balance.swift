//
//  Balance.swift
//  Onout Watch App
//
//  Created by Никита Иванов on 03.10.2023.
//

import Foundation

struct Balance: Codable {
    let totalUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalUsd = "total_usd"
    }
}
