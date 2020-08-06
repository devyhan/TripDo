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
  
  fileprivate let layout = UICollectionViewFlowLayout()
  
  fileprivate let months = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
  fileprivate let daysOfMonth = ["일", "월", "화", "수", "목", "금", "토"]
  fileprivate var daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  fileprivate var currentMonth = String()
  fileprivate var numberOfEmptyBox = Int()
  fileprivate var nextNumberOfEmptyBox = Int()
  fileprivate var previousNumberOfEmptyBox = 0
  fileprivate var direction = 0
  fileprivate var positionIndex = 0
  fileprivate var leapYearCounter = 2
  fileprivate var dayCounter = 0
  fileprivate var nowDate = 0
  
  fileprivate let titleLabel: UILabel = {
    let l = UILabel()
    l.text = "먼저,\n여행 일정을 선택해 주세요."
    l.font = UIFont.preferredFont(forTextStyle: .title1)
    l.numberOfLines = .zero
    l.textColor = Common.subColor
    
    return l
  }()
  
  fileprivate let yearBackButton: UIButton = {
    let b = UIButton()
    b.setImage(UIImage(systemName: Common.SFSymbolKey.back.rawValue), for: .normal)
    b.tintColor = Common.subColor
    b.addTarget(self, action: #selector(didTapYearBackButton), for: .touchUpInside)
    
    return b
  }()
  
  fileprivate let monthLabel: UILabel = {
    let l = UILabel()
    l.textAlignment = .center
    l.textColor = Common.subColor
    
    return l
  }()
  
  fileprivate let yearNextButton: UIButton = {
    let b = UIButton()
    b.setImage(UIImage(systemName: Common.SFSymbolKey.next.rawValue), for: .normal)
    b.tintColor = Common.subColor
    b.addTarget(self, action: #selector(didTapYearNextButton), for: .touchUpInside)
    
    return b
  }()
  
  fileprivate lazy var stackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [yearBackButton, monthLabel, yearNextButton])
    sv.axis = .horizontal
    sv.distribution = .fillEqually
    
    return sv
  }()
  
  fileprivate lazy var weekStackView: UIStackView = {
    let sv = UIStackView()
    sv.axis = .horizontal
    sv.distribution = .fillEqually
    
    return sv
  }()
  
  fileprivate lazy var calenderCollectionView: UICollectionView = {
    let cv = UICollectionView(frame: .infinite, collectionViewLayout: layout)
    cv.register(CalenderCollectionViewCell.self, forCellWithReuseIdentifier: CalenderCollectionViewCell.identifier)
    cv.backgroundColor = Common.mainColor
    
    return cv
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
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    nowDate = Int(dateFormatter.string(from: Date()))!
    
    currentMonth = months[month]
    monthLabel.text = "\(year)년 \(currentMonth)"
    if weekday == 0 {
      weekday = 7
    }
    GetStartDateDayPosition()
    
    setUI()
  }
}

// MARK: - UI

extension WriteViewController {
  fileprivate func setUI() {
    let guid = view.safeAreaLayoutGuide
    calenderCollectionView.dataSource = self
    calenderCollectionView.delegate = self
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
    
    for i in 0...daysOfMonth.count - 1 {
      setWeekLable(text: daysOfMonth[i])
      if i == 1 {
        //        daysOfMonth[i]
      }
    }
    
    // Layout
    
    [titleLabel, stackView, weekStackView, calenderCollectionView, dismissButton, nextButton].forEach {
      view.addSubview($0)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(guid).offset(20)
      $0.trailing.equalTo(guid).offset(-40)
      $0.leading.equalTo(guid).offset(40)
    }
    
    stackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(40)
      $0.trailing.equalTo(guid).offset(-40)
      $0.leading.equalTo(guid).offset(40)
    }
    
    weekStackView.snp.makeConstraints {
      $0.top.equalTo(stackView.snp.bottom).offset(20)
      $0.trailing.equalTo(guid).offset(-20)
      $0.leading.equalTo(guid).offset(50)
      $0.height.equalTo(50)
    }
    
    calenderCollectionView.snp.makeConstraints {
      $0.top.equalTo(weekStackView.snp.bottom).offset(-10)
      $0.trailing.equalTo(guid).offset(-30)
      $0.leading.equalTo(guid).offset(30)
      $0.bottom.equalTo(guid)
    }
    
    setCollectionView()
  }
  
  fileprivate func setCollectionView() {
    layout.sectionInset = .init(top: 8, left: 8, bottom: 8, right: 8)
    layout.minimumLineSpacing = 8
    layout.scrollDirection = .vertical
  }
  
  fileprivate func setWeekLable(text: String) {
    let l = UILabel()
    l.text = text
    l.textColor = Common.subColor
    
    weekStackView.addArrangedSubview(l)
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
  
  @objc fileprivate func didTapYearNextButton() {
    switch currentMonth {
    case "12월":
      direction = 1
      month = 0
      year += 1
      
      if leapYearCounter  < 5 {
        leapYearCounter += 1
      }
      if leapYearCounter == 4 {
        daysInMonths[1] = 29
      }
      if leapYearCounter == 5{
        leapYearCounter = 1
        daysInMonths[1] = 28
      }
      
      GetStartDateDayPosition()
      currentMonth = months[month]
      monthLabel.text = "\(year)년 \(currentMonth)"
      calenderCollectionView.reloadData()
      
    default:
      direction = 1
      GetStartDateDayPosition()
      month += 1
      currentMonth = months[month]
      monthLabel.text = "\(year)년 \(currentMonth)"
      calenderCollectionView.reloadData()
    }
  }
  
  @objc fileprivate func didTapYearBackButton() {
    switch currentMonth {
    case "1월":
      direction = -1
      month = 11
      year -= 1
      
      if leapYearCounter > 0 {
        leapYearCounter -= 1
      }
      if leapYearCounter == 0 {
        daysInMonths[1] = 29
        leapYearCounter = 4
      } else {
        daysInMonths[1] = 28
      }
      
      GetStartDateDayPosition()
      currentMonth = months[month]
      monthLabel.text = "\(year)년 \(currentMonth)"
      calenderCollectionView.reloadData()
      
    default:
      direction = -1
      month -= 1
      GetStartDateDayPosition()
      currentMonth = months[month]
      monthLabel.text = "\(year)년 \(currentMonth)"
      calenderCollectionView.reloadData()
    }
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

// MARK: - UICollectionViewDataSource

extension WriteViewController: UICollectionViewDataSource  {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch direction{
    case 0:
      return daysInMonths[month] + 1 + numberOfEmptyBox
    case 1...:
      return daysInMonths[month] + 1 + nextNumberOfEmptyBox
    case -1:
      return daysInMonths[month] + 1 + previousNumberOfEmptyBox
    default:
      fatalError()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalenderCollectionViewCell.identifier, for: indexPath) as! CalenderCollectionViewCell
    
    cell.backgroundColor = UIColor.clear
    cell.cycleView.isHidden = true
    
    if cell.isHidden {
      cell.isHidden = false
    }
    switch direction {
    case 0:
      cell.calenderDateLabel.text = "\(indexPath.row - numberOfEmptyBox)"
    case 1:
      cell.calenderDateLabel.text = "\(indexPath.row - nextNumberOfEmptyBox)"
    case -1:
      cell.calenderDateLabel.text = "\(indexPath.row  - previousNumberOfEmptyBox)"
    default:
      fatalError()
    }
    
    if Int(cell.calenderDateLabel.text!)! < 1 {
      cell.isHidden = true
    }
    
    switch indexPath.row {
    case 6, 7, 13, 14, 20, 21, 27, 28, 34, 35:
      if Int(cell.calenderDateLabel.text!)! > 0 {
        cell.calenderDateLabel.textColor = Common.edgeColor
      }
    default:
      cell.calenderDateLabel.textColor = Common.subColor
    }
    if currentMonth == months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row - numberOfEmptyBox == day {
      cell.cycleView.isHidden = false
      cell.DrawCircle()
    }
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension WriteViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    layout.sectionInset
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width / 8
    let height = collectionView.frame.width / 8
    
    return CGSize(width: width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    switch direction {
    case 0:
      print("year: \(year), currentMonth: \(currentMonth), days: \(indexPath.row - numberOfEmptyBox)")
    case 1:
      print("year: \(year), currentMonth: \(currentMonth), days: \(indexPath.row - numberOfEmptyBox)")
    case -1:
      print("year: \(year), currentMonth: \(currentMonth), days: \(indexPath.row - numberOfEmptyBox)")
    default:
      fatalError()
    }
  }
}

// MARK: - Calender

extension WriteViewController {
  func GetStartDateDayPosition() {
    switch direction {
    case 0:
      numberOfEmptyBox = weekday
      dayCounter = day
      while dayCounter > 0 {
        numberOfEmptyBox = numberOfEmptyBox - 1
        dayCounter = dayCounter - 1
        if numberOfEmptyBox == 0 {
          numberOfEmptyBox = 7
        }
      }
      if numberOfEmptyBox == 7 {
        numberOfEmptyBox = 0
      }
      positionIndex = numberOfEmptyBox
    case 1...:
      nextNumberOfEmptyBox = (positionIndex + daysInMonths[month]) % 7
      positionIndex = nextNumberOfEmptyBox
    case -1:
      previousNumberOfEmptyBox = (7 - (daysInMonths[month] - positionIndex) % 7)
      if previousNumberOfEmptyBox == 7 {
        previousNumberOfEmptyBox = 0
      }
      positionIndex = previousNumberOfEmptyBox
    default:
      fatalError()
    }
  }
}
