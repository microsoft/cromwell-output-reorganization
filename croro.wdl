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
      inputPath="https://vsmcf2817752f18c0.blob.core.windows.net/cromwell-executions/GenomeAssembly/4aa78d2e-318c-4f52-b61f-142c6b69392b?sp=racwl&st=2022-04-15T16:16:35Z&se=2022-04-16T00:16:35Z&spr=https&sv=2020-08-04&sr=c&sig=HsyLWKr6bLt%2BCm0cSgo9beCYKZ2QS7ONH7vGdmDlmIg%3D"
      inputPath=("${inputPath/.blob.core.windows.net/}")
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
