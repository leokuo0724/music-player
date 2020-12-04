//
//  MusicViewController.swift
//  music-player
//
//  Created by 郭家銘 on 2020/12/2.
//

import UIKit
var starArray: Array<StarImageView> = []

class MusicViewController: UIViewController {

    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var starsUIView: UIView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMusicImage()
        initStars()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // set view based on data
        setMusicView()
        setPlayBtn()
    }
    func initMusicImage() {
        musicView.layer.shadowOpacity = 0.4
        musicView.layer.shadowOffset = CGSize(width:0, height:4)
        musicView.layer.shadowRadius = 20
        musicView.layer.cornerRadius = 20
        musicImageView.clipsToBounds = true
        musicImageView.layer.cornerRadius = 20
    }
    func initStars() {
        for i in 1...5 {
            let star = StarImageView(image: UIImage(systemName: "star")!, starIndex: i)
            star?.frame = CGRect(x: (i-1)*26, y: 0, width: 18, height: 18)
            starsUIView.addSubview(star!)
            starArray.append(star!)
        }
    }
    
    func setMusicView() {
        musicImageView.image = UIImage(named: playerStatus.nowPlaying!.songImage)
        songLabel.text = playerStatus.nowPlaying!.songName
        singerLabel.text = playerStatus.nowPlaying!.singerName
        MusicViewController.setStarCounts(counts: playerStatus.nowPlaying!.starCounts)
    }
    
    static func setStarCounts(counts: Int) {
        starArray.forEach({
            if $0.starIndex <= counts {
                $0.image = UIImage(systemName: "star.fill")
            } else {
                $0.image = UIImage(systemName: "star")
            }
        })
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playPause(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("playPause"), object: nil)
        setPlayBtn()
    }
    func setPlayBtn() {
        if playerStatus.isPlay {
            playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    @IBAction func nextSong(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("nextSong"), object: nil)
        setMusicView()
    }
}
