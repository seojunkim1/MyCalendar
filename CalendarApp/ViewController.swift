//
//  ViewController.swift
//  CalendarApp
//
//  Created by Pigman on 22/02/2019.
//  Copyright © 2019 Pigman. All rights reserved.
//

import UIKit

enum MyTheme {
    case light
    case dark
}

class ViewController: UIViewController {
    
    var theme = MyTheme.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Just Calendar!"
        self.navigationController?.navigationBar.isTranslucent = false  
        self.view.backgroundColor = Style.bgColor
        
        view.addSubview(calendarView)
        calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        calendarView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        calendarView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        calendarView.heightAnchor.constraint(equalToConstant: 365).isActive = true
        
        let rightBarButton = UIBarButtonItem(title: "화이트 모드", style: .plain, target: self, action: #selector(rightBarButtonAction))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func rightBarButtonAction(sender: UIBarButtonItem) {
        if theme == .dark {
            sender.title = "다크 모드"
            theme = .light
            Style.themeLight()
        } else {
            sender.title = "화이트 모드"
            theme = .dark
            Style.themeDark()
        }
        self.view.backgroundColor = Style.bgColor
        calendarView.changeTheme()
    }
    
    let calendarView: CalendarView = {
        let v = CalendarView(theme: MyTheme.dark)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
}


