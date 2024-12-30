import UIKit
import FSCalendar



class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, AddButtonModalViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    private var calendar: FSCalendar!
    private var prevButton: UIButton!
    private var nextButton: UIButton!
    
    private var events: [(name: String, startDate: Date, endDate: Date, isDetailed: Bool)] = []
    private var eventRangeViews: [UIView] = []
    private var todayScheduleView: UIView!
    private var addButton: UIButton!
    private var calendarHeightConstraint: NSLayoutConstraint!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var scheduleCountView: UIView!
    private var todayLabel: UILabel!
    private var countLabel: UILabel!
    private var mainPlusButton: UIButton!
    private var scheduleTableView: UITableView!
    private var connectionLines: [UIView] = []
    private let apiService = APIService.shared
    private var monthlySchedule: CalendarResponse?
    private var userId = "user2" // 사용자 ID 설정
    private var currentYear: Int = 0
    private var currentMonth: Int = 0

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
        calendar.appearance.weekdayTextColor = .white
        calendar.appearance.titleDefaultColor = .white
        calendar.appearance.titlePlaceholderColor = .gray
        calendar.appearance.selectionColor = .systemBlue
        calendar.appearance.todayColor = #colorLiteral(red: 0.1829021573, green: 0.1829021573, blue: 0.1829021573, alpha: 1)
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
        
        calendarHeightConstraint = calendar.heightAnchor.constraint(equalToConstant: 500)
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
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
        
        NSLayoutConstraint.activate([
            todayScheduleView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10),
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
        
        mainPlusButton = UIButton()
        mainPlusButton.setImage(UIImage(named: "mainPlus"), for: .normal)
        mainPlusButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleCountView.addSubview(mainPlusButton)
        
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
            
            mainPlusButton.leadingAnchor.constraint(equalTo: todayLabel.trailingAnchor, constant: 10),
            mainPlusButton.centerYAnchor.constraint(equalTo: scheduleCountView.centerYAnchor),
            mainPlusButton.widthAnchor.constraint(equalToConstant: 24),
            mainPlusButton.heightAnchor.constraint(equalToConstant: 24),
            
            countLabel.trailingAnchor.constraint(equalTo: scheduleCountView.trailingAnchor),
            countLabel.centerYAnchor.constraint(equalTo: scheduleCountView.centerYAnchor)
        ])
        
        mainPlusButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
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
        
        fetchCurrentMonthSchedule()
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
    
    // MARK: - FSCalendarDelegate
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.addEventRangeLine()
        }
        
        updateScheduleCount()
        scheduleTableView.reloadData()
        
        // 테이블뷰 업데이트 후 약간의 지연을 주어 셀이 모두 그려진 후 선을 그림
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
            guard let startCell = calendar.cell(for: event.startDate, at: .current),
                  let endCell = calendar.cell(for: event.endDate, at: .current) else {
                print("Date is not in the current visible range.")
                continue
            }
            
            let lineColor = event.isDetailed ?
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
                let y = startPoint.y + startCell.frame.height - 25 + verticalOffset
                
                lineView.frame = CGRect(x: startX, y: y, width: endX - startX, height: 13)
                eventRangeViews.append(lineView)
                
                let nameLabel = UILabel()
                nameLabel.text = event.name
                nameLabel.font = .systemFont(ofSize: 10)
                nameLabel.textColor = event.isDetailed ? .systemBlue : .systemYellow
                nameLabel.sizeToFit()
                calendar.addSubview(nameLabel)
                
                nameLabel.frame.origin = CGPoint(
                    x: startX + 5,
                    y: y
                )
                eventRangeViews.append(nameLabel)
                
                let timeLabel = UILabel()
                timeLabel.text = "~\(timeFormatter.string(from: event.endDate))"
                timeLabel.font = .systemFont(ofSize: 10)
                timeLabel.textColor = event.isDetailed ? .systemBlue : .systemYellow
                timeLabel.sizeToFit()
                calendar.addSubview(timeLabel)
                
                timeLabel.frame.origin = CGPoint(
                    x: endX - timeLabel.frame.width - 5,
                    y: y
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
                
                firstLineView.frame = CGRect(x: firstLineStartX, y: firstLineY, width: firstLineEndX - firstLineStartX, height: 13)
                eventRangeViews.append(firstLineView)
                
                let nameLabel = UILabel()
                nameLabel.text = event.name
                nameLabel.font = .systemFont(ofSize: 10)
                nameLabel.textColor = event.isDetailed ? .systemBlue : .systemYellow
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
                let lastLineY = endPoint.y + endCell.frame.height - 25 + verticalOffset
                
                lastLineView.frame = CGRect(x: lastLineStartX, y: lastLineY, width: lastLineEndX, height: 13)
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
                    y: lastLineY
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
        guard gesture.state == .began else { return }
        
        let alert = UIAlertController(title: "일정 삭제", message: "이 일정을 삭제하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self,
                  let view = gesture.view else { return }
            
            // 해당 이벤트 찾기
            if let index = self.eventRangeViews.firstIndex(of: view) {
                // 이벤트 배열과 뷰 배열에서 제거
                self.events.remove(at: index)
                view.removeFromSuperview()
                self.eventRangeViews.remove(at: index)
                
                // 테이블뷰 업데이트
                self.scheduleTableView.reloadData()
                
                // 연결선 다시 그리기
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.drawConnectionLines()
                }
                
                // 카운트 업데이트
                self.updateScheduleCount()
                
                // 캘린더 라인 다시 그리기
                self.addEventRangeLine()
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
            } else if deltaY < -50 && calendar.scope == .month {
                calendar.setScope(.week, animated: true)
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
        let totalCount = events.count
        let todayCount = events.filter { Calendar.current.isDateInToday($0.startDate) }.count
        countLabel.text = "\(todayCount)/\(totalCount)개"
    }

    // UITableViewDataSource 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let event = events[indexPath.row]
        
        // 이미지뷰 생성 및 설정
        let ballImageView = UIImageView()
        ballImageView.image = UIImage(named: event.isDetailed ? "detailBall" : "noDetailBall")
        ballImageView.contentMode = .scaleAspectFit
        
        // 이미지뷰를 셀의 contentView에 추가
        cell.contentView.addSubview(ballImageView)
        ballImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 이미지뷰 제약조건 설정
        NSLayoutConstraint.activate([
            ballImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
            ballImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            ballImageView.widthAnchor.constraint(equalToConstant: 10),
            ballImageView.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        // 텍스트 레이블 설정
        cell.textLabel?.text = "      " + event.name
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Pretendard-Regular", size: 17)
        cell.selectionStyle = .none
        
        // 시간 표시 (isDetailed가 true일 때만)
        if event.isDetailed {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let startTime = formatter.string(from: event.startDate)
            let endTime = formatter.string(from: event.endDate)
            cell.detailTextLabel?.text = "\(startTime)~\(endTime)"
            cell.detailTextLabel?.textColor = .white
            cell.detailTextLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
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
            
            point1.x -= 31.5
            point2.x -= 31.5
            
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
                let event = (name: plan.plantitle, startDate: startDate, endDate: endDate, isDetailed: false)
                events.append(event)
            }
        }

        for planSub in response.planSubs {
            if let startDate = dateFormatter.date(from: planSub.startDate),
               let endDate = dateFormatter.date(from: planSub.endDate) {
                let event = (name: planSub.plansubtitle, startDate: startDate, endDate: endDate, isDetailed: true)
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
//        let yearMonth = "\(currentYear)-\(String(format: "%02d", currentMonth))"
        let yearMonth = "2024-01"
        userId = "user2"
        fetchMonthlySchedule(userId: userId, yearMonth: yearMonth)
    }
}

