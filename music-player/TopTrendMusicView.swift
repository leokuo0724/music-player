//
//  TopTrendMusicView.swift
//  music-player
//
//  Created by 郭家銘 on 2020/12/2.
//

import UIKit

class TopTrendMusicView: UIView {
    let singerImage: UIImage
    let singerName: String
    
    init?(frame: CGRect, singerImage: UIImage, singerName: String) {
        self.singerImage = singerImage
        self.singerName = singerName
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "DarkColor")
        self.layer.cornerRadius = 20
        setSingerImage()
        setNameSection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("TopTrendMusicView init error!")
    }
    
    private func setSingerImage() {
        let singerImage = UIImageView()
        singerImage.frame = CGRect(x: 18, y: -18, width: 106, height: 160)
        singerImage.image = self.singerImage
        singerImage.contentMode = .scaleAspectFill
        singerImage.clipsToBounds = true
        self.addSubview(singerImage)
    }
    
    private func setNameSection() {
        let container = UIView(frame: CGRect(x: 0, y: 101, width: 142, height: 41))
        container.layer.cornerRadius = 20
        container.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        container.backgroundColor = UIColor(named: "PrimaryColor")
        let label = UILabel(frame: CGRect(x: 16, y: 10, width: 110, height: 20))
        label.text = self.singerName
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "WhiteColor")
        container.addSubview(label)
        self.addSubview(container)
    }

}
