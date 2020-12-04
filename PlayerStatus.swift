//
//  PlayerStatus.swift
//  music-player
//
//  Created by 郭家銘 on 2020/12/2.
//

import Foundation

class PlayerStatus {
    var nowPlaying: MusicData? = nil
    var nowPlayIndex: Int = 0
    var isPlay: Bool = false
    var playType: String = "normal" // normal, shuffle, repeat
}
