//
//  TripDoUITests.swift
//  TripDoUITests
//
//  Created by 요한 on 2020/08/12.
//  Copyright © 2020 요한. All rights reserved.
//

import XCTest

// test로 시작한 메서드만 인식한다.

// 에니메이션이 포함되어있을경우 딜레이 때문에, 요소가 없다고 판단할 수 있다 그래서 .waitForExistence(timeout: )을 사용해준다

class TripDoUITests: XCTestCase {
  
  var app: XCUIApplication!
  
  // XCUIElementQuery = 각 요소들의 질문
  // XCUIElement = 여러가지 이벤트
  
  override func setUpWithError() throws {
    
    self.app = XCUIApplication()
    self.app.launch()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_all() {
    
    
    let app = XCUIApplication()
    app.buttons["plus"].tap()
    
    let textFiled = app.textFields["ex) 1박 2일 서울투어 !!"]
    textFiled.tap()
    textFiled.typeText("여행")
    
    app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards.buttons[\"Return\"]",".buttons[\"Return\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    app.buttons["Forward"].tap()
    
    let collectionViewsQuery = app.collectionViews
    collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["25"]/*[[".cells.staticTexts[\"25\"]",".staticTexts[\"25\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    
    let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
    element.children(matching: .other).element(boundBy: 0).buttons["Forward"].tap()
    collectionViewsQuery.cells.containing(.staticText, identifier:"1").children(matching: .other).element.tap()
    app.alerts["여행 날자를 확인하세요."].buttons["확인"].tap()
    element.children(matching: .button)["Forward"].tap()
    
    collectionViewsQuery.children(matching: .cell).element(boundBy: 0).staticTexts["여행"].tap()
    app/*@START_MENU_TOKEN@*/.collectionViews.containing(.other, identifier:"Vertical scroll bar, 2 pages").element/*[[".collectionViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\").element",".collectionViews.containing(.other, identifier:\"Vertical scroll bar, 2 pages\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
    collectionViewsQuery.children(matching: .cell).element(boundBy: 1).staticTexts["임실 치즈 테마파크"].swipeDown()
    app.buttons["magnifyingglass"].tap()
    
    sleep(3)
    
    let webViewsQuery = app.webViews.webViews.webViews
    webViewsQuery/*@START_MENU_TOKEN@*/.textFields["예) 판교역로 235, 분당 주공, 삼평동 681"]/*[[".otherElements.matching(identifier: \"우편번호검색프레임\")",".otherElements[\"우편번호 검색 입력폼\"].textFields[\"예) 판교역로 235, 분당 주공, 삼평동 681\"]",".textFields[\"예) 판교역로 235, 분당 주공, 삼평동 681\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    app.buttons["Next keyboard"].tap()
    
    let key = app/*@START_MENU_TOKEN@*/.keys["ㅍ"]/*[[".keyboards.keys[\"ㅍ\"]",".keys[\"ㅍ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    key.tap()
    
    let key2 = app/*@START_MENU_TOKEN@*/.keys["ㅏ"]/*[[".keyboards.keys[\"ㅏ\"]",".keys[\"ㅏ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    key2.tap()
    
    let key3 = app/*@START_MENU_TOKEN@*/.keys["ㄴ"]/*[[".keyboards.keys[\"ㄴ\"]",".keys[\"ㄴ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    key3.tap()
    
    let key4 = app/*@START_MENU_TOKEN@*/.keys["ㄱ"]/*[[".keyboards.keys[\"ㄱ\"]",".keys[\"ㄱ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    key4.tap()
    
    let key5 = app/*@START_MENU_TOKEN@*/.keys["ㅛ"]/*[[".keyboards.keys[\"ㅛ\"]",".keys[\"ㅛ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    key5.tap()
    app/*@START_MENU_TOKEN@*/.buttons["Go"]/*[[".keyboards",".buttons[\"이동\"]",".buttons[\"Go\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    webViewsQuery/*@START_MENU_TOKEN@*/.buttons["경기 성남시 분당구 대왕판교로 477 (낙생고등학교)"]/*[[".otherElements.matching(identifier: \"우편번호검색프레임\").buttons[\"경기 성남시 분당구 대왕판교로 477 (낙생고등학교)\"]",".buttons[\"경기 성남시 분당구 대왕판교로 477 (낙생고등학교)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    
    sleep(5)
    
    let multiplyButton = app.buttons["multiply"]
    multiplyButton.tap()
    multiplyButton.tap()


    
  }
  
  func testExample() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication() // 우리 앱을 간접적으로 사용 가능하게 해주는 메서드
    app.launch() // 런처를 꼭 해줘야 한다.
    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  
//  성능 테스트
//  func testLaunchPerformance() throws {
//    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//      // This measures how long it takes to launch your application.
//      measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//        XCUIApplication().launch()
//      }
//    }
//  }
}
