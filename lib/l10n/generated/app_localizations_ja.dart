// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get navHome => 'ホーム'; [cite: 11]

  @override
  String get navApps => 'アプリ'; [cite: 11]

  @override
  String get navSettings => '設定'; [cite: 11]

  @override
  String get cancel => 'キャンセル'; [cite: 11]

  @override
  String get confirm => '確認'; [cite: 11]

  @override
  String get ok => 'OK'; [cite: 11]

  @override
  String get apply => '適用'; [cite: 11]

  @override
  String get noChange => '変更しない'; [cite: 11]

  @override
  String get newVersionFound => '新しいバージョンが利用可能です'; [cite: 11]

  @override
  String currentVersion(String version) {
    return '現在のバージョン: $version'; [cite: 11]
  }

  @override
  String latestVersion(String version) {
    return '最新のバージョン: $version'; [cite: 11]
  }

  @override
  String get later => '後で'; [cite: 11]

  @override
  String get goUpdate => '更新'; [cite: 11]

  @override
  String get sponsorSupport => '作者をサポートする'; [cite: 11]

  @override
  String get sponsorAuthor => 'スポンサー'; [cite: 11]

  @override
  String get restartScope => 'スコープを再起動'; [cite: 11]

  @override
  String get systemUI => 'システム UI'; [cite: 11]

  @override
  String get downloadManager => 'ダウンロードマネージャー'; [cite: 11]

  @override
  String get xmsf => 'XMSF (Xiaomi サービスフレームワーク)'; [cite: 11]

  @override
  String get notificationTest => '通知のテスト'; [cite: 11]

  @override
  String get sendTestNotification => 'テスト通知を送信'; [cite: 11]

  @override
  String get notes => '説明'; [cite: 11]

  @override
  String get detectingModuleStatus => 'モジュールの状態を検出中...'; [cite: 11]

  @override
  String get moduleStatus => 'モジュールの状態'; [cite: 11]

  @override
  String get activated => '有効'; [cite: 11]

  @override
  String get notActivated => '無効'; [cite: 11]

  @override
  String get enableInLSPosed => 'LSPosed でこのモジュールを有効化してください'; [cite: 11]

  @override
  String lsposedApiVersion(int version) {
    return 'LSPosed API Version: $version'; [cite: 1]
  }

  @override
  String get updateLSPosedRequired => 'LSPosed バージョンを更新してください'; [cite: 11]

  @override
  String get systemNotSupported => 'システムは非対応です'; [cite: 11]

  @override
  String systemNotSupportedSubtitle(int version) {
    return 'システムは Dynamic Island に非対応です (現在のプロトコルバージョンは $version、プロトコルバージョン 3 が必要です)'; [cite: 12]
  }

  @override
  String restartFailed(String message) {
    return '再起動に失敗しました: $message'; [cite: 11]
  }

  @override
  String get restartRootRequired => 'このアプリに root 権限が付与されているか確認してください'; [cite: 11]

  @override
  String get note1 => '1. このページは Dynamic Island の対応をテストするためのものであり、実際の効果を示すものではありません。'; [cite: 13]

  @override
  String get note2 => '2. HyperCeiler でシステム UI と MIUI フレームワークのフォーカス通知のホワイトリストを無効化してください。'; [cite: 11]

  @override
  String get note3 => '3. LSPosed Manager で有効化後に関連するスコープアプリを再起動する必要があります。'; [cite: 14]

  @override
  String get note4 => '4. 一般的なアダプティブ表示に対応しています。適切なテンプレートを確認してみてください。'; [cite: 11]

  @override
  String get behaviorSection => '動作'; [cite: 11]

  @override
  String get defaultConfigSection => 'デフォルトのチャンネル設定'; [cite: 11]

  @override
  String get appearanceSection => '外観'; [cite: 11]

  @override
  String get configSection => '構成'; [cite: 11]

  @override
  String get aboutSection => 'アプリについて'; [cite: 11]

  @override
  String get keepFocusNotifTitle => 'ダウンロードの一時停止後も通知を保持する'; [cite: 11]

  @override
  String get keepFocusNotifSubtitle => 'ダウンロードを再開するためのフォーカス通知を表示しますが、状態の同期でズレが発生する可能性があります'; [cite: 11]

  @override
  String get unlockAllFocusTitle => 'フォーカス通知のホワイトリストを削除'; [cite: 11]

  @override
  String get unlockAllFocusSubtitle => 'システム認証がない場合でもすべてのアプリでフォーカス通知を送信可能にします'; [cite: 11]

  @override
  String get unlockFocusAuthTitle => 'フォーカス通知の署名検証を削除'; [cite: 11]

  @override
  String get unlockFocusAuthSubtitle => '署名検証のバイパスとすべてのアプリでフォーカス通知を時計/ブレスレットに送信可能な状態にします (XMSF のフックが必要です)'; [cite: 11]

  @override
  String get checkUpdateOnLaunchTitle => '起動時に更新を確認する'; [cite: 11]

  @override
  String get checkUpdateOnLaunchSubtitle => 'アプリの起動時に最新のバージョンを自動で確認します'; [cite: 11]

  @override
  String get showWelcomeTitle => '起動時にウェルカムメッセージを表示する'; [cite: 1]

  @override
  String get showWelcomeSubtitle => '起動時に Island にウェルカムメッセージを表示します'; [cite: 1]

  @override
  String get interactionHapticsTitle => 'インタラクションハプティクス'; [cite: 1]

  @override
  String get interactionHapticsSubtitle => 'スイッチ、スライダー、ボタンでカスタム触覚フィードバックを有効にします'; [cite: 1]

  @override
  String get checkUpdate => '更新を確認'; [cite: 11]

  @override
  String get alreadyLatest => '最新のバージョンを使用しています'; [cite: 11]

  @override
  String get useAppIconTitle => 'アプリアイコンを使用する'; [cite: 1]

  @override
  String get useAppIconSubtitle => 'ダウンロードマネージャーの通知にアプリアイコンを使用します'; [cite: 1]

  @override
  String get roundIconTitle => 'アイコンの角を丸める'; [cite: 11]

  @override
  String get roundIconSubtitle => '通知アイコンの角を丸めます'; [cite: 11]

  @override
  String get marqueeChannelTitle => 'Island のテキストをスクロール '; [cite: 11]

  @override
  String get marqueeSpeedTitle => '速度'; [cite: 11]

  @override
  String marqueeSpeedLabel(int speed) {
    return '$speed px/秒'; [cite: 15]
  }

  @override
  String get themeModeTitle => 'カラーモード'; [cite: 11]

  @override
  String get themeModeSystem => 'システムに従う'; [cite: 11]

  @override
  String get themeModeLight => 'ライト'; [cite: 11]

  @override
  String get themeModeDark => 'ダーク'; [cite: 11]

  @override
  String get languageTitle => '言語'; [cite: 11]

  @override
  String get languageAuto => 'システムに従う'; [cite: 11]

  @override
  String get languageZh => '中文'; [cite: 11]

  @override
  String get languageEn => 'English'; [cite: 11]

  @override
  String get languageJa => '日本語'; [cite: 11]

  @override
  String get languageTr => 'Türkçe'; [cite: 11]

  @override
  String get exportToFile => 'ファイルにエクスポート'; [cite: 11]

  @override
  String get exportToFileSubtitle => '構成を JSON ファイルで保存します'; [cite: 11]

  @override
  String get exportToClipboard => 'クリップボードにエクスポート'; [cite: 11]

  @override
  String get exportToClipboardSubtitle => '構成の JSON テキストをクリップボードにコピーします'; [cite: 11]

  @override
  String get exportConfig => '構成をエクスポート'; [cite: 1]

  @override
  String get exportConfigSubtitle => 'ファイルまたはクリップボードにエクスポートするか選択してください'; [cite: 1]

  @override
  String get importFromFile => 'ファイルからインポート'; [cite: 11]

  @override
  String get importFromFileSubtitle => 'JSON ファイルから構成を復元します'; [cite: 11]

  @override
  String get importFromClipboard => 'クリップボードからインポート'; [cite: 11]

  @override
  String get importFromClipboardSubtitle => 'クリップボードの JSON テキストから構成を復元します'; [cite: 11]

  @override
  String get importConfig => '構成をインポート'; [cite: 1]

  @override
  String get importConfigSubtitle => 'ファイルまたはクリップボードにインポートするか選択してください'; [cite: 1]

  @override
  String get qqGroup => 'QQ グループ'; [cite: 11]

  @override
  String get restartScopeApp => '設定を適用するにはスコープアプリを再起動してください'; [cite: 11]

  @override
  String get groupNumberCopied => 'グループ番号をクリップボードにコピーしました'; [cite: 11]

  @override
  String exportedTo(String path) {
    return 'エクスポート先: $path'; [cite: 11]
  }

  @override
  String exportFailed(String error) {
    return 'エクスポートに失敗しました: $error'; [cite: 11]
  }

  @override
  String get configCopied => '構成をクリップボードにコピーしました'; [cite: 11]

  @override
  String importSuccess(int count) {
    return '$count 個の項目をインポートしました。アプリを再起動してください。'; [cite: 11]
  }

  @override
  String importFailed(String error) {
    return 'インポートに失敗しました: $error'; [cite: 11]
  }

  @override
  String get appAdaptation => 'アプリのアダプティブ表示'; [cite: 16]

  @override
  String selectedAppsCount(int count) {
    return '$count 個のアプリを選択済み'; [cite: 11]
  }

  @override
  String get cancelSelection => '選択をキャンセル'; [cite: 11]

  @override
  String get deselectAll => 'すべての選択を解除'; [cite: 11]

  @override
  String get selectAll => 'すべて選択'; [cite: 11]

  @override
  String get batchChannelSettings => 'チャンネルを一括で設定'; [cite: 11]

  @override
  String get selectEnabledApps => '有効化するアプリを選択'; [cite: 11]

  @override
  String get batchEnable => '一括で有効化'; [cite: 11]

  @override
  String get batchDisable => '一括で無効化'; [cite: 11]

  @override
  String get multiSelect => '複数選択'; [cite: 11]

  @override
  String get showSystemApps => 'システムアプリを表示'; [cite: 11]

  @override
  String get refreshList => 'リストを更新'; [cite: 11]

  @override
  String get enableAll => 'すべて有効'; [cite: 11]

  @override
  String get disableAll => 'すべて無効'; [cite: 11]

  @override
  String enabledAppsCount(int count) {
    return 'Dynamic Island は $count 個のアプリで有効です'; [cite: 11]
  }

  @override
  String enabledAppsCountWithSystem(int count) {
    return 'Dynamic Island は $count 個のアプリで有効です (システムアプリも含む)'; [cite: 11]
  }

  @override
  String get searchApps => 'アプリ名またはパッケージ名で検索'; [cite: 11]

  @override
  String get noAppsFound => 'インストール済みのアプリが見つかりません\nアプリリストの権限が有効か確認してください'; [cite: 11]

  @override
  String get noMatchingApps => '一致するアプリがありません'; [cite: 11]

  @override
  String applyToSelectedAppsChannels(int count) {
    return '選択した $count 個のアプリで有効なチャンネルに適用されます'; [cite: 11]
  }

  @override
  String get applyingConfig => '構成を適用中です...'; [cite: 11]

  @override
  String progressApps(int done, int total) {
    return '進捗: $done / $total'; [cite: 11]
  }

  @override
  String batchApplied(int count) {
    return '$count 個のアプリを適用しました'; [cite: 11]
  }

  @override
  String get cannotReadChannels => '通知チャンネルを読み込めません'; [cite: 11]

  @override
  String get rootRequiredMessage => '通知チャンネルの読み取りには root 権限が必要です。\nroot 権限が付与されていることを確認後に再度お試しください。'; [cite: 11]

  @override
  String get enableAllChannels => 'すべてのチャンネルで有効'; [cite: 11]

  @override
  String get noChannelsFound => '通知チャンネルがありません'; [cite: 11]

  @override
  String get noChannelsFoundSubtitle => 'このアプリには通知チャンネルがありません。通知の読み取りはできません。'; [cite: 17]

  @override
  String allChannelsActive(int count) {
    return '$count 個のチャンネルですべて有効'; [cite: 11]
  }

  @override
  String selectedChannels(int selected, int total) {
    return '$selected / $total 個のチャンネルを選択済み'; [cite: 11]
  }

  @override
  String allChannelsDisabled(int count) {
    return 'すべての $count 個のチャンネル (無効化済み)'; [cite: 11]
  }

  @override
  String get appDisabledBanner => 'アプリが無効化されているため、以下のチャンネル設定は無効です'; [cite: 11]

  @override
  String channelImportance(String importance, String id) {
    return '重要度: $importance  ·  $id'; [cite: 11]
  }

  @override
  String get channelSettings => 'チャンネルの設定'; [cite: 11]

  @override
  String get importanceNone => 'なし'; [cite: 11]

  @override
  String get importanceMin => '中'; [cite: 11]

  @override
  String get importanceLow => '低'; [cite: 11]

  @override
  String get importanceDefault => 'デフォルト'; [cite: 11]

  @override
  String get importanceHigh => '高'; [cite: 11]

  @override
  String get importanceUnknown => '不明'; [cite: 11]

  @override
  String applyToEnabledChannels(int count) {
    return '有効な $count 個のチャンネルに適用されます'; [cite: 11]
  }

  @override
  String applyToAllChannels(int count) {
    return 'すべての $count 個のチャンネルに適用されます'; [cite: 11]
  }

  @override
  String get templateDownloadName => 'ダウンロード'; [cite: 11]

  @override
  String get templateNotificationIslandName => 'Notification Island'; [cite: 11]

  @override
  String get templateNotificationIslandLiteName => 'Notification Island|Lite'; [cite: 11]

  @override
  String get templateDownloadLiteName => 'Lite|をダウンロード'; [cite: 11]

  @override
  String get islandSection => 'Island'; [cite: 11]

  @override
  String get template => 'テンプレート'; [cite: 11]

  @override
  String get rendererLabel => 'スタイル'; [cite: 11]

  @override
  String get rendererImageTextWithButtons4Name => '画像 + テキスト + 下部テキストボタン'; [cite: 11]

  @override
  String get rendererCoverInfoName => 'カバー情報 + 自動で折りたたみ'; [cite: 11]

  @override
  String get rendererImageTextWithRightTextButtonName => '画像 + テキスト + 右テキストボタン'; [cite: 18]

  @override
  String get islandIcon => 'Island のアイコン'; [cite: 11]

  @override
  String get islandIconLabel => '大きな Island アイコン'; [cite: 11]

  @override
  String get islandIconLabelSubtitle => '有効にすると Island に大きなアイコンを表示します (小さな Island は影響を受けません)'; [cite: 11]

  @override
  String get focusIconLabel => 'フォーカスアイコン'; [cite: 11]

  @override
  String get focusNotificationLabel => 'フォーカス通知'; [cite: 11]

  @override
  String get preserveStatusBarSmallIconLabel => 'ステータスバーアイコン'; [cite: 11]

  @override
  String get restoreLockscreenTitle => 'ロック画面の通知を復元する'; [cite: 11]

  @override
  String get restoreLockscreenSubtitle => 'ロック画面でのフォーカス通知処理をスキップし、元のプライバシーに適切な動作を保持します'; [cite: 11]

  @override
  String get firstFloatLabel => '最初にフロート表示'; [cite: 11]

  @override
  String get updateFloatLabel => '更新時にフロート表示'; [cite: 11]

  @override
  String get autoDisappear => '自動で無視'; [cite: 11]

  @override
  String get seconds => '秒'; [cite: 11]

  @override
  String get onlyEnabledChannels => '有効なチャンネルにのみ適用されます'; [cite: 11]

  @override
  String enabledChannelsCount(int enabled, int total) {
    return '$enabled / $total 個のチャンネルが有効'; [cite: 11]
  }

  @override
  String get iconModeAuto => '自動'; [cite: 11]

  @override
  String get iconModeNotifSmall => '小さな通知アイコン'; [cite: 11]

  @override
  String get iconModeNotifLarge => '大きな通知アイコン'; [cite: 11]

  @override
  String get iconModeAppIcon => 'アプリアイコン'; [cite: 11]

  @override
  String get optDefault => 'デフォルト'; [cite: 11]

  @override
  String get optDefaultOn => 'デフォルト (ON)'; [cite: 11]

  @override
  String get optDefaultOff => 'デフォルト (OFF)'; [cite: 11]

  @override
  String get optOn => 'ON'; [cite: 11]

  @override
  String get optOff => 'OFF'; [cite: 11]

  @override
  String get errorInvalidFormat => '無効な構成フォーマットです'; [cite: 11]

  @override
  String get errorNoStorageDir => 'ストレージのディレクトリを取得できません'; [cite: 11]

  @override
  String get errorNoFileSelected => 'ファイルが選択されていません'; [cite: 11]

  @override
  String get errorNoFilePath => 'ファイルパスを取得できません'; [cite: 11]

  @override
  String get errorEmptyClipboard => 'クリップボードは空です'; [cite: 11]

  @override
  String get navBlacklist => 'フォーカスのブラックリスト'; [cite: 11]

  @override
  String get navBlacklistSubtitle => '特定のアプリでのフォーカス通知をブロック、フローティングまたは非表示にします'; [cite: 19]

  @override
  String get presetGamesTitle => '人気のゲームをクイックでフィルター'; [cite: 11]

  @override
  String presetGamesSuccess(int count) {
    return '$count 個のインストールしたゲームをブラックリストに追加しました'; [cite: 11]
  }

  @override
  String blacklistedAppsCount(int count) {
    return '$count 個のアプリのフォーカス通知をブロックしました'; [cite: 11]
  }

  @override
  String blacklistedAppsCountWithSystem(int count) {
    return '$count 個のアプリのフォーカス通知をブロックしました (システムアプリを含む)'; [cite: 11]
  }

  @override
  String get firstFloatLabelSubtitle => 'Island が初めて通知を受信時にフォーカス通知として展開します'; [cite: 11]

  @override
  String get updateFloatLabelSubtitle => 'Island の更新時にフロート通知を展開します'; [cite: 11]

  @override
  String get marqueeChannelTitleSubtitle => 'Island で長いメッセージをスクロールします'; [cite: 11]

  @override
  String get focusNotificationLabelSubtitle => '通知をフォーカス通知に置き換えます (無効で元の通知が表示されます)'; [cite: 11]

  @override
  String get preserveStatusBarSmallIconLabelSubtitle => 'フォーカス通知を表示時にステータスバーアイコンを強制的に保持します'; [cite: 11]

  @override
  String get aiConfigSection => 'AI エンハンスメント'; [cite: 11]

  @override
  String get aiConfigTitle => 'AI 通知の概要'; [cite: 11]

  @override
  String get aiConfigSubtitleEnabled => '有効 · タップで AI パラメータを構成'; [cite: 11]

  @override
  String get aiConfigSubtitleDisabled => '無効 · タップで構成'; [cite: 11]

  @override
  String get aiEnabledTitle => 'AI の概要を有効化'; [cite: 11]

  @override
  String get aiEnabledSubtitle => 'AI が Island の左右のテキストを生成します。タイムアウトまたはエラーの発生時はフォールバックします。'; [cite: 11]

  @override
  String get aiApiSection => 'API パラメータ'; [cite: 20]

  @override
  String get aiUrlLabel => 'API URL'; [cite: 11]

  @override
  String get aiUrlHint => 'https://api.openai.com/v1/chat/completions'; [cite: 11]

  @override
  String get aiApiKeyLabel => 'API キー'; [cite: 11]

  @override
  String get aiApiKeyHint => 'sk-...'; [cite: 11]

  @override
  String get aiModelLabel => 'モデル'; [cite: 11]

  @override
  String get aiModelHint => 'gpt-4o-mini'; [cite: 11]

  @override
  String get aiPromptLabel => 'カスタムプロンプト'; [cite: 11]

  @override
  String get aiPromptHint => 'デフォルトを使用する場合は空欄: 左右それぞれ 6 単語または 12 文字以内の重要な情報を抽出します'; [cite: 11]

  @override
  String get aiPromptInUserTitle => 'ユーザーメッセージにプロンプトを表示する'; [cite: 11]

  @override
  String get aiPromptInUserSubtitle => '一部のモデルではシステム命令がサポートされていないため、ユーザーメッセージにプロンプ​​トを表示させることができません'; [cite: 11]

  @override
  String get aiTimeoutTitle => 'AI レスポンスのタイムアウト'; [cite: 1]

  @override
  String aiTimeoutLabel(int seconds) {
    return 'AI レスポンスのタイムアウト'; [cite: 1]
  }

  @override
  String get aiTemperatureTitle => 'サンプリング温度'; [cite: 1]

  @override
  String get aiTemperatureSubtitle => '回答のランダム性を制御します。0 は正確、1 はより創造的になります'; [cite: 1]

  @override
  String get aiMaxTokensTitle => '最大トークン'; [cite: 1]

  @override
  String get aiMaxTokensSubtitle => 'AI が生成するレスポンスの最大数を制限します'; [cite: 1]

  @override
  String get aiDefaultPromptFull => '空欄のままにするとデフォルトのプロンプトを使用します: 通知からキー情報を抽出します。左右それぞれに最大 6 単語または 12 文字までです。'; [cite: 1]

  @override
  String get aiTestButton => 'テスト接続'; [cite: 11]

  @override
  String get aiTestUrlEmpty => '始めに API URL を入力してください'; [cite: 11]

  @override
  String get aiLastLogTitle => '最近の AI リクエストログ'; [cite: 1]

  @override
  String get aiLastLogSubtitle => 'テスト接続や通知によってトリガーされた AI リクエストはここに表示されます'; [cite: 1]

  @override
  String get aiLastLogEmpty => '表示する AI リクエストログはまだありません'; [cite: 1]

  @override
  String get aiLastLogSourceLabel => 'ソース'; [cite: 1]

  @override
  String get aiLastLogTimeLabel => '時間'; [cite: 1]

  @override
  String get aiLastLogStatusLabel => 'ステータス'; [cite: 1]

  @override
  String get aiLastLogDurationLabel => '長さ'; [cite: 1]

  @override
  String get aiLastLogSourceNotification => '通知のトリガー'; [cite: 1]

  @override
  String get aiLastLogSourceSettingsTest => 'テスト設定'; [cite: 1]

  @override
  String get aiLastLogRendered => 'レンダリング済み'; [cite: 1]

  @override
  String get aiLastLogRaw => '生'; [cite: 1]

  @override
  String get aiLastLogCopy => 'ログをコピー'; [cite: 1]

  @override
  String get aiLastLogCopied => 'AI リクエストログをコピーしました'; [cite: 1]

  @override
  String get aiLastLogRequest => 'リクエスト'; [cite: 1]

  @override
  String get aiLastLogResponse => 'レスポンス'; [cite: 1]

  @override
  String get aiLastLogUsage => 'トークン消費'; [cite: 1]

  @override
  String get aiLastLogMessages => 'メッセージ'; [cite: 1]

  @override
  String get aiLastLogError => 'エラー'; [cite: 1]

  @override
  String get aiLastLogHttpCode => 'HTTP ステータス'; [cite: 1]

  @override
  String get aiLastLogLeftText => '左のテキスト'; [cite: 1]

  @override
  String get aiLastLogRightText => '右のテキスト'; [cite: 1]

  @override
  String get aiLastLogAssistantContent => 'モデルレスポンスのコンテンツ'; [cite: 1]

  @override
  String get aiConfigSaveButton => '保存'; [cite: 11]

  @override
  String get aiConfigSaved => 'AI の構成を保存しました'; [cite: 11]

  @override
  String get aiConfigTips => 'AI は各通知のアプリパッケージ、タイトル、コンテンツを受信し、短い左側 (ソース) と右側 (コンテンツ) のテキストを返します。OpenAI 形式の API (DeepSeek、Claude など) と互換性があります。レスポンスがない場合は、デフォルトのロジックにフォールバックします。'; [cite: 11]

  @override
  String get templateAiNotificationIslandName => 'AI Notification Island'; [cite: 11]

  @override
  String get hideDesktopIconTitle => 'デスクトップアイコンを非表示にする'; [cite: 11]

  @override
  String get hideDesktopIconSubtitle => 'アプリのアイコンをランチャーから非表示にします。非表示後は、LSPosed Manager 経由で開くことができます。'; [cite: 11]
}
