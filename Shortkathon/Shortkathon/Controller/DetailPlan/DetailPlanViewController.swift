import UIKit

class DetailPlanViewController : UIViewController {
    
    //MARK: - property
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    let contentView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var monthLabel : UILabel = {
        let label = UILabel()
        label.text = "1월"
        label.font = UIFont(name: "Pretendard-Regular", size: 25)
        return label
    }()
    
    
    private let dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 11
        layout.minimumLineSpacing = 15
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.canCancelContentTouches = true
        collectionView.delaysContentTouches = false
        collectionView.alwaysBounceHorizontal = true
        return collectionView
    }()
    
    let seperateDayListView : SeperateDayListView = {
        let view = SeperateDayListView()
        view.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    let seperateLabel : UILabel = {
        let label = UILabel()
        label.text = "요일 나누기"
        label.font = UIFont(name: "Pretendard-Regular", size: 20)
        return label
    }()
    
    
    
    let seperateTaskView : SeperateTaskView = {
        let view = SeperateTaskView()
        view.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    
    // 더미 데이터
    private let dates: [(date: String, day: String)] = [
        ("4", "수"), ("5", "목"), ("6", "금"), ("7", "토"), ("8", "일"), ("9", "월"), ("10", "화"), ("11", "수"), ("12", "목")
    ]
    
    
    let seperateListData : [String] = []
    
    //MARK: - main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2128768861, green: 0.2128768861, blue: 0.2128768861, alpha: 1)
        configureNavigationBar()
        configureCollectionView()
        setUI()
        
        scrollView.delegate = self
        scrollView.delaysContentTouches = false
        dateCollectionView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.direct.rawValue)]
    }
    
    //MARK: - functions
    func configureNavigationBar(){
        navigationItem.title = "새로운 일 분류"
        
        let customButton = UIButton(type: .system)
        customButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        customButton.setTitle(" 생성", for: .normal)
        customButton.tintColor = #colorLiteral(red: 1, green: 0.3735775948, blue: 0.3423727155, alpha: 1)
        customButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: customButton)
        navigationItem.leftBarButtonItem = backButton
        
        
        let doneButton = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        doneButton.tintColor = #colorLiteral(red: 0.6817840338, green: 0.6817839742, blue: 0.6817840338, alpha: 1)
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureCollectionView(){
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        dateCollectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.identifier)
        dateCollectionView.canCancelContentTouches = true
        dateCollectionView.delaysContentTouches = false
        dateCollectionView.panGestureRecognizer.delaysTouchesBegan = false
        dateCollectionView.panGestureRecognizer.delaysTouchesEnded = false
        
        
        // 셀 선택시 로직
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let indexPath = IndexPath(item: 0, section: 0)
            self.dateCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            self.collectionView(self.dateCollectionView, didSelectItemAt: indexPath)
        }
    }
    
    
    
    
    func setUI(){
        
        [scrollView,contentView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [monthLabel,dateCollectionView, seperateDayListView,seperateLabel,seperateTaskView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        seperateTaskView.viewHeightConstraint = seperateTaskView.heightAnchor.constraint(equalToConstant: 280)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1000),
            
            monthLabel.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 22),
            monthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  24),
            monthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -333),
            
            dateCollectionView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 10),
            dateCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  22),
            dateCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor ),
            dateCollectionView.heightAnchor.constraint(equalToConstant: 80),
            
            seperateLabel.topAnchor.constraint(equalTo: dateCollectionView.bottomAnchor, constant: 19),
            seperateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26),
            
            seperateDayListView.topAnchor.constraint(equalTo: seperateLabel.bottomAnchor, constant: 5),
            seperateDayListView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 24 ),
            seperateDayListView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -24),
            seperateDayListView.heightAnchor.constraint(equalToConstant: 242), // 나중에 바꾸기
            
            
            seperateTaskView.topAnchor.constraint(equalTo: seperateDayListView.bottomAnchor , constant: 22),
            seperateTaskView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 24 ),
            seperateTaskView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -24),
//            seperateTaskView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -33),
            seperateTaskView.viewHeightConstraint!
        ])
    }
    
    
    @objc func backButtonTapped(){
        print("뒤로가기")
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func doneButtonTapped(){
        print("완료")
        
    }
}


//MARK: - CollectionView extension
extension  DetailPlanViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as? DateCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let date = dates[indexPath.item]
        cell.dateLabel.text = date.date
        cell.dayLabel.text = date.day
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 여기에 날짜 선택 시 contentView의 내용을 변경하는 로직 추가
        let selectedDate = dates[indexPath.item]
        
        print("\(selectedDate.date)일 \(selectedDate.day)요일 선택됨")
    }
    
}


extension DetailPlanViewController:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    // 줄 간격을 0으로 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    // 아이템 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension DetailPlanViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            // 수평 스크롤 방지
            if scrollView.contentOffset.x != 0 {
                scrollView.contentOffset.x = 0
            }
        }
    }
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return scrollView == self.scrollView
    }
}
