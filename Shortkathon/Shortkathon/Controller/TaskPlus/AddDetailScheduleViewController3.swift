


import UIKit

class AddDetailScheduleViewController3 : UIViewController {
    
    //MARK: - property
    var startDate : Date?
    var endDate : Date?
    var planSubId : Int?
    
    let scrollView : UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.1372549087, green: 0.1372549087, blue: 0.1372549087, alpha: 1)
        return view
    }()
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.text = "세분화 일정 등록"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let backButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("날짜/시간", attributes: AttributeContainer([
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
        imageView.image = UIImage(named: "progess3")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 15)
        button.backgroundColor = #colorLiteral(red: 0.5591031909, green: 0.571234405, blue: 0.5998923779, alpha: 1)
        button.layer.cornerRadius = 12
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()
    
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "해야하는 일을 작은 일들로\n나누어 적어보세요!"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 30)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let tableUIView : SeperateTaskView = {
        let view = SeperateTaskView()
        view.backgroundColor =  #colorLiteral(red: 0.1372549087, green: 0.1372549087, blue: 0.1372549087, alpha: 1)
        return view
    }()
    
    private var hasTableContent: Bool = false {
        didSet {
            updateNextButtonState()
        }
    }
    
    //MARK: - main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1372549087, green: 0.1372549087, blue: 0.1372549087, alpha: 1)
        
        print("페이지 3\(planSubId)")
        setUI()
        buttonTapped()
        setupKeyboardDismiss()
        setupTableViewDelegate()
    }
    
    
    //MARK: - function
    func setUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [mainLabel,backButton,cancelButton,progessbarImage,titleLabel,tableUIView,nextButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        
        
        tableUIView.viewHeightConstraint = tableUIView.heightAnchor.constraint(equalToConstant: 330)
        tableUIView.viewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // MainLabel
            mainLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            
            // BackButton
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 33),
            
            // CancelButton
            cancelButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            
            // ProgressBarImage
            progessbarImage.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 60),
            progessbarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31),
            progessbarImage.widthAnchor.constraint(equalToConstant: 179),
            progessbarImage.heightAnchor.constraint(equalToConstant: 21),
            
            // TitleLabel
            titleLabel.topAnchor.constraint(equalTo: progessbarImage.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31),
            
            // TableUIView
            tableUIView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 70),
            tableUIView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31),
            tableUIView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -31),
            tableUIView.viewHeightConstraint!,
            
            // NextButton
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: tableUIView.bottomAnchor, constant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 46),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40) // 중요
        ])
    }
    
    private func setupTableViewDelegate() {
        tableUIView.delegate = self
    }
    
    
    
    
    private func updateNextButtonState() {
        if hasTableContent {
            nextButton.isEnabled = true
            applyGradient(to: nextButton, colors: [
                #colorLiteral(red: 0.5294117647, green: 0.6745098039, blue: 0.9411764706, alpha: 1).cgColor,
                #colorLiteral(red: 0.3098039216, green: 0.5019607843, blue: 0.8431372549, alpha: 1).cgColor
            ])
        } else {
            nextButton.isEnabled = false
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
        updateNextButtonState()
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
        let vc = AddDetailScheduleViewController4()
        
        vc.modalPresentationStyle = .fullScreen
        vc.taskList = tableUIView.task
        vc.startDate = startDate
        vc.endDate = endDate
        vc.planSubId = planSubId
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        present(vc,animated: false)
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

//MARK: - seperateTaskView 델리게이트

extension AddDetailScheduleViewController3: SeperateTaskViewDelegate {
    func taskContentDidChange(hasContent: Bool) {
        print("taskContentDidChange called: \(hasContent)")
        if hasContent {
            nextButton.isEnabled = true
            applyGradient(to: nextButton, colors: [
                #colorLiteral(red: 0.5294117647, green: 0.6745098039, blue: 0.9411764706, alpha: 1).cgColor,
                #colorLiteral(red: 0.3098039216, green: 0.5019607843, blue: 0.8431372549, alpha: 1).cgColor
            ])
        } else {
            nextButton.isEnabled = false
            applyGradient(to: nextButton, colors: [
                #colorLiteral(red: 0.4862745098, green: 0.4980392157, blue: 0.5294117647, alpha: 1).cgColor,
                #colorLiteral(red: 0.4862745098, green: 0.4980392157, blue: 0.5294117647, alpha: 1).cgColor
            ])
        }
        
        // 레이아웃 업데이트
        nextButton.setNeedsDisplay()
        nextButton.layoutIfNeeded()
    }
    
}

// SeperateTaskView에 추가할 델리게이트 프로토콜
protocol SeperateTaskViewDelegate: AnyObject {
    func taskContentDidChange(hasContent: Bool)
}
