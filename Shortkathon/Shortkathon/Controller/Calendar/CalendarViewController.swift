import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, AddButtonModalViewControllerDelegate {

    private var calendar: FSCalendar!
    private var addButton: UIButton!
    private var prevButton: UIButton!
    private var nextButton: UIButton!
    
    private var events: [(name: String, startDate: Date, endDate: Date, isDetailed: Bool)] = []
    private var eventRangeViews: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = #colorLiteral(red: 0.1829021573, green: 0.1829021573, blue: 0.1829021573, alpha: 1)
        
        calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(calendar)
        
        calendar.backgroundColor = #colorLiteral(red: 0.1829021573, green: 0.1829021573, blue: 0.1829021573, alpha: 1)
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerTitleColor = .white
        calendar.appearance.weekdayTextColor = .white
        calendar.appearance.titleDefaultColor = .white
        calendar.appearance.titlePlaceholderColor = .gray
        calendar.appearance.selectionColor = .systemBlue
        calendar.appearance.todayColor = #colorLiteral(red: 0.1829021573, green: 0.1829021573, blue: 0.1829021573, alpha: 1)
        calendar.placeholderType = .fillHeadTail
        
        prevButton = UIButton(type: .system)
        prevButton.setImage(UIImage(named: "leftButton"), for: .normal)
        prevButton.tintColor = .white
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(prevButton)
        
        nextButton = UIButton(type: .system)
        nextButton.setImage(UIImage(named: "rightButton"), for: .normal)
        nextButton.tintColor = .white
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        prevButton.addTarget(self, action: #selector(prevButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 600),
            
            prevButton.centerYAnchor.constraint(equalTo: calendar.calendarHeaderView.centerYAnchor),
            prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            prevButton.widthAnchor.constraint(equalToConstant: 20),
            prevButton.heightAnchor.constraint(equalToConstant: 20),
            
            nextButton.centerYAnchor.constraint(equalTo: calendar.calendarHeaderView.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nextButton.widthAnchor.constraint(equalToConstant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        addButton = UIButton(type: .system)
        addButton.setTitle("일정 추가", for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addEventRangeLine()
    }
    
    @objc private func addButtonTapped() {
        let modalVC = AddButtonModalViewController()
        modalVC.delegate = self
        modalVC.modalPresentationStyle = .pageSheet
        present(modalVC, animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Selected date: \(date)")
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    func didAddEvent(name: String, startDate: Date, endDate: Date, isDetailed: Bool) {
        let newEvent = (name: name, startDate: startDate, endDate: endDate, isDetailed: isDetailed)
        let level = getOverlappingLineLevel(for: newEvent)
        
        if level == -1 {
            let alert = UIAlertController(title: "알림",
                                        message: "해당 기간의 특정 날짜에 이미 3개의 일정이 존재합니다.",
                                        preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        events.append(newEvent)
        sortEventsByStartDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        for i in 0..<events.count {
            var usedLevels = Set<Int>()
            
            for j in 0..<i {
                let event1 = events[j]
                let event2 = events[i]
                
                let start1 = formatter.string(from: event1.startDate)
                let end1 = formatter.string(from: event1.endDate)
                let start2 = formatter.string(from: event2.startDate)
                let end2 = formatter.string(from: event2.endDate)
                
                if max(start1, start2) <= min(end1, end2) {
                    usedLevels.insert(j % 3)
                }
            }
            
            var newLevel = 0
            while usedLevels.contains(newLevel) {
                newLevel += 1
            }
            
            if i != events.count - 1 {
                let temp = events[i]
                events.remove(at: i)
                events.insert(temp, at: newLevel)
            }
        }
        
        calendar.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.addEventRangeLine()
        }
    }
    
    private func hasEvent(for date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        return events.contains { event in
            let startDateString = formatter.string(from: event.startDate)
            let endDateString = formatter.string(from: event.endDate)
            return dateString >= startDateString && dateString <= endDateString
        }
    }

    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return nil
    }
    
    private func addEventRangeLine() {
        eventRangeViews.forEach { $0.removeFromSuperview() }
        eventRangeViews.removeAll()
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        for (index, event) in events.enumerated() {
            guard let startCell = calendar.cell(for: event.startDate, at: .current),
                  let endCell = calendar.cell(for: event.endDate, at: .current) else {
                print("Date is not in the current visible range.")
                continue
            }
            
            let lineColor = event.isDetailed ?
                UIColor.systemBlue.withAlphaComponent(0.3) :
                UIColor.systemYellow.withAlphaComponent(0.3)
            
            let startPoint = startCell.convert(startCell.bounds.origin, to: calendar)
            let endPoint = endCell.convert(endCell.bounds.origin, to: calendar)
            let level = index % 3
            let verticalOffset = CGFloat(level) * 15
            
            if startPoint.y == endPoint.y {
                let lineView = UIView()
                lineView.backgroundColor = lineColor
                lineView.layer.cornerRadius = 3
                calendar.addSubview(lineView)
                
                let startX = startPoint.x
                let endX = endCell.convert(endCell.bounds, to: calendar).maxX
                let y = startPoint.y + startCell.frame.height - 25 + verticalOffset
                
                lineView.frame = CGRect(x: startX, y: y, width: endX - startX, height: 10)
                eventRangeViews.append(lineView)
                
                let timeLabel = UILabel()
                timeLabel.text = "~\(timeFormatter.string(from: event.endDate))"
                timeLabel.font = .systemFont(ofSize: 10)
                timeLabel.textColor = event.isDetailed ? .systemBlue : .systemYellow
                timeLabel.sizeToFit()
                calendar.addSubview(timeLabel)
                
                timeLabel.frame.origin = CGPoint(
                    x: endX - timeLabel.frame.width - 5,
                    y: y - 2
                )
                eventRangeViews.append(timeLabel)
                
                addLongPressGesture(to: lineView, for: event)
                
            } else {
                let firstLineView = UIView()
                firstLineView.backgroundColor = lineColor
                firstLineView.layer.cornerRadius = 5
                calendar.addSubview(firstLineView)
                
                let firstLineStartX = startPoint.x
                let firstLineEndX = calendar.bounds.width
                let firstLineY = startPoint.y + startCell.frame.height - 25 + verticalOffset
                
                firstLineView.frame = CGRect(x: firstLineStartX, y: firstLineY, width: firstLineEndX - firstLineStartX, height: 10)
                eventRangeViews.append(firstLineView)
                
                addLongPressGesture(to: firstLineView, for: event)
                
                let lastLineView = UIView()
                lastLineView.backgroundColor = lineColor
                lastLineView.layer.cornerRadius = 5
                calendar.addSubview(lastLineView)
                
                let lastLineStartX: CGFloat = 0
                let lastLineEndX = endCell.convert(endCell.bounds, to: calendar).maxX
                let lastLineY = endPoint.y + endCell.frame.height - 25 + verticalOffset
                
                lastLineView.frame = CGRect(x: lastLineStartX, y: lastLineY, width: lastLineEndX, height: 10)
                eventRangeViews.append(lastLineView)
                
                addLongPressGesture(to: lastLineView, for: event)
                
                let timeLabel = UILabel()
                timeLabel.text = "~\(timeFormatter.string(from: event.endDate))"
                timeLabel.font = .systemFont(ofSize: 10)
                timeLabel.textColor = event.isDetailed ? .systemBlue : .systemYellow
                timeLabel.sizeToFit()
                calendar.addSubview(timeLabel)
                
                timeLabel.frame.origin = CGPoint(
                    x: lastLineEndX - timeLabel.frame.width - 5,
                    y: lastLineY - 2
                )
                eventRangeViews.append(timeLabel)
                
                if endPoint.y - startPoint.y > startCell.frame.height {
                    let rowCount = Int((endPoint.y - startPoint.y) / startCell.frame.height)
                    
                    let firstLineY = startPoint.y + startCell.frame.height - 25 + verticalOffset
                    let lastLineY = endPoint.y + endCell.frame.height - 25 + verticalOffset
                    let totalHeight = lastLineY - firstLineY
                    
                    for row in 1..<rowCount {
                        let middleLineView = UIView()
                        middleLineView.backgroundColor = lineColor
                        middleLineView.layer.cornerRadius = 5
                        calendar.addSubview(middleLineView)
                        
                        let ratio = CGFloat(row) / CGFloat(rowCount)
                        let middleY = firstLineY + (totalHeight * ratio)
                        
                        middleLineView.frame = CGRect(
                            x: 0,
                            y: middleY,
                            width: calendar.bounds.width,
                            height: 10
                        )
                        eventRangeViews.append(middleLineView)
                        
                        addLongPressGesture(to: middleLineView, for: event)
                    }
                }
            }
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.addEventRangeLine()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addEventRangeLine()
    }
    
    private func getOverlappingLineLevel(for newEvent: (name: String, startDate: Date, endDate: Date, isDetailed: Bool)) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        var usedLevels = Set<Int>()
        
        var currentDate = newEvent.startDate
        
        while currentDate <= newEvent.endDate {
            let dateString = formatter.string(from: currentDate)
            
            for event in events {
                let eventStartDate = formatter.string(from: event.startDate)
                let eventEndDate = formatter.string(from: event.endDate)
                
                if max(dateString, eventStartDate) <= min(dateString, eventEndDate) {
                    if let index = events.firstIndex(where: { $0.startDate == event.startDate && $0.endDate == event.endDate }) {
                        usedLevels.insert(index % 3)
                    }
                }
            }
            
            if usedLevels.count >= 3 {
                return -1
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        if !usedLevels.contains(0) {
            return 0
        }
        
        if !usedLevels.contains(1) {
            return 1
        }
        
        if !usedLevels.contains(2) {
            return 2
        }
        
        return -1
    }
    
    private func addLongPressGesture(to view: UIView, for event: (name: String, startDate: Date, endDate: Date, isDetailed: Bool)) {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(longPressGesture)
        if let index = events.firstIndex(where: { $0.startDate == event.startDate && $0.endDate == event.endDate }) {
            view.tag = index
        }
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            guard let view = gesture.view,
                  view.tag < events.count else { return }
            
            let event = events[view.tag]
            let alert = UIAlertController(
                title: "일정 삭제",
                message: "(\(event.name))을 삭제 하시겠습니까?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "예", style: .destructive) { [weak self] _ in
                self?.events.remove(at: view.tag)
                self?.calendar.reloadData()
                self?.addEventRangeLine()
            })
            
            alert.addAction(UIAlertAction(title: "아니요", style: .cancel))
            
            present(alert, animated: true)
        }
    }
    
    private func sortEventsByStartDate() {
        events.sort { $0.startDate < $1.startDate }
    }

    @objc private func prevButtonTapped() {
        let currentPage = calendar.currentPage
        let previousPage = Calendar.current.date(byAdding: .month, value: -1, to: currentPage)!
        calendar.setCurrentPage(previousPage, animated: true)
    }

    @objc private func nextButtonTapped() {
        let currentPage = calendar.currentPage
        let nextPage = Calendar.current.date(byAdding: .month, value: 1, to: currentPage)!
        calendar.setCurrentPage(nextPage, animated: true)
    }
}

