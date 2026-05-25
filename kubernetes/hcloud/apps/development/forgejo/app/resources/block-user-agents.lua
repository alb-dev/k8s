function envoy_on_request(request_handle)
  local ua = request_handle:headers():get("user-agent") or ""
  local ua_lower = string.lower(ua)

  local ai_crawlers = {
    "gptbot", "oai-searchbot", "chatgpt-user",   -- OpenAI
    "google-extended", "googleother",            -- Google AI
    "meta-externalagent", "meta-webindexer",     -- Meta
    "meta-externalfetcher", "facebookbot",
    "amazonbot",                                 -- Amazon
    "applebot-extended",                         -- Apple AI
    "bytespider",                                -- ByteDance
    "perplexitybot", "perplexity-user",          -- Perplexity
    "ccbot",                                     -- Common Crawl
    "cohere-ai",                                 -- Cohere
    "youbot",                                    -- You.com
    "diffbot",                                   -- Diffbot
    "ai2bot",                                    -- Allen Institute
    "imagesiftbot",                              -- Hive AI
    "omgili", "omgilibot",                       -- Webz.io
    "timpibot",                                  -- Timpi
    "duckassistbot",                             -- DuckDuckGo AI
    "pangubot",                                  -- Huawei
  }

  for _, bot in ipairs(ai_crawlers) do
    if string.find(ua_lower, bot, 1, true) then
      request_handle:respond({[":status"] = "200"}, "")
      return
    end
  end
end

function envoy_on_response(response_handle)
end