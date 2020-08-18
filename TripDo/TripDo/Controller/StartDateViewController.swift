//
//  WriteViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/08/01.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import SnapKit

class StartDateViewController: UIViewController {
  
  let userDefaults = UserDefaults.standard
  
  fileprivate let layout = UICollectionViewFlowLayout()
  
  fileprivate let months = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
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
  fileprivate var nowDate = String()
  fileprivate var getStartDate = String()
  
  fileprivate var selectionArray = [String]()
  
  fileprivate let titleLabel: UILabel = {
    let l = UILabel()
    l.text = "이제,\n여행의 시작날짜를\n입력해 주세요."
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
  
  fileprivate let backButton: UIButton = {
    let b = UIButton()
    b.backgroundColor = Common.subColor
    b.setImage(UIImage(systemName: Common.SFSymbolKey.back.rawValue), for: .normal)
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
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M"
    nowDate = dateFormatter.string(from: Date())
    
    currentMonth = months[month]
    monthLabel.text = "\(year)년 \(currentMonth)월"
    if weekday == 0 {
      weekday = 7
    }
    GetStartDateDayPosition()
    
    setUI()
  }
}

// MARK: - UI

extension StartDateViewController {
  fileprivate func setUI() {
    let guid = view.safeAreaLayoutGuide
    calenderCollectionView.dataSource = self
    calenderCollectionView.delegate = self
    calenderCollectionView.allowsMultipleSelection = true
    view.backgroundColor = Common.mainColor
    navigationItem.hidesBackButton = true
    
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
    
    
    print("currentDate: ", currentMonth)
    for i in 0...daysOfMonth.count - 1 {
      setWeekLable(text: daysOfMonth[i])
      if i == 1 {
        //        daysOfMonth[i]
      }
    }
    
    // Layout
    
    [titleLabel, stackView, weekStackView, calenderCollectionView, backButton, nextButton].forEach {
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

extension StartDateViewController {
  @objc fileprivate func backButtonDidTap() {
    print("dismissButtonDidTap")
    let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
    deleteUserInfo(id: Int64(userInfo.count) - 1)
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc fileprivate func nextButtonDidTap() {
    guard let getName = userDefaults.string(forKey: Common.UserDefaultKey.name.rawValue) else { return }
    guard let getStartDate = selectionArray.sorted().first else { return }
    guard let getEndDate = selectionArray.sorted().last else { return }
    
    // Time Interval
    let format = DateFormatter()
    format.dateFormat = "yyyy-M-dd"
    guard let startDate = format.date(from: getStartDate) else { return }
    guard let endDate = format.date(from: getEndDate) else { return }
    let timeInterval = Double(endDate.timeIntervalSince(startDate))
    let taskCount = Int(floor(timeInterval/86400) + 1)
    let task: [Task] = CoreDataManager.coreDataShared.getTasks()
    let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
    
    for i in 1...taskCount {
      saveTask(taskId: Int64(userInfo.count), taskCellId: Int64(i), address: "", post: "", check: false)
      print("=====================// StartDateViewController i\n", i)
    }
    
    saveUserInfo(id: Int64(userInfo.count), name: getName, age: 24, startDate: getStartDate, endDate: getEndDate, task: task)
    
    self.navigationController?.popToRootViewController(animated: true)
    print("nextButtonDidTap")
  }
  
  @objc fileprivate func didTapYearNextButton() {
    switch currentMonth {
    case "12":
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
      monthLabel.text = "\(year)년 \(currentMonth)월"
      calenderCollectionView.reloadData()
      
    default:
      direction = 1
      GetStartDateDayPosition()
      month += 1
      currentMonth = months[month]
      monthLabel.text = "\(year)년 \(currentMonth)월"
      calenderCollectionView.reloadData()
    }
  }
  
  @objc fileprivate func didTapYearBackButton() {
    if currentMonth == nowDate {
      showAlert(alertText: "error", alertMessage: "과거로의 여행은 불가능 합니다.")
    } else {
      switch currentMonth {
      case "1":
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
        monthLabel.text = "\(year)년 \(currentMonth)월"
        calenderCollectionView.reloadData()
        
      default:
        direction = -1
        month -= 1
        GetStartDateDayPosition()
        currentMonth = months[month]
        monthLabel.text = "\(year)년 \(currentMonth)월"
        calenderCollectionView.reloadData()
      }
    }
  }
}

// MARK: - UICollectionViewDataSource

extension StartDateViewController: UICollectionViewDataSource  {
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
    
    if Int(cell.calenderDateLabel.text!)! < calendar.component(.day, from: date) && currentMonth == months[calendar.component(.month, from: date) - 1] {
      cell.calenderDateLabel.alpha = 0.5
      cell.isUserInteractionEnabled = false
    } else {
      cell.calenderDateLabel.alpha = 1
      cell.isUserInteractionEnabled = true
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
      Common.shadowMaker(view: cell)
    }
   
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension StartDateViewController: UICollectionViewDelegateFlowLayout {
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
    print("0:", nowDate)
    print("1:", indexPath.row)
    print("2:", calendar.component(.day, from: date))
    print("3:", currentMonth == months[calendar.component(.month, from: date) - 1])
    
    if selectionArray.count == 2 {
      titleLabel.text = "이제,\n여행의 시작날짜를\n입력해 주세요."
      selectionArray = []
      collectionView.reloadData()
      nextButton.isEnabled = false
      nextButton.alpha = 0.5
    }
    
    switch direction {
    case 0:
      getStartDate = "\(year)-\(currentMonth)-\(indexPath.row - numberOfEmptyBox)"
      print(getStartDate)
      selectionArray.append(getStartDate)
      print("0 Array:", selectionArray.sorted())
    case 1:
      getStartDate = "\(year)-\(currentMonth)-\(indexPath.row - nextNumberOfEmptyBox)"
      print(getStartDate)
      selectionArray.append(getStartDate)
      print("1 Array:", selectionArray.sorted())
    case -1:
      getStartDate = "\(year)-\(currentMonth)-\(indexPath.row - previousNumberOfEmptyBox)"
      print(getStartDate)
      selectionArray.append(getStartDate)
      print("-1 Array:", selectionArray.sorted())
    default:
      fatalError()
    }
    print("4", selectionArray.count)
    switch selectionArray.count - 1 {
    case 0:
      titleLabel.text = "이제,\n여행의 종료날짜를\n입력해 주세요."
      nextButton.isEnabled = false
      nextButton.alpha = 0.5
    case 1:
      titleLabel.text = "이제,\n여행 날짜설정이\n완료되었습니다."
      print(selectionArray)
      print("first: ",selectionArray.sorted().first!)
      print("last: ",selectionArray.sorted().last!)
      nextButton.isEnabled = true
      nextButton.alpha = 1
      showAlert(alertText: "여행 날자를 확인하세요.", alertMessage: "시작 날짜 : \(selectionArray.sorted().first!)\n종료 날짜 \(selectionArray.sorted().last!)")
    default:
      break;
    }
  }
}

// MARK: - Calender

extension StartDateViewController {
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

// MARK: - CoreData

extension StartDateViewController {
  fileprivate func saveUserInfo(id: Int64, name: String, age: Int64, startDate: String, endDate: String, task: [Any]) {
    CoreDataManager.coreDataShared.saveUser(
      id: id,
      name: name,
      age: age,
      startDate: startDate,
      endDate: endDate,
      task: NSSet.init(array: task),
      date: Date()) { (onSuccess) in
        print("savedUser =", onSuccess)
    }
  }
  
  fileprivate func saveTask(taskId: Int64, taskCellId: Int64, address: String, post: String, check: Bool) {
    CoreDataManager.coreDataShared.saveTask(
      taskId: taskId,
      taskCellId: taskCellId,
      address: address,
      post: post,
      check: check,
      date: Date()) { (onSuccess) in
        print("savedTask =", onSuccess)
    }
  }
  
  fileprivate func deleteUserInfo(id: Int64) {
    CoreDataManager.coreDataShared.deleteUser(id: id) { (onSuccess) in
      print("deleteUser =", onSuccess)
    }
  }
}

