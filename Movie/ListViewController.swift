//
//  ListViewController.swift
//  Movie
//
//  Created by JEN Lee on 2021/02/08.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    
    
    var page = 1
    @IBOutlet weak var moreBtn: UIButton!
    
    //테이블 뷰를 구성할 리스트 데이터
    lazy var list: [MovieVO] = {
       var datalist = [MovieVO]()
        return datalist
    }()
    
    
    @IBAction func more(_ sender: UIButton) {
        self.page += 1
        callMovieAPI()
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        callMovieAPI()
    }
    
    func callMovieAPI() {
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=30&genreId=&order=releasedateasc"
        let apiURI: URL! = URL(string: url)
        
        let apidata = try! Data(contentsOf: apiURI)
        
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            for row in movie {
                let r = row as! NSDictionary
                
                let mvo = MovieVO()
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = ((r["ratingAverage"] as! NSString).doubleValue)
                
                self.list.append(mvo)
                
                //더보기 버튼 숨김 처리
                let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
                
                if (self.list.count >= totalCount) {
                    self.moreBtn.isHidden = true
                }
            }
        } catch { NSLog("Parse Error!") }
    }
    
    func getThumbnailImage(_ index: Int) -> UIImage {
        
        let mvo = self.list[index]
        
        //메모제이션
        if let savedImage = mvo.thumbnailImage {
            return savedImage
        } else {
            let url: URL! = URL(string: mvo.thumbnail!)
            let imageData = try! Data(contentsOf: url)
            mvo.thumbnailImage = UIImage(data: imageData)
            
            return mvo.thumbnailImage!
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        
        
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
        
        
        //비동기 방식
        DispatchQueue.main.async {
            cell.thumbnail.image = self.getThumbnailImage(indexPath.row)
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//MARK: - 화면 전환 시 값을 넘겨주기 위한 세그웨이 처리
extension ListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_detail" {
            
            let cell = sender as! MovieCell
            let path = self.tableView.indexPath(for: cell)
            let movieinfo = self.list[path!.row]
            
            let detailVC = segue.destination as? DetailViewController
            detailVC?.mvo = movieinfo
        }
    }
}
