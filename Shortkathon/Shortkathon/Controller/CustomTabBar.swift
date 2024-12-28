import UIKit


class CustomTabBar: UITabBar {
    static let customHeight: CGFloat = 120

    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
           var sizeThatFits = super.sizeThatFits(size)
           sizeThatFits.height = CustomTabBar.customHeight
           return sizeThatFits
       }
    
    override func draw(_ rect: CGRect) {
        // 탭바 배경색 설정
        self.backgroundColor = .black
        
        // 라운딩 처리를 위한 path
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 20, height: 20)
        )
        
        // 라운딩된 마스크 레이어 생성
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
        // 그림자 설정
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.white.withAlphaComponent(0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -4)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 그림자를 위한 path 설정
        self.layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 20, height: 20)
        ).cgPath
    }
}
