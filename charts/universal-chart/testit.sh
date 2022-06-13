#!/bin/sh -eu
dirname=$(dirname "$0")
tests="$dirname/tests"
rm -rf --one-file-system "$tests"
mkdir -p "$tests"

for filename in "$dirname"/samples/*
do
  echo "Testing $filename"
  basename=$(basename "$filename")
  helm --kube-context="notexisting" template test "$dirname" --values "$filename" |grep -Ev '^ +helm.sh/chart:' > "$tests"/"$basename"
  diff -u "$dirname"/results/"$basename" "$tests"/"$basename"
  echo "OK"
done
