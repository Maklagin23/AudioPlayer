//
//  PlayerViewController.swift
//  AudioPlayer
//
//  Created by Maksim Maklagin on 25.03.2023.
//

import AVFoundation
import UIKit

class PlayerViewController: UIViewController {
    
    @IBOutlet var holder: UIView!

    //MARK: - UI Elements
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let timeLabelStart: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textAlignment = .left
        timeLabel.text = "-:--"
        
        return timeLabel
    }()
    
    private let timeLabelEnd: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textAlignment = .right
        timeLabel.text = "-:--"
        
        return timeLabel
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.contentMode = .scaleAspectFill
        
        slider.maximumValue = 1000
        slider.minimumValue = 0
        
        return slider
    }()
    
    private let playPauseButton = UIButton()
    private let nextButton = UIButton()
    private let backButton = UIButton()
    private let dismissButton = UIButton()
        
    private var player: AVAudioPlayer?
    private var timer = Timer()
    
    var position = 0
    var songs: [Song] = []

    //MARK: - override methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if holder.subviews.count == 0 {
            configure()
        }
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configure()
//
//    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let player = player {
            player.stop()
        }
    }
    

    
    //MARK: - private methods
    
    private func configure() {

        setupPlayer()
        addActions()
        setupFrame()
        setupStyling()
        updateTimer()

        setupSubviews(
            albumImageView,
            timeLabelStart,
            timeLabelEnd,
            slider,
            songNameLabel,
            artistNameLabel,
            playPauseButton,
            backButton,
            nextButton,
            dismissButton
            )
    }
    
    private func setupPlayer() {
        
        let song = songs[position]

        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        //setup user  interface elements
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else { return }
            guard let url = URL(string: urlString) else { return }
            
            player = try AVAudioPlayer(contentsOf: url)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch {
            print("error occurred")
        }
        
        albumImageView.image = UIImage(systemName: "music.note.list")
        artistNameLabel.text = song.artistName
        songNameLabel.text = song.name

    }
    
    private func addActions() {
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        
        slider.addTarget(self, action: #selector(setUpSlider), for: .touchDragInside)
        
    }
    
    private func setupStyling() {
        
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        dismissButton.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        
        playPauseButton.tintColor = .black
        backButton.tintColor = .black
        nextButton.tintColor = .black
    }
    
    private func updateTimer() {
        
        guard let player = player else { return }
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        slider.maximumValue = Float(player.duration)
        timeLabelEnd.text = stringFormatterTimerInterval(interval: player.duration)
    }
    
    private func stringFormatterTimerInterval(interval: TimeInterval) -> String {
        
        let timer = Int(interval)
        let second = timer % 60
        let minutes = (timer / 60) % 60
        
        return String(format: "%0.2d:%0.2d", minutes, second)
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    //MARK: - objc methods
    
    @objc func setUpSlider() {
        guard let player = player else { return }
        
        if player.isPlaying == true {
            
            player.stop()
            player.currentTime = TimeInterval(slider.value)
            player.play()
        } else {
            
            player.currentTime = TimeInterval(slider.value)
        }
    }
    
    @objc func update() {
        guard let player = player else { return }
        
        slider.value = Float(player.currentTime)
        
        timeLabelStart.text = stringFormatterTimerInterval(interval: TimeInterval(slider.value)) as String
    }
    
    @objc func didTapPlayPauseButton() {
        
        guard let player = player else { return }
        
        if player.isPlaying == true {
            player.pause()
            
        } else {
            player.play()
            
        }
        
        playPauseButton.setBackgroundImage(UIImage(systemName: player.isPlaying == true ? "pause.fill" : "play.fill"), for: .normal)

    }
    
    @objc func didTapBackButton() {
        
        guard let player = player else { return }
        
        if position > 0 {
            position = position - 1
            player.stop()
            
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }

            configure()
        } else {
            position = songs.endIndex - 1
            player.stop()
            
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            
            configure()
        }
    }
    
    @objc func didTapNextButton() {
        
        guard let player = player else { return }
        
        if position < (songs.count - 1) {
            position = position + 1
            player.stop()
            
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            
            configure()
        } else {
            position = songs.startIndex
            player.stop()
            
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }

            configure()
        }
    }
    
    @objc func didTapDismissButton() {
        dismiss(animated: true)
    }
}

//MARK: - SetUp frame

extension PlayerViewController {
    
    private func setupFrame() {
        
        dismissButton.frame = CGRect(
            x: 20,
            y: 20,
            width: 30,
            height: 30
        )

        albumImageView.frame = CGRect(
            x: holder.frame.size.width - 340,
            y: 10,
            width: holder.frame.size.width - 100,
            height: holder.frame.size.width - 100
        )
        
        artistNameLabel.frame = CGRect(
            x: 10,
            y: albumImageView.frame.size.height + 20,
            width: holder.frame.size.width - 20,
            height: 70
        )
        
        songNameLabel.frame = CGRect(
            x: 10,
            y: albumImageView.frame.size.height + 60,
            width: holder.frame.size.width - 20,
            height: 70
        )
        
        timeLabelStart.frame = CGRect(
            x: 20,
            y: albumImageView.frame.size.height + 120,
            width: holder.frame.size.width - 20,
            height: 70
            
        )
        
        timeLabelEnd.frame = CGRect(
            x: 20,
            y: albumImageView.frame.size.height + 120,
            width: holder.frame.size.width - 40,
            height: 70
            
        )
        
        slider.frame = CGRect(
            x: 20,
            y: albumImageView.frame.size.height + 180,
            width: holder.frame.size.width - 40,
            height: 30
        )
        
        // Frame for buttons
        
        let yPosition = slider.frame.origin.y + 50
        let size: CGFloat = 40
        
        playPauseButton.frame = CGRect(
            x: (holder.frame.size.width - size) / 2.0,
            y: yPosition,
            width: size,
            height: size
        )
        
        nextButton.frame = CGRect(
            x: holder.frame.size.width - size - 100,
            y: yPosition,
            width: size,
            height: size
        )
        
        backButton.frame = CGRect(
            x: 100,
            y: yPosition,
            width: size,
            height: size
        )
    }
}
