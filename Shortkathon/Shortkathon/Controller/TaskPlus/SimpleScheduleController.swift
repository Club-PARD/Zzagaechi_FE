//  Created by 김사랑 on 12/28/24.
//

import UIKit

class SimpleScheduleController: UIViewController, UITextFieldDelegate {
    var userId =  UserDefaults.standard.string(forKey: "userIdentifier")

    var uid3: String?
    
    private let apiService = APIService.shared
    
    // 시간 선택 여부를 추적하는 플래그 추가
    private var userSelectedTime = false
    
    let centerLabel: UILabel = {
        let label = UILabel()
        label.text = "간단한 일정 등록"
        label.font = .systemFont(ofSize: 16)
        label.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Icon-3")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        let firstPart = "간단한 일에 대한"
        let secondPart = "일정을 입력하세요"
        let combinedText = "\(firstPart)!\n\(secondPart)"
        
        label.text = combinedText
        label.font = .systemFont(ofSize: 30)
        //        label.font = UIFont(name: "Pretendard-Regular", size: 30)//볼더임
        label.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        label.numberOfLines = 0 // 여러 줄 지원
        label.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "한 번에 끝낼 수 있는 작업의 제목과 날짜, 시간을 입력해주세요"
        label.textColor = #colorLiteral(red: 0.6901960784, green: 0.6901960784, blue: 0.6901960784, alpha: 1)
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        label.font = .systemFont(ofSize: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let schedulTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력하세요"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 12
        textField.font = .systemFont(ofSize: 14)
        //        textField.font = UIFont(name: "Pretendard-Regular", size: 14)
        
        textField.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        textField.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        textField.layer.borderColor = #colorLiteral(red: 0.7294117647, green: 0.8117647059, blue: 0.9568627451, alpha: 1)
        textField.layer.borderWidth = 2
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let startLabel: UILabel = {
        let label = UILabel()
        label.text = "시작일"
        label.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        label.font = .systemFont(ofSize: 19)
                label.font = UIFont(name: "Pretendard-Medium", size: 19)//미디움
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let endLabel: UILabel = {
        let label = UILabel()
        label.text = "종료일"
        label.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        label.font = .systemFont(ofSize: 19)
                label.font = UIFont(name: "Pretendard-Medium", size: 19)//미디움
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let endDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = ""
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "시간"
        label.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        label.font = UIFont(name: "Pretendard-Medium", size: 19)//미디움
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할일을 적어보세요!"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.font = .systemFont(ofSize: 14)
        textField.textAlignment = .center
        textField.backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "ko_KR")
        picker.tintColor = #colorLiteral(red: 0, green: 0.5176470588, blue: 1, alpha: 1)
        return picker
    }()
    
    let endTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "날짜를 선택하세요"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.font = .systemFont(ofSize: 14)
        textField.textAlignment = .center
        textField.backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "ko_KR")
        picker.tintColor = .white
        return picker
    }()
    
    let timeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "시간을 선택하세요"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.font = .systemFont(ofSize: 14)
        textField.textAlignment = .center
        textField.backgroundColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let timeDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.tintColor = .white
        return picker
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2980392157, green: 0.2980392157, blue: 0.2980392157, alpha: 1), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // ScrollView 및 ContentView 추가
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        
        schedulTextField.delegate = self
        schedulTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        backButton.addTarget(self, action: #selector(moveBack), for: .touchUpInside)
        
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(didtap), for: .touchUpInside)
        
        setupScrollView()
        setupDatePicker()
        endsetupDatePicker()
        timesetDatePicker()
        setupKeyboardDismiss()
        setUI()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd, yyyy"
        formatter.locale = Locale(identifier: "ko_KR")
        startTextField.text = formatter.string(from: Date())
        startTextField.textColor = .black
        startDatePicker.date = Date()
        
        let endformatter = DateFormatter()
        endformatter.dateFormat = "M월 dd, yyyy"
        endformatter.locale = Locale(identifier: "ko_KR")
        endTextField.text = endformatter.string(from: Date())
        endTextField.textColor = .black
        endDatePicker.date = Date()
        
        // timeTextField에 현재 시간 설정
        timeTextField.placeholder = "시간을 선택하세요"
        timeDatePicker.date = Date()  // 현재 시간으로 설정
        timeChanged(timeDatePicker)   // 현재 시간을 텍스트 필드에 표시
        userSelectedTime = false      // 초기 시간 설정은 사용자 선택이 아님
        
        viewDidLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 레이아웃이 업데이트될 때마다 그라데이션 다시 적용
        if !schedulTextField.text!.isEmpty {
            applyGradient(to: saveButton, colors: [
                #colorLiteral(red: 0.9568627451, green: 0.9450980392, blue: 0.7294117647, alpha: 1).cgColor,
                #colorLiteral(red: 0.9764705882, green: 0.9568627451, blue: 0.5568627451, alpha: 1).cgColor
            ])
        } else {
            applyGradient(to: saveButton, colors: [
                #colorLiteral(red: 0.4862745098, green: 0.4980392157, blue: 0.5294117647, alpha: 1).cgColor,
                #colorLiteral(red: 0.4862745098, green: 0.4980392157, blue: 0.5294117647, alpha: 1).cgColor
            ])
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
        ])
    }
    
    private func setupDatePicker() {
        startTextField.inputView = startDatePicker
        
        startDatePicker.addTarget(self, action: #selector(startdateChanged), for: .valueChanged)
    }
    
    private func endsetupDatePicker() {
        endTextField.inputView = endDatePicker
        
        endDatePicker.addTarget(self, action: #selector(enddateChanged), for: .valueChanged)
    }
    
    private func timesetDatePicker() {
        timeTextField.inputView = timeDatePicker
        timeDatePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
    }
    
    func setUI() {
        contentView.addSubview(centerLabel)
        contentView.addSubview(backButton)
        contentView.addSubview(mainLabel)
        contentView.addSubview(subLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(schedulTextField)
        contentView.addSubview(startLabel)
        contentView.addSubview(endLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(startTextField)
        contentView.addSubview(endTextField)
        contentView.addSubview(timeTextField)
        contentView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            centerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            centerLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 33),
            
            mainLabel.topAnchor.constraint(equalTo: centerLabel.bottomAnchor, constant: 52),
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31),
            //            mainLabel.heightAnchor.constraint(equalToConstant: 68),
            
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16),
            subLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31),
            //            subLabel.heightAnchor.constraint(equalToConstant: 18),
            
            titleLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            //            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            schedulTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            schedulTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31),
            schedulTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -31),
            schedulTextField.heightAnchor.constraint(equalToConstant: 50),
            
            startLabel.topAnchor.constraint(equalTo: schedulTextField.bottomAnchor, constant: 50),
            startLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            
            endLabel.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 55),
            endLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            
            timeLabel.topAnchor.constraint(equalTo: endLabel.bottomAnchor, constant: 55),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            
            startTextField.topAnchor.constraint(equalTo: schedulTextField.bottomAnchor, constant: 48),
            //            startTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 262),
            startTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -31),
            startTextField.heightAnchor.constraint(equalToConstant: 39),
            
            endTextField.topAnchor.constraint(equalTo: startTextField.bottomAnchor, constant: 41),
            endTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -31),
            endTextField.heightAnchor.constraint(equalToConstant: 39),
            
            timeTextField.topAnchor.constraint(equalTo: endTextField.bottomAnchor, constant: 41),
            timeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -31),
            timeTextField.heightAnchor.constraint(equalToConstant: 39),
            
            saveButton.topAnchor.constraint(equalTo: schedulTextField.bottomAnchor, constant: 354),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -31),
            saveButton.heightAnchor.constraint(equalToConstant: 46),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -49)
        ])
    }
    
    @objc private func startdateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd,yyyy"
        formatter.locale = Locale(identifier: "ko_KR")
        startTextField.text = formatter.string(from: sender.date)
        startTextField.textColor = .systemBlue  // 선택된 날짜는 파란색으로 표시
        startTextField.resignFirstResponder()
    }
    
    @objc private func enddateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd,yyyy"
        formatter.locale = Locale(identifier: "ko_KR")
        endTextField.text = formatter.string(from: sender.date)
        endTextField.textColor = .systemBlue  // 선택된 날짜는 파란색으로 표시
        endTextField.resignFirstResponder()
    }
    
    @objc private func timeChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        timeTextField.text = formatter.string(from: sender.date)
        timeTextField.textColor = .systemBlue
        timeTextField.resignFirstResponder()
        
        // 사용자가 직접 시간을 변경했음을 표시
        userSelectedTime = true
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        startTextField.textColor = .black
        endTextField.textColor = .black
        timeTextField.textColor = .black
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.isEmpty {
            saveButton.isEnabled = false
            applyGradient(to: saveButton, colors: [
                #colorLiteral(red: 0.4862745098, green: 0.4980392157, blue: 0.5294117647, alpha: 1).cgColor,
                #colorLiteral(red: 0.4862745098, green: 0.4980392157, blue: 0.5294117647, alpha: 1).cgColor
            ])
        } else {
            saveButton.isEnabled = true
            applyGradient(to: saveButton, colors: [
                #colorLiteral(red: 0.9568627451, green: 0.9450980392, blue: 0.7294117647, alpha: 1).cgColor,
                #colorLiteral(red: 0.9764705882, green: 0.9568627451, blue: 0.5568627451, alpha: 1).cgColor
            ])
        }
    }
    
    private func applyGradient(to button: UIButton, colors: [CGColor]) {
        // 기존 그라데이션 레이어 제거
        button.layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = button.layer.cornerRadius
        gradientLayer.frame = button.bounds
        
        button.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc func didtap() {
        print("간단한 일정 다 등록했디~!")
        let vc = SchedulemodalController()
        
        // 사용자가 직접 시간을 선택했는지 확인
        if userSelectedTime {
            // 사용자가 직접 시간을 선택한 경우 postDateTime 호출
            print("시간 있")
            postDateTime()
        } else {
            // 사용자가 시간을 선택하지 않은 경우 postDate 호출
            print("시간 없")
            postDate()
        }
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @objc func moveBack(){
        
        let mainVC = ViewController()
        mainVC.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: true )
    }
    
}
extension SimpleScheduleController {
    func postDateTime() {
        print("시간까지 받는 POST")
        
        // 날짜 변환을 위한 포매터
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "M월 dd,yyyy"
        inputDateFormatter.locale = Locale(identifier: "ko_KR")
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 시간 변환을 위한 포매터
        let inputTimeFormatter = DateFormatter()
        inputTimeFormatter.dateFormat = "a hh:mm"
        inputTimeFormatter.locale = Locale(identifier: "ko_KR")
        
        let outputTimeFormatter = DateFormatter()
        outputTimeFormatter.dateFormat = "HH:mm"
        
        // 날짜 변환
        var formattedStartDate = "2024-01-01"
        var formattedEndDate = "2024-01-01"
        
        if let dateText = startTextField.text,
           let date = inputDateFormatter.date(from: dateText) {
            formattedStartDate = outputDateFormatter.string(from: date)
        }
        
        if let dateText = endTextField.text,
           let date = inputDateFormatter.date(from: dateText) {
            formattedEndDate = outputDateFormatter.string(from: date)
        }
        
        // 시간 변환
        var startTimeString = "14:00"
        
        if let timeText = timeTextField.text,
           let timeDate = inputTimeFormatter.date(from: timeText) {
            startTimeString = outputTimeFormatter.string(from: timeDate)
        }
        
        // 서버에 보낼 데이터 준비 (swagger 형식에 맞춤)
        let parameters: [String: Any] = [
            "plantitle": schedulTextField.text ?? "",
            "startDate": formattedStartDate,
            "endDate": formattedEndDate,
            "startTime": startTimeString
        ]
        
        print("서버로 보내는 파라미터:", parameters)
        
        // API 호출
//        let userId = "user2"
        
        guard let userId = userId else { return }
        
        apiService.post(endpoint: "/plan/\(userId)/datetime", parameters: parameters) { (result: Result<APIResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("✅ 일정 등록 성공:", response)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("❌ 일정 등록 실패:", error.localizedDescription)
                    self.showAlert(message: "일정 등록에 실패했습니다: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func postDate() {
        print("시간안 받는 POST")
        // 날짜 변환을 위한 포매터
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "M월 dd,yyyy"
        inputDateFormatter.locale = Locale(identifier: "ko_KR")
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 날짜 변환
        var formattedStartDate = "2024-01-01"
        var formattedEndDate = "2024-01-01"
        
        if let dateText = startTextField.text,
           let date = inputDateFormatter.date(from: dateText) {
            formattedStartDate = outputDateFormatter.string(from: date)
        }
        
        if let dateText = endTextField.text,
           let date = inputDateFormatter.date(from: dateText) {
            formattedEndDate = outputDateFormatter.string(from: date)
        }
        
        // 서버에 보낼 데이터 준비 (swagger 형식에 맞춤)
        let parameters: [String: Any] = [
            "plantitle": schedulTextField.text ?? "",
            "startDate": formattedStartDate,
            "endDate": formattedEndDate
        ]
        
        print("서버로 보내는 파라미터 (날짜만):", parameters)
        guard let userId = userId else { return }
        // API 호출
//        let userId = "user2"
        apiService.post(endpoint: "/plan/\(userId)/date", parameters: parameters) { (result: Result<APIResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("✅ 일정 등록 성공 (날짜만):", response)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("❌ 일정 등록 실패:", error.localizedDescription)
                    self.showAlert(message: "일정 등록에 실패했습니다: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

