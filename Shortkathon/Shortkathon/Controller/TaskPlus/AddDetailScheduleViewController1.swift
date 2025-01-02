//
//  AddDetailScheduleViewController1.swift
//  Sergei
//
//  Created by 김사랑 on 12/28/24.
//



import UIKit

class AddDetailScheduleViewController1 : UIViewController {
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.text = "세분화 일정 등록"
        label.font = .systemFont(ofSize: 16)
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
        button.setTitleColor(#colorLiteral(red: 1, green: 0.2745098039, blue: 0.2745098039, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        let firstPart = "해야 하는 일에 대한"
        let secondPart = "제목을 적어보세요!"
        let combinedText = "\(firstPart)\n\(secondPart)"
        
        label.text = combinedText
        label.font = .systemFont(ofSize: 30)
        label.font = UIFont(name: "Pretendard-SemiBold", size: 30)//볼더임
        label.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
        label.numberOfLines = 0 // 여러 줄 지원
        label.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 일을 해야 하는지 제목을 입력해주세요"
        label.font = UIFont(name: "Pretendard-Medium", size: 15)
        label.textColor = #colorLiteral(red: 0.6901960784, green: 0.6901960784, blue: 0.6901960784, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let schedulTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "제목을 입력하세요"
            textField.borderStyle = .roundedRect
            textField.layer.cornerRadius = 12
            textField.font = .systemFont(ofSize: 14)
            textField.font = UIFont(name: "Pretendard-Regular", size: 14)
            
            textField.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
            textField.textColor = #colorLiteral(red: 0.9999999881, green: 0.9999999881, blue: 0.9999999881, alpha: 1)
            textField.layer.borderColor = #colorLiteral(red: 0.7294117647, green: 0.8117647059, blue: 0.9568627451, alpha: 1)
            textField.layer.borderWidth = 2
            textField.translatesAutoresizingMaskIntoConstraints = false
            
            // 왼쪽 여백 추가
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always

            return textField
        }()
    
    let progessbarImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progess")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 15)
        button.backgroundColor = #colorLiteral(red: 0.4862745098, green: 0.4980392157, blue: 0.5294117647, alpha: 1)
        button.layer.cornerRadius = 12
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()
    
    
    
    //MARK: - main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1372549087, green: 0.1372549087, blue: 0.1372549087, alpha: 1)
        
        setUI()
        buttonTapped()
        setupKeyboardDismiss()
        setupTextField()
    }
    
    
    //MARK: - function
    func setUI(){
        [nextButton,mainLabel,backButton,cancelButton,progessbarImage,headerLabel,subLabel,schedulTextField].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 15),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 15),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 33),
            
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 15),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -28),
            
            progessbarImage.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 60),
            progessbarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 31),
            progessbarImage.widthAnchor.constraint(equalToConstant: 179),
            progessbarImage.heightAnchor.constraint(equalToConstant: 21),
            
            headerLabel.topAnchor.constraint(equalTo: progessbarImage.bottomAnchor , constant: 11),
            headerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 31),
            
            subLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor , constant: 16),
            subLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 31),
            
            schedulTextField.topAnchor.constraint(equalTo: subLabel.bottomAnchor , constant: 65),
            schedulTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 31),
            schedulTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor , constant: -31),
            schedulTextField.heightAnchor.constraint(equalToConstant: 50),
            
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor , constant: -49),
            nextButton.heightAnchor.constraint(equalToConstant: 46),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
        ])
    }
    
    
    func setupTextField(){
        schedulTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
    }
    
    @objc func textFieldChanged(_ textField: UITextField){
        let isEmpty = textField.text?.isEmpty ?? true
        updateNextButtonState(isEmpty: isEmpty)
    }
    
    
    func updateNextButtonState(isEmpty : Bool){
        if isEmpty {
            nextButton.backgroundColor = #colorLiteral(red: 0.5591031909, green: 0.571234405, blue: 0.5998923779, alpha: 1)
            // 비활성화 상태에서는 그라데이션 레이어 제거
            nextButton.layer.sublayers?.forEach { layer in
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
            nextButton.isEnabled = false
        } else {
            // 그라데이션 레이어 생성
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = nextButton.bounds
            gradientLayer.colors = [
                #colorLiteral(red: 0.5294117647, green: 0.6745098039, blue: 0.9411764706, alpha: 1).cgColor,
                #colorLiteral(red: 0.3098039216, green: 0.5019607843, blue: 0.8431372549, alpha: 1).cgColor,
            ]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.cornerRadius = 12
            
            // 기존 그라데이션 레이어 제거
            nextButton.layer.sublayers?.forEach { layer in
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
            
            nextButton.layer.insertSublayer(gradientLayer, at: 0)
            nextButton.isEnabled = true
        }
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
        guard nextButton.isEnabled else { return }

        let vc = AddDetailScheduleViewController2()
        vc.plansubtitle = schedulTextField.text
        
        
        vc.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        present(vc,animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.frame = nextButton.bounds
            }
        }
    }
    
    
    
}

