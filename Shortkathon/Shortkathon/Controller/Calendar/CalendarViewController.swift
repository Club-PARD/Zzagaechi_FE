import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource {
    var userId = UserDefaults.standard.string(forKey: "userIdentifier")

    private var calendar: FSCalendar!
    private var prevButton: UIButton!
    private var nextButton: UIButton!
    
    private var events: [(id: Int, name: String, startDate: Date, endDate: Date, startTime: String?, deadline: String?)] = []
    private var eventRangeViews: [UIView] = []
    private var todayScheduleView: UIView!
    private var addButton: UIButton!
    private var calendarHeightConstraint: NSLayoutConstraint!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var scheduleCountView: UIView!
    private var todayLabel: UILabel!
    private var countLabel: UILabel!
    private var scheduleTableView: UITableView!
    private var connectionLines: [UIView] = []
    private let apiService = APIService.shared
    private var monthlySchedule: CalendarResponse?
//    private var userId = "user2" // 사용자 ID 설정

    private var currentYear: Int = 0
    private var currentMonth: Int = 0
    private var todayScheduleTopConstraint: NSLayoutConstraint!
    private var dailySchedule: DailySchedule?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = #colorLiteral(red: 0.1829021573, green: 0.1829021573, blue: 0.1829021573, alpha: 1)
        
        calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .month
        calendar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(calendar)
        
        calendar.backgroundColor = #colorLiteral(red: 0.1829021573, green: 0.1829021573, blue: 0.1829021573, alpha: 1)
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerTitleColor = .white
        calendar.appearance.headerTitleFont = UIFont(name: "Pretendard-Regular", size: 25)
        calendar.weekdayHeight = 20

        calendar.appearance.weekdayTextColor = .white
        calendar.appearance.titleDefaultColor = .white
        calendar.appearance.titlePlaceholderColor = .gray
        calendar.appearance.selectionColor = #colorLiteral(red: 0, green: 0.5176470588, blue: 1, alpha: 0.2)
        calendar.appearance.titleSelectionColor = #colorLiteral(red: 0, green: 0.5176470588, blue: 1, alpha: 1)
        calendar.appearance.todayColor = .clear
        calendar.appearance.todaySelectionColor = .clear
        calendar.appearance.titleTodayColor = #colorLiteral(red: 0, green: 0.5176470588, blue: 1, alpha: 1)
        calendar.placeholderType = .fillHeadTail
        
        let dividerView = UIView()
        dividerView.backgroundColor = .gray
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        calendar.addSubview(dividerView)
        
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: calendar.leadingAnchor, constant: 15),
            dividerView.trailingAnchor.constraint(equalTo: calendar.trailingAnchor, constant: -15),
            dividerView.topAnchor.constraint(equalTo: calendar.calendarWeekdayView.bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
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
        
        calendarHeightConstraint = calendar.heightAnchor.constraint(equalToConstant: 550)
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            calendar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            calendarHeightConstraint,

            prevButton.centerYAnchor.constraint(equalTo: calendar.calendarHeaderView.centerYAnchor),
            prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            prevButton.widthAnchor.constraint(equalToConstant: 20),
            prevButton.heightAnchor.constraint(equalToConstant: 20),
            
            nextButton.centerYAnchor.constraint(equalTo: calendar.calendarHeaderView.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nextButton.widthAnchor.constraint(equalToConstant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        todayScheduleView = UIView()
        todayScheduleView.backgroundColor = #colorLiteral(red: 0.2834452093, green: 0.2834451795, blue: 0.2834452093, alpha: 1)
        todayScheduleView.layer.cornerRadius = 14
        todayScheduleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayScheduleView)
        
        todayScheduleTopConstraint = todayScheduleView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10)

        NSLayoutConstraint.activate([
            todayScheduleTopConstraint,
            todayScheduleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todayScheduleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todayScheduleView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let handleBar = UIView()
        handleBar.backgroundColor = .gray
        handleBar.layer.cornerRadius = 3
        handleBar.translatesAutoresizingMaskIntoConstraints = false
        todayScheduleView.addSubview(handleBar)
        
        NSLayoutConstraint.activate([
            handleBar.centerXAnchor.constraint(equalTo: todayScheduleView.centerXAnchor),
            handleBar.topAnchor.constraint(equalTo: todayScheduleView.topAnchor, constant: 8),
            handleBar.widthAnchor.constraint(equalToConstant: 60),
            handleBar.heightAnchor.constraint(equalToConstant: 6)
        ])
        
        scheduleCountView = UIView()
        scheduleCountView.backgroundColor = .clear
        scheduleCountView.translatesAutoresizingMaskIntoConstraints = false
        todayScheduleView.addSubview(scheduleCountView)
        
        todayLabel = UILabel()
        todayLabel.text = "오늘 할 일"
        todayLabel.font = UIFont(name: "Pretendard-Bold", size: 22)
        todayLabel.textColor = .white
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        scheduleCountView.addSubview(todayLabel)
        
        countLabel = UILabel()
        countLabel.text = "0/0개"
        countLabel.font = UIFont(name: "Pretendard-Regular", size: 16)
        countLabel.textColor = .white
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        scheduleCountView.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            scheduleCountView.topAnchor.constraint(equalTo: todayScheduleView.topAnchor, constant: 20),
            scheduleCountView.leadingAnchor.constraint(equalTo: todayScheduleView.leadingAnchor, constant: 20),
            scheduleCountView.trailingAnchor.constraint(equalTo: todayScheduleView.trailingAnchor, constant: -20),
            scheduleCountView.heightAnchor.constraint(equalToConstant: 30),
            
            todayLabel.leadingAnchor.constraint(equalTo: scheduleCountView.leadingAnchor),
            todayLabel.centerYAnchor.constraint(equalTo: scheduleCountView.centerYAnchor),
            
            countLabel.trailingAnchor.constraint(equalTo: scheduleCountView.trailingAnchor),
            countLabel.centerYAnchor.constraint(equalTo: scheduleCountView.centerYAnchor)
        ])
                
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        todayScheduleView.addGestureRecognizer(panGestureRecognizer)
        
        // 테이블 뷰 설정
        scheduleTableView = UITableView()
        scheduleTableView.backgroundColor = #colorLiteral(red: 0.2834452093, green: 0.2834451795, blue: 0.2834452093, alpha: 1)
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        todayScheduleView.addSubview(scheduleTableView)
        
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: scheduleCountView.bottomAnchor, constant: 20),
            scheduleTableView.leadingAnchor.constraint(equalTo: todayScheduleView.leadingAnchor, constant: 20),
            scheduleTableView.trailingAnchor.constraint(equalTo: todayScheduleView.trailingAnchor, constant: -20),
            scheduleTableView.bottomAnchor.constraint(equalTo: todayScheduleView.bottomAnchor, constant: -20)
        ])
        
        // 테이블 뷰 델리게이트 설정
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        
        // 현재 날짜로 초기화
        let currentDate = Date()
        let calendar = Calendar.current
        currentYear = calendar.component(.year, from: currentDate)
        currentMonth = calendar.component(.month, from: currentDate)
        
        fetchCurrentMonthSchedule()
        fetchDailySchedule(for: Date())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addEventRangeLine()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 현재 달의 일정을 가져오고 Event range 라인을 그립니다
        fetchCurrentMonthSchedule()
        
        // 약간의 지연을 주어 레이아웃이 완전히 설정된 후 라인을 그립니다
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.addEventRangeLine()
        }
    }
    
    // MARK: - FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Selected date: \(date)")
        fetchDailySchedule(for: date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    func didAddEvent(id: Int, name: String, startDate: Date, endDate: Date, startTime: String?, deadline: String?) {
        let newEvent = (id: id, name: name, startDate: startDate, endDate: endDate, startTime: startTime, deadline: deadline)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.addEventRangeLine()
        }
        
        updateScheduleCount()
        scheduleTableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.drawConnectionLines()
        }
        
        updateScheduleCount()
        addEventRangeLine()
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
    
    // MARK: - Event Range 라인 그리기
    private func addEventRangeLine() {
        eventRangeViews.forEach { $0.removeFromSuperview() }
        eventRangeViews.removeAll()
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        for (index, event) in events.enumerated() {
            // 이벤트가 현재 보이는 범위와 전혀 겹치지 않으면 건너뛰기
            if !isDateInCurrentView(event.startDate) && !isDateInCurrentView(event.endDate) {
                continue
            }
            
            // 주간 보기일 때는 현재 주에 포함된 부분만 표시
            if calendar.scope == .week {
                let calendar = Calendar.current
                let weekRange = calendar.dateInterval(of: .weekOfMonth, for: self.calendar.currentPage)!
                
                // 이벤트가 현재 주와 전혀 겹치지 않으면 건너뛰기
                if event.endDate < weekRange.start || event.startDate > weekRange.end {
                    continue
                }
            }
            
            // 이벤트의 시작일과 종료일을 현재 보이는 범위로 조정
            let adjustedStartDate = getAdjustedDateForCurrentView(event.startDate)
            let adjustedEndDate = getAdjustedDateForCurrentView(event.endDate)
            
            // 조정된 날짜로 셀 가져오기
            guard let startCell = calendar.cell(for: adjustedStartDate, at: .current),
                  let endCell = calendar.cell(for: adjustedEndDate, at: .current) else {
                continue
            }
            
            let lineColor = event.deadline != nil ?
            #colorLiteral(red: 0.7760145068, green: 0.8501827121, blue: 0.9661260247, alpha: 1) : #colorLiteral(red: 0.9568627451, green: 0.9450980392, blue: 0.7294117647, alpha: 1)
            
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
                let y = startPoint.y + startCell.frame.height - 20 + verticalOffset
                
                lineView.frame = CGRect(x: startX, y: y, width: endX - startX, height: 13)
                eventRangeViews.append(lineView)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let startDateString = formatter.string(from: event.startDate)
                let endDateString = formatter.string(from: event.endDate)
                
                let nameLabel = UILabel()
                let truncatedName = event.name.count > 5 ? event.name.prefix(5) + "..." : event.name
                nameLabel.text = truncatedName
                nameLabel.font = .systemFont(ofSize: 10)
                nameLabel.textColor = event.deadline != nil ? #colorLiteral(red: 0.1882352941, green: 0.3058823529, blue: 0.5137254902, alpha: 1) : #colorLiteral(red: 0.3921568627, green: 0.4039215686, blue: 0.1725490196, alpha: 1)
                nameLabel.sizeToFit()
                calendar.addSubview(nameLabel)
                
                nameLabel.frame.origin = CGPoint(
                    x: startX + 5,
                    y: y
                )
                eventRangeViews.append(nameLabel)
                
                if startDateString != endDateString {
                    let timeLabel = UILabel()
                    timeLabel.text = "~\(timeFormatter.string(from: event.endDate))"
                    timeLabel.font = .systemFont(ofSize: 10)
                    timeLabel.textColor = event.deadline != nil ? #colorLiteral(red: 0.1882352941, green: 0.3058823529, blue: 0.5137254902, alpha: 1) : #colorLiteral(red: 0.3921568627, green: 0.4039215686, blue: 0.1725490196, alpha: 1)
                    timeLabel.sizeToFit()
                    calendar.addSubview(timeLabel)
                    
                    timeLabel.frame.origin = CGPoint(
                        x: endX - timeLabel.frame.width - 5,
                        y: y
                    )
                    eventRangeViews.append(timeLabel)
                }
                
                addLongPressGesture(to: lineView, for: event)
                
            } else {
                let firstLineView = UIView()
                firstLineView.backgroundColor = lineColor
                firstLineView.layer.cornerRadius = 5
                calendar.addSubview(firstLineView)
                
                let firstLineStartX = startPoint.x
                let firstLineEndX = calendar.bounds.width
                let firstLineY = startPoint.y + startCell.frame.height - 20 + verticalOffset
                
                firstLineView.frame = CGRect(x: firstLineStartX, y: firstLineY, width: firstLineEndX - firstLineStartX, height: 13)
                eventRangeViews.append(firstLineView)
                
                let nameLabel = UILabel()
                let truncatedName = event.name.count > 5 ? event.name.prefix(5) + "..." : event.name
                nameLabel.text = truncatedName
                nameLabel.font = .systemFont(ofSize: 10)
                nameLabel.textColor = event.deadline != nil ? #colorLiteral(red: 0.2426371872, green: 0.3858973086, blue: 0.5858027339, alpha: 1) : #colorLiteral(red: 0.3921568627, green: 0.4039215686, blue: 0.1725490196, alpha: 1)
                nameLabel.sizeToFit()
                calendar.addSubview(nameLabel)
                
                nameLabel.frame.origin = CGPoint(
                    x: firstLineStartX + 5,
                    y: firstLineY
                )
                eventRangeViews.append(nameLabel)
                
                addLongPressGesture(to: firstLineView, for: event)
                
                let lastLineView = UIView()
                lastLineView.backgroundColor = lineColor
                lastLineView.layer.cornerRadius = 5
                calendar.addSubview(lastLineView)
                
                let lastLineStartX: CGFloat = 0
                let lastLineEndX = endCell.convert(endCell.bounds, to: calendar).maxX
                let lastLineY = endPoint.y + endCell.frame.height - 20 + verticalOffset
                
                lastLineView.frame = CGRect(x: lastLineStartX, y: lastLineY, width: lastLineEndX, height: 13)
                eventRangeViews.append(lastLineView)
                
                addLongPressGesture(to: lastLineView, for: event)
                
                let timeLabel = UILabel()
                timeLabel.text = "~\(timeFormatter.string(from: event.endDate))"
                timeLabel.font = .systemFont(ofSize: 10)
                timeLabel.textColor = event.deadline != nil ? #colorLiteral(red: 0.2426371872, green: 0.3858973086, blue: 0.5858027339, alpha: 1) : #colorLiteral(red: 0.3921568627, green: 0.4039215686, blue: 0.1725490196, alpha: 1)
                timeLabel.sizeToFit()
                calendar.addSubview(timeLabel)
                
                timeLabel.frame.origin = CGPoint(
                    x: lastLineEndX - timeLabel.frame.width - 5,
                    y: lastLineY
                )
                eventRangeViews.append(timeLabel)
                
                if endPoint.y - startPoint.y > startCell.frame.height {
                    let rowCount = Int((endPoint.y - startPoint.y) / startCell.frame.height)
                    
                    let firstLineY = startPoint.y + startCell.frame.height - 20 + verticalOffset
                    let lastLineY = endPoint.y + endCell.frame.height - 20 + verticalOffset
                    let totalHeight = lastLineY - firstLineY
                    
                    for row in 1..<rowCount {
                        let middleLineView = UIView()
                        middleLineView.backgroundColor = lineColor
                        calendar.addSubview(middleLineView)
                        
                        let ratio = CGFloat(row) / CGFloat(rowCount)
                        let middleY = firstLineY + (totalHeight * ratio)
                        
                        middleLineView.frame = CGRect(
                            x: 0,
                            y: middleY,
                            width: calendar.bounds.width,
                            height: 13
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
        let currentPage = calendar.currentPage
        let calendar = Calendar.current
        currentYear = calendar.component(.year, from: currentPage)
        currentMonth = calendar.component(.month, from: currentPage)
        fetchCurrentMonthSchedule()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addEventRangeLine()
    }
    
    private func getOverlappingLineLevel(for newEvent: (id: Int, name: String, startDate: Date, endDate: Date, startTime: String?, deadline: String?)) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var usedLevels = Set<Int>()
        
        for event in events {
            let start1 = formatter.string(from: event.startDate)
            let end1 = formatter.string(from: event.endDate)
            let start2 = formatter.string(from: newEvent.startDate)
            let end2 = formatter.string(from: newEvent.endDate)
            
            if max(start1, start2) <= min(end1, end2) {
                usedLevels.insert(0)
            }
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
    
    private func addLongPressGesture(to view: UIView, for event: (id: Int, name: String, startDate: Date, endDate: Date, startTime: String?, deadline: String?)) {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(longPressGesture)
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            view.tag = index
        }
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        guard let view = gesture.view else { return }
        let index = view.tag
        guard index < events.count else { return }
        
        let alert = UIAlertController(title: "일정 삭제", message: "이 일정을 삭제하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            let event = self.events[index]
            guard let userId = self.userId else { return }
            
            let endpoint = event.deadline == nil ?
                "/plan/\(userId)/\(event.id)" :
                "/plansub/\(userId)/\(event.id)"
            
            self.apiService.deleteWithStatusCode(endpoint: endpoint) { [weak self] statusCode in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    if statusCode == 200 {
                        // UI 업데이트
                        self.events.remove(at: index)
                        self.eventRangeViews.forEach { $0.removeFromSuperview() }
                        self.eventRangeViews.removeAll()
                        self.addEventRangeLine()
                        self.scheduleTableView.reloadData()
                        self.drawConnectionLines()
                        self.updateScheduleCount()
                    } else {
                        let errorAlert = UIAlertController(
                            title: "삭제 실패",
                            message: "일정을 삭제하는데 실패했습니다.",
                            preferredStyle: .alert
                        )
                        errorAlert.addAction(UIAlertAction(title: "확인", style: .default))
                        self.present(errorAlert, animated: true)
                    }
                }
            }
        })
        
        present(alert, animated: true)
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

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: self.view)
        
        switch gesture.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            let deltaY = touchPoint.y - initialTouchPoint.y
            if deltaY > 50 && calendar.scope == .week {
                calendar.setScope(.month, animated: true)
                UIView.animate(withDuration: 0.3) {
                    self.todayScheduleTopConstraint.constant = 10
                    self.view.layoutIfNeeded()
                }
            } else if deltaY < -50 && calendar.scope == .month {
                calendar.setScope(.week, animated: true)
                UIView.animate(withDuration: 0.3) {
                    self.todayScheduleTopConstraint.constant = 20
                    self.view.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }

    private func updateScheduleCount() {
        if let dailySchedule = dailySchedule {
            countLabel.text = "\(dailySchedule.completedCount)/\(dailySchedule.totalCount)개"
        } else {
            countLabel.text = "0/0개"
        }
    }

    // UITableViewDataSource 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dailySchedule?.plans.count ?? 0) + (dailySchedule?.details.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        let plansCount = dailySchedule?.plans.count ?? 0
        
        if indexPath.row < plansCount {
            // Plan
            if let plan = dailySchedule?.plans[indexPath.row] {
                configurePlanCell(cell, with: plan)
            }
        } else {
            // Detail
            if let detail = dailySchedule?.details[indexPath.row - plansCount] {
                configureDetailCell(cell, with: detail)
            }
        }
        
        return cell
    }

    private func configurePlanCell(_ cell: UITableViewCell, with plan: Plan) {
        let ballImageView = UIImageView(frame: CGRect(x: 10, y: 20, width: 10, height: 10))
        ballImageView.image = UIImage(named: "noDetailBall")
        cell.contentView.addSubview(ballImageView)
        
        cell.textLabel?.text = "      " + plan.plantitle
        if let startTime = plan.startTime {
            cell.detailTextLabel?.text = startTime
        }
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
    }

    private func configureDetailCell(_ cell: UITableViewCell, with detail: Detail) {
        let ballImageView = UIImageView(frame: CGRect(x: 10, y: 20, width: 10, height: 10))
        ballImageView.image = UIImage(named: "detailBall")
        cell.contentView.addSubview(ballImageView)
        
        // 시간 포맷 변경
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        
        var startTimeFormatted = detail.startTime
        var endTimeFormatted = detail.endTime
        
        if let startDate = timeFormatter.date(from: detail.startTime) {
            startTimeFormatted = outputFormatter.string(from: startDate)
        }
        
        if let endDate = timeFormatter.date(from: detail.endTime) {
            endTimeFormatted = outputFormatter.string(from: endDate)
        }
        
        cell.textLabel?.text = "      " + detail.content
        cell.detailTextLabel?.text = "\(startTimeFormatted)~\(endTimeFormatted)"
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
    }

    private func drawConnectionLines() {
        // 기존 선들 제거
        connectionLines.forEach { $0.removeFromSuperview() }
        connectionLines.removeAll()
        
        // 최소 2개의 셀이 있어야 선을 그릴 수 있음
        guard events.count >= 2 else { return }
        
        // 모든 Ball 이미지뷰를 앞으로 가져오기
        for i in 0..<events.count {
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = scheduleTableView.cellForRow(at: indexPath),
               let ballView = cell.contentView.subviews.first(where: { $0 is UIImageView }) {
                cell.contentView.bringSubviewToFront(ballView)
            }
        }
        
        // 선 그리기
        for i in 0..<events.count - 1 {
            let indexPath1 = IndexPath(row: i, section: 0)
            let indexPath2 = IndexPath(row: i + 1, section: 0)
            
            guard let cell1 = scheduleTableView.cellForRow(at: indexPath1),
                  let cell2 = scheduleTableView.cellForRow(at: indexPath2),
                  let ballView1 = cell1.contentView.subviews.first(where: { $0 is UIImageView }),
                  let ballView2 = cell2.contentView.subviews.first(where: { $0 is UIImageView }) else {
                continue
            }
            
            var point1 = ballView1.convert(ballView1.center, to: scheduleTableView)
            var point2 = ballView2.convert(ballView2.center, to: scheduleTableView)
            
            point1.x -= 34.7
            point2.x -= 34.7
            point1.y += 8
            point2.y += 8
            
            let line = UIView()
            line.backgroundColor = .gray
            scheduleTableView.insertSubview(line, at: 0)
            
            let length = sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))
            let angle = atan2(point2.y - point1.y, point2.x - point1.x)
            
            line.frame = CGRect(x: point1.x, y: point1.y, width: length, height: 1)
            line.transform = CGAffineTransform(rotationAngle: angle)
            
            connectionLines.append(line)
        }
    }

    // MARK: - API 호출
    func fetchMonthlySchedule(userId: String, yearMonth: String) {
        apiService.get(endpoint: "/calendar/\(userId)/\(yearMonth)") { [weak self] (result: Result<CalendarResponse, Error>) in
            switch result {
            case .success(let response):
                print(response)
                self?.monthlySchedule = response
                self?.processScheduleData(response)
            case .failure(let error):
                print("Failed to fetch monthly schedule:", error)
            }
        }
    }
    
    private func processScheduleData(_ response: CalendarResponse) {
        events.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for plan in response.plans {
            if let startDate = dateFormatter.date(from: plan.startDate),
               let endDate = dateFormatter.date(from: plan.endDate) {
                let event: (id: Int, name: String, startDate: Date, endDate: Date, startTime: String?, deadline: String?) = 
                    (id: plan.planId, name: plan.plantitle, startDate: startDate, endDate: endDate, startTime: plan.startTime, deadline: nil)
                events.append(event)
            }
        }

        for planSub in response.planSubs {
            if let startDate = dateFormatter.date(from: planSub.startDate),
               let endDate = dateFormatter.date(from: planSub.endDate) {
                let event: (id: Int, name: String, startDate: Date, endDate: Date, startTime: String?, deadline: String?) = 
                    (id: planSub.plansubId, name: planSub.plansubtitle, startDate: startDate, endDate: endDate, startTime: nil, deadline: planSub.deadline)
                events.append(event)
            }
        }

        sortEventsByStartDate()
        DispatchQueue.main.async {
            self.scheduleTableView.reloadData()
            self.drawConnectionLines()
            self.updateScheduleCount()
            self.addEventRangeLine()
        }
    }

    private func fetchCurrentMonthSchedule() {
        let yearMonth = "\(currentYear)-\(String(format: "%02d", currentMonth))"
        print(yearMonth)
//        let yearMonth = "2024-01"
        guard let userId = userId else { return }
//        userId = "user2"
        fetchMonthlySchedule(userId: userId, yearMonth: yearMonth)
    }

    private func isDateInCurrentView(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let currentPage = self.calendar.currentPage
        
        if self.calendar.scope == .month {
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentPage))!
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
            return date >= startOfMonth && date <= endOfMonth
        } else {
            let weekRange = calendar.dateInterval(of: .weekOfMonth, for: currentPage)!
            // 주간 보기에서는 더 엄격한 체크
            return date >= weekRange.start && date <= weekRange.end
        }
    }

    private func getAdjustedDateForCurrentView(_ date: Date) -> Date {
        let calendar = Calendar.current
        let currentPage = self.calendar.currentPage
        
        if self.calendar.scope == .month {
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentPage))!
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
            
            if date < startOfMonth {
                return startOfMonth
            } else if date > endOfMonth {
                return endOfMonth
            }
        } else {
            let weekRange = calendar.dateInterval(of: .weekOfMonth, for: currentPage)!
            if date < weekRange.start {
                return weekRange.start
            } else if date > weekRange.end {
                return weekRange.end
            }
        }
        return date
    }

    private func fetchDailySchedule(for date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        guard let userId = userId else { return }
        let endpoint = "/daily/\(userId)/\(dateString)"
        
        apiService.get(endpoint: endpoint) { [weak self] (result: Result<DailySchedule, Error>) in
            switch result {
            case .success(let schedule):
                self?.dailySchedule = schedule
                DispatchQueue.main.async {
                    self?.updateDailyScheduleUI()
                    self?.updateScheduleCount()
                }
            case .failure(let error):
                print("Failed to fetch daily schedule:", error)
            }
        }
    }

    private func updateDailyScheduleUI() {
        // Implementation of updateDailyScheduleUI
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50  // 원하는 셀 높이 값으로 수정 가능
    }
}

