//
//  TutorialView.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/04/04.
//

import SwiftUI
import SwiftyUserDefaults

struct TutorialView: View {
    @StateObject private var musicPlayer = MusicPlayer(selectedMusic: .tutorial)
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            Button(action: {
                musicPlayer.stopMusic()
                Defaults.isShowFirstTutorial = true
                GlobalViewModel.shared.switchMainView()
            }) {
                Text("Next MainView")
            }
        }
        .onAppear {
            musicPlayer.playMusic()
        }
    }
}

#Preview {
    TutorialView()
}
