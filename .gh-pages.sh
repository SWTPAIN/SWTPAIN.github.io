stack exec site clean
stack exec site build
git checkout -b master --track origin/master
cp -a _site/. .
git add -A
git commit -m "Publish."
git push origin master:master
git checkout develop
git branch -D master
