# Cromwell Output Reorganization

This repository is an example of WDL workflow for organizing outputs from [Cromwell](https://github.com/broadinstitute/cromwell/), specifically Cromwell On Azure.<br/>

Learn more about using Azure for your Cromwell WDL workflows on our GitHub repo! - [Cromwell on Azure](https://github.com/microsoft/CromwellOnAzure).<br/>

This example takes advantage of [Croo](https://github.com/ENCODE-DCC/croo), a python package to reorganize outputs.

Here, you can find the WDL files and an example inputs JSON files.

The `croro.trigger.json` trigger files is a template trigger. You can start the workflow on your instance of Cromwell on Azure, using [these instructions](https://github.com/microsoft/CromwellOnAzure/blob/master/docs/managing-your-workflow.md/#Start-your-workflow).



## croro:
This WDL is the Cromwell Output Reorganization (croro) workflow.
This example shows the minimum options that must be specified to perform an reorganization and move of data other Storage accounts and Containers.


#### Requirements/expectations
-  Metdata Json, Path for a metadata.json for a workflow
- [Output definition JSON](https://github.com/ENCODE-DCC/croo/blob/master/docs/OUT_DEF_JSON.md) file for a WDL file corresponding to the specified metadata.json file [Optional]
- Input Directory, URL for Azure Blob Storage with shared access signature token
- Output Directory,  URL for Azure Blob Storage with shared access signature token
- Docker image to run with AzCopy and Croo

#### Outputs
- None

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft
trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
