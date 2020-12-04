//
//  MusicViewController.swift
//  music-player
//
//  Created by 郭家銘 on 2020/12/2.
//

import UIKit
import AVFoundation

var starArray: Array<StarImageView> = []

class MusicViewController: UIViewController {

    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var starsUIView: UIView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timePassLabel: UILabel!
    @IBOutlet weak var timeRemainLabel: UILabel!
    @IBOutlet weak var repeatBtn: UIButton!
    @IBOutlet weak var shuffleBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMusicImage()
        initStars()
        initSlider()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setMusicView), name: NSNotification.Name("setMusicView"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // set view based on data
        setMusicView()
        setPlayBtn()
        setSliderMinMax()
        setPlayTypeBtns()
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
    func initSlider() {
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value:1, timescale: 1), queue: DispatchQueue.main, using: { (CMTime) in
            if let _ = playerStatus.nowPlaying, playerStatus.isPlay {
                // set slider
                let currentTime = player.currentTime().seconds
                self.slider.value = Float(currentTime)
                // set labels
                self.timePassLabel.text = self.timeFormat(time: currentTime)
                self.timeRemainLabel.text = "-\(self.timeFormat(time: playerStatus.duration - currentTime))"
            }
        })
    }
    func setSliderMinMax() {
        slider.maximumValue = Float(playerStatus.duration)
        slider.isContinuous = true
    }
    func timeFormat(time: Double) -> String{
        let result = Int(time).quotientAndRemainder(dividingBy: 60)
        return "\(result.quotient):\(String(format:"%.02d", result.remainder))"
    }
    @objc func setMusicView() {
        musicImageView.image = UIImage(named: playerStatus.nowPlaying!.songImage)
        songLabel.text = playerStatus.nowPlaying!.songName
        singerLabel.text = playerStatus.nowPlaying!.singerName
        MusicViewController.setStarCounts(counts: playerStatus.nowPlaying!.starCounts)
    }
    func setPlayTypeBtns() {
        if playerStatus.playType == "repeat" {
            repeatBtn.alpha = 1
            shuffleBtn.alpha = 0.6
        } else if playerStatus.playType == "shuffle" {
            repeatBtn.alpha = 0.6
            shuffleBtn.alpha = 1
        } else {
            repeatBtn.alpha = 0.6
            shuffleBtn.alpha = 0.6
        }
        
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
    @IBAction func prevSong(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("prevSong"), object: nil)
        setMusicView()
    }
    
    @IBAction func sliderControl(_ sender: UISlider) {
        let time = CMTime(value: CMTimeValue(sender.value), timescale: 1)
        player.seek(to: time)
    }
    
    @IBAction func songRepeat(_ sender: Any) {
        if playerStatus.playType != "repeat" {
            playerStatus.playType = "repeat"
        } else {
            playerStatus.playType = "normal"
        }
        setPlayTypeBtns()
    }
    
    
    @IBAction func songsShuffle(_ sender: Any) {
        if playerStatus.playType != "shuffle" {
            playerStatus.playType = "shuffle"
            musicQueue.shuffle()
            print(musicQueue)
        } else {
            playerStatus.playType = "normal"
        }
        setPlayTypeBtns()
    }
}
