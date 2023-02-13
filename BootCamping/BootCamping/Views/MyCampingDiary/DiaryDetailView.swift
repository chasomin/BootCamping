//
//  DiaryCellView.swift
//  BootCamping
//
//  Created by 박성민 on 2023/01/18.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct DiaryDetailView: View {
    @EnvironmentObject var bookmarkStore: BookmarkStore
    @EnvironmentObject var wholeAuthStore: WholeAuthStore
    @EnvironmentObject var diaryStore: DiaryStore
    @EnvironmentObject var blockedUserStore: BlockedUserStore
    
    @StateObject var campingSpotStore: CampingSpotStore = CampingSpotStore()
    @StateObject var diaryLikeStore: DiaryLikeStore = DiaryLikeStore()
    @StateObject var commentStore: CommentStore = CommentStore()
    
    var diaryCampingSpot: [Item] {
        get {
            return campingSpotStore.campingSpotList.filter{
                $0.contentId == item.diary.diaryAddress
            }
        }
    }
    
    @State private var diaryComment: String = ""
    
    //삭제 알림
    @State private var isShowingDeleteAlert = false
    //유저 신고/ 차단 알림
    @State private var isShowingUserReportAlert = false
    @State private var isShowingUserBlockedAlert = false
    @State private var isBlocked = false
    
    //자동 스크롤
    @Namespace var topID
    @Namespace var bottomID
    
    //키보드 dismiss
    @FocusState private var inputFocused: Bool
    
    var item: UserInfoDiary
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading) {
                        diaryUserProfile.id(topID)
                        diaryDetailImage.zIndex(1) 
                        Group {
                            HStack(alignment: .center){
                                if item.diary.uid == wholeAuthStore.currnetUserInfo!.id {
                                    isPrivateImage
                                }
                                diaryDetailTitle
                            }
                            diaryDetailContent
                            if !campingSpotStore.campingSpotList.isEmpty {
                                diaryCampingLink
                            }
                            diaryDetailInfo
                            Divider()
                            //댓글
                            ForEach(commentStore.commentList) { comment in
                                DiaryCommentCellView(item2: item, item: comment)
                            }
                            //댓글 작성시 뷰 가장 아래로
                            EmptyView().id(bottomID)
                        }
                        .padding(.horizontal, UIScreen.screenWidth * 0.03)
                    }
                    .onAppear {
                        proxy.scrollTo(topID)
                    }
                }
                HStack {
                    if wholeAuthStore.currnetUserInfo?.profileImageURL != "" {
                        WebImage(url: URL(string: wholeAuthStore.currnetUserInfo!.profileImageURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        
                    } else {
                        Image("defaultProfileImage")
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }
                    TextField("댓글을 적어주세요", text: $diaryComment, axis: .vertical)
                        .focused($inputFocused)

                    Button {
                        commentStore.createCommentCombine(diaryId: item.diary.id, comment: Comment(id: UUID().uuidString, diaryId: item.diary.id, uid: wholeAuthStore.currnetUserInfo?.id ?? "" , nickName: wholeAuthStore.currnetUserInfo?.nickName ?? "", profileImage: wholeAuthStore.currnetUserInfo?.profileImageURL ?? "", commentContent: diaryComment, commentCreatedDate: Timestamp()))
                        commentStore.readCommentsCombine(diaryId: item.diary.id)
                        withAnimation {
                            proxy.scrollTo(bottomID)
                        }
                        
                        diaryComment = ""
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.title2)
                    }
                    .disabled(diaryComment == "")
                    
                }
                .foregroundColor(.bcBlack)
                .font(.title3)
                .padding(.vertical, 5)
                .padding(.horizontal, UIScreen.screenWidth * 0.03)
                
            }
            .padding(.top)
            .padding(.bottom)
            .navigationTitle("BOOTCAMPING")
            .onAppear{
                commentStore.readCommentsCombine(diaryId: item.diary.id)
                campingSpotStore.readCampingSpotListCombine(readDocument: ReadDocuments(campingSpotContenId: [item.diary.diaryAddress]))
                diaryLikeStore.readDiaryLikeCombine(diaryId: item.diary.id)
            }
        }
        .onTapGesture {
            submit()
        }
    }
}

private extension DiaryDetailView {
    
    //MARK: - 댓글 삭제 기능
    func delete(at offsets: IndexSet) {
        commentStore.commentList.remove(atOffsets: offsets)
    }
    
    //MARK: - 다이어리 작성자 프로필
    var diaryUserProfile: some View {
        HStack {
            if item.user.profileImageURL != "" {
                WebImage(url: URL(string: item.user.profileImageURL))
                    .resizable()
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            } else {
                Image("defaultProfileImage")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            
            //유저 닉네임
//            Text(item.diary.diaryUserNickName)
            // 이게 맞나
            Text(item.user.nickName)
                .font(.callout)
            Spacer()
            
            //MARK: -...버튼 글 쓴 유저일때만 ...나타나도록
            if item.diary.uid == Auth.auth().currentUser?.uid {
                alertMenu
//                    .padding(.horizontal, UIScreen.screenWidth * 0.03)
                    .padding(.top, 5)
            }
            else {
                reportAlertMenu
//                    .padding(.horizontal, UIScreen.screenWidth * 0.03)
                    .padding(.top, 5)
            }
            
        }
        .padding(.horizontal, UIScreen.screenWidth * 0.03)
    }
    
    // MARK: - 다이어리 공개 여부를 나타내는 이미지
    private var isPrivateImage: some View {
        Image(systemName: "lock")
            .foregroundColor(Color.secondary)
    }
    
    //MARK: - Alert Menu 버튼
    var alertMenu: some View {
        //MARK: - ... 버튼입니다.
        Menu {
            
            
            
            NavigationLink {
                DiaryEditView(diaryTitle: item.diary.diaryTitle, diaryIsPrivate: item.diary.diaryIsPrivate, diaryContent: item.diary.diaryContent, campingSpotItem: diaryCampingSpot.first ?? campingSpotStore.campingSpot, campingSpot: diaryCampingSpot.first?.facltNm ?? "", item: item, selectedDate: item.diary.diaryVisitedDate)
            } label: {
                Text("수정하기")
            }

            
            Button {
                isShowingDeleteAlert = true
            } label: {
                Text("삭제하기")
            }
            
        } label: {
            Image(systemName: "ellipsis")
                .font(.title3)
                .frame(width: 30,height: 30)
        }
        //MARK: - 일기 삭제 알림
        .alert("일기를 삭제하시겠습니까?", isPresented: $isShowingDeleteAlert) {
            Button("취소", role: .cancel) {
                isShowingDeleteAlert = false
            }
            Button("삭제", role: .destructive) {
                diaryStore.deleteDiaryCombine(diary: item.diary)
            }
        }
    }
    
    //MARK: - 유저 신고 / 차단 버튼
    var reportAlertMenu: some View {
        
        //MARK: - ... 버튼입니다.
        
        Button(action: {
            isShowingUserReportAlert.toggle()
        }) {
            Image(systemName: "ellipsis")
                .font(.title3)
                .frame(width: 30,height: 30)

        }
        .confirmationDialog("알림", isPresented: $isShowingUserReportAlert, titleVisibility: .hidden, actions: {
            Button("신고하기", role: .destructive) {
                print("신고하기ㅣㅣㅣㅣ")
                   // ReportUserView(placeholder: "")
            }
            Button("차단하기", role: .destructive) {
                print("차단해ㅐㅐㅐㅐ")
                isBlocked.toggle()
                if isBlocked {
                    blockedUserStore.addBlockedUserCombine(blockedUserId: item.diary.uid)
                }
                wholeAuthStore.readMyInfoCombine(user: wholeAuthStore.currnetUserInfo!)
            }
            Button("취소", role: .cancel) {}
        })
    }

    
    // MARK: -View : 다이어리 사진
    var diaryDetailImage: some View {
        TabView{
            ForEach(item.diary.diaryImageURLs, id: \.self) { url in
                ZStack{
                    WebImage(url: URL(string: url))
                        .resizable()
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .scaledToFill()
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
                        .clipped()
                }
            }
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
        .pinchZoomAndDrag()
    }
    
    // MARK: -View : 다이어리 제목
    var diaryDetailTitle: some View {
        Text(item.diary.diaryTitle)
            .font(.system(.title3, weight: .semibold))
            .padding(.vertical, 5)
    }
    
    // MARK: -View : 다이어리 내용
    var diaryDetailContent: some View {
        Text(item.diary.diaryContent)
            .multilineTextAlignment(.leading)
    }
    
    //MARK: - 방문한 캠핑장 링크
    //TODO: - 캠핑장 정보 연결
    var diaryCampingLink: some View {
        
        NavigationLink {
            CampingSpotDetailView(campingSpot: campingSpotStore.campingSpotList.first ?? campingSpotStore.campingSpot)
        } label: {
            HStack {
                WebImage(url: URL(string: campingSpotStore.campingSpotList.first?.firstImageUrl == "" ? campingSpotStore.noImageURL : campingSpotStore.campingSpotList.first?.firstImageUrl ?? ""))
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(campingSpotStore.campingSpotList.first?.facltNm ?? "")
                        .font(.headline)
                    HStack {
                        Text("\(campingSpotStore.campingSpotList.first?.doNm ?? "") \(campingSpotStore.campingSpotList.first?.sigunguNm ?? "")")
                        Spacer()
                        Group {
                            Text("자세히 보기")
                            Image(systemName: "chevron.right")
                        }
                        .font(.footnote)
                        
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .foregroundColor(.bcBlack)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.bcDarkGray, lineWidth: 1)
                    .opacity(0.3)
            )
        }
        .foregroundColor(.clear)
    }
    
    
    
    //MARK: - 좋아요, 댓글, 타임스탬프
        var diaryDetailInfo: some View {
            HStack {
                Button {
                    //좋아요 버튼, 카운드
                    if diaryLikeStore.diaryLikeList.contains(wholeAuthStore.currentUser?.uid ?? "") {
                        diaryLikeStore.removeDiaryLikeCombine(diaryId: item.diary.id)
                    } else {
                        diaryLikeStore.addDiaryLikeCombine(diaryId: item.diary.id)
                    }
                    diaryLikeStore.readDiaryLikeCombine(diaryId: item.diary.id)
                    //탭틱
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                } label: {
                    Image(systemName: diaryLikeStore.diaryLikeList.contains(wholeAuthStore.currentUser?.uid ?? "") ? "flame.fill" : "flame")
                        .foregroundColor(diaryLikeStore.diaryLikeList.contains(wholeAuthStore.currentUser?.uid ?? "") ? .red : .bcBlack)
                }
                Text("\(diaryLikeStore.diaryLikeList.count)")
                    .padding(.trailing, 7)

                //댓글 버튼
                Button {
                    //"댓글 작성 버튼으로 이동"
                } label: {
                    Image(systemName: "message")
                }
                Text("\(commentStore.commentList.count)")
                    .font(.body)
                    .padding(.horizontal, 3)

                Spacer()
                //작성 경과시간
                Text("\(TimestampToString.dateString(item.diary.diaryCreatedDate)) 전")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .foregroundColor(.bcBlack)
            .font(.title3)
            .padding(.vertical, 5)
        }
    
    //MARK: - 키보드 dismiss 함수입니다.
    func submit() {
        resignKeyboard()
    }
    //iOS 15 아래버전은 유킷연동 함수 사용
    func resignKeyboard() {
        if #available(iOS 15, *) {
            inputFocused = false
        } else {
            dismissKeyboard()
        }
    }
}
