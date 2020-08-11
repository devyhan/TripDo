//
//  PostAddressViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/08/11.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import WebKit

class PostAddressViewController: UIViewController {
  
  weak var delegate: PostAddressDelegate?
  
  var webView: WKWebView?
  let indicator = UIActivityIndicatorView(style: .medium)
  var post = ""
  var address = ""
  
  fileprivate lazy var leftButton: UIBarButtonItem = {
    let b = UIBarButtonItem(
      title: "close",
      style: .plain,
      target: self,
      action: #selector(webNavButton)
    )
    b.tag = 1
    return b
  }()
  
  fileprivate lazy var rightButton: UIBarButtonItem = {
    let b = UIBarButtonItem(
      image: UIImage(systemName: Common.SFSymbolKey.reload.rawValue),
      style: .plain,
      target: self,
      action: #selector(webNavButton)
    )
    b.tag = 2
    
    return b
  }()
  
  override func loadView() {
    super.loadView()
    
    let contentController = WKUserContentController()
    contentController.add(self, name: "callBackHandler")
    
    let config = WKWebViewConfiguration()
    config.userContentController = contentController
    
    self.webView = WKWebView(frame: .zero, configuration: config)
    self.view = self.webView!
    self.webView?.navigationDelegate = self
    
    self.webView?.addSubview(indicator)
    indicator.center.x = UIScreen.main.bounds.width / 2
    indicator.center.y = UIScreen.main.bounds.height / 2
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = self.leftButton
    navigationItem.rightBarButtonItem = self.rightButton
    
    guard
      let url = URL(string: "https://trilliwon.github.io/postcode/"),
      let webView = webView else { return }
    
    let request = URLRequest(url: url)
    webView.load(request)
    
    self.webView?.navigationDelegate = self
    indicator.startAnimating()
  }
  
  @objc private func webNavButton(_ sender: Any) {
    if let button = sender as? UIBarButtonItem {
      switch button.tag {
      case 1:
        dismiss(animated: true, completion: nil)
      case 2:
        webView?.reload()
      default:
        print("error")
      }
    }
  }
}

extension PostAddressViewController: WKScriptMessageHandler, WKNavigationDelegate {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if let postCodData = message.body as? [String: Any] {
      post = postCodData["zonecode"] as? String ?? ""
      address = postCodData["addr"] as? String ?? ""
    }
    
    delegate?.postString(post)
    delegate?.addressString(address)
    dismiss(animated: true, completion: nil)
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    indicator.startAnimating()
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    indicator.stopAnimating()
  }
}
