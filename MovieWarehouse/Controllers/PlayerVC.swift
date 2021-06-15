//
//  PlayerVC.swift
//  MovieWarehouse
//
//  Created by Kurs on 15/06/2021.
//

import Foundation
import UIKit
import youtube_ios_player_helper

class PlayerVC: UIViewController, YTPlayerViewDelegate {
    @IBOutlet private var playerView: YTPlayerView!
    private var key = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self
        playerView.load(withVideoId: key)
    }

    func setKey(key: String) {
        self.key = key
    }

    // backgroundView clear (black)
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return .clear
    }
}
