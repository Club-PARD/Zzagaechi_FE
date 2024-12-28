import UIKit


class ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        // 커스텀 탭바 설정
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTabbar()
        self.selectedIndex = 1
    }

    func setTabbar() {
        let vc1 = UINavigationController(rootViewController: CalendarViewController())
        let vc2 = UINavigationController(rootViewController: MainViewController())
        let vc3 = UINavigationController(rootViewController: SeparateTaskViewController())
        
        self.viewControllers = [vc1, vc2, vc3]
    
        // 탭바 아이템 색상 설정
        self.tabBar.tintColor = .white  // 선택된 아이템 색상
        self.tabBar.unselectedItemTintColor = .gray  // 선택되지 않은 아이템 색상
        
        guard let tabBarItem = self.tabBar.items else { return }
        
        // 탭바 아이템 설정
        tabBarItem[0].image = UIImage(named: "calender")
        tabBarItem[1].image = UIImage(named: "home")
        tabBarItem[2].image = UIImage(named: "plus")
        tabBarItem[0].title = "캘린더"
        tabBarItem[1].title = "홈"
        tabBarItem[2].title = "추가"
    }
}
