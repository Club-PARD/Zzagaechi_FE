

import UIKit

class SeparateTaskViewController : UIViewController {
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0.529, green: 0.698, blue: 1.0, alpha: 1.0).cgColor, // #87B2FF
            UIColor(red: 0.447, green: 0.643, blue: 1.0, alpha: 1.0).cgColor  // #72A4FF
        ]
        layer.locations = [0.0, 1.0]
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)  // 왼쪽 상단
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)    // 가운데 하단
        return layer
    }()
    
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 새로운 일정을 등록할래요?"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let Button: UIButton = {
        let button = UIButton()
        button.setTitle("세분화 일정", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 20)
        button.setTitleColor(#colorLiteral(red: 0.1882352941, green: 0.4784313725, blue: 0.9960784314, alpha: 1), for: .normal)
        button.layer.cornerRadius = 18
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // 그림자 설정
        button.layer.shadowColor = UIColor.black.cgColor // 그림자 색상
        button.layer.shadowOffset = CGSize(width: 2, height: 2) // 그림자 위치
        button.layer.shadowOpacity = 0.3 // 그림자 투명도
        button.layer.shadowRadius = 8// 그림자 반경
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // 타이틀 위치 설정
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .top
        button.titleEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 0, right: 0)
        
        return button
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        let firstPart = "큰 목표도 작은 단위로"
        let secondPart = "해야할 일을 나눠서 차근차근 달성해보세요"
        let combinedText = "\(firstPart)!\n\(secondPart)"
        
        label.text = combinedText
        label.font = UIFont(name: "Pretendard-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.numberOfLines = 0 // 여러 줄 지원
        label.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Icon_right")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let Button2: UIButton = {
        let button = UIButton()
        button.setTitle("간단한 일정", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.7921568627, blue: 0.431372549, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 20)
        button.layer.cornerRadius = 18
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // 그림자 설정
        button.layer.shadowColor = UIColor.black.cgColor // 그림자 색상
        button.layer.shadowOffset = CGSize(width: 2, height: 2) // 그림자 위치
        button.layer.shadowOpacity = 0.3 // 그림자 투명도
        
        button.layer.shadowRadius = 8 // 그림자 반경
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .top
        button.titleEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 0, right: 0)
        
        return button
    }()
    
    let ezLabel: UILabel = {
        let label = UILabel()
        let firstPart = "한 번에 처리할 수 있는 일을"
        let secondPart = "바로 추가하고 시작해보세요"
        let combinedText = "\(firstPart)!\n\(secondPart)"
        
        label.text = combinedText
        label.font = UIFont(name: "Pretendard-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.numberOfLines = 0 // 여러 줄 지원
        label.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Icon_right")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        //        view.backgroundColor = #colorLiteral(red: 0.7294117647, green: 0.8078431373, blue: 0.9568627451, alpha: 1)
        super.viewDidLoad()
        
        setupGradientBackground()
        Button.addTarget(self, action: #selector(didTap), for:  .touchUpInside)
        Button2.addTarget(self, action: #selector(doTap), for: .touchUpInside)
        setUI()
        
    }
    
    func setUI() {
        view.addSubview(mainLabel)
        view.addSubview(Button)
        view.addSubview(subLabel)
        view.addSubview(iconImage)
        view.addSubview(Button2)
        view.addSubview(ezLabel)
        view.addSubview(iconImage2)
        
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 73),
            
            Button.topAnchor.constraint(equalTo: view.topAnchor, constant: 136),
            Button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:44),
            Button.widthAnchor.constraint(equalToConstant: 305),
            Button.heightAnchor.constraint(equalToConstant: 92),
            Button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:   -44),
            
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 85),
            subLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            
            iconImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 175),
            //            iconImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 324.25),
            iconImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -62.57),
            
            Button2.topAnchor.constraint(equalTo: Button.bottomAnchor, constant: 22),
            Button2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:44),
            Button2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:   -44),
            Button2.widthAnchor.constraint(equalToConstant: 305),
            Button2.heightAnchor.constraint(equalToConstant: 92),
            
            ezLabel.topAnchor.constraint(equalTo: Button.bottomAnchor, constant: 68),
            ezLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            
            iconImage2.topAnchor.constraint(equalTo: view.topAnchor, constant: 289),
            //            iconImage2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 324.25),
            iconImage2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -62.57),
        ])
        
        
    }
    
    @objc func didTap() {
        print("누가 세분화 일정 눌렀디")
        let vc = AddDetailScheduleViewController1()
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true)
        
    }
    
    
    @objc func doTap() {
        print("누가 간단한 일정 눌렀디")
        let vc = SimpleScheduleController()
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 뷰의 크기가 결정된 후 그라데이션 레이어의 프레임 설정
        gradientLayer.frame = view.bounds
    }
    
    private func setupGradientBackground() {
        // 그라데이션 레이어를 뷰의 가장 아래 레이어로 삽입
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}




