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
//    MusicData(songName: "向晚的迷途指南", album: "向晚的迷途指南", songImage: "向晚的迷途指南", singerName: "棉花糖", year: 2014, starCounts: 2),
//    MusicData(songName: "在名為未來的波浪裡", album: "在名為未來的波浪裡", songImage: "在名為未來的波浪裡", singerName: "原子邦妮", year: 2020),
//    MusicData(songName: "想見你想見你想見妳", album: "想見你", songImage: "想見你想見你想見你", singerName: "八三夭", year: 2019),
//    MusicData(songName: "重遊舊地", album: "重遊舊地", songImage: "重遊舊地", singerName: "吳汶芳", year: 2020)
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
    @IBOutlet weak var nowPlayingPlayBtn: UIButton!
    
    let topTrendSingers: Array<TopSinger> = [
        TopSinger(singerName: "吳汶芳", imageName: "Us小時"),
        TopSinger(singerName: "吳汶芳", imageName: "Us小時"),
        TopSinger(singerName: "吳汶芳", imageName: "Us小時"),
        TopSinger(singerName: "吳汶芳", imageName: "Us小時"),
        TopSinger(singerName: "吳汶芳", imageName: "Us小時"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNowPlayingSheet()
        initTrendCards()
        initRecentlyCards()
        initMadeForYou()
         
        // music observer
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
            self.playNextSong()
            self.setNowPlayingView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playPause), name: NSNotification.Name("playPause"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nextSong), name: NSNotification.Name("nextSong"), object: nil)
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
        setNowPlayingView()
        
        // set touchable
        nowPlayingSheet.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.toCurrentMusicPage))
        nowPlayingSheet.addGestureRecognizer(gesture)
    }
    

    
    // click song view
    func songViewTouchAction(nextSongInfo: MusicData) {
        if playerStatus.nowPlaying?.songName == nextSongInfo.songName {
            toCurrentMusicPage()
        } else {
            playerStatus.nowPlaying = nextSongInfo
            toNextMusicPage()
        }
    }
    // present next music page
    @objc func toNextMusicPage() {
        if let controller = storyboard?.instantiateViewController(identifier: "MusicPage") as? MusicViewController {
            present(controller, animated: true, completion: nil) // set song
            setNowPlayingView()
            if let nextSong = playerStatus.nowPlaying {
                playMusic(nextSong.songName)
            }
        }
    }
    @objc func toCurrentMusicPage() {
        
        if let controller = storyboard?.instantiateViewController(identifier: "MusicPage") as? MusicViewController,
           let _ = playerStatus.nowPlaying {
            present(controller, animated: true, completion: nil) // set song
        }
    }
    
    // play/pause music
    func playMusic(_ resource: String) {
        let fileUrl = Bundle.main.url(forResource: resource, withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: fileUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        playerStatus.isPlay = true
        setPlayBtn()
    }
    func resumeMusic() {
        player.play()
        playerStatus.isPlay = true
        setPlayBtn()
    }
    func pauseMusic() {
        player.pause()
        playerStatus.isPlay = false
        setPlayBtn()
    }
    
    func setNowPlayingView() {
        if let currentSong = playerStatus.nowPlaying {
            nowPlayingImage.image = UIImage(named: currentSong.songImage)
            nowPlayingSongLabel.text = currentSong.songName
            nowPlayingSingerLabel.text = currentSong.singerName
        } else {
            nowPlayingImage.image = nil
            nowPlayingSongLabel.text = "歌曲"
            nowPlayingSingerLabel.text = "歌手"
        }
    }
    
    func setPlayBtn() {
        if playerStatus.isPlay {
            nowPlayingPlayBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            nowPlayingPlayBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    // play/pause button
    @IBAction func playPause(_ sender: Any) {
        if playerStatus.isPlay {
            pauseMusic()
        } else {
            // deal with initial situation
            if playerStatus.nowPlaying == nil {
                playerStatus.nowPlaying = musicQueue[playerStatus.nowPlayIndex]
                playMusic(playerStatus.nowPlaying!.songName)
                setNowPlayingView()
            }
            resumeMusic()
        }
    }
    
    @IBAction func nextSong(_ sender: Any) {
        playNextSong()
    }
    
    func playNextSong() {
        if playerStatus.nowPlaying == nil {
            playerStatus.nowPlaying = musicQueue[playerStatus.nowPlayIndex]
        } else {
            playerStatus.nowPlayIndex += 1
            if (playerStatus.nowPlayIndex >= musicQueue.count) {
                playerStatus.nowPlayIndex = 0
            }
            playerStatus.nowPlaying = musicQueue[playerStatus.nowPlayIndex]
        }
        playMusic(playerStatus.nowPlaying!.songName)
        setNowPlayingView()
    }
    
}
