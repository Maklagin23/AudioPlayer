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
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.contentMode = .scaleAspectFill
        
        return progressView
    }()
    
    var position = 0
    var songs: [Song] = []
    private var player: AVAudioPlayer?
    
    private let playPauseButton = UIButton()
    private let nextButton = UIButton()
    private let backButton = UIButton()
    
    
    //MARK: - override func
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if holder.subviews.count == 0 {
            configure()
        }
    }
    
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
        
        setupSubviews(
            albumImageView,
            progressView,
            songNameLabel,
            albumNameLabel,
            artistNameLabel,
            playPauseButton,
            backButton,
            nextButton
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
        songNameLabel.text = song.name
        albumNameLabel.text = "Album name"
        artistNameLabel.text = "Artist name"

        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setUpProgressView), userInfo: self, repeats: true)
        
    }
    
    
    
    private func setupFrame() {
        
        albumImageView.frame = CGRect(
            x: 10,
            y: 10,
            width: holder.frame.size.width - 20,
            height: holder.frame.size.width - 20
        )
        
        progressView.frame = CGRect(
            x: 10,
            y: albumImageView.frame.size.height + 10 + 210,
            width: holder.frame.size.width - 20,
            height: holder.frame.size.width - 20
        )

        songNameLabel.frame = CGRect(
            x: 10,
            y: albumImageView.frame.size.height + 0,
            width: holder.frame.size.width - 20,
            height: 70
        )
        
        albumNameLabel.frame = CGRect(
            x: 10,
            y: albumImageView.frame.size.height + 70,
            width: holder.frame.size.width - 20,
            height: 70
        )
        
        artistNameLabel.frame = CGRect(
            x: 10,
            y: albumImageView.frame.size.height + 140,
            width: holder.frame.size.width - 20,
            height: 70
        )
        
        // Frame for buttons
        
        let yPosition = artistNameLabel.frame.origin.y + 70 + 40
        let size: CGFloat = 40
        
        playPauseButton.frame = CGRect(
            x: (holder.frame.size.width - size) / 2.0,
            y: yPosition, width: size,
            height: size
        )
        
        nextButton.frame = CGRect(
            x: holder.frame.size.width - size - 100,
            y: yPosition, width: size,
            height: size
        )
        
        backButton.frame = CGRect(
            x: 100, y: yPosition,
            width: size,
            height: size
        )
    }
    
    
    private func addActions() {
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    private func setupStyling() {
        
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)

        playPauseButton.tintColor = .black
        backButton.tintColor = .black
        nextButton.tintColor = .black
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            holder.addSubview(subview)
        }
    }
    
    //MARK: - objc methods
    
    @objc func setUpProgressView() {
        
        guard let player = player else { return }
        let totalProgress = Float(player.currentTime) / Float(player.duration)
        
        progressView.setProgress(totalProgress, animated: true)
        
        if player.isPlaying == true {
            progressView.setProgress(totalProgress, animated: true)
        }
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
}
