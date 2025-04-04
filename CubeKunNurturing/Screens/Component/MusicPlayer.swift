//
//  MusicPlayer.swift
//  CubeKunNurturing
//
//  Created by 永井涼 on 2025/04/04.
//

import SwiftUI
import AVFoundation

class MusicPlayer: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    var selectedMusic: Music
    
    init(audioPlayer: AVAudioPlayer? = nil, selectedMusic: Music) {
        self.audioPlayer = audioPlayer
        self.selectedMusic = selectedMusic
    }

    func playMusic() {
        guard let url = Bundle.main.url(forResource: selectedMusic.musicFileName, withExtension: "mp3") else {
            print("音楽ファイルが見つかりません")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // -1で無限ループ
            audioPlayer?.play()
        } catch {
            print("音楽の再生に失敗しました: \(error.localizedDescription)")
        }
    }

    func stopMusic() {
        audioPlayer?.stop()
    }
}

enum Music: String {
    case tutorial
    case home
    
    var musicFileName: String {
        switch self {
        case .tutorial:
            "nyantoko-talk"
        case .home:
            "tokotoko-kun"
        }
    }
}
