# Build images, supply the template name as the argument

#first argument should be the template file, second is the loglevel
param(
  [string] $template_file="./ubuntu-1804.json",
  [int] $packer_log=0
)

if ((Test-Path -Path "$template_file")) {
  $env:PACKER_LOG=$packer_log
  $env:builddate=Get-Date -Format 'yyyyMMdd'
  Write-Output "launching packer to build $template_file at $env:builddate"
  try {
    packer build --force -only="hyperv" -var "BUILDDATE=$env:builddate" -var-file="secret.json" "$template_file"
  }
  catch {
    Write-Output "Packer build failed, exiting."
    exit (-1)
  }
}
else {
  Write-Output "Template or Var file not found - exiting"
  exit (-1)
}
