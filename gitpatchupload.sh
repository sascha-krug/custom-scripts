#!/usr/bin/env bash
ISSUE_NAME=$1
if [[ "$ISSUE_NAME" != "" ]]; then
	CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
	git diff origin/"${CURRENT_BRANCH}" > "${ISSUE_NAME}.patch"
	gsutil cp "${ISSUE_NAME}.patch" gs://drupal-patches
	gsutil setmeta -h "Content-Type:text/plain" -h "Cache-Control:public" "gs://drupal-patches/${ISSUE_NAME}.patch"
	gsutil acl ch -u AllUsers:R "gs://drupal-patches/${ISSUE_NAME}.patch"
	curl "https://storage.googleapis.com/drupal-patches/${ISSUE_NAME}.patch"
else
	echo No issue name provided
fi
