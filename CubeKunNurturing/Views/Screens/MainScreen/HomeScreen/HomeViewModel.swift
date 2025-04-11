//
//  HomeViewModel.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/04/04.
//

import Foundation
import SwiftyUserDefaults

final class HomeViewModel: ObservableObject {
    @Published var breedingDays: Int = Defaults.breedingDays
    @Published var cubeSize: Double = Defaults.cubeSize
    @Published var satisfaction: Int = Defaults.satisfaction
    @Published var myGold: Int = Defaults.satisfaction
   
    
    @Published var isObjectThrown = false
    @Published var cameraMode = false
    @Published var cleaningMode = false

    var globalViewModel: GlobalViewModel = .shared
    
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
    
    func addCubeSize() {
        Task { @MainActor in
            cubeSize += 0.0001
            Defaults.cubeSize += 0.0001
        }
    }
    
    func addSatisfaction() {
        Task { @MainActor in
            let maxSatisfaction = 100
            
            if satisfaction != maxSatisfaction {
                satisfaction += 5
                Defaults.satisfaction += 5
            }
        }
    }
}
