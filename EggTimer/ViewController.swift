//
//  ViewController.swift
//  EggTimer
//
//  Created by Евгений Башун on 30.01.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private let cookingTime = ["Soft" : 3, "Medium" : 4, "Hard" : 5]
    private var secondsPassed: Float = 0
    private var totalTime: Float = 0
    private var timer = Timer()
    private var player: AVAudioPlayer?

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func hardnessSelected(_ sender: UIButton) {
     
        timer.invalidate()
        guard let hardness = sender.currentTitle else { return }
        guard let count = cookingTime[hardness] else { return }
        totalTime = Float(count)
        progressBar.progress = 0.0
        secondsPassed = 0
        textLabel.text = hardness
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
    }
    
    @objc
    private func update() {
        if secondsPassed < totalTime {
            progressBar.progress = Float(secondsPassed/totalTime)
            secondsPassed += 1.0
        } else {
            textLabel.text = "Done!"
            progressBar.progress = 1.0
            playSound()
        }
    }
    
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
