//
//  SongView.swift
//  music-player
//
//  Created by 郭家銘 on 2020/12/3.
//

import UIKit

class SongCardView: UIView {
    var songInfo: MusicData?
    let touchFunc: (MusicData) -> Void
    var songImageView: UIImageView = UIImageView()
    var singerNameLabel: UILabel = UILabel()
    var songNameLabel: UILabel = UILabel()
    
    init?(frame: CGRect,
          songInfo: MusicData?,
          touchFunc: @escaping (MusicData) -> Void) {
        self.songInfo = songInfo
        self.touchFunc = touchFunc
        super.init(frame: frame)
        
        initSongImageView()
        initSingerNameLabel()
        initSongNameLabel()
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("RecentlySongView init error!")
    }
    
    private func initSongImageView() {
        songImageView.frame = CGRect(x: 0, y: 0, width: 142, height: 142)
        songImageView.contentMode = .scaleAspectFill
        songImageView.clipsToBounds = true
        songImageView.layer.cornerRadius = 20
        songImageView.backgroundColor = UIColor(named: "DarkColor")
        setInteractive(imageView: songImageView)
        self.addSubview(songImageView)
    }
    private func setInteractive(imageView: UIImageView) {
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.touchAction))
        imageView.addGestureRecognizer(gesture)
    }
    @objc private func touchAction(_ sender: UITapGestureRecognizer) {
        self.touchFunc(self.songInfo!)
    }
    
    private func initSongNameLabel() {
        songNameLabel.frame = CGRect(x: 10, y: 145, width: 122, height: 20)
        songNameLabel.font = UIFont.systemFont(ofSize: 17)
        songNameLabel.textColor = UIColor(named: "WhiteColor")
        self.addSubview(songNameLabel)
    }
    
    private func initSingerNameLabel() {
        singerNameLabel.frame = CGRect(x: 10, y: 167, width: 122, height: 18)
        singerNameLabel.font = UIFont.systemFont(ofSize: 15)
        singerNameLabel.textColor = UIColor(named: "WhiteColor")
        singerNameLabel.alpha = 0.6
        self.addSubview(singerNameLabel)
    }
    
    final func setSongInfo(info: MusicData) {
        songInfo = info
        setView()
    }
    
    private func setView() {
        if let songInfo = songInfo {
            songImageView.image = UIImage(named: songInfo.songImage)
            singerNameLabel.text = songInfo.singerName
            songNameLabel.text = songInfo.songName
        } else {
            songImageView.image = nil
            singerNameLabel.text = songInfo?.singerName ?? "歌曲"
            songNameLabel.text = songInfo?.songName ?? "歌手"
        }
    }

}

