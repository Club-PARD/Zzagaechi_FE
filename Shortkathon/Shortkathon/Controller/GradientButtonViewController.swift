//
//  GradientButtonViewController.swift
//  Sergei
//
//  Created by 김사랑 on 12/28/24.
//

import UIKit

class GradientButtonViewController: UIViewController {

    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true // 모서리 깎기
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경색 설정
        view.backgroundColor = .white
        
        // 버튼 초기 설정
        view.addSubview(saveButton)
        setupConstraints()
        
        // 버튼 활성화/비활성화 상태 테스트
        saveButton.isEnabled = false
        updateButtonGradient(for: saveButton)
        
        // 상태 변경을 위한 버튼 추가
        let toggleButton = UIButton(type: .system)
        toggleButton.setTitle("활성화/비활성화 전환", for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleSaveButtonState), for: .touchUpInside)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleButton)
        NSLayoutConstraint.activate([
            toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20)
        ])
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func updateButtonGradient(for button: UIButton) {
        // 기존 그라데이션 제거
        button.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradientLayer = CAGradientLayer()
        if button.isEnabled {
            // 활성화 상태의 그라데이션
            gradientLayer.colors = [
                UIColor(hex: "#F4F1BA", alpha: 1.0).cgColor,
                UIColor(hex: "#FFF75F", alpha: 0.9).cgColor
            ]
        } else {
            // 비활성화 상태의 그라데이션 (흐리게 처리)
            gradientLayer.colors = [
                UIColor(hex: "#7C7F87", alpha: 0.4).cgColor,
            ]
        }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = button.bounds
        gradientLayer.cornerRadius = button.layer.cornerRadius
        
        // 버튼의 layer에 그라데이션 추가
        button.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 버튼 크기에 맞게 그라데이션 업데이트
        saveButton.layer.sublayers?.first?.frame = saveButton.bounds
    }

    @objc func toggleSaveButtonState() {
        saveButton.isEnabled.toggle()
        updateButtonGradient(for: saveButton)
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
