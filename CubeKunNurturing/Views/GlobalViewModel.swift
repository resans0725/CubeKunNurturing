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
