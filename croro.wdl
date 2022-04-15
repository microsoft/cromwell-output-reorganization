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
    preemptible: true
  }

 command <<<

  if [ -z ~{outDefJsonFile} ]
  then
      echo "No reorganizing is required"
      azcopy copy "~{inputDir}" "~{outDir}" --recursive
  else
      echo "Reorganizing data, before transfer"

      # copy input data locally using azcopy
      inputPath=~{inputDir}
      inputPath=("${inputPath/https:\/\//}")
      inputPath=("${inputPath/http:\/\//}")
      acct_and_cont=$(expr "$inputPath" : '^[-/]*\([^?]*\)')    # remove leading "-" and "/", and the SAS token
      acct_and_cont=${acct_and_cont/%\//}    # remove trailing "/"
      container_name=$(echo "$acct_and_cont" | cut -d / -f 2)
      cd /$container_name

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
