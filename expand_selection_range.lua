function expandSelectionRange(start, length, text)
    local function isWordChar(char)
        return char:match("[%w_]") ~= nil
    end

    local function isPunctuation(char)
        return char:match("[%p]") ~= nil
    end

    local function expandToWordBoundary(s, e)
        while s > 1 and isWordChar(text:sub(s - 1, s - 1)) do
            s = s - 1
        end
        while e < #text and isWordChar(text:sub(e + 1, e + 1)) do
            e = e + 1
        end
        return s, e
    end

    local function expandToPunctuation(s, e)
        while s > 1 and isPunctuation(text:sub(s - 1, s - 1)) do
            s = s - 1
        end
        while e < #text and isPunctuation(text:sub(e + 1, e + 1)) do
            e = e + 1
        end
        return s, e
    end

    local function expandToWhitespace(s, e)
        while s > 1 and not text:sub(s - 1, s - 1):match("%s") do
            s = s - 1
        end
        while e < #text and not text:sub(e + 1, e + 1):match("%s") do
            e = e + 1
        end
        return s, e
    end

    local s, e = start + 1, start + length

    if length == 0 then
        s, e = expandToWordBoundary(s, e)
    elseif e - s + 1 == e - s + 1 then
        s, e = expandToPunctuation(s, e)
    elseif e - s + 1 < #text - 2 then
        s, e = expandToWhitespace(s, e)
    elseif s > 1 or e < #text then
        s, e = 1, #text
    end

    return {s - 1, e - s + 1}
end

return expandSelectionRange
