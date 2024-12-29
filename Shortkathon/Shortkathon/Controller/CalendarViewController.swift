import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    var uid = String(describing: UserDefaults.standard.string(forKey: "userIdentifier"))
    private var calendar: FSCalendar!
    private var calendarHeightConstraint: NSLayoutConstraint!
    private var scheduleViewController: MainScheduleViewController!
    private var titleImageView: UIImageView!
    private var addScheduleButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1)
        
        setupUI()
    }

    private func setupUI() {
        configureCalendar()
        configureScheduleViewController()
        setConstraints()
    }

    private func configureCalendar() {
        titleImageView = UIImageView(image: UIImage(named: "nano_title"))
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleImageView)
        
        calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1)
        calendar.appearance.headerDateFormat = "YYYY M월"
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.headerTitleColor = .white
        calendar.appearance.headerTitleFont = UIFont(name: "Pretendard-Regular", size: 35)
        calendar.appearance.weekdayTextColor = .white
        calendar.appearance.titleDefaultColor = .white
        calendar.appearance.selectionColor = .lightGray
        calendar.appearance.todayColor = #colorLiteral(red: 0.7760145068, green: 0.8501827121, blue: 0.9661260247, alpha: 1)
        calendar.placeholderType = .fillHeadTail
        calendar.appearance.headerTitleAlignment = .left
        calendar.appearance.headerTitleOffset = CGPoint(x: -80, y: 0)
        calendar.appearance.titleOffset = CGPoint(x: 0, y: 0)
        calendar.rowHeight = 120
        calendar.headerHeight = 50
        calendar.weekdayHeight = 40
        
        if let header = calendar.subviews.first(where: { $0 is FSCalendarHeaderView }) {
            header.translatesAutoresizingMaskIntoConstraints = false
            header.leadingAnchor.constraint(equalTo: calendar.leadingAnchor).isActive = true
        }
        
        self.view.addSubview(calendar)
        
        calendarHeightConstraint = calendar.heightAnchor.constraint(equalToConstant: 470)
        
        // 구분선 생성
        let separatorView = UIView()
        separatorView.backgroundColor = .white
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        calendar.addSubview(separatorView)
        
        // 구분선 제약조건 설정
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: calendar.leadingAnchor, constant: 15),
            separatorView.trailingAnchor.constraint(equalTo: calendar.trailingAnchor, constant: -15),
            separatorView.topAnchor.constraint(equalTo: calendar.calendarWeekdayView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        // 추가 버튼 설정
        addScheduleButton = UIButton(type: .custom)
        if let buttonImage = UIImage(named: "mainPlus") {
            addScheduleButton.setImage(buttonImage, for: .normal)
        }
        addScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        addScheduleButton.contentMode = .scaleAspectFit
        calendar.addSubview(addScheduleButton)
        
        NSLayoutConstraint.activate([
            addScheduleButton.centerYAnchor.constraint(equalTo: calendar.calendarHeaderView.centerYAnchor),
            addScheduleButton.trailingAnchor.constraint(equalTo: calendar.trailingAnchor, constant: -20),
            addScheduleButton.widthAnchor.constraint(equalToConstant: 30),
            addScheduleButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        addScheduleButton.addTarget(self, action: #selector(didTapAddScheduleButton), for: .touchUpInside)
    }

    private func configureScheduleViewController() {
        scheduleViewController = MainScheduleViewController()
        self.addChild(scheduleViewController)
        scheduleViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scheduleViewController.view)
        scheduleViewController.didMove(toParent: self)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        scheduleViewController.view.addGestureRecognizer(panGesture)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 3),
            titleImageView.heightAnchor.constraint(equalToConstant: 25),
            
            calendar.topAnchor.constraint(equalTo: titleImageView.bottomAnchor),
            calendar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            calendarHeightConstraint,

            scheduleViewController.view.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 30),
            scheduleViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scheduleViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scheduleViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

        ])
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)

        if gesture.state == .ended {
            if translation.y < 0 {
                changeCalendarKind(toMonth: false)
            } else if translation.y > 0 {
                changeCalendarKind(toMonth: true)
            }
        }
    }

    private func changeCalendarKind(toMonth: Bool) {
        calendar.setScope(toMonth ? .month : .week, animated: true)
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Selected date: \(date)")
    }

    @objc private func didTapAddScheduleButton() {
        let modalVC = AddScheduleModalViewController()
        modalVC.modalPresentationStyle = .overCurrentContext
        modalVC.modalTransitionStyle = .crossDissolve
        modalVC.delegate = scheduleViewController
        present(modalVC, animated: true, completion: nil)
    }
}
