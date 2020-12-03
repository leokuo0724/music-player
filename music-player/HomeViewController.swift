//
//  HomeViewController.swift
//  music-player
//
//  Created by 郭家銘 on 2020/12/1.
//

import UIKit
import AVFoundation

let player = AVPlayer()
let playerStatus = PlayerStatus()
var musicQueue: Array<MusicData> = [
    MusicData(songName: "Last Dance", album: "愛情的盡頭", songImage: "愛情的盡頭", singerName: "伍百", year: 1996, starCounts: 5),
    MusicData(songName: "Us小時", album: "Us小時", songImage: "Us小時", singerName: "吳汶芳", year: 2016, starCounts: 3),
    MusicData(songName: "向晚的迷途指南", album: "向晚的迷途指南", songImage: "向晚的迷途指南", singerName: "棉花糖", year: 2014, starCounts: 2),
    MusicData(songName: "在名為未來的波浪裡", album: "在名為未來的波浪裡", songImage: "在名為未來的波浪裡", singerName: "原子邦妮", year: 2020),
    MusicData(songName: "想見你想見你想見妳", album: "想見你", songImage: "想見你想見你想見你", singerName: "八三夭", year: 2019),
    MusicData(songName: "重遊舊地", album: "重遊舊地", songImage: "重遊舊地", singerName: "吳汶芳", year: 2020)
]
var recentlyPlayed: Array<MusicData?> = [ nil, nil, nil ]

struct TopSinger {
    let singerName: String
    let imageName: String
}

class HomeViewController: UIViewController {

    @IBOutlet weak var nowPlayingSheet: UIView!
    @IBOutlet weak var nowPlayingImage: UIImageView!
    @IBOutlet weak var nowPlayingSongLabel: UILabel!
    @IBOutlet weak var nowPlayingSingerLabel: UILabel!
    @IBOutlet weak var topTrendUIScrollView: UIScrollView! // 未使用
    @IBOutlet weak var topTrendUIView: UIView!
    @IBOutlet weak var recentlyPlayedUIView: UIView!
    @IBOutlet weak var madeForUUIView: UIView!
    
    let topTrendSingers: Array<TopSinger> = [
        TopSinger(singerName: "吳汶芳", imageName: "Us小時"),
        TopSinger(singerName: "吳汶芳", imageName: "Us小時"),
        TopSinger(singerName: "吳汶芳", imageName: "Us小時"),
        TopSinger(singerName: "吳汶芳", imageName: "Us小時"),
        TopSinger(singerName: "吳汶芳", imageName: "Us小時"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let fileUrl = Bundle.main.url(forResource: "Us小時", withExtension: "mp3")!
//        let playerItem = AVPlayerItem(url: fileUrl)
//        player.replaceCurrentItem(with: playerItem)
//        player.play()
        
        initNowPlayingSheet()
        initTrendCards()
        initRecentlyCards()
        initMadeForYou()
    }

    func initTrendCards() {
        let beginningX = 36
        for (index, data) in topTrendSingers.enumerated() {
            let frame = CGRect(x: beginningX+index*158, y: 42, width: 142, height: 142)
            topTrendUIView.addSubview(
                TopTrendMusicView(frame: frame, singerImage: UIImage(named: data.imageName)!, singerName: data.singerName)!
            )
        }
    }
    
    func initRecentlyCards() {
        let beginningX = 36
        for (index, data) in recentlyPlayed.enumerated() {
            let frame = CGRect(x: beginningX+index*158, y: 12, width: 142, height: 185)
            if let data = data {
                recentlyPlayedUIView.addSubview(
                    SongCardView(frame: frame, songInfo: data, touchFunc: songViewTouchAction)!
                )
            } else {
                recentlyPlayedUIView.addSubview(
                    SongCardView(frame: frame, songInfo: data, touchFunc: songViewTouchAction)!
                )
            }
            
        }
    }
    
    func initMadeForYou() {
        let beginningX = 36
        // 依星星數排列
        let sortArr = musicQueue.sorted {
            $0.starCounts > $1.starCounts
        }
        for (index, data) in sortArr.enumerated() {
            let frame = CGRect(x: beginningX+index*158, y: 12, width: 142, height: 185)
            madeForUUIView.addSubview(SongCardView(frame: frame, songInfo: data, touchFunc: songViewTouchAction)!)
        }
    }
    
    func initNowPlayingSheet() {
        nowPlayingSheet.layer.cornerRadius = 36
        nowPlayingSheet.layer.shadowOpacity = 0.4
        nowPlayingSheet.layer.shadowOffset = CGSize(width: 0, height: 2)
        nowPlayingSheet.layer.shadowRadius = 20
        nowPlayingImage.layer.cornerRadius = 24
        nowPlayingImage.clipsToBounds = true
        setNowPlaying()
    }
    
    // song view 點擊事件，切換畫面
    func songViewTouchAction() {
        if let controller = storyboard?.instantiateViewController(identifier: "MusicPage") as? MusicViewController {
            present(controller, animated: true, completion: nil)
        }
    }
    
    func setNowPlaying() {
        if let currentSong = playerStatus.nowPlaying {
            nowPlayingSheet.alpha = 1
            print(currentSong)
        } else {
            nowPlayingSheet.alpha = 0
        }
    }
    
}
