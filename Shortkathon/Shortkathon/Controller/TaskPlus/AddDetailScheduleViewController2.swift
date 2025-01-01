//
//  AddDetailScheduleViewController1.swift
//  Sergei
//
//  Created by 김사랑 on 12/28/24.
//



import UIKit

class AddDetailScheduleViewController2 : UIViewController {
    var plansubtitle : String?
    var userId =  UserDefaults.standard.string(forKey: "userIdentifier")
    let apiService = APIService.shared
    private let maximumDays: Int = 30
    var planSubId: Int?
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.text = "세분화 일정 등록"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    let backButton : UIButton = {
//        let button = UIButton()
//        let image = UIImage(named: "Icon-3")
//        button.setImage(image, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
        let backButton: UIButton = {
            var config = UIButton.Configuration.plain()
            config.attributedTitle = AttributedString("제목", attributes: AttributeContainer([
                .font: UIFont(name: "Pretendard-Regular", size: 16.0),
                .foregroundColor: UIColor(red: 0.6817840338, green: 0.6817839742, blue: 0.6817840338, alpha: 1)
            ]))
            config.image = UIImage(named: "Icon-3")
            config.imagePlacement = .leading
            config.imagePadding = 8
            config.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 12, trailing: 26)
            let button = UIButton(configuration: config)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    

    
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 15)
        button.setTitleColor(#colorLiteral(red: 1, green: 0.2745098039, blue: 0.2745098039, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let progessbarImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progess2")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        let firstPart = "할 일의 날짜와 시간을"
        let secondPart = "선택해보세요!"
        let combinedText = "\(firstPart)\n\(secondPart)"
        
        label.text = combinedText
        label.font = UIFont(name: "Pretendard-SemiBold", size: 30)//볼더임
        label.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        label.numberOfLines = 0 // 여러 줄 지원
        label.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "언제부터 언제까지 진행하실건가요?"
        label.font = UIFont(name: "Pretendard-Regular", size: 15)
        label.textColor = #colorLiteral(red: 0.6901960784, green: 0.6901960784, blue: 0.6901960784, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startLabel: UILabel = {
        let label = UILabel()
        label.text = "시작일"
        label.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        label.font = UIFont(name: "Pretendard-Regular", size: 19)//미디움
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let endLabel: UILabel = {
        let label = UILabel()
        label.text = "종료일"
        label.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        label.font = UIFont(name: "Pretendard-Regular", size: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let endDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = ""
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "시간"
        label.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        label.font = UIFont(name: "Pretendard-Regular", size: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할일을 적어보세요!"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.font = UIFont(name: "Pretendard-Regular", size: 14)
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
        picker.tintColor = .systemBlue
        return picker
    }()
    
    let endTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "날짜를 선택하세요"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.font = UIFont(name: "Pretendard-Regular", size: 14)
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
        picker.tintColor = .systemBlue
        return picker
    }()
    
    let timeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "시간을 선택하세요"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.font = UIFont(name: "Pretendard-Regular", size: 14)
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
        picker.tintColor = .systemBlue
        return picker
    }()
    
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 15)
        button.setTitleColor(#colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 날짜 선택 상태를 추적하는 변수 추가
    private var isStartDateSelected = false
    private var isEndDateSelected = false
    private var isTimeSelected = false    // 추가
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1372549087, green: 0.1372549087, blue: 0.1372549087, alpha: 1)
        
        setupDatePicker()
        endsetupDatePicker()
        timesetDatePicker()
        setupKeyboardDismiss()
        buttonTapped()
        setUI()
        
        // 오늘 날짜를 텍스트 필드에 설정
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd, yyyy"
        formatter.locale = Locale(identifier: "ko_KR")
        startTextField.text = formatter.string(from: Date())
        startTextField.textColor = .black  // 초기 텍스트 색상을 검은색으로 설정
        // DatePicker의 초기 날짜도 오늘로 설정
        startDatePicker.date = Date()
        
        let endformatter = DateFormatter()
        endformatter.dateFormat = "M월 dd, yyyy"
        endformatter.locale = Locale(identifier: "ko_KR")
        endTextField.text = endformatter.string(from: Date())
        endTextField.textColor = .black  // 초기 텍스트 색상을 검은색으로 설정
        // DatePicker의 초기 날짜도 오늘로 설정
        endDatePicker.date = Date()
        
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "a hh:mm"
        timeformatter.locale = Locale(identifier: "ko_KR")
        timeTextField.text = timeformatter.string(from: Date())
        timeTextField.textColor = .black
        timeDatePicker.date = Date()
        
        nextButton.isEnabled = false
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .clear
        
        checkTextFieldsAndUpdateButton()
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
    
    
    func setUI(){
        [nextButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        
        view.addSubview(mainLabel)
        view.addSubview(backButton)
        view.addSubview(cancelButton)
        view.addSubview(progessbarImage)
        
        view.addSubview(headerLabel)
        view.addSubview(subLabel)
        view.addSubview(startLabel)
        view.addSubview(endLabel)
        view.addSubview(timeLabel)
        view.addSubview(startTextField)
        view.addSubview(endTextField)
        view.addSubview(timeTextField)
        
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 15),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 15),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 33),
            
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 15),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -28),
            
            progessbarImage.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 57),
            progessbarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 31),
            
            headerLabel.topAnchor.constraint(equalTo: progessbarImage.bottomAnchor , constant: 12),
            headerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 31),
            
            subLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor , constant: 16),
            subLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 32),
            
            startLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor , constant: 98),
            startLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 44),
            
            endLabel.topAnchor.constraint(equalTo: startLabel.bottomAnchor , constant: 55),
            endLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 44),
            
            timeLabel.topAnchor.constraint(equalTo: endLabel.bottomAnchor , constant: 55),
            timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 44),
            
            startTextField.topAnchor.constraint(equalTo: subLabel.bottomAnchor , constant: 91),
            startTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 230),
            startTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor , constant: -28),
            startTextField.heightAnchor.constraint(equalToConstant: 39),
            
            endTextField.topAnchor.constraint(equalTo: startTextField.bottomAnchor , constant: 41),
            endTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 230),
            endTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor , constant: -28),
            endTextField.heightAnchor.constraint(equalToConstant: 39),
            
            timeTextField.topAnchor.constraint(equalTo: endTextField.bottomAnchor , constant: 41),
            timeTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 230),
            timeTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor , constant: -28),
            timeTextField.heightAnchor.constraint(equalToConstant: 39),
            
            
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor , constant: -49),
            nextButton.heightAnchor.constraint(equalToConstant: 46),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
        ])
    }
    
    
    func buttonTapped(){
        backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(moveToMain), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(movoToNext), for: .touchUpInside)
    }
    
    
    
    
    @objc func dismissVC() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    @objc func moveToMain() {
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        present(vc,animated: false)
    }
    
    @objc func movoToNext(){
        guard nextButton.isEnabled else {return}
        
//        guard let planSubId = planSubId else {return}
        
        let vc = AddDetailScheduleViewController3()
        vc.modalPresentationStyle = .fullScreen
        
//        if !isTimeSelected {
//            postSchedule1()
//        } else{
//            postSchedule2()
//        }
        if !isTimeSelected {
               postSchedule1 { [weak self] success in
                   guard let self = self else { return }
                   if success {
                       self.presentNextViewController(vc)
                   }
               }
           } else {
               postSchedule2 { [weak self] success in
                   guard let self = self else { return }
                   if success {
                       self.presentNextViewController(vc)
                   }
               }
           }
        
    }
    
    private func presentNextViewController(_ vc: AddDetailScheduleViewController3) {
        DispatchQueue.main.async {
            vc.planSubId = self.planSubId
            vc.startDate = self.startDatePicker.date
            vc.endDate = self.endDatePicker.date
            
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = .push
            transition.subtype = .fromRight
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.present(vc, animated: false)
        }
    }

    
    @objc private func startdateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd,yyyy"
        formatter.locale = Locale(identifier: "ko_KR")
        
        let maxDate = Calendar.current.date(byAdding: .day, value: maximumDays, to: sender.date)
        endDatePicker.maximumDate = maxDate
        
        // 종료일이 최대 허용 기간을 초과하면 자동으로 조정
        if let maxDate = maxDate, endDatePicker.date > maxDate {
            endDatePicker.date = maxDate
            endTextField.text = formatter.string(from: maxDate)
        }
        
        startTextField.text = formatter.string(from: sender.date)
        startTextField.textColor = .systemBlue
        isStartDateSelected = true  // 날짜 선택 상태 업데이트
        checkTextFieldsAndUpdateButton()
    }
    
    @objc private func enddateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd,yyyy"
        formatter.locale = Locale(identifier: "ko_KR")
        
        // 선택된 종료일이 시작일보다 이전이면 시작일로 설정
        if sender.date < startDatePicker.date {
            sender.date = startDatePicker.date
        }
        
        // 선택된 종료일이 최대 허용 기간을 초과하면 최대 날짜로 설정
        let maxDate = Calendar.current.date(byAdding: .day, value: maximumDays, to: startDatePicker.date)
        if let maxDate = maxDate, sender.date > maxDate {
            sender.date = maxDate
        }
        
        endTextField.text = formatter.string(from: sender.date)
        endTextField.textColor = .systemBlue
        isEndDateSelected = true
        checkTextFieldsAndUpdateButton()
        
        // 날짜 차이가 30일을 초과하면 알림 표시
        let days = Calendar.current.dateComponents([.day], from: startDatePicker.date, to: sender.date).day ?? 0
        if days > maximumDays {
            let alert = UIAlertController(
                title: "알림",
                message: "시작일로부터 최대 30일까지만 선택할 수 있습니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            
            // 종료일을 최대 허용 날짜로 재설정
            if let maxDate = maxDate {
                sender.date = maxDate
                endTextField.text = formatter.string(from: maxDate)
            }
        }
    }
    
    @objc private func timeChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        timeTextField.text = formatter.string(from: sender.date)
        timeTextField.textColor = .systemBlue
        isTimeSelected = true    // 시간 선택 상태 업데이트
        checkTextFieldsAndUpdateButton()  // 버튼 상태 체크 추가
        timeTextField.resignFirstResponder()
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
    
    private func checkTextFieldsAndUpdateButton() {
        let isEnabled = isStartDateSelected && isEndDateSelected
        //        && isTimeSelected
        
        nextButton.isEnabled = isEnabled
        if isEnabled {
            applyGradient(to: nextButton, colors: [
                #colorLiteral(red: 0.5294117647, green: 0.6745098039, blue: 0.9411764706, alpha: 1).cgColor,
                #colorLiteral(red: 0.3098039216, green: 0.5019607843, blue: 0.8431372549, alpha: 1).cgColor
            ])
        } else {
            applyGradient(to: nextButton, colors: [
                #colorLiteral(red: 0.4862745098, green: 0.4980392157, blue: 0.5294117647, alpha: 1).cgColor,
                #colorLiteral(red: 0.4862745098, green: 0.4980392157, blue: 0.5294117647, alpha: 1).cgColor
            ])
        }
    }
    
    private func applyGradient(to button: UIButton, colors: [CGColor]) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        checkTextFieldsAndUpdateButton()
    }
    
}



//MARK: - main

extension AddDetailScheduleViewController2 {
    func postSchedule1(completion : @escaping (Bool) -> Void) {
        print("첫번째 POST")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let plansubtitle = plansubtitle else{return}
        
        // 시작일과 종료일 가져오기
        let startDate = dateFormatter.string(from: startDatePicker.date)
        let endDate = dateFormatter.string(from: endDatePicker.date)
        
        let parameters: [String: Any] = [
            "plansubtitle": plansubtitle ,
            "startDate": startDate,
            "endDate": endDate
        ]
        
        print("startDate : \(startDate)")
        print("endDate : \(endDate)")
        print("plansubtitle : \(plansubtitle)")
        
        guard let userId = userId else { return }
        
//        let userId = "user2"
        // API 호출
        apiService.post(
            endpoint: "/plansub/\(userId)",
            parameters: parameters
        ) { (result: Result<Int, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ 일정 등록 성공: \(response)")
                    self.planSubId = response
                    print("🚨플랜서브아이디\(self.planSubId)")
                    completion(true)

                case .failure(let error):
                    print("❌ 일정 등록 실패: \(error.localizedDescription)")
                    // 에러 처리
                    completion(false)
                    print("🚨세분화 1,2 post 실패")
                }
            }
        }
        
        
        
    }
    
    func postSchedule2(completion : @escaping (Bool) -> Void) {
        print("두번째 POST")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        guard let plansubtitle = plansubtitle else{return}
        print("plansubtitle : \(plansubtitle)")
        // 시작일과 종료일 가져오기
        let startDate = dateFormatter.string(from: startDatePicker.date)
        let endDate = dateFormatter.string(from: endDatePicker.date)
        let deadline = timeFormatter.string(from: timeDatePicker.date)
        
        print("startDate : \(startDate)")
        print("endDate : \(endDate)")
        print("deadline : \(deadline)")
        
        
        let parameters: [String: Any] = [
            "plansubtitle" : plansubtitle,
            "startDate": startDate,
            "endDate": endDate,
            "deadline": deadline,
        ]
        
//        let userId = "user2"
        guard let userId = userId else { return }

        // API 호출
        apiService.post(
            endpoint: "/plansub/\(userId)/endtime",
            parameters: parameters
        ) { (result: Result<Int, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ 일정 등록 성공: \(response)")
                    self.planSubId = response
                    completion(true)
                case .failure(let error):
                    print("❌ 일정 등록 실패: \(error.localizedDescription)")
                    // 에러 처리
                    completion(false)
                    print("🚨세분화 1,2 post 실패")
                }
            }
        }
        
    }
    
    
    
}

