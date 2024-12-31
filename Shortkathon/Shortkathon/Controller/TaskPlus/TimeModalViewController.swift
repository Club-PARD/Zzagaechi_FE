import UIKit

protocol TimeModalViewControllerDelegate: AnyObject {
    func didSelectDateTime(date: Date, startTime: Date?, endTime: Date?)
}


class TimeModalViewController: UIViewController {
    
    var availableStartDate : Date?
    var availableEndDate : Date?
    weak var delegate: TimeModalViewControllerDelegate?
    private var selectedDate: Date?
    private var selectedStartTime: Date?
    private var selectedEndTime: Date?
    
    enum ModalStep {
        case date
        case startTime
        case endTime
        
        var title: String {
            switch self {
            case .date: return "날짜"
            case .startTime: return "시작 시간"
            case .endTime: return "종료 시간"
            }
        }
    }
    
    private var currentStep: ModalStep = .date {
        didSet {
            updateUI()
        }
    }
    
    // UI Components
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1)
        view.layer.cornerRadius = 12.2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.text = "날짜"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel1: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.text = "날짜"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(#colorLiteral(red: 0.3369887173, green: 0.6149112582, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 16)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(#colorLiteral(red: 0.7529411765, green: 0.2156862745, blue: 0.2156862745, alpha: 1), for: .normal)
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 16)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.locale = Locale(identifier: "ko_KR")
        picker.tintColor = .white
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "00:00"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        setupUI()
        updateUI()
        
        
    }
    
    private func setupUI() {
        view.addSubview(containerView)
        
        [nextButton, cancelButton, titleLabel].forEach{
            containerView.addSubview($0)
        }
        if let startDate = availableStartDate {
            datePicker.minimumDate = startDate
        }
        if let endDate = availableEndDate {
            datePicker.maximumDate = endDate
        }
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 333),
            containerView.heightAnchor.constraint(equalToConstant: 331),
            
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            
            nextButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            nextButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            cancelButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            
        ])
        
        cancelButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    private func updateUI() {
        titleLabel.text = currentStep.title
        
        datePicker.removeFromSuperview()
        timeLabel.removeFromSuperview()
        titleLabel1.removeFromSuperview()
        containerView.addSubview(datePicker)
        containerView.addSubview(timeLabel)
        containerView.addSubview(titleLabel1)
        
        switch currentStep {
        case .date:
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .inline
            timeLabel.isHidden = true
            nextButton.setTitle("다음", for: .normal)
            
            NSLayoutConstraint.activate([
                
                titleLabel1.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                titleLabel1.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
                
                datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
                datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                datePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
            ])
            
        case .startTime, .endTime:
            datePicker.datePickerMode = .time
            datePicker.preferredDatePickerStyle = .wheels
            timeLabel.isHidden = false
            nextButton.setTitle(currentStep == .endTime ? "완료" : "다음", for: .normal)
            titleLabel1.isHidden = true
            NSLayoutConstraint.activate([
                
                timeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
                
                datePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
                datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                datePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
            ])
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    @objc private func nextButtonTapped() {
        switch currentStep {
        case .date:
            selectedDate = datePicker.date
            currentStep = .startTime
        case .startTime:
            selectedStartTime = datePicker.date
            currentStep = .endTime
        case .endTime:
            selectedEndTime = datePicker.date
            
            if let date = selectedDate {
                delegate?.didSelectDateTime(date: date, startTime: selectedStartTime, endTime: selectedEndTime)
            }
            dismiss(animated: true)
        }
    }
    
    @objc func back(){
        dismiss(animated: true)
    }
    
    
    @objc private func datePickerValueChanged() {
        if currentStep != .date {
            let formatter = DateFormatter()
            formatter.dateFormat = "a HH:mm"
            timeLabel.text = formatter.string(from: datePicker.date)
        }
    }
}
