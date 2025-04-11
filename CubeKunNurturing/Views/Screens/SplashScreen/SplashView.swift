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
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("育ててキューブくん")
                    .foregroundColor(.white)
                    .font(.system(size: 20).bold())
                Image(.cubeKun)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
        }
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
