//
//  EventTrack.swift
//
//
//  Created by Roberto Oliveira on 07/06/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import Foundation

// This class is made to organize Tracking Event Ids, making it safer and easier to track events
// Each struct represents a feature/screen of the app and there are a lot of possible events for each of them
class EventTrack {
    
    
    // MARK: - Not a specific screen
    struct NoScreen {
        static let openExternalPushNotification = 1
        static let performSilentGetVersion = 2
        static let openAudioLibraryFromFloatingButton = 157
        static let serversFailed = 225
        static let floatingButton = 0
    }
    
    
    
    
    // MARK: - Splash
    struct Splash {
        static let tryAgain = 3
    }
    
    
    
    
    // MARK: - Maintenance
    struct Maintenance {
        static let tryAgain = 4
        static let downloadNewVersion = 5
        static let skip = 6
    }
    
    
    
    
    // MARK: - Login
    struct Signup {
        static let openTermsOfUse = 7
        static let openPrivacyPolicy = 8
        static let confirm = 9
        static let openLogIn = 10
        static let skipSignup = 0
    }
    
    struct Signin {
        static let recoverPassword = 11
        static let signin = 12
        static let openSignup = 13
    }
    
    struct CompleteSignup {
        static let confirm = 0
        static let close = 0
    }
    
    
    
    // MARK: - Request Notifications
    struct PushNotificationsPermission {
        static let confirm = 14
    }
    
    
    
    // MARK: - Home
    struct Home {
        static let homeTabMenu = 15
        static let pullToReload = 16
        static let expandTweet = 17
        static let seeMoreTweets = 18
        static let openAllTweets = 19
        static let newsTryAgain = 20
        static let openNews = 21
        static let lastMatchesTryAgain = 22
        static let quizPreviewStart = 23
        static let quizPreviewTryAgain = 24
        static let squadSelectorStart = 25
        static let squadSelectorTryAgain = 26
        static let storiesOpenItem = 27
        static let storiesTryAgain = 28
        static let scheduleTryAgain = 136
        static let buyScheduleTickets = 137
        static let openSchedule = 138
        static let openMatchDetails = 141
        static let audioLibraryPlay = 170
        static let openAllNews = 171
        static let openNotificationsCentral = 180
        static let openCTABanner = 186
        static let openShopGallery = 188
        static let openShopGalleryItem = 189
        static let openVideoItem = 0

    }
    
    
    
    // MARK: - Home Questions
    struct HomeQuestions {
        static let homeQuestionsTabMenu = 29
        static let selectSurveysTab = 30
        static let selectMultipleSurveysTab = 31
        static let selectQuizTab = 32
    }
    
    struct Surveys {
        static let tryAgain = 33
        static let skipQuestion = 34
        static let nextQuestion = 35
        static let selectAnswerOption = 36
        static let sendTextAnswer = 37
    }
    
    struct QuizGroups {
        static let tryAgain = 38
        static let selectGroup = 39
        static let startGroup = 40
        static let backToList = 41
        static let pullToReload = 42
    }
    
    struct Quiz {
        static let answerTimeout = 43
        static let selectAnswer = 44
        static let nextQuestionTimer = 45
        static let nextQuestion = 46
        static let close = 47
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Squad Selector
    struct SquadSelector {
        static let tryAgain = 48
        static let close = 49
        static let selectScheme = 50
        static let addItem = 51
        static let removeItem = 52
        static let share = 249
    }
    
    struct SquadSelectorShare {
        static let confirm = 250
    }
    
    struct SquadSelectorList {
        static let tryAgain = 53
        static let close = 54
        static let selectItem = 55
    }
    
    
    
    
    
    
    // MARK: - Club Home
    struct ClubHome {
        static let clubHomeTabMenu = 56
        static let pullToReload = 57
        // schedule
        static let scheduleTryAgain = 58
        static let buyScheduleTickets = 59
        static let openSchedule = 60
        // last matches
        static let lastMatchesTryAgain = 61
        static let openMatchDetails = 142
        // squad
        static let squadTryAgain = 62
        static let squadSelectItem = 63
    }
    
    
    
    // MARK: - Schedule
    struct Schedule {
        static let tryAgain = 64
        static let buyScheduleTickets = 65
    }
    
    
    
    
    // MARK: - Player Profile
    struct PlayerProfile {
        static let close = 66
        static let tryAgain = 67
        static let changeChartData = 68
    }
    
    
    
    
    
    
    // MARK: - Multiple Surveys
    struct MultipleSurveys {
        static let tryAgain = 69
        static let start = 70
        static let nextQuestion = 71
        static let previousQuestion = 72
        static let openPlayersSelector = 73
        static let selectAnswerOption = 74
        static let send = 75
        static let showAnswers = 76
        static let back = 77
        static let openResultsDetails = 143
    }
    
    struct MultipleSurveysListSelector {
        static let tryAgain = 78
        static let close = 79
        static let selectItem = 80
    }
    
    
    
    
    
    
    // MARK: - Rankings
    struct Rankings {
        static let tryAgain = 81
        static let close = 82
        static let selectGroup = 83
    }
    
    
    
    
    
    // MARK: - Store
    struct Store {
        static let close = 84
        static let tryAgain = 85
        static let selectItem = 86
    }
    
    struct StoreItem {
        static let close = 87
        static let tryAgain = 88
        static let confirm = 89
        static let openDocument = 90
    }
    
    struct StoreItemRedeem {
        static let close = 91
        static let confirm = 92
    }
    
    
    
    
    
    
    // MARK: - Menu
    struct Menu {
        static let menuTabMenu = 148
        static let profileAvatar = 93
        static let membership = 94
        static let profile = 95
        static let ranking = 96
        static let store = 97
        static let settings = 98
        static let logout = 99
        static let logoutYes = 100
        static let logoutNo = 101
        static let audioLibrary = 151
        static let DynamicCTA = 187
        static let openShopGallery = 190
        static let checkin = 204
    }
    
    
    
    
    
    // MARK: - Badge Details
    struct BadgeDetails {
        static let close = 102
    }
    
    
    
    // MARK: - Document
    struct Document {
        static let close = 103
        static let tryAgain = 104
    }
    
    struct StoreDocument {
        static let close = 105
        static let tryAgain = 106
    }
    
    
    
    
    // MARK: - Membership
    struct Membership {
        static let close = 107
        static let confirm = 108
    }
    
    
    
    
    // MARK: - Settings
    struct Settings {
        static let close = 109
        static let changePassword = 110
        static let editProfile = 111
        static let documentsTryAgain = 112
        static let openDocument = 113
    }
    
    
    
    // MARK: - Change Password
    struct ChangePassword {
        static let close = 114
        static let confirm = 115
    }
    
    
    
    // MARK: - Edit Profile
    struct EditProfile {
        static let close = 116
        static let confirm = 117
        static let changePhoto = 118
        static let changePhotoCamera = 119
        static let changePhotoLibrary = 120
        static let changePhotoCancel = 121
    }
    
    
    // MARK: - Profile
    struct Profile {
        static let close = 122
        static let openSettings = 123
        static let changeAvatar = 124
        static let avatarFromCamera = 125
        static let avatarFromLibrary = 126
        static let avatarCancel = 127
        static let badgesTryAgain = 128
        static let selectBadge = 129
        static let pullToReloadBadges = 130
    }
    
    
    
    // MARK: - New Badge
    struct NewBadge {
        static let close = 131
        static let nextBadge = 132
    }
    
    
    
    // MARK: - News
    struct News {
        static let close = 133
        static let share = 134
        static let tryAgain = 135
    }
    
    
    
    // MARK: - MatchDetails
    struct MatchDetails {
        static let tryAgain = 139
        static let close = 140
    }
    
    
    
    // MARK: - MultipleSurveysResultsGroups
    struct MultipleSurveysResultsGroups {
        static let tryAgain = 144
        static let pullToReload = 145
        static let close = 146
        static let selectGroup = 147
    }
    
    
    // MARK: - MultipleSurveysResultsGroup
    struct MultipleSurveysResultsGroup {
        static let tryAgain = 149
        static let close = 150
    }
    
     
    
    
    // MARK: - AudioLibrary
    struct AudioLibrary {
        static let tryAgain = 152
        static let close = 153
        static let selectHighlightedItem = 154
        static let selectItem = 155
        static let pullToReload = 156
    }
    
    // MARK: - AudioLibraryPlayer
    struct AudioLibraryPlayer {
        static let lyricsAction = 158
        static let repeatAction = 159
        static let shuffleAction = 160
        static let muteAction = 161
        static let rewind15 = 162
        static let forward15 = 163
        static let previousTrack = 164
        static let nextTrack = 165
        static let play = 166
        static let pause = 167
        static let download = 168
        static let close = 169
    }
    
    
    
    // MARK: - AllNews
    struct AllNews {
        static let close = 172
        static let tryAgain = 173
        static let pullToReload = 174
        static let openNews = 175
        static let openFilters = 176
    }
    
    struct AllNewsFilters {
        static let close = 177
        static let tryAgain = 178
        static let selectFilter = 179
    }
    
    
    
    
    // MARK: - NotificationsCentral
    struct NotificationsCentral {
        static let tryAgain = 181
        static let close = 182
        static let selectItem = 183
        static let setAllRead = 184
        static let pullToReload = 185
    }
    
    
    
    
    
    // MARK: - Shop Gallery
    struct ShopGallery {
        static let close = 191
        static let tryAgain = 192
        static let pullToReload = 193
        static let openProduct = 194
        static let openFilters = 195
        static let dismissFooter = 196
    }
    
    struct ShopGalleryFilters {
        static let close = 197
        static let tryAgain = 198
        static let selectFilter = 199
    }
    
    
    
    
    
    // Dynamic Message
    struct DynamicMessage {
        static let close = 200
    }
    
    
    // MembershipRequired [NOT USED]
    struct MembershipRequired {
        static let close = 201
        static let alreadyMember = 202
        static let signupMembership = 203
    }
    
    
    
    
    // Checkin [NOT USED]
    struct CheckinMatches {
        static let close = 205
        static let tryAgain = 206
        static let pullToReload = 207
        static let selectMatch = 208
    }
    
    struct CheckinMatchSections {
        static let close = 209
        static let tryAgain = 210
        static let selectItem = 211
        static let confirm = 212
    }
    
    struct CheckinMatchSectionGroups {
        static let close = 213
        static let tryAgain = 214
        static let selectItem = 215
        static let confirm = 216
    }
    
    struct CheckinConfirmation {
        static let close = 217
        static let confirm = 218
    }
    
    struct CheckinCompleted {
        static let close = 219
    }
    
    struct CheckinCanceled {
        static let close = 220
    }
    
    struct CheckinSummary {
        static let close = 221
        static let cancel = 222
    }
    
    struct CheckinCancelAlert {
        static let close = 223
        static let confirm = 224
    }
    
    
    
    
    
    
    
    
    
    
    // Membership
    struct MembershipWelcome {
        static let close = 226
        static let openLogin = 227
        static let join = 228
    }
    
    struct MembershipLogin {
        static let close = 229
        static let confirm = 230
    }
    
    struct MembershipHome {
        static let close = 231
        static let openSettings = 232
        static let openAllInvoices = 233
        static let confirmInvoice = 234
        static let selectPlanGroup = 235
        static let addPlanHolder = 236
        static let addPlanDependent = 237
        static let openCardDetails = 238
    }
    
    struct MembershipSettings {
        static let close = 239
        static let editProfile = 240
        static let editAddress = 241
    }
    
    struct MembershipInvoices {
        static let close = 241
        static let confirmInvoice = 243
    }
    
    struct MembershipCardDetails {
        static let close = 244
        static let newCard = 245
        static let upgrade = 246
        static let deliveryStatus = 247
        static let renew = 248
    }
    
    // Videos
    // [21]
    struct VideoItem {
        static let close = 0
    }
    
    // [22]
    struct Videos {
        static let openItem = 0
        static let openCategory = 0
        static let tabMenu = 0
    }
    
    // [23]
    struct VideosCategory {
        static let close = 0
        static let openItem = 0
    }
    
}



