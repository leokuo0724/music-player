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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMusicImage()
        initStars()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // set view based on data
        musicImageView.image = UIImage(named: playerStatus.nowPlaying!.songImage)
        songLabel.text = playerStatus.nowPlaying!.songName
        singerLabel.text = playerStatus.nowPlaying!.singerName
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

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
