//
//  TrackListViewController.swift
//  AudioPlayer
//
//  Created by Maksim Maklagin on 25.03.2023.
//

import UIKit

class TrackListViewController: UITableViewController {
    
    private var songs: [Song] = []
    
    //MARK: - override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSongs()
    }
    
    //MARK: - private methods
    
    private func configureSongs() {
        
        songs.append(
            Song(
                artistName: "G.O. THOMAS - ",
                name: "GOOD GUY",
                albumName: "cover1",
                trackName: "song1"
            )
        )
        
        songs.append(
            Song(
                artistName: "Lately Kind of Yeah  - ",
                name: "Heart",
                albumName: "cover2",
                trackName: "song2"
            )
        )
        
        songs.append(
            Song(
                artistName: "Mr Smith - ",
                name: "JB Hustle",
                albumName: "cover3",
                trackName: "song4"
            )
        )
        
        songs.append(
            Song(
                artistName: "Lately Kind of Yeah - ",
                name: "Ghost",
                albumName: "cover4",
                trackName: "song3"
            )
        )
    }
    
}

//MARK: - tableView

extension TrackListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "track", for: indexPath)
        let song = songs[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = song.fullName
        content.secondaryText = "0:00"
        
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let position = indexPath.row
        
        guard let playerVC = storyboard?.instantiateViewController(withIdentifier: "player") as? PlayerViewController else { return }

        playerVC.songs = songs
        playerVC.position = position
        
        present(playerVC, animated: true)
    }
}


