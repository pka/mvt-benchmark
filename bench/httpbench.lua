request = function()
    path = "/ne_countries/7/69/47.pbf"
    return wrk.format(nil, path)
end


done = function(summary, latency, requests)
  -- open output file
  local fn = "/bench/results/results_http.csv"
  local f = io.open(fn,"r")
  local newcsv = (f==nil)
  if f~=nil then
    io.close(f)
  end

  f = io.open(fn, "a+")
  if newcsv then
    f:write("#time_started,software,connections,min_requests,max_requests,mean_requests,min_latency,max_latency,mean_latency,stdev,50th,90th,99th,99.999th,duration,requests,bytes,request_per_sec,connect_errors,read_errors,write_errors,status_errors,timeouts\n")
  end
  f:write(string.format("%s,%s,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%d,%d,%f,%d,%d,%d,%d,%d\n",
    os.date("!%Y-%m-%dT%TZ"),
    os.getenv("SW"),
    os.getenv("CONNECTIONS"),
    requests.min,   -- per-thread request rate
    requests.max,
    requests.mean,
    latency.min,    -- per-request latency
    latency.max,
    latency.mean,
    latency.stdev,

    latency:percentile(50),     -- 50percentile latency
    latency:percentile(90),     -- 90percentile latency
    latency:percentile(99),     -- 99percentile latency
    latency:percentile(99.999), -- 99.999percentile latency

    summary["duration"],          -- duration of the benchmark
    summary["requests"],          -- total requests during the benchmark
    summary["bytes"],             -- total received bytes during the benchmark

    summary["requests"]/(summary["duration"]/1000000), -- Total requests/sec

    summary["errors"]["connect"], -- total socket connection errors
    summary["errors"]["read"],    -- total socket read errors
    summary["errors"]["write"],   -- total socket write errors
    summary["errors"]["status"],  -- total socket write errors
    summary["errors"]["timeout"]  -- total request timeouts
    ))

  f:close()
end
