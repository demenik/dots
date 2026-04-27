secretPath:
# lua
''
  function()
    local handle = io.popen("git config --get remote.origin.url")
    local remote = handle:read("*a") or ""
    handle:close()

    remote = remote:gsub("%s+", "")
    if remote == "" then
      return nil, nil, "No git remote found in current directory."
    end

    local domain = ""

    -- SSH format
    local _, _, ssh_domain = string.find(remote, "@([^:]+):")
    if ssh_domain then
      domain = ssh_domain
    else
      -- https format
      local _, _, http_domain = string.find(remote, "://([^/]+)/")
      if http_domain then
        domain = http_domain
      end
    end

    if domain == "" then
      return nil, nil, "Could not extract domain from remote URL: " .. remote
    end

    local secret_path = "${secretPath}"
    local f = io.open(secret_path, "r")

    if not f then
      return nil, nil, "Could not open SOPS secret file at: " .. secret_path
    end

    local content = f:read("*a")
    f:close()

    local tokens = {}
    for key, value in string.gmatch(content, "([%w_.-]+)=([^\n]+)") do
      value = value:gsub('^%s*(.-)%s*$', '%1')
      value = value:gsub('^"(.-)"$', '%1')
      tokens[key] = value
    end

    local token = tokens[domain]
    local api_url = "https://" .. domain

    if not token or token == "" then
      return nil, nil, "No token mapped in SOPS secret for domain: " .. domain
    end

    return token, api_url, nil
  end
''
