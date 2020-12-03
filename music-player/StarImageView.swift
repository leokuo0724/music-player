//
//  StarImageView.swift
//  music-player
//
//  Created by 郭家銘 on 2020/12/2.
//

import UIKit

class StarImageView: UIImageView {
    let starIndex: Int
    
    init?(image: UIImage, starIndex: Int) {
        self.starIndex = starIndex
        super.init(image: image)
        self.tintColor = UIColor(named: "PrimaryColor")
        self.setInteractive()
    }
    
    required init?(coder: NSCoder) {
        fatalError("StarImage Init Error!")
    }
    
    private func setInteractive() {
        self.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.touchAction))
        self.addGestureRecognizer(gesture)
    }
    
    @objc private func touchAction(_ sender: UITapGestureRecognizer) {
        // 改資料 star 再呼叫更改 view
        print(self.starIndex)
        // 設定 music star
    }
    
    func setStar(bool: Bool) {
        if bool {
            self.image = UIImage(systemName: "star.fill")
        } else {
            self.image = UIImage(systemName: "star")
        }
    }
    
    func setStarsDisplay(counts: Int) {
        // 從 musicStatus 改
    }

}
