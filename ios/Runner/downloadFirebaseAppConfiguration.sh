#!/bin/bash

# 各環境のFirebase構成ファイル(GoogleService-Info.plist)をダウンロードするスクリプト。最初に環境構築時に実行する

# 関数: plistファイルの存在確認
check_plist_file() {
    if [ ! -f "$1" ]; then
        local ENVIRONMENT=$2
        echo "error: Google Service Info plist file not found for configuration ${ENVIRONMENT}"
        exit 1
    fi
}

# 環境ごとの構成ファイルをダウンロード
download_config() {
    local ENVIRONMENT=$1
    local APP_ID=$2
    local PROJECT_ID=$3
    local OUTPUT_FILE="ios/Runner/GoogleService-Info-${ENVIRONMENT}.plist"

    # 既存のファイルを削除
    rm -f $OUTPUT_FILE

    # Firebase CLIを使用して構成ファイルをダウンロード
    firebase apps:sdkconfig IOS $APP_ID --project $PROJECT_ID --out $OUTPUT_FILE

    # plistファイルの存在確認
    check_plist_file $OUTPUT_FILE $ENVIRONMENT
}

# 各環境の構成ファイルをダウンロード
# 必要な値はGit管理せず、実行時の環境変数で渡す。
: "${FIREBASE_STAGING_PROJECT_ID:?FIREBASE_STAGING_PROJECT_ID is required}"
: "${FIREBASE_STAGING_IOS_APP_ID:?FIREBASE_STAGING_IOS_APP_ID is required}"
: "${FIREBASE_PRODUCT_PROJECT_ID:?FIREBASE_PRODUCT_PROJECT_ID is required}"
: "${FIREBASE_PRODUCT_IOS_APP_ID:?FIREBASE_PRODUCT_IOS_APP_ID is required}"

echo "==== stg ===="
download_config homeStaging "$FIREBASE_STAGING_IOS_APP_ID" \
  "$FIREBASE_STAGING_PROJECT_ID"

echo "==== prod ===="
download_config homeProduct "$FIREBASE_PRODUCT_IOS_APP_ID" \
  "$FIREBASE_PRODUCT_PROJECT_ID"
