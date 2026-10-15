{
  # fmUpdate script printing the latest GitHub release version without the leading "v"
  latestRelease = repo: "curl -sL https://api.github.com/repos/${repo}/releases/latest | grep -oP '\"tag_name\": *\"v\\K[^\"]+'";
}
