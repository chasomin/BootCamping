<img src="https://github.com/chasomin/BootCamping/assets/114223423/1a51d1af-87d3-41df-a0f4-12f96c17673d" width=100, height=100>


# 부트캠핑

캠핑 사진과 캠핑장 정보 공유를 통해 더 나은 캠핑 문화를 만들어나가는, 캠퍼들을 위한 커뮤니티 앱

### 6인 팀 프로젝트



### **기간**

23.01.16 ~ 23.02.17 (1개월)


### **최소버전**

iOS 16.0

### 앱스토어 링크
[앱스토어](https://apps.apple.com/kr/app/%EB%B6%80%ED%8A%B8%EC%BA%A0%ED%95%91/id1672213235)
<br>

### Team Repository
[부트캠핑](https://github.com/APP-iOS1/finalproject-bootcamping.git)

<br>

### **스크린샷**

|<img src="https://user-images.githubusercontent.com/114223237/222382498-420efc96-fb3b-4eeb-ade8-39ccc306bb40.gif"></img>|<img src="https://user-images.githubusercontent.com/114223237/222381783-de2153bc-5b53-49b7-af76-5c2af1d321b0.gif"></img>|<img src="https://user-images.githubusercontent.com/114223237/222381623-6ee28409-21ee-4427-9c60-e1ce0e7f68dc.gif"></img>|<img src="https://user-images.githubusercontent.com/114223237/222385759-ef3a9738-31e6-4f6c-8f2c-c1cd86fe218c.gif"></img>|
|:-:|:-:|:-:|:-:|
|`스플래시뷰`|`온보딩뷰`|`로그인 및 회원가입`|`다크모드`|
|<img src="https://user-images.githubusercontent.com/114223237/222385743-e6acddcf-0ae0-4a09-a5dc-2658766bfd6c.gif"></img>|<img src="https://user-images.githubusercontent.com/114223237/222382137-6c9223de-2505-4486-a209-dfa6217d2fe6.gif"></img>|<img src="https://user-images.githubusercontent.com/114223237/222382016-757b9274-8556-4f96-88ca-d797fe76bfed.gif"></img>|<img src="https://user-images.githubusercontent.com/114223237/222381916-de59591f-1f5e-4666-b5cd-2736d8c945f5.gif"></img>|
|`인기 캠핑 포토카드`|`실시간 캠핑 피드`|`캠핑장 검색`|`캠핑장 정보`|
|<img src="https://user-images.githubusercontent.com/114223237/222383116-b7fb7fdc-cf86-438e-8119-03da92cea9e8.gif"></img>|<img src="https://user-images.githubusercontent.com/114223237/222383091-b3863957-1ddf-4579-8306-fd403ab82fb5.gif"></img>|<img src="https://user-images.githubusercontent.com/114223237/222383712-cf3d4f1a-5247-4d35-b4d3-6cd8e343ed19.gif"></img>|<img src="https://user-images.githubusercontent.com/114223237/222383656-e70ba78f-bb1e-4a04-988c-34f05be1b7f2.gif"></img>|
|`내 캠핑일기`|`캠핑일기 작성`|`마이페이지`|`북마크`|
<br>

## 기능 소개

- 인기순 게시글 10개를 포토카드로 구성
- 유저들이 업로드한 게시글을 실시간 공유
- 한국관광공사 고캠핑 API를 활용하여 캠핑장 검색, 캠핑장 데이터를 지역∙전망 별로 분류
- 캠핑장 정보와 위치 Map을 제공
- 캠핑장 북마크 기능
- 캠핑장 경험을 사진과 글로 작성, 공개 / 비공개 설정 가능
- 마이페이지 내 캠핑 일정 관리, 북마크 해 둔 관심 캠핑장만 분류
- 소셜 로그인 (애플, 카카오, 구글)


## **기술**

`SwiftUI` `MVVM` `Combine` `URLSession` `MapKit` `LocalNotification` `LocalAuthentication` `Decodable` `Hashable` `SDWebImage` `Lottie` `Firebase - Analytics, Cloud Firestore, Authentication, Storage` `KakaoSDK`


## **기술 설명**
 
 **Combine**을 사용한 비동기 처리

 enum을 활용한 Error case 분리로 사용자에게 상황에 맞는 Error 메시지 전달

 **Identifiable** 채택으로 List, ForEach에서 데이터 항목을 고유하게 식별하여 성능 최적화

 **Local Authentication**을 활용한 사용자 인증

 **@EnvironmentObject**를 사용한 전역적인 데이터 공유

 **@FocusState**를 사용하여 TextField 간 이동 / 키보드 Dismiss 구현

 **@AppStorage**를 사용한 간단한 데이터 저장하고 UI 자동 업데이트

 간단한 UI 관련된 데이터를 **@AppStorage**로 저장하여 자동으로 UI 업데이트

 **CustomModifier**를 사용하여 코드 재사용성과 가독성 향상

 **Firebase Analytics**를 통해 사용자 참여 통계 분석




