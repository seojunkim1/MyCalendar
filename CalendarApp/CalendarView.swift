//
//  CalendarView.swift
//  CalendarApp
//
//  Created by Pigman on 22/02/2019.
//  Copyright © 2019 Pigman. All rights reserved.
//

import UIKit

struct Colors {
    static var darkGray = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    static var darkRed = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
}

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLabelColor = UIColor.white
    static var monthViewButtonRightColor = UIColor.white
    static var monthViewButtonLeftColor = UIColor.white
    static var activeCellLabelColor = UIColor.white
    static var activeCellLabelColorHighlighted = UIColor.black
    static var weekdaysLabelColor = UIColor.white
    
    static func themeDark() {
        bgColor = Colors.darkGray
        monthViewLabelColor = UIColor.white
        monthViewButtonRightColor = UIColor.white
        monthViewButtonLeftColor = UIColor.white
        activeCellLabelColor = UIColor.white
        activeCellLabelColorHighlighted = UIColor.black
        weekdaysLabelColor = UIColor.white
    }
    
    static func themeLight(){
        bgColor = UIColor.white
        monthViewLabelColor = UIColor.black
        monthViewButtonRightColor = UIColor.black
        monthViewButtonLeftColor = UIColor.black
        activeCellLabelColor = UIColor.black
        activeCellLabelColorHighlighted = UIColor.white
        weekdaysLabelColor = UIColor.black
        
    }
    
}


class CalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    // MonthViewDelegate는 MonthView에서 왔음. Calendar View의 변화를 알려줘야하기때문에
    
    var numberOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear:Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0     //(Sunday-Saturday 1-7)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    convenience init(theme: MyTheme) {      // convenience 초기화 : 2개의 value를 처리할 수 있는 enumerator임.
        self.init()
        
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        
        initializeView()
    }
    
    func changeTheme() {        // 모드 바꿔주는 함수
        
        myCollectionView.reloadData()
        
        monthView.lblName.textColor = Style.monthViewLabelColor
        monthView.btnRight.setTitleColor(Style.monthViewButtonRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewButtonLeftColor, for: .normal)
        
        for i in 0..<7 {
            (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLabelColor
        }
        
    }
    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()
        
        // 2월달에 29일 날짜 표시해주는거
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numberOfDaysInMonth[currentMonthIndex-1] = 29
        }
        
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        
        setupView()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1   // month의 첫번째 날을 구하기 위해 firstWeekDayOfMonth -1 을 해줌.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.backgroundColor = UIColor.clear
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden = true
            // month가 바뀌면서 Cell을 숨기는거임. 여기가 잘 이해 안됨. 다시 생각해보자.
            
        } else {    // 오늘기준으로 지난 day는 disabled하게 해주는 코드
            let calcDate = indexPath.row - firstWeekDayOfMonth + 2
            cell.isHidden = false
            cell.lbl.text = "\(calcDate)"
            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                cell.isUserInteractionEnabled = false
                cell.lbl.textColor = UIColor.lightGray
            } else {
                cell.isUserInteractionEnabled = true
                cell.lbl.textColor = Style.activeCellLabelColor
            }
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = Colors.darkRed
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = UIColor.white
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = Style.activeCellLabelColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        
        return day
    }
    
    
    func didChangeMonth(monthIndex: Int, year: Int) {   // delegate 함수임.
        currentMonthIndex = monthIndex + 1
        currentYear = year
        
        // 2월달 만들어주는 코드
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numberOfDaysInMonth[monthIndex] = 29
            } else {
                numberOfDaysInMonth[monthIndex] = 28
            }
        }
        
        firstWeekDayOfMonth = getFirstWeekDay()
        myCollectionView.reloadData()       // month가 바뀌니까 myCollectionView 갱신해줘야함!
        monthView.btnLeft.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)       // month 바꿔주는 버튼이 작동안할 수도 있음. isEnabled 프로퍼티에 &&조건을 걸어줘서 오류없이 작동하게 하는 코드.
    }
    
    
    
    func setupView() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        monthView.delegate = self       // month가 바뀌면 CalendarView에 noti를 줘야하기 때문에 delegate를 선언해줘야함.
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive = true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive = true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    let monthView: MonthView = {    // MonthView는 소스파일에서 가져온거임.
        let v = MonthView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v = WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let myCollectionView: UICollectionView = {      // day가 표시되는 view 전체가 myCollectionView 임. 전반적인 디자인임. dateCVCell는 day 하나 하나에 적용되는 디자인임.
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)    // 레이아웃 초기화
        
        let myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.backgroundColor = UIColor.clear
        myCollectionView.allowsMultipleSelection = false
        return myCollectionView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class dateCVCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.cornerRadius = 5
        layer.masksToBounds = true
        setupViews()
        
    }
    
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"       // 초기화 시켜주는 코드
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// 각 달의 첫번째 날을 가져옴
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

// 각 달의 첫번째 문자열을 가져옴
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
