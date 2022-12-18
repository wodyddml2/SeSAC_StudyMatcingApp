# 새싹 스터디

<img width="690" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-15_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_6 13 00" src="https://user-images.githubusercontent.com/83345066/208295022-1f3d7607-17e5-4e90-9e67-8500d136e3ac.png">

> **Introduction**
> 
- 개인 프로젝트(기획, 디자인, API 제공)
- 프로젝트 기간 한달 (2022.11.07 ~ 2022.12.07)
- 현재 위치를 기반으로 주변에 스터디를 원하는 새싹인들을 지도를 통해 찾아볼 수 있으며 원하는 새싹인과 스터디 매칭 후 채팅을 이어주는 앱

> **프로젝트 기능**
> 
- **FirebaseAuth**를 사용하여 문자 인증을 통한 로그인 기능
- **MapKit**, **CoreLocation**을 토대로 지도의 가운데 위치를 기준으로 스터디를 원하는 주변 새싹인들을 찾을 수 있는 기능
- 원하는 스터디 목록 등록
- **StoreKit**을 이용한 새싹과 배경화면을 구입할 수 있는 인앱 결제 기능
- **RESTful API**로 서버와 통신하여 
회원가입 / 내 정보 / 스터디 등록 / 주변 새싹인과 스터디 매칭 or 취소
스터디 찾기 중단/ 리뷰 작성 /매칭 상태 확인 / 채팅 기능
- **Socket** 통신과 **Realm**을 기반으로 한 채팅 기능
- **Network** framework를 통해 네트워크 연결 상태 체크

> **개발 공수 및 사용 기술**
> 
- 개발 기간: 2022.11.07 ~ 2022.12.07 (약 4주)
- [개인일지](https://www.notion.so/09865db883654d33ba1c7a996d54f48a)

|                       진행 사항 |                       진행 기간 |                       세부 내역 |
| --- | --- | --- |
| 온보딩, 로그인, 회원가입 구현 | 2022.11.07 ~ 2022.11.11 |  |
| 내 정보 탭 구현 | 2022.11.12 ~ 2022.11.16 | 내 정보 수정(상대방 연령대, 내 성별, 내 번호 검색 허용) , 회원탈퇴 |
| 지도, 스터디 등록 화면 구현 | 2022.11.17 ~ 2022.11.19 | 지도
(성별에 따른 annotation, 주변에 스터디를 원하는 새싹인들 custom Annotation, 현재 위치 버튼, 매칭 상태에 따른 플러팅 버튼)
스터디 등록
(주변 새싹인들이 원하는 스터디 등록 cell, searchBar를 이용한 내가 원하는 스터디 등록) |
| 스터디 요청 수락 화면 구현 | 2022.11.21 ~ 2022.11.23 | tabman을 이용한 상단 tab 구성으로 스터디 요청과 수락 화면 분리,
주변 새싹인들 스터디 요청과 수락 기능,
스터디 찾기 중단, 새로고침
주변 스터디 없을 시 스터디 변경하기, 새로고침 기능 |
| 채팅 화면 구현 | 2022.11.24 ~ 2022.11.30 | 상대방과 실시간 통신 기능,
신고, 리뷰, 스터디 취소 기능 |
| 앱 성능 개선 (Repactoring) | 2022.12.01 ~ 2022.12.02 | 1. endpoint 분리
2. 폴더링 세분화
3. 필요없는 singleton pattern 제거
4. Router 파일 분리
5. 자주 호출되는 프로퍼티 타입 프로퍼티로 변경
6. 반복되는 코드 하나로 묶어서 사용 |
| 인 앱 결제 화면 구현 | 2022.12.03 ~ 2022.12.04 | 아이콘과 배경화면 구입 기능,
내 아이콘과 배경화면 변경 기능 |

**Stack**

> **Trouble Shooting**
> 

<aside>
💡 인증 문자 재전송 버튼 누를 시 타이머가 중복되어 무작위로 시간초가 보이는 문제

</aside>

```swift
var timerDisposable: Disposable?

timerDisposable?.dispose()
timerDisposable = Observable<Int>
						.timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
						.withUnretained(self)
            .subscribe(onNext: { vc, value in
                if value <= 50 {
                    vc.mainView.timerLabel.text = value == 0 ? "01:00" : "00:\(60 - value)"
                } else if value <= 60 {
                    vc.mainView.timerLabel.text = "00:0\(60 - value)"
                } else {
                    vc.timerDisposable?.dispose()
                }
            }, onDisposed: {
                UserManager.authVerificationID = ""
            })
```

인증문자 재전송 버튼을 눌렀을 때 타이머 시간을 초기화 시켜 새롭게 이벤트를 발생시켜야하는데 이전 타이머 이벤트와 중첩되면서 시간초가 겹쳐져서 나오는 이슈가 발생

해당 이슈는 **Disposable을 dispose** 해주기 위해 Disposable 타입의 임의의 변수를 생성시켜 재전송 버튼을 누르는 시점에서 dispose를 해주면서 해결

이번 문제를 해결하면서 구독하고 해지시키는 시점에 따라 이벤트 발생을 조절 시킬 수 있는 disposable과 dispose에 대해 배우면서 Rx의 로직 흐름을 더욱 이해할 수 있는 과정이 됨

<aside>
💡 binding 해준 버튼의 tap 이벤트가 누를 때마다 중첩되는 현상

</aside>

```swift
// VC File
RxTableViewSectionedReloadDataSource<ShopSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
   guard let cell = tableView.dequeueReusableCell(withIdentifier: BgShopTableViewCell.reusableIdentifier, for: indexPath) as? BgShopTableViewCell else {return UITableViewCell()}
   ...
   cell.sesacPriceButton.rx.tap
       .withUnretained(self)
       .bind { vc, _ in
          ...
        .disposed(by: cell.disposeBag)
   return cell
})

// UICollectionViewCell File
override func prepareForReuse() {
     disposeBag = DisposeBag()
}
```

dequeReusableCell을 사용하는 코드에서 버튼을 binding해서 이벤트 처리를 하였는데 이벤트를 실행할 때마다 이벤트가 중첩이 되는 문제가 발생

원인은 해당 이벤트가 dispose 되지 않고 메모리에 그대로 남아있어 cell이 재사용되면서 dispose 되지 않은 이벤트들이 여러번 발생하는 문제였음

cell을 재사용하기 전 시점인 **prepareForReuse**에서 **disposeBag**을 새롭게 할당시켜주면서 기존에 담겨있던 **disposable을 dispose** 시켜줌으로써 해당 이슈를 해결

Rx를 사용하면서 당연하게 DisposeBag을 사용해왔는데 해당 이슈로 인해 DisposeBag에 대해 더욱 제대로 알아볼 수 있는 계기가 되었고 cell의 생명주기의 시점을 다시 공부할 수 있는 계기가 됨

또한 cell을 재사용하는 시점에서 binding된 이벤트들이 불필요하게 사용되는 부분을 더욱 고려하여 코드를 작성할 수 있는 좋은 계기가 됨

<aside>
💡 cell의 동적인 높이를 구현중 cell을 접었을 때 화면 밖으로 내부 객체들이 튀어나오는 이슈

</aside>

<img width="387" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-15_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9 50 24" src="https://user-images.githubusercontent.com/83345066/208295029-0fa376f3-a790-4e07-8925-867cef97def0.png">

특정 cell을 접고 필 수 있는 기능을 구현하기 위해 tableView의 **automaticDimension**을 사용하여 cell의 높이를 동적으로 구현하는 과정에서 cell을 접었을 때 내부 객체들이 밖으로 빠져나오는 문제가 발생

해당 문제는 Stack View에 정적으로 높이를 지정해주면서 **automaticDimension**의 기능이 적용이 되지않아 생긴 layout 에러인데 **automaticDimension**은 cell의 높이값을 설정할 때 cell의 내부 객체의 높이를 정적으로 구현하면 layout이 깨지는 오류가 발생하기 때문에 Stack View의 특성대로 특정 높이를 주지않고 내부 객체들의 높이를 통해 동적으로 높이를 구현함으로써 해당 이슈를 해결

<aside>
💡 다른 section의 cell에 같은 값이 중복되어 들어가지 않는 문제

</aside>

![KakaoTalk_Photo_2022-12-16-23-54-23](https://user-images.githubusercontent.com/83345066/208295034-653d0637-f17a-412d-8299-19f6df8152d2.jpeg)

스터디를 등록하는 기능을 만드는 과정에서 위의 이미지처럼 **‘지금 주변에는’** section의 cell을 클릭 시 **‘내가 하고 싶은’** section에 값이 들어가야하는데 **DiffableDataSource**의 특징으로 setion과 item의 identifier는 **unique**해야하기 때문에 cell을 클릭하면 **‘내가 하고 싶은’**의 section에 값이 들어가지만 **‘지금 주변에는’** section의 cell이 사라지는 문제가 발생

값이 중복되어 들어갈 수 있게끔 **itemIdentifier**의 Type에 들어갈 item 모델을 만들어 **UUID**를 활용해 고유한 id를 만들어줌으로써 중복된 값이 들어갈 수 있도록 처리

DiffableDataSource를 처음 사용해보면서 여러 기능을 사용해보며 새로운 기술을 공부할 수 있었을 뿐만 아니라 DiffableDataSource가 내부적으로 어떻게 구성이 되어 있고 어떤 프로토콜을 준수하는지를 이번 이슈로 인해 많이 배움

