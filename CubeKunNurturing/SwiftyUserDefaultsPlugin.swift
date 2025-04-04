//
//  SwiftyUserDefaultsPlugin.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/04/01.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKey {
    // 飼育日数
    var breedingDays: DefaultsKey<Int>{
        .init("breedingDays", defaultValue: 1)
    }
}
