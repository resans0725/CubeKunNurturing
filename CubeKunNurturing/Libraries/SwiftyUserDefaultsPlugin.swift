//
//  SwiftyUserDefaultsPlugin.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/04/01.
//

import Foundation
import SwiftyUserDefaults

// MARK: 飼育データ
extension DefaultsKeys {
    // 飼育日数
    var breedingDays: DefaultsKey<Int> {
        .init("breedingDays", defaultValue: 1)
    }
    
    // 満足度
    var satisfaction: DefaultsKey<Int> {
        .init("satisfaction", defaultValue: 0)
    }
    
    // 大きさ
    var cubeSize: DefaultsKey<Double> {
        .init("cubeSize", defaultValue: 0.5)
    }
    
    // 所持ゴールド
    var myGold: DefaultsKey<Int> {
        .init("myGold", defaultValue: 500)
    }
}


// MARK: 表示
extension DefaultsKeys {
   // 初回チュートリアル表示したか
    var isShowFirstTutorial: DefaultsKey<Bool> {
        .init("isShowFirstTutorial", defaultValue: false)
    }
}

// MARK: 1日1回実行
extension DefaultsKeys {
   // 初回チュートリアル表示したか
    var lastExecutionDate: DefaultsKey<String?> {
        .init("lastExecutionDate", defaultValue: nil)
    }
}
