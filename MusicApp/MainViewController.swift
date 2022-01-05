//
//  MainViewController.swift
//  MusicApp
//
//  Created by 蔡尚諺 on 2021/12/30.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var musicCollectionView: UICollectionView!
    @IBOutlet weak var musicTableView: UITableView!
    
    var musicResponse: MusicResponse?
    var task: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicTableView.delegate = self
        musicTableView.dataSource = self
        
        musicCollectionView.delegate = self
        musicCollectionView.dataSource = self
        
        fetchMusicItem()   //get item
//        configureCellSize() //cellSize
    }
    
    @IBSegueAction func toPagePlay(_ coder: NSCoder) -> PlayViewController? {
        
        let playVC = PlayViewController(coder: coder)
        playVC?.musicItem = musicResponse?.results[musicTableView.indexPathForSelectedRow!.row]
        
        return playVC
    }
    func configureCellSize(){
        let itemCounts: CGFloat = 3
        let itemSpace: CGFloat = 3
        let width = floor((musicCollectionView.bounds.size.width - itemSpace * (itemCounts - 1)) / itemCounts)
        
        let flowLayout = musicCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        
        flowLayout?.itemSize = CGSize(width: width, height: width)
        
    }
    
    func fetchMusicItem(){
        
        if let url = URL(string: "https://itunes.apple.com/search?media=music&term=earth+wind+fire") {
            
            task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data,
                   let response = response as? HTTPURLResponse,
                   response.statusCode == 200,
                   error == nil{
                    do {
                        let decoder = JSONDecoder()
                        
                        let musicResponse = try decoder.decode(MusicResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.musicResponse = musicResponse
                            self.musicCollectionView.reloadData()
                            self.musicTableView.reloadData()
                        }
                        
                    } catch {
                        print("錯誤：\(error)")
                    }
                }else{
                    print("錯誤：\(error)")
                }
            }
            
            task?.resume()
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

//TableView
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musicResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MusicTableViewCell.self)", for: indexPath) as! MusicTableViewCell
        let musicItem = musicResponse?.results[indexPath.row]
        cell.trackNameLabel.text = musicItem?.trackName
        cell.artistNameLabel.text = musicItem?.artistName
        cell.photoImageView.image = UIImage(named: "dataNotFound")
        
        if let url = musicItem?.artworkUrl100 {
            
            
            cell.fetchImage(url: url) { image in
                DispatchQueue.main.async {cell.photoImageView.image = image} //填圖片
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath){
        let cell = cell as? MusicTableViewCell
        cell?.task?.cancel()
        cell?.task = nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let musicItem = musicResponse?.results[indexPath.row]
        performSegue(withIdentifier: "toPagePlay", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//CollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        musicResponse?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MusicCollectionViewCell.self)", for: indexPath) as! MusicCollectionViewCell
        let musicItem = musicResponse?.results[indexPath.row]
        cell.photoImageView.image = UIImage(named: "dataNotFound")
        
        if let url = musicItem?.artworkUrl100 {
            cell.fetchImage(url: url) { image in
                DispatchQueue.main.async {cell.photoImageView.image = image} //填圖片
            }
        }
        
        return cell
    }
    //把task清掉，避免圖片抓太慢顯示在不同的位置上
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        
        let cell = cell as? MusicCollectionViewCell
        cell?.task?.cancel()
        cell?.task = nil
        
    }
    
}
