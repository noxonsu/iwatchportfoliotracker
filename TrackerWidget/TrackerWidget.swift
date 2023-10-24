//
//  Widget.swift
//  Widget
//
//  Created by Никита Иванов on 03.10.2023.
//

import WidgetKit
import SwiftUI

struct BalanceWidgetEntry: TimelineEntry {
    let date: Date
    let balance: Double
}

struct BalanceWidgetProvider: TimelineProvider {
    typealias Entry = BalanceWidgetEntry
    private var viewModel = BalanceViewModel()
    
    
    func placeholder(in context: Context) -> BalanceWidgetEntry {
        BalanceWidgetEntry(date: Date(), balance: 10000.0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BalanceWidgetEntry) -> Void) {
        let currentDate = Date()
        
        viewModel.fetchBalance{ totalUsd in
            let entry = BalanceWidgetEntry(date: currentDate, balance: totalUsd)
            
            completion(entry)
        }
        
       
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BalanceWidgetEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        viewModel.fetchBalance{ totalUsd in
            
            let entry = BalanceWidgetEntry(date: currentDate, balance: viewModel.balance)
            
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
     
    }
}

struct BalanceWidgetView: View {
    var entry: BalanceWidgetProvider.Entry
    
    var body: some View {
        VStack{
            Spacer()
            Image("icon")
                .resizable()
                .frame(width: 10, height: 10)
            Text("$\(formatInt(number: Int(entry.balance)))")
                .font(.system(size: 16))
                .bold()
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            Spacer()
            Spacer()

            
        }
         


        
    }
    
    func formatInt(number: Int) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        let suffixes = ["", "k", "M", "B", "T"]
        var suffixIndex = 0
        var value = Double(number)
        while value >= 1000 && suffixIndex < suffixes.count - 1 {
            value /= 1000
            suffixIndex += 1
        }
        let formattedNumber = formatter.string(from: NSNumber(value: value)) ?? ""
        let suffix = suffixes[suffixIndex]
        let result = "\(formattedNumber)\(suffix)"
        return result
    }
}

@main
struct BalanceWidget: Widget {
    let kind: String = "BalanceWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BalanceWidgetProvider()) { entry in
            BalanceWidgetView(entry: entry)
        }
        .configurationDisplayName("Balance Widget")
        .description("Displays the balance from the Onout app.")
    
    }
}

struct BalanceWidget_Previews: PreviewProvider {
    static var previews: some View {
        BalanceWidgetView(entry: BalanceWidgetEntry(date: Date(), balance: 100.0))
           
    }
}
