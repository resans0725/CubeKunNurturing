//
//  HomeView.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/04/04.
//

import SwiftUI
import SceneKit

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack {
            SceneKitView(
                isObjectThrown: $viewModel.isObjectThrown,
                cameraMode: $viewModel.cameraMode,
                cleaningMode: $viewModel.cleaningMode,
                cubeSize: $viewModel.cubeSize,
                addCubeSize: viewModel.addCubeSize,
                addSatisfaction: viewModel.addSatisfaction
            )
            .edgesIgnoringSafeArea(.all)
            .overlay(alignment: .top, content: {
                HStack(spacing: 20) {
                    VStack {
                        Text("飼育日数")
                        Text("\(viewModel.breedingDays)日目")
                    }
                    
                    VStack {
                        Text("満足度")
                        Text("\(viewModel.satisfaction)%")
                    }
                    
                    VStack {
                        Text("大きさ")
                        Text("\(viewModel.cubeSize)cm")
                    }
                }
            })
            .overlay(alignment: .bottom) {
                    HStack {
                        Button("ごはん") {
                            viewModel.onTapCubeFood()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("お掃除") {
                            viewModel.onTapClean()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button(viewModel.cameraMode ? "飼育モード": "観察モード") {
                            viewModel.onTapCameraMode()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                }
        }
    }
}



