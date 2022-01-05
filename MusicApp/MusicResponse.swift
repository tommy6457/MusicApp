//
//  MusicResponse.swift
//  MusicApp
//
//  Created by 蔡尚諺 on 2021/12/30.
//

import Foundation

struct MusicResponse: Codable {
    
    var resultCount: Int            //回傳總數
    var results: [MusicItemResponse]  //items
    
}


struct MusicItemResponse: Codable {
    
    var artistName: String          //作者名稱
    var collectionName: String      //專輯名稱
    var trackName: String           //歌曲名稱
    var previewUrl: URL             //歌曲URL
    var artworkUrl100: URL          //專輯圖片
    
}
