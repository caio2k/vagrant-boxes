# Build images

$template_file="./debian-10-devel.json"

if ((Test-Path -Path "$template_file")) {
  Write-Output "Template file found"
  try {
    $env:PACKER_LOG=$packer_log
    packer build --force -only="hyperv" "$template_file"
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