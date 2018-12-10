#!/bin/bash

file="./sites"
difffile="./diff"

touch $difffile
set newdiff=""

while IFS= read -r site
do
  if [[ $site == *#* ]]; then
    continue
  fi

  isValidSite=$(curl $site --write-out %{http_code} --silent --output /dev/null servername)
  if [[ $isValidSite != 200000 ]]; then
    printf "$site FAILED\n"
  fi

  md5=$(curl -s $site | md5sum | cut -d ' ' -f1)
  found=0

  while IFS= read -r diffline
  do
    diffsite=$(echo "$diffline" | cut -d ' ' -f1)
    diffmd5=$(echo "$diffline" | cut -d ' ' -f2)

    if [[ $site == $diffsite ]]; then
      found=1
      if [[ $diffmd5 != $md5 ]]; then
        printf "$site\n"
      fi

      continue
    fi
  done < $difffile

  if [[ $found == 0 ]]; then
    printf "$site INIT\n"
  fi

  newdiff+="$site $md5 \n"
done < "$file"

echo -e $newdiff > $difffile

index 
