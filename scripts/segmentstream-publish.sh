#!/bin/bash
set -eux

SRCROOT="$(cd "$(dirname "$0")/.." && pwd)"
GIT_PUSH=${GIT_PUSH:-false}
GIT_URL=git@github.com:segmentstream/argo-helm.git

rm -rf $SRCROOT/output && git clone -b gh-pages $GIT_URL $SRCROOT/output

for dir in $(find $SRCROOT/charts -mindepth 1 -maxdepth 1 -type d);
do
 echo "Processing $dir"
 helm package $dir
done
cp $SRCROOT/*.tgz output/
cd $SRCROOT/output && helm repo index .

cd $SRCROOT/output && git status

if [ "$GIT_PUSH" == "true" ]
then
    cd $SRCROOT/output && git add . && git commit -m "Publish charts" && git push GIT_URL gh-pages
fi
