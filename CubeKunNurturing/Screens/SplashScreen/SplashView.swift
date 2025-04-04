//
//  SplashView.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/04/04.
//

import SwiftUI
import SwiftyUserDefaults

struct SplashView: View {
    
    var body: some View {
        Text("スプラッシュ")
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        if Defaults.isShowFirstTutorial {
                            GlobalViewModel.shared.switchMainView()
                        } else {
                            GlobalViewModel.shared.switchTutorialView()
                        }
                    }
                }
            }
    }
}
