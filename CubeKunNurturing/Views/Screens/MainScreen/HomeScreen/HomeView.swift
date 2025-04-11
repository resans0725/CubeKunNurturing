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
        contentView
    }
    
    var contentView: some View {
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
                topMenuView
            })
            .overlay(alignment: .bottom) {
                bottomMenuView
            }
            .overlay(alignment: .topTrailing) {
                rightSideMenuView
            }
        }
    }
    
    var topMenuView: some View {
        HStack(spacing: 20) {
            breedingDaysView
            
            VStack(alignment: .leading) {
                HStack {
                    goldView
                    cubeSizeView
                }
                
                satisfactionView
            }
        }
    }
    
    var bottomMenuView: some View {
        HStack {
            Button(action: { viewModel.onTapClean() }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.bottomMenu)
                    .frame(width:117, height: 119)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                    .overlay {
                        VStack {
                            Image(.mop)
                            Text("お掃除")
                                .font(.system(size: 15).bold())
                                .foregroundColor(.white)
                        }
                    }
            }
            
            Button(action: {
                viewModel.onTapCubeFood()
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.bottomMenu)
                    .frame(width:117, height: 119)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                    .overlay {
                        VStack {
                            Image(.cube)
                            Text("キューブ")
                                .font(.system(size: 15).bold())
                                .foregroundColor(.white)
                        }
                    }
            }
            
            Button(action: {
                //ショップに行ける
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.bottomMenu)
                    .frame(width:117, height: 119)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                    .overlay {
                        VStack {
                            Image(.shop)
                            Text("ショップ")
                                .font(.system(size: 15).bold())
                                .foregroundColor(.white)
                        }
                    }
            }
        }
    }
    
    var rightSideMenuView: some View {
        VStack {
            Button(action: {
                viewModel.onTapCameraMode()
            }) {
                Circle()
                    .fill(.rightSideMenu)
                    .frame(width:50, height: 50)
                    .overlay {
                        Image(viewModel.cameraMode ? .grow : .camera)
                    }
            }
            
            Button(action: {
                // 設定
            })  {
                Circle()
                    .fill(.rightSideMenu)
                    .frame(width:50, height: 50)
                    .overlay {
                        Image(.settings)
                    }
            }
        }
        .padding(.top, 90)
        .padding(.trailing, 10)
    }
    
    var breedingDaysView: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.day)
                .frame(width:95, height: 82)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 0.5)
                )
                .overlay(content: {
                    Text("\(viewModel.breedingDays)")
                        .font(.system(size: 30).bold())
                        .padding(.top, 20)
                })
                .overlay(alignment: .top) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.topMenu)
                        .frame(width:95, height: 25)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 0.5)
                        })
                        .overlay {
                            Text("飼育日数")
                                .font(.system(size: 12).bold())
                                .foregroundColor(.white)
                        }
                }
        }
    }
    
    var goldView: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.topMenu)
            .frame(width: 120, height: 30)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 0.5)
            )
            .overlay {
                HStack {
                    Image(.coin)
                        .padding(.leading, 5)
                    Spacer()
                    Text("\(viewModel.myGold)G")
                        .font(.system(size: 18).bold())
                        .foregroundColor(.white)
                        .padding(.trailing, 5)
                }
            }
    }
    
    var cubeSizeView: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.topMenu)
            .frame(width: 120, height: 30)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 0.5)
            )
            .overlay {
                HStack {
                    Image(.cress)
                        .padding(.leading, 5)
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Text("\(viewModel.cubeSize)")
                            .font(.system(size: 10).bold())
                            .foregroundColor(.white)
                        
                        Text("cm")
                            .font(.system(size: 12).bold())
                            .foregroundColor(.white)
                            .padding(.trailing, 5)
                            .padding(.bottom, 0.5)
                    }
                    
                }
            }
    }
    
    
    var satisfactionView: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.topMenu)
            .frame(width: 245, height: 38)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 0.5)
            )
            .overlay {
                HStack {
                    Image(.wellness)
                    Text("満足度")
                        .font(.system(size: 10).bold())
                        .foregroundColor(.white)
                    
                    // ゲージ
                }
            }
        
//        Text("\(viewModel.satisfaction)%")
    }
}



