import UIKit


class ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        tabBarItem[0].image = UIImage(systemName: "folder.fill")
        tabBarItem[1].image = UIImage(systemName: "house")
        tabBarItem[2].image = UIImage(systemName: "person.crop.badge.magnifyingglass")
        tabBarItem[0].title = "Calender"
        tabBarItem[1].title = "Home"
        tabBarItem[2].title = "Separate"
    }
}
