//
//  TheaterViewViewController.swift
//  Movie
//
//  Created by JEN Lee on 2021/02/17.
//

import UIKit
import MapKit

class TheaterViewViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    
    var param: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.param["상영관명"] as? String

        let lat = Double(param?["위도"] as! String) ?? 0.0
        let lng = Double(param?["경도"] as! String) ?? 0.0
        
        //위도, 경도 정보로 하는 투디 위치 정보 객체 정의
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        //지도에 표현될 거리 :100m
        let regionRadius: CLLocationDistance = 100
        
        //거리 반영해서 지역정보 조합, 지도 데이터 생성
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        self.map.setRegion(coordinateRegion, animated: true)
        
        //어딘지 표시해주기!
        let point = MKPointAnnotation()
        point.coordinate = location
        self.map.addAnnotation(point)
    }
    
}
