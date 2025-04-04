//
//  ContentViewModel.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/04/01.
//

import SwiftyUserDefaults
import SwiftUI

final class ContentViewModel: ObservableObject {
    @Published  private var lastExecutionDate: String? = Defaults.lastExecutionDate
    
    func executeOncePerDay() {
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        
        if let lastDate = lastExecutionDate {
            if lastDate != today {
                performDailyTask()
                lastExecutionDate = today  // 日付を更新
            }
        } else {
            // 初回起動時も実行
            performDailyTask()
            lastExecutionDate = today  // 初回の値をセット
        }
    }
    
    // 1日1回実行する処理
    func performDailyTask() {
        print("1日1回の処理を実行")
        // ここに実行したい処理を書く
    }
}
