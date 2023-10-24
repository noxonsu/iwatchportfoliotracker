//
//  BalanceModel.swift
//  apple-watch-portfolio-tracker Watch App
//
//  Created by Никита Иванов on 24.10.2023.
//

import Foundation

struct BalanceModel: Codable {
    let totalUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalUsd = "total_usd"
    }
}
