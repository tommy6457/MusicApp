//
//  PlayViewController.swift
//  MusicApp
//
//  Created by 蔡尚諺 on 2022/1/5.
//

import UIKit
import AVKit

class PlayViewController: UIViewController {
    
    var musicItem: MusicItemResponse!
    var task: URLSessionDataTask?
    var avPlayer: AVPlayer?
    var play = false
    
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = musicItem {
            fetchImage(url: item.artworkUrl100) { image in
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            }
            title = item.trackName
        }
        
        playButton.setImage(UIImage(systemName:  "play.fill"), for: .normal)
        
    }
    
    func fetchImage(url: URL , completion: @escaping (UIImage?) -> Void) {
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               error == nil,
               let image = UIImage(data: data){
                completion(image)
            }else{
                completion(nil)
            }
        }
        
        task?.resume()
    }
    
    @IBAction func pausePlay(_ sender: UIButton) {
        
        if avPlayer == nil {
            avPlayer = AVPlayer(url: musicItem.previewUrl)
            
        }
        
        if play {
            play = false
            avPlayer?.pause()
            playButton.setImage(UIImage(systemName:  "play.fill"), for: .normal)
        }else{
            play = true
            avPlayer?.play()
            playButton.setImage(UIImage(systemName:  "pause.fill"), for: .normal)
            
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
