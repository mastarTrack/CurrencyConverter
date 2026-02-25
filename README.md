# CurrencyConverter

**실시간 데이터를 외부 API를 통해 받아오고**

그 데이터를 UI에 표시하고, 사용자의 입력을 바탕으로 **새로운 결과를 계산하여 보여주는 앱**을 만들어봅니다.

**환율 계산기 앱**

> 실시간 환율 정보를 Open API로 받아오고, 금액을 변환하거나, 관심 있는 통화를 즐겨찾기에 추가해 상단 고정해보세요!
> 
> 
> 환율 정보는 항상 변하고, 다양한 국가의 통화가 존재하기 때문에,
> 
> 이번 과제를 통해 다음과 같은 내용을 복습하고 실습할 수 있습니다:
> 
> •    **SnapKit을 활용한 UI 구성 및 AutoLayout 디버깅 경험**
> 
> •    **URLSession을 활용한 Open API 통신**
> 
> •    **UITableView를 통한 리스트 UI 구성**
> 
> •    **MVVM 패턴을 활용한 로직 분리**
> 
> •    **CoreData를 활용한 간단한 데이터 저장 및 즐겨찾기 기능**
>

----------

# 1. 프로젝트 소개
## 1) 기술 스택
- **Language** : Swift
- **UI Framework** : UIKit
- **Architecture** : MVVM
- **Library** : SnapKit, Alamofire
- **Local Storage** : CoreData

## 2) 프로젝트 구조
```swift
currencyConverter
├── Model
│   ├── CoreData
│   ├── Network
│   │   ├── CurrencyResponse.swift
│   │   └── DataService.swift
│   │
│   ├── CoreDataManager.swift
│   └── Rate.swift
│
├── Service
│
├── Test
│
├── View
│   ├── CalculationView
│   │   ├── CalculationView.swift
│   │   └── CalculationViewController.swift
│   │
│   ├── MainView
│   │   ├── ListViewCell.swift
│   │   ├── MainView.swift
│   │   └── ViewController.swift
│
├── ViewModel
│   ├── CalculationViewModel.swift
│   ├── MainViewModel.swift
│   └── ViewModelProtocol.swift
│
├── AppDelegate.swift
└── SceneDelegate.swift
```

과제 요구사항에 맞추어 MVVM 패턴을 적용하였습니다.

- **Model**
    : Network 응답 모델 및 CoreData Entity 모델
    : 환율 데이터 관련 모델
- **View**
    : UI 구성
    : ViewModel과의 바인딩 - ViewController 객체에서 담당
- **ViewModel**
    : 비즈니스 로직 처리
    : Model 데이터 가공 및 View로의 전달

- **Service** : MVVM에 해당하지 않는 서비스 객체
- **Test** : 테스트를 위한 목업 객체


# 2. 메모리 이슈 디버깅
## 1) Memory Graph Debugger 사용하기
<img width="2672" height="1522" alt="image" src="https://github.com/user-attachments/assets/03a35b80-b3ec-4d7a-bcfd-fdb734b6940d" />

메모리 그래프에서는 별다른 느낌표가 발생하지 않았습니다.

<img width="2560" height="1440" alt="image" src="https://github.com/user-attachments/assets/7eac5d23-b209-4ad7-a47b-cb9175bcfb30" />

메모리 사용량 확인 시에도 메모리 사용량이 크게 튄 부분이 없는 것으로 보입니다.

## 2) Leaks Instrument 사용하기

Leaks Instrument를 활용해보아도 감지되는 누수가 없는 것으로 확인하였습니다.

<img width="3164" height="1878" alt="image" src="https://github.com/user-attachments/assets/b3fc0eb0-ef53-4593-936c-d319590da2af" />

![f](https://github.com/user-attachments/assets/0333a375-2e07-491b-9c08-2b24529e16c4)


# 3. 회고

예상보다 구현에 더 많은 시간이 걸린 과제였습니다.

아래와 같은 이유들로 시간이 지체되지 않았을까 생각해보았습니다.
1) UICollectionView와 Diffable DataSource 사용의 미숙함
2) 아키텍처 패턴 적용을 위한 유저 입력에 대한 동작 분리(데이터 처리 및 UI 변경)의 어려움
2-2) 아키텍처 변경 과정에서의 동작 분리
3) CoreData 적용 및 활용

대다수가 활용에 대한 미숙함이긴 한데, 그런 부분에 대해서 혼자 해결하려고 애썼던 시간이 조금 길지 않았나 생각됩니다.

튜터님을 좀더 찾아가볼걸 그랬습니다.

### 목표 달성 체크리스트

> **SnapKit을 활용한 UI 구성 및 AutoLayout 디버깅 경험**: 🟢
> 
> **URLSession을 활용한 Open API 통신**: 🟢 (Alamofire 활용)
> 
> **UITableView를 통한 리스트 UI 구성**: 🟡 (UICollectionView로 대체)
> 
> **MVVM 패턴을 활용한 로직 분리**: 🟢
> 
> **CoreData를 활용한 간단한 데이터 저장 및 즐겨찾기 기능**: 🟢
