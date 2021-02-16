//
//  DetailViewController.swift
//  Movie
//
//  Created by JEN Lee on 2021/02/16.
//

import Foundation
import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var wv: WKWebView!
    var mvo: MovieVO!
    
    override func viewDidLoad() {
        self.wv.navigationDelegate = self
        
        //네비게이션 바 타이틀에 영화명 출력
        let navibar = self.navigationItem
        navibar.title = self.mvo.title
        
        //웹뷰에 요청, 로드
        let url = URL(string: (self.mvo.detail!))
        let req = URLRequest(url: url!)
        self.wv.load(req)
    }
}

//MARK: - WKNavigationDelegate 구현
extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.alert("상세 페이지를 읽어오지 못했습니다.") {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)
    {
        self.alert("상세 페이지를 읽어오지 못했습니다.") {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
}


//MARK: - 심플 경고창 함수 정의용 익스텐션
extension UIViewController {
    func alert(_ message: String, onClick: (()-> Void)? = nil) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel) { (_) in
            onClick?()
        })
        DispatchQueue.main.async {
            self.present(controller, animated: false)
        }
    }
}

