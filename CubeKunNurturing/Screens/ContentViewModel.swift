//
//  ContentViewModel.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/04/01.
//

import SwiftyUserDefaults
import SwiftUI

final class ContentViewModel: ObservableObject {
    init() {
        executeOncePerDay()
    }
    
    func executeOncePerDay() {
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        
        if let lastDate = Defaults.lastExecutionDate {
            if lastDate != today {
                performDailyTask()
                Defaults.lastExecutionDate = today  // 日付を更新
            }
        } else {
            Defaults.lastExecutionDate = today  // 初回の値をセット
        }
    }
    
    // 1日1回実行する処理
    func performDailyTask() {
        Defaults.breedingDays += 1
    }
}
