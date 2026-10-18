local results = {}

---@param iterations number
---@param title string | number
---@param func function
local function benchmarkInternal(iterations, title, func)
    local start = os.nanotime()

    for i = 1, iterations do
        func()
    end

    results[#results + 1] = { (os.nanotime() - start) / iterations, title }
end

---@param iterations number
local function showResults(iterations)
    print(('Average results from %d iterations (ms)'):format(iterations))
    table.sort(results, function(a, b) return a[1] < b[1] end)

    for i = 1, #results do
        local result = results[i]
        print(('#%d - %.4f\t(%s)'):format(i, result[1] / 1e6, result[2]))
    end

    table.wipe(results)
end

---@param n number
---@param tbl table<string, function>
function benchmark(n, tbl)
    for k, v in pairs(tbl) do
        benchmarkInternal(n, k, v)
    end

    showResults(n)
end