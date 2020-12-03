//
//  MusicData.swift
//  music-player
//
//  Created by 郭家銘 on 2020/12/2.
//

import UIKit
import Foundation

class MusicData {
    let songName: String
    let album: String
    let songImage: String
    let singerName: String
    let year: Int
    var starCounts: Int = 0
    
    init(songName: String,
         album: String,
         songImage: String,
         singerName: String,
         year: Int,
         starCounts: Int = 0) {
        self.songName = songName
        self.album = album
        self.songImage = songImage
        self.singerName = singerName
        self.year = year
        self.starCounts = starCounts
    }
}
