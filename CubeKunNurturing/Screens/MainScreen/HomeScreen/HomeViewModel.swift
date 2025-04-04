//
//  HomeViewModel.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/04/04.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var isObjectThrown = false
    @Published var cameraMode = false
    @Published var cleaningMode = false
    
    private var musicPlayer = MusicPlayer(selectedMusic: .home)
    
    init() {
        musicPlayer.playMusic()
    }
    
    func onTapCubeFood() {
        isObjectThrown.toggle()
    }
    
    func onTapClean() {
        cleaningMode.toggle()
    }
    
    func onTapCameraMode() {
        cameraMode.toggle()
    }
}
