//
//  completemodalController.swift
//  Sergei
//
//  Created by 김사랑 on 12/28/24.
//

//
//  SchedulemodalController.swift
//  Sergei
//
//  Created by 김사랑 on 12/28/24.
//

import UIKit


class completemodalController: UIViewController {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1)
        view.layer.borderColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        let firstPart = "  할 일을 다 해내다니"//히히 꼼수 부려버리기~!~!~!
        let secondPart = "오늘 하루도 고생했어요!"
        let combinedText = "\(firstPart)!\n\(secondPart)"
        label.text = combinedText
        label.font = .systemFont(ofSize: 21)
//        label.font = UIFont(name: "Pretendard-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        label.numberOfLines = 0 // 여러 줄 지원
        label.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        let firstPart = "미루지 않고 할 일을 모두 끝낸"
        let secondPart = "스스로에게 칭찬 한마디 어때요?"
        let combinedText = "\(firstPart)!\n\(secondPart)"
        label.text = combinedText
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
//        label.font = UIFont(name: "Pretendard-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        label.numberOfLines = 0 // 여러 줄 지원
        label.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
        
    }()
    
    let fireImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Group 2063")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("나 자신 칭찬해 👏🏻", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.7764705882, blue: 0.9803921569, alpha: 1)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.addSubview(containerView)
        containerView.addSubview(closeButton)
        containerView.addSubview(mainLabel)
        containerView.addSubview(fireImageView)
        containerView.addSubview(subLabel)
        containerView.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 315),
            containerView.heightAnchor.constraint(equalToConstant: 467),
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            
            mainLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35.32),
            mainLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 51),
            mainLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -56),
            
            fireImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 36),
            fireImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 62),
            fireImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -48.25),
            
            
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 242.12),
            subLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 68),
            subLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -73),
            
            confirmButton.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 16.63),
            confirmButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 54),
            confirmButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -60),
            confirmButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true)
    }
}
