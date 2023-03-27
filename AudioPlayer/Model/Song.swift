//
//  Song.swift
//  AudioPlayer
//
//  Created by Maksim Maklagin on 25.03.2023.
//

import Foundation


struct Song {
    let artistName: String
    let name: String
    let albumName: String
    let trackName: String
    
    var fullName: String {
        artistName + name
    }
}
