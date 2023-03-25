//
//  TrackListViewController.swift
//  AudioPlayer
//
//  Created by Maksim Maklagin on 25.03.2023.
//

import UIKit

class TrackListViewController: UITableViewController {
    
    var songs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSongs()
    }
    
    func configureSongs() {
        
        songs.append(
            Song(
                name: "Unknow",
                trackName: "song1"
            )
        )
        
        songs.append(
            Song(
                name: "Lately Kind of Yeah - Heart",
                trackName: "song2"
            )
        )
        
        songs.append(
            Song(
                name: "IMLC - In Case You Missed It",
                trackName: "song3"
            )
        )
    }
    
}

extension TrackListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "track", for: indexPath)
        let song = songs[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        
        content.text = song.name
        content.secondaryText = "3:35"
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //present the player
        let position = indexPath.row
        
        //songs
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "player") as? PlayerViewController else { return }
        
        vc.songs = songs
        vc.position = position
        present(vc, animated: true)
    }
}
