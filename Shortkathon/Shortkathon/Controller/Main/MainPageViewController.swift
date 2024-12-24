import UIKit
import FSCalendar

class MainPageViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    var uid = String(describing: UserDefaults.standard.string(forKey: "userIdentifier"))
    private var calendar: FSCalendar!
    private var calendarHeightConstraint: NSLayoutConstraint!
    private var scheduleViewController: MainScheduleViewController!

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
        calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1)
        calendar.appearance.headerDateFormat = "YYYY M월"
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.headerTitleColor = .white
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 30)
        calendar.appearance.weekdayTextColor = .white
        calendar.appearance.titleDefaultColor = .white
        calendar.appearance.selectionColor = .lightGray
        calendar.appearance.todayColor = #colorLiteral(red: 0.7760145068, green: 0.8501827121, blue: 0.9661260247, alpha: 1)
        calendar.placeholderType = .fillHeadTail
        
        if let header = calendar.subviews.first(where: { $0 is FSCalendarHeaderView }) {
            header.translatesAutoresizingMaskIntoConstraints = false
            header.leadingAnchor.constraint(equalTo: calendar.leadingAnchor).isActive = true
        }
        
        self.view.addSubview(calendar)
        
        calendarHeightConstraint = calendar.heightAnchor.constraint(equalToConstant: 400)
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
            calendar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            calendarHeightConstraint,

            scheduleViewController.view.topAnchor.constraint(equalTo: calendar.bottomAnchor),
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
}
