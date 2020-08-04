//
//  WriteViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/08/01.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import SnapKit

class WriteViewController: UIViewController {
  
  fileprivate let titleLabel: UILabel = {
    let l = UILabel()
    l.text = "먼저,\n여행 일정을 선택해 주세요."
    l.font = UIFont.preferredFont(forTextStyle: .title1)
    l.numberOfLines = .zero
    l.textColor = Common.subColor
    
    return l
  }()

  fileprivate lazy var stackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [titleLabel])
    sv.spacing = 30
    
    return sv
  }()
  
  fileprivate let dismissButton: UIButton = {
    let b = UIButton()
    b.backgroundColor = Common.subColor
    b.setImage(UIImage(systemName: Common.SFSymbolKey.cancle.rawValue), for: .normal)
    b.tintColor = Common.mainColor
    b.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
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
    
    return b
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUI()
  }
}

// MARK: - UI

extension WriteViewController {
  fileprivate func setUI() {
    let guid = view.safeAreaLayoutGuide
    view.backgroundColor = Common.mainColor
    navigationItem.hidesBackButton = true
    
    dismissButton.frame = CGRect(
      x: view.bounds.minX + 40,
      y: view.bounds.height - 120,
      width: 60,
      height: 60
    )
    dismissButton.layer.cornerRadius = dismissButton.bounds.width / 2
    
    nextButton.frame = CGRect(
      x: view.bounds.maxX - 100,
      y: view.bounds.height - 120,
      width: 60,
      height: 60
    )
    nextButton.layer.cornerRadius = nextButton.bounds.height / 2
    
    // Layout
    
    [stackView, dismissButton, nextButton].forEach {
      view.addSubview($0)
    }
    
    stackView.snp.makeConstraints {
      $0.top.equalTo(guid)
      $0.trailing.equalTo(guid).offset(-40)
      $0.leading.equalTo(guid).offset(40)
    }
    
  }
}

// MARK: - Action

extension WriteViewController {
  @objc fileprivate func dismissButtonDidTap() {
    print("dismissButtonDidTap")
    self.navigationController?.popViewController(animated: true)
    deleteUserInfo(id: 1)
  }
  
  @objc fileprivate func nextButtonDidTap() {
    print("nextButtonDidTap")
    saveUserInfo(id: 1, name: "요한", age: 24)
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: - CoreData

extension WriteViewController {
  fileprivate func saveUserInfo(id: Int64, name: String, age: Int64) {
    CoreDataManager.coreDataShared.saveUser(
      id: id,
      name: name,
      age: age,
      date: Date()) { (onSuccess) in
        print("saved =", onSuccess)
    }
  }
  
  fileprivate func deleteUserInfo(id: Int64) {
    CoreDataManager.coreDataShared.deleteUser(id: id) { (onSuccess) in
      print("delete =", onSuccess)
    }
  }
}
