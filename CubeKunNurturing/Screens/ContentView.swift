//
//  ContentView.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/03/31.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var globalViewModel: GlobalViewModel
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        screens
    }
    
    @ViewBuilder
    private var screens: some View {
        switch globalViewModel.viewType {
        case .splashView:
            SplashView()
        case .tutorialView:
            TutorialView()
        case .mainView:
            HomeView()
        }
    }
}
