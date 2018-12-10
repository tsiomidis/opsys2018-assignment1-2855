targz="./test.tar.gz"
download_dir="./test"
repo_dir="./assignments"

function main () {
  clone_sites_from_tar

  cd $repo_dir

  for dir in $(ls); do
    get_metrics $dir
  done
}

function get_metrics () {
  cd $1 
  dirs=$(find . -mindepth 1 -type d | wc -l) 
  txt=$(find . -type f -name "*.txt" | wc -l)
  other=$(($(find . -mindepth 1 | wc -l) - $txt - $dirs))

  printf "$1:\n"
  printf "Number of directories: $dirs\n"
  printf "Number of txt files : $txt\n"
  printf "Number of other files : $other\n"

  if [ -e ./more ] && [ -e ./dataA.txt ] && [ -e ./more/dataB.txt ] && [ -e ./more/dataC.txt ]; then
    printf "Directory structure is OK.\n"
  else
    printf "Directory structure is NOT OK.\n"
  fi

  cd ..
}

function clone_sites_from_tar () {
  #unzip files to download_dir
  tar -xzf $targz
  #make repo_dir
  mkdir -p $repo_dir

  files=$(find $dir -type f -name "*.txt")

  for filename in $files; do
    while IFS= read -r site
    do
      if [[ $site == *https* ]]; then
        cd $repo_dir
        git clone -q $site

        ret=$?
        if ! test "$ret" -eq 0
        then
          printf "$site: Cloning FAILED"
          cd ..
          break
        fi
        cd ..

        printf "$site: Cloning OK"
        #to keep only first matching line
        break
      fi
    done < $filename
  done
}

main
