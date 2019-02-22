//
//  WeekdaysView.swift
//  CalendarApp
//
//  Created by Pigman on 22/02/2019.
//  Copyright © 2019 Pigman. All rights reserved.
//

import UIKit

class WeekdaysView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        setupView()
        
        
    }
    
    func setupView() {
        addSubview(myStackView)
        myStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        myStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        myStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        myStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        var daysArray = ["일", "월", "화", "수", "목", "금", "토"]
        for i in 0..<7 {
            let lbl = UILabel()
            lbl.text = daysArray[i]
            lbl.textAlignment = .center
            lbl.textColor = Style.weekdaysLabelColor
            myStackView.addArrangedSubview(lbl)
        }
    }
    
    let myStackView: UIStackView = {    
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
