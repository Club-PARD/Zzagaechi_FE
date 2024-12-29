//
//  AddDetailScheduleViewController1.swift
//  Sergei
//
//  Created by 김사랑 on 12/28/24.
//



import UIKit

class AddDetailScheduleViewController2 : UIViewController {
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.text = "세분화 일정 등록"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backButton : UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Icon-3")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 15)
        button.tintColor = #colorLiteral(red: 1, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
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
        label.text = "언제부터 언제까지 진행하실건가요?"
        label.font = .systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.6901960784, green: 0.6901960784, blue: 0.6901960784, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startLabel: UILabel = {
        let label = UILabel()
        label.text = "시작일"
        label.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        label.font = .systemFont(ofSize: 19)
        //        label.font = UIFont(name: "Pretendard-Regular", size: 30)//미디움
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let endLabel: UILabel = {
        let label = UILabel()
        label.text = "종료일"
        label.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        label.font = .systemFont(ofSize: 19)
        //        label.font = UIFont(name: "Pretendard-Regular", size: 30)//미디움
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
        label.font = .systemFont(ofSize: 19)
        //        label.font = UIFont(name: "Pretendard-Regular", size: 30)//미디움
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
        picker.tintColor = .white
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
    
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 15)
        button.backgroundColor = #colorLiteral(red: 0.5591031909, green: 0.571234405, blue: 0.5998923779, alpha: 1)
        button.layer.cornerRadius = 12
        button.tintColor = .white
        return button
    }()
    
    
    
    
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
            startTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 262),
            startTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor , constant: -44),
            startTextField.heightAnchor.constraint(equalToConstant: 39),
            
            endTextField.topAnchor.constraint(equalTo: startTextField.bottomAnchor , constant: 41),
            endTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 262),
            endTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor , constant: -44),
            endTextField.heightAnchor.constraint(equalToConstant: 39),
            
            timeTextField.topAnchor.constraint(equalTo: endTextField.bottomAnchor , constant: 41),
            timeTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 262),
            timeTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor , constant: -44),
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
        let vc = AddDetailScheduleViewController3()
        vc.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        present(vc,animated: false)
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
    }

    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

}
