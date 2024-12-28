import UIKit

class CustomTabBar: UITabBar {
    static let customHeight: CGFloat = 110 // 탭바 높이 조정

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = CustomTabBar.customHeight
        return sizeThatFits
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = .clear
        let backgroundLayer = CAShapeLayer()
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 30, height: 30) // 둥근 모서리 크기
        )
        
        // 배경색 적용
        backgroundLayer.path = path.cgPath
        backgroundLayer.fillColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        layer.insertSublayer(backgroundLayer, at: 0)
        
        // 그림자 추가
        backgroundLayer.shadowColor = UIColor.white.cgColor
        backgroundLayer.shadowOffset = CGSize(width: 0, height: -2) // 그림자 위치 조정
        backgroundLayer.shadowOpacity = 0.2 // 그림자 투명도
        backgroundLayer.shadowRadius = 6 // 그림자 퍼짐 정도
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    
        // TabBar 아이템들의 위치 및 크기 조정
        let tabBarItems = self.subviews.filter({ $0 is UIControl })
        let tabBarItemWidth = self.bounds.width / CGFloat(tabBarItems.count)
        for (index, tabBarItem) in tabBarItems.enumerated() {
            let xPosition = tabBarItemWidth * CGFloat(index)
            tabBarItem.frame = CGRect(
                x: xPosition,
                y: 10, // 탭바 아이템을 조금 위로 올림
                width: tabBarItemWidth,
                height: self.bounds.height - 20
            )
        }
        
        // 아이템 위치 조정
          if let items = self.items {
              items.forEach { item in
                  // 타이틀을 더 위로 올림 (vertical 값을 더 작게(음수) 조정)
                  item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -16)
                  
                  // 이미지도 함께 조정하고 싶다면
                  item.imageInsets = UIEdgeInsets(top: -8, left: 0, bottom: 8, right: 0)
              }
          }
        
        
    }
}

