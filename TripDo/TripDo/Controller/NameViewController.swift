//
//  NameViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/08/06.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import SnapKit

class NameViewController: UIViewController {
  
  let userDefalts = UserDefaults.standard
  
  fileprivate let titleLabel: UILabel = {
    let l = UILabel()
    l.text = "먼저,\n이번 여행일정의\n이름을 지어볼까요 ?"
    l.font = UIFont.preferredFont(forTextStyle: .title1)
    l.numberOfLines = .zero
    l.textColor = Common.subColor
    
    return l
  }()
  
  let tripNameTextField: UITextField = {
    let tf = UITextField()
    tf.layer.cornerRadius = 14
    tf.backgroundColor = Common.mainColor
    Common.shadowMaker(view: tf)
    
    tf.attributedPlaceholder = NSAttributedString(string: "ex) 1박 2일 서울투어 !!", attributes: [NSAttributedString.Key.foregroundColor: Common.subColor.withAlphaComponent(0.5)])
    tf.textColor = Common.subColor
    tf.tintColor = Common.edgeColor
    tf.font = UIFont.preferredFont(forTextStyle: .title2)
    tf.addLeftPadding()
    
    return tf
  }()
  
  fileprivate let backButton: UIButton = {
    let b = UIButton()
    b.backgroundColor = Common.subColor
    b.setImage(UIImage(systemName: Common.SFSymbolKey.cancle.rawValue), for: .normal)
    b.tintColor = Common.mainColor
    b.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    Common.shadowMaker(view: b)
    
    return b
  }()
  
  fileprivate let nextButton: UIButton = {
    let b = UIButton()
    b.backgroundColor = Common.subColor
    b.setImage(UIImage(systemName: Common.SFSymbolKey.next.rawValue), for: .normal)
    b.tintColor = Common.mainColor
    b.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    Common.shadowMaker(view: b)
    
    b.isEnabled = false
    b.alpha = 0.5
    
    return b
  }()
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    hideKeyboard()
    setUI()
  }
}

// MARK: - UI

extension NameViewController {
  fileprivate func setUI() {
    let guid = view.safeAreaLayoutGuide
    view.backgroundColor = Common.mainColor
    navigationItem.hidesBackButton = true
    tripNameTextField.delegate = self
    
    backButton.frame = CGRect(
      x: view.bounds.minX + 40,
      y: view.bounds.height - 120,
      width: 60,
      height: 60
    )
    backButton.layer.cornerRadius = backButton.bounds.width / 2
    
    nextButton.frame = CGRect(
      x: view.bounds.maxX - 100,
      y: view.bounds.height - 120,
      width: 60,
      height: 60
    )
    nextButton.layer.cornerRadius = nextButton.bounds.height / 2
    
    [titleLabel, tripNameTextField, backButton, nextButton].forEach {
      view.addSubview($0)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(guid).offset(20)
      $0.trailing.equalTo(guid).offset(-40)
      $0.leading.equalTo(guid).offset(40)
    }
    
    tripNameTextField.snp.makeConstraints {
      $0.centerY.equalTo(guid).offset(-view.frame.height / 6)
      $0.trailing.equalTo(guid).offset(-40)
      $0.leading.equalTo(guid).offset(40)
      $0.height.equalTo(50)
    }
  }
}

// MARK: - Action

extension NameViewController {
  @objc fileprivate func backButtonDidTap() {
    print("dismissButtonDidTap")
    self.navigationController?.popViewController(animated: true)
    //    deleteUserInfo(id: 1)
  }
  
  @objc fileprivate func nextButtonDidTap() {
    guard let name = tripNameTextField.text else { return }
    //    saveUserInfo(id: 1, name: "요한", age: 24, startDate: getDate)
    let vc = StartDateViewController()
    vc.modalPresentationStyle = .fullScreen
    navigationController?.pushViewController(vc, animated: true)
    userDefalts.set(name, forKey: Common.UserDefaultKey.name.rawValue)
  }
}

// MARK: - UITextFieldDelegate

extension NameViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    guard let text = textField.text else { return false }
    print("End:", text.count)
    switch text.count {
    case 0:
      nextButton.isEnabled = false
      nextButton.alpha = 0.5
    default:
      nextButton.isEnabled = true
      nextButton.alpha = 1
    }
    
    return true
  }
}

