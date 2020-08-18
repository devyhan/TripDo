//
//  TripDoUITests.swift
//  TripDoUITests
//
//  Created by 요한 on 2020/08/16.
//  Copyright © 2020 요한. All rights reserved.
//

import XCTest

class TripDoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()
      
      let plusButton = app.buttons["plus"]
      plusButton.tap()
      
      let ex12TextField = app.textFields["ex) 1박 2일 서울투어 !!"]
      ex12TextField.tap()
      
      let moreKey = app/*@START_MENU_TOKEN@*/.keys["more"]/*[[".keyboards",".keys[\"숫자\"]",".keys[\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
      moreKey.tap()
      moreKey.tap()
      
      let key = app/*@START_MENU_TOKEN@*/.keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      key.tap()
      key.tap()
      
      let window = app.children(matching: .window).element(boundBy: 0)
      let element = window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
      element.tap()
      
      let forwardButton = app.buttons["Forward"]
      forwardButton.tap()
      
      let collectionViewsQuery = app.collectionViews
      let staticText = collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["25"]/*[[".cells.staticTexts[\"25\"]",".staticTexts[\"25\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      staticText.tap()
      staticText.tap()
      
      let button = app.alerts["여행 날자를 확인하세요."].scrollViews.otherElements.buttons["확인"]
      button.tap()
      
      let forwardButton2 = element.children(matching: .button)["Forward"]
      forwardButton2.tap()
      plusButton.tap()
      ex12TextField.tap()
      moreKey.tap()
      moreKey.tap()
      
      let key2 = app/*@START_MENU_TOKEN@*/.keys["2"]/*[[".keyboards.keys[\"2\"]",".keys[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      key2.tap()
      key2.tap()
      app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards.buttons[\"Return\"]",".buttons[\"Return\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      forwardButton.tap()
      collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["26"]/*[[".cells.staticTexts[\"26\"]",".staticTexts[\"26\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["27"]/*[[".cells.staticTexts[\"27\"]",".staticTexts[\"27\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      button.tap()
      forwardButton2.tap()
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
