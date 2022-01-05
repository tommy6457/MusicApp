//
//  MusicCollectionViewCell.swift
//  MusicApp
//
//  Created by 蔡尚諺 on 2021/12/30.
//

import UIKit

class MusicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    var task: URLSessionDataTask?
    
    /*  1.@escaping是為了在此方法外還可正常運作
        2.檢查錯誤
        3.將data轉換為UIImage
        4.執行閉包completion的動作 */
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
}
