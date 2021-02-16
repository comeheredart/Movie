//
//  TheaterListViewController.swift
//  Movie
//
//  Created by JEN Lee on 2021/02/16.
//

import UIKit

class TheaterListViewController: UITableViewController {

    var list = [NSDictionary]()
    var startPoint = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callTheaterAPI()
    }
    
    func callTheaterAPI() {
        let requestURI = "http://swiftapi.rubypaper.co.kr:2029/theater/list"
        let sList = 100
        let type = "json"
        
        let urlObj = URL(string: "\(requestURI)?s_page=\(self.startPoint)&s_list=\(sList)&type=\(type)")
        
        do {
            let stringdata = try NSString(contentsOf: urlObj!, encoding: 0x80_000_422)
            let encdata = stringdata.data(using:String.Encoding.utf8.rawValue)
            
            do {
                let apiArray = try JSONSerialization.jsonObject(with: encdata!, options: []) as? NSArray
                
                for obj in apiArray! {
                    self.list.append(obj as! NSDictionary)
                }
            } catch {
                let alert = UIAlertController(title: "실패", message: "데이터 분석이 실패하였습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: false)
            }
            self.startPoint += sList
            
        } catch {
            let alert = UIAlertController(title: "실패", message: "데이터 분석이 실패하였습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell") as! TheaterCell
        cell.name?.text = obj["상영관명"] as? String
        cell.address?.text = obj["소재지도로명주소"] as? String
        cell.phone?.text = obj["연락처"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    


}
