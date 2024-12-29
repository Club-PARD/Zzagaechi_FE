


import UIKit

class AddDetailScheduleViewController3 : UIViewController {
    
    //MARK: - property
    
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
        return button
    }()
    
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "할 일들을 나눠서\n적어보세요!"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 30)
        label.numberOfLines = 0
        return label
    }()
    
    let tableUIView : SeperateTaskView = {
        let view = SeperateTaskView()
        view.backgroundColor =  #colorLiteral(red: 0.1372549087, green: 0.1372549087, blue: 0.1372549087, alpha: 1)
        return view
    }()
    
    
    //MARK: - main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1372549087, green: 0.1372549087, blue: 0.1372549087, alpha: 1)
//        setupScrollView()
        setUI()
        buttonTapped()
        setupKeyboardDismiss()
    }
    
    
    //MARK: - function
    func setUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [mainLabel,backButton,cancelButton,progessbarImage,titleLabel,tableUIView,nextButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        
        
        tableUIView.viewHeightConstraint = tableUIView.heightAnchor.constraint(equalToConstant: 280)
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

            // TitleLabel
            titleLabel.topAnchor.constraint(equalTo: progessbarImage.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31),

            // TableUIView
            tableUIView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 98),
            tableUIView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31),
            tableUIView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -31),
            tableUIView.viewHeightConstraint!,

            // NextButton
            nextButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: tableUIView.bottomAnchor, constant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 46),
            nextButton.widthAnchor.constraint(equalToConstant: 331),
            nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // 중요
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
        let vc = AddDetailScheduleViewController4()
        vc.modalPresentationStyle = .fullScreen
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
