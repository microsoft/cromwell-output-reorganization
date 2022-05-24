version 1.0


task croro_task {

  input {

  File metadataJsonFile
  File? outDefJsonFile
  String inputDir
  String dockerImage
  String outDir

  }

  String memory="2 GB"
  String threads="1"

  runtime {
    docker: dockerImage
    memory: memory
    cpu: threads
  }

 command <<<

  echo "Reorganizing data, before transfer"

  # copy input data locally using azcopy
  inputPath="~{inputDir}"
  inputPath=("${inputPath/.blob.core.windows.net/}")
  inputPath=("${inputPath/https:\/\//}")
  inputPath=("${inputPath/http:\/\//}")
  acct_and_cont=$(expr "$inputPath" : '^[-/]*\([^?]*\)')    # remove leading "-" and "/", and the SAS token
  acct_and_cont=${acct_and_cont/%\//}    # remove trailing "/"
  container_name=$(echo "$acct_and_cont" | cut -d / -f2-)

  IFS='/' read -r -a path_array <<< "$container_name"

  if [ "${#path_array[@]}" -gt 1 ]; then
    dir_name=$(dirname  "$container_name")
  else
    dir_name="$container_name"
  fi

  mkdir -p /$dir_name
  cd /$dir_name

  # just run azcopy if outDefJsonFile not provided

  if [ -z "~{outDefJsonFile}" ]; then
    azcopy copy "~{inputDir}" "~{outDir}" --recursive
  else
    azcopy copy "~{inputDir}" . --recursive

    # Make temp directory
    mkdir -p temp

    cd temp

    # run Croo to copy all the data
    croo --out-def-json ~{outDefJsonFile} --method copy \
     --out-dir $PWD ~{metadataJsonFile}

    # Remove croo tsv and html before upload
    rm croo*

    # upload all data
    azcopy copy "$PWD/*" "~{outDir}" --recursive
  fi

  >>>

  output {
  }
}

workflow croro_transform_data {

  input {

    File metadataJsonFile
    File? outDefJsonFile
    String inputDir
    String dockerImage
    String outDir

  }

  call croro_task {
      input:
          metadataJsonFile = metadataJsonFile,
          outDefJsonFile = outDefJsonFile,
          inputDir = inputDir,
          outDir = outDir,
          dockerImage = dockerImage
  }

   output {
  }

}
