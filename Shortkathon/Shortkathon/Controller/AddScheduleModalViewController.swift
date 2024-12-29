//임의로 만든 일정 추가 페이지

import UIKit

protocol AddScheduleModalDelegate: AnyObject {
    func didAddTask(_ task: String, startTime: Date, endTime: Date, isDetailed: Bool)
}

class AddScheduleModalViewController: UIViewController {

    private var textField: UITextField!
    private var startTimePicker: UIDatePicker!
    private var endTimePicker: UIDatePicker!
    private var startTimeLabel: UILabel!
    private var endTimeLabel: UILabel!
    private var buttonStackView: UIStackView!
    private var confirmButton: UIButton!
    private var cancelButton: UIButton!
    private var timeToggleSwitch: UISwitch!
    private var timeToggleLabel: UILabel!
    private var detailToggleSwitch: UISwitch!
    private var detailToggleLabel: UILabel!
    
    private var isTimePickerEnabled: Bool = true {
        didSet {
            updateTimePickersVisibility()
        }
    }
    private var detailFlag: Int = 0
    
    weak var delegate: AddScheduleModalDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        configureTextField()
        configureTimeToggle()
        configureTimePickers()
        configureButtons()
    }

    private func configureTextField() {
        textField = UITextField()
        textField.placeholder = "새로운 할 일 입력"
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = 22
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            textField.widthAnchor.constraint(equalToConstant: 250),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func configureTimeToggle() {
        let toggleStackView = UIStackView()
        toggleStackView.axis = .horizontal
        toggleStackView.spacing = 30
        toggleStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleStackView)
        
        let timeToggleContainer = UIStackView()
        timeToggleContainer.spacing = 10
        
        timeToggleLabel = UILabel()
        timeToggleLabel.text = "시간 설정"
        timeToggleLabel.textColor = .white
        
        timeToggleSwitch = UISwitch()
        timeToggleSwitch.isOn = true
        timeToggleSwitch.addTarget(self, action: #selector(timeToggleSwitchChanged), for: .valueChanged)
        
        timeToggleContainer.addArrangedSubview(timeToggleLabel)
        timeToggleContainer.addArrangedSubview(timeToggleSwitch)
        
        let detailToggleContainer = UIStackView()
        detailToggleContainer.spacing = 10
        
        detailToggleLabel = UILabel()
        detailToggleLabel.text = "세분화"
        detailToggleLabel.textColor = .white
        
        detailToggleSwitch = UISwitch()
        detailToggleSwitch.isOn = false
        detailToggleSwitch.addTarget(self, action: #selector(detailToggleSwitchChanged), for: .valueChanged)
        
        detailToggleContainer.addArrangedSubview(detailToggleLabel)
        detailToggleContainer.addArrangedSubview(detailToggleSwitch)
        
        toggleStackView.addArrangedSubview(timeToggleContainer)
        toggleStackView.addArrangedSubview(detailToggleContainer)
        
        NSLayoutConstraint.activate([
            toggleStackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            toggleStackView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            toggleStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func configureTimePickers() {
        startTimeLabel = UILabel()
        startTimeLabel.text = "시작 시간"
        startTimeLabel.textColor = .white
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startTimeLabel)
        
        endTimeLabel = UILabel()
        endTimeLabel.text = "종료 시간"
        endTimeLabel.textColor = .white
        endTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(endTimeLabel)
        
        startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = .time
        startTimePicker.preferredDatePickerStyle = .wheels
        startTimePicker.translatesAutoresizingMaskIntoConstraints = false
        startTimePicker.backgroundColor = .darkGray
        startTimePicker.tintColor = .white
        view.addSubview(startTimePicker)
        
        endTimePicker = UIDatePicker()
        endTimePicker.datePickerMode = .time
        endTimePicker.preferredDatePickerStyle = .wheels
        endTimePicker.translatesAutoresizingMaskIntoConstraints = false
        endTimePicker.backgroundColor = .darkGray
        endTimePicker.tintColor = .white
        view.addSubview(endTimePicker)
        
        NSLayoutConstraint.activate([
            startTimeLabel.topAnchor.constraint(equalTo: timeToggleLabel.bottomAnchor, constant: 20),
            startTimeLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            
            startTimePicker.topAnchor.constraint(equalTo: startTimeLabel.bottomAnchor, constant: 5),
            startTimePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startTimePicker.widthAnchor.constraint(equalToConstant: 250),
            startTimePicker.heightAnchor.constraint(equalToConstant: 100),
            
            endTimeLabel.topAnchor.constraint(equalTo: startTimePicker.bottomAnchor, constant: 20),
            endTimeLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            
            endTimePicker.topAnchor.constraint(equalTo: endTimeLabel.bottomAnchor, constant: 5),
            endTimePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endTimePicker.widthAnchor.constraint(equalToConstant: 250),
            endTimePicker.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        updateTimePickersVisibility()
    }
    
    private func updateTimePickersVisibility() {
        let alpha: CGFloat = isTimePickerEnabled ? 1.0 : 0.3
        startTimeLabel.alpha = alpha
        endTimeLabel.alpha = alpha
        startTimePicker.alpha = alpha
        endTimePicker.alpha = alpha
        
        startTimePicker.isUserInteractionEnabled = isTimePickerEnabled
        endTimePicker.isUserInteractionEnabled = isTimePickerEnabled
    }
    
    @objc private func timeToggleSwitchChanged(_ sender: UISwitch) {
        isTimePickerEnabled = sender.isOn
    }
    
    @objc private func detailToggleSwitchChanged(_ sender: UISwitch) {
        detailFlag = sender.isOn ? 1 : 0
    }
    
    @objc private func didTapConfirmButton() {
        if let task = textField.text, !task.isEmpty {
            if isTimePickerEnabled {
                delegate?.didAddTask(task, startTime: startTimePicker.date, endTime: endTimePicker.date, isDetailed: detailFlag == 1)
            } else {
                let currentDate = Date()
                delegate?.didAddTask(task, startTime: currentDate, endTime: currentDate, isDetailed: detailFlag == 1)
            }
            dismiss(animated: true)
        }
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    private func configureButtons() {
        buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
        
        confirmButton = UIButton(type: .system)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.backgroundColor = .systemBlue
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 10
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.backgroundColor = .systemGray
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.layer.cornerRadius = 10
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: endTimePicker.bottomAnchor, constant: 20),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: 250),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
} 
