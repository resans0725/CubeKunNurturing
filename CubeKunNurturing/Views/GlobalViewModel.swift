//
//  GlobalViewModel.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/04/04.
//

import Foundation
import SwiftyUserDefaults

extension GlobalViewModel {
    enum ContentViewType {
        case splashView
        case tutorialView
        case mainView
    }
}

final class GlobalViewModel: ObservableObject {
    static let shared: GlobalViewModel = .init()
    @Published private(set) var viewType: ContentViewType = .splashView
    @Published private(set) var breedingDays: Int = Defaults.breedingDays
    @Published private(set) var cubeSize: Double = Defaults.cubeSize
    @Published private(set) var satisfaction: Int = Defaults.satisfaction
    @Published private(set) var myGold: Int = Defaults.satisfaction
    
    
    func switchSplashView() {
        Task { @MainActor in
            viewType = .splashView
        }
    }
    
    func switchTutorialView() {
        Task { @MainActor in
            viewType = .tutorialView
        }
    }
    
    func switchMainView() {
        Task { @MainActor in
            viewType = .mainView
        }
    }
}
