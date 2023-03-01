# 🌱 새싹 스터디

<img width="831" alt="스크린샷 2022-12-22 오후 7 29 05" src="https://user-images.githubusercontent.com/83345066/209114716-558cf067-c331-41e5-81dc-f09cf4ddda1b.png">

<img width="837" alt="스크린샷 2022-12-22 오후 7 28 18" src="https://user-images.githubusercontent.com/83345066/209114838-f58cb07a-21aa-4d57-8a88-eac0b0d28087.png">

## 💁🏻‍♂️ Introduction
- 개인 프로젝트(기획, 디자인, API 제공)
- 프로젝트 기간 한달 (2022.11.07 ~ 2022.12.07)
- 현재 위치를 기반으로 주변에 스터디를 원하는 새싹인들을 지도를 통해 찾아볼 수 있으며 원하는 새싹인과 스터디 매칭 후 채팅을 이어주는 앱
- 스터디를 원하는 주변에 스터디를 원하는 사용자들을 지도에 표시해줍니다
- 스터디를 등록하고 주변 사용자와 매칭을 할 수 있습니다
- 매칭된 사용자와 실시간 채팅이 가능합니다
- 인앱 결제를 통해 캐릭터와 배경화면을 구매하고 적용할 수 있습니다

<br><br/>
## ⚙️ Stack
> 기술 및 라이브러리
> 
- UIKit, SnapKit, StoreKit, MapKit, CoreLocation, Toast
- Tabman, MultiSlider, Compositional Layout, DiffableDataSource
- Alamofire, Codable, SocketIO, Network, FirebaseAuth, FCM
- Realm
- MVC, MVVM, Singleton Pattern, in-output Pattern
- SPM
- RxSwift, RxCocoa, RxDataSources, RxGesture, RxKeyboard

<br><br/>
> 프로젝트 기술 적용
> 
- **Design Pattern**
    - **MVVM**, **input-output** 패턴을 이용한 비즈니스 로직 분리
    - **Singleton** 패턴으로 하나의 객체만을 생성해 메모리 낭비 방지
- **Reactive Programming**
    - **RxSwift**, **RxCocoa**를 이용해 데이터 스트림을 비동기적인 흐름으로 처리
- **Authentication View**
    - **Firebase Authentication** 문자 인증을 통한 로그인
    - **Restful API**를 통한 회원 가입 구현
- **Main View**
    - **CoreLocation, MapKit**으로 주변 위치 탐색 및 주변 사용자들 Annotation으로 식별
- **Study Registration View**
    - **Compositional Layout**을 사용해 복잡한 레이아웃 대응
    - **DiffableDataSource**를 이용해 자연스러운 UI 업데이트
- **Study Matching View**, **Profile** **View**
    - UITableView의 **automaticDimension**을 사용해 cell의 동적인 높이 조절
- **Chatting View**
    - **Socket** 통신을 기반으로 한 채팅 기능
    - **Realm Database**에 채팅 내역을 저장해 서버에 과도한 요청 방지
    - **FCM** background 상태에서 채팅 알림 구현
- **Store View**
    - **StoreKit**을 이용한 상품 인앱 결제
    - 상품 결제 시 **transaction** 상태에 따른 이벤트 처리
    - 구매 승인 시 구매 목록 갱신을 위해 영수증 검증 후 Encoding하여 서버 통신
- **Network** Framework를 이용한 네트워크 연결 상태 체크 및 대응


<br><br/>
## 📝 개발 공수
- 개발 기간: 2022.11.07 ~ 2022.12.07 (약 4주)
- [개인일지](https://www.notion.so/09865db883654d33ba1c7a996d54f48a)

|                       진행 사항 |                       진행 기간 |                       세부 내역 |
| --- | --- | --- |
| 온보딩, 로그인, 회원가입 구현 | 2022.11.07 ~ 2022.11.11 |  |
| 내 정보 탭 구현 | 2022.11.12 ~ 2022.11.16 | 내 정보 수정(상대방 연령대, 내 성별, 내 번호 검색 허용) , 회원탈퇴 |
| 지도, 스터디 등록 화면 구현 | 2022.11.17 ~ 2022.11.19 | 지도 (성별에 따른 annotation, 주변에 스터디를 원하는 새싹인들 custom Annotation, 현재 위치 버튼, 매칭 상태에 따른 플러팅 버튼), 스터디 등록(주변 새싹인들이 원하는 스터디 등록 cell, searchBar를 이용한 내가 원하는 스터디 등록) |
| 스터디 요청 수락 화면 구현 | 2022.11.21 ~ 2022.11.23 | tabman을 이용한 상단 tab 구성으로 스터디 요청과 수락 화면 분리, 주변 새싹인들 스터디 요청과 수락 기능, 스터디 찾기 중단, 새로고침, 주변 스터디 없을 시 스터디 변경하기, 새로고침 기능 |
| 채팅 화면 구현 | 2022.11.24 ~ 2022.11.30 | 상대방과 실시간 통신 기능, 신고, 리뷰, 스터디 취소 기능 |
| 앱 성능 개선 (Repactoring) | 2022.12.01 ~ 2022.12.02 | endpoint 분리, 폴더링 세분화, 필요없는 singleton pattern 제거, Router 파일 분리, 자주 호출되는 프로퍼티 타입 프로퍼티로 변경, 반복되는 코드 하나로 묶어서 사용 |
| 인 앱 결제 화면 구현 | 2022.12.03 ~ 2022.12.04 | 아이콘과 배경화면 구입 기능, 내 아이콘과 배경화면 변경 기능 |

<br><br/>
## ⚒ Trouble Shooting

> **인증 문자 재전송 버튼 누를 시 타이머가 중복되어 무작위로 시간초가 보이는 문제**
>

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

<br><br/>
>  binding 해준 버튼의 tap 이벤트가 누를 때마다 중첩되는 현상
>

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

<br><br/>
> cell의 동적인 높이를 구현중 cell을 접었을 때 화면 밖으로 내부 객체들이 튀어나오는 이슈
>

<img width="387" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-15_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9 50 24" src="https://user-images.githubusercontent.com/83345066/208295029-0fa376f3-a790-4e07-8925-867cef97def0.png">

특정 cell을 접고 필 수 있는 기능을 구현하기 위해 tableView의 **automaticDimension**을 사용하여 cell의 높이를 동적으로 구현하는 과정에서 cell을 접었을 때 내부 객체들이 밖으로 빠져나오는 문제가 발생

해당 문제는 Stack View에 정적으로 높이를 지정해주면서 **automaticDimension**의 기능이 적용이 되지않아 생긴 layout 에러인데 **automaticDimension**은 cell의 높이값을 설정할 때 cell의 내부 객체의 높이를 정적으로 구현하면 layout이 깨지는 오류가 발생하기 때문에 Stack View의 특성대로 특정 높이를 주지않고 내부 객체들의 높이를 통해 동적으로 높이를 구현함으로써 해당 이슈를 해결

<br><br/>
> 다른 section의 cell에 같은 값이 중복되어 들어가지 않는 문제
>

<img width="361" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-12-18_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_8 13 28" src="https://user-images.githubusercontent.com/83345066/208295201-10ec38c2-2f2b-4111-925e-17fa73d05b11.png">

setion과 item의 identifier가 **unique**해야하는 **DiffableDataSource**의 특징으로 다른 section에 중복된 cell이 들어가지 못하는 이슈

값이 중복되어 들어갈 수 있게끔 **itemIdentifier**의 Type에 들어갈 item 모델을 만들어 **UUID**를 활용해 고유한 id를 만들어줌으로써 중복된 값이 들어갈 수 있도록 처리

DiffableDataSource를 처음 사용해보면서 여러 기능을 사용해보며 새로운 기술을 공부할 수 있었을 뿐만 아니라 DiffableDataSource가 내부적으로 어떻게 구성이 되어 있고 어떤 프로토콜을 준수하는지를 이번 이슈로 인해 많이 배움


<br><br/>
## 🔥 프로젝트 회고
이번 프로젝트는 협업 프로젝트를 진행하게 되었다.
처음으로 디자인, 기획, 백앤드 파트와 진행하는 협업 프로젝트이다보니 여러 상황에 대처하는 것을 배울 수 있었는데
예를 들어 중간에 version 값이나 path 값이 바뀌는 경우를 겪으면서 url을 세분화해서 구성해놔야 변경사항에 효율적으로 대처할 수 있음을 배울 수 있었다.
또한 저번 앱스토어 출시 프로젝트에서 중복 코드, 폴더링, MVVM 패턴 적용, 반응형 프로그래밍, 문자열 처리 등 제대로 대응하지 못해 아쉬웠던 부분들을 이번 프로젝트에 녹여보면서 개발 역량이 늘어날 수 있는 계기가 되었다.

많은 부분을 배울 수 있었던 것만큼 아쉬웠던 부분들이 몇가지 있었다.

1. Codable 커스텀 디코딩
    
    서버 응답 값을 받기 위해 Codable 프로토콜을 채택 받는 모델을 생성했는데
    중간에 서버에서 응답 값의 이름이 변경이 될 수 있다는 것을 생각하지 못하고 예외처리를 해주지 않았다.
    디코딩을 커스텀 할 때 decodeIfPresent를 사용하여 받아오는 응답 값에 대한 예외처리를 해서 보완해야겠다.
    
2. 메모리 관리
    
    자주 사용하는 코드를 따로 함수로 묶은 부분에서 인스턴스를 생성하는데 함수 호출할 때마다 계속 인스턴스를 생성하여 
    메모리 낭비를 하는 것을 볼 수 있었다.
    앱의 성능을 위해 이런 메모리 낭비를 조금이라도 줄여야하기에 앞으로 항상 세심하게 체크해야겠다.
    이 부분은 타입 프로퍼티를 사용해서 한 번만 초기화 할 수 있도록 보완을 해야겠다.
    
3. 기능에 대해 여러 예외처리
    
    이번 프로젝트를 진행하면서 기능을 만들 때 여러 상황에 대한 예외처리를 통해 사용자의 불편함을 최소화 시키려고 했다.
    다른 앱의 비슷한 기능과 비교하고 여러 가능성을 생각해보며 예외처리를 진행했지만 백그라운드 쪽 예외처리가 부족한 부분이 있다고 생각이 든다.
    이 부분이 이번 프로젝트에서 가장 아쉬운 점이며 앞으로 많은 프로젝트를 진행할텐데 백그라운드 예외처리에 대한 부분을 좀 더 고려해서 사용자들의 불편을 최소화하도록 노력해야겠다.
