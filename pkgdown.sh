#!/bin/bash
set -e
[ -z "${GITHUB_PAT}" ] && exit 0
echo "Environment variables:"
echo "  PATH: ${PATH}"
echo "  TRAVIS_BRANCH: ${TRAVIS_BRANCH}"
echo "  TRAVIS_PULL_REQUEST: ${TRAVIS_PULL_REQUEST}"
echo "  TRAVIS_PULL_REQUEST_BRANCH: ${TRAVIS_PULL_REQUEST_BRANCH}"
if [[ "${TRAVIS_BRANCH}" == "master" && "${TRAVIS_PULL_REQUEST}" == "false" ]]
then
  echo "Deploying to production."
  git config --global user.email "will.landau@gmail.com"
  git config --global user.name "wlandau"
  git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git gh-pages
  cd gh-pages
  ls -a | grep -Ev "^\.$|^..$|^\.git$" | xargs rm -rf
  cp -r ../docs/* ./
  git add *
  git commit -am "Update pkgdown site" || true
  git push -q origin gh-pages
fi
