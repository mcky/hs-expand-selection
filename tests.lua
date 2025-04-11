local expandSelectionRange = require("expand_selection_range")

function assertSelection(start, length, text, expected)
    local expanded = expandSelectionRange(start, length, text)
    local expandedSubstring = text:sub(expanded[1] + 1, expanded[1] + expanded[2])
    local expectedSubstring = text:sub(expected[1] + 1, expected[1] + expected[2])

    lt.assert_equal(expected, expanded,
        string.format("Expected: `%s` but got: `%s` (expected substring: '%s', expanded substring: '%s')",
            table.concat(expected, ", "), table.concat(expanded, ", "), expectedSubstring, expandedSubstring))

    -- if expanded[1] ~= expected[1] or expanded[2] ~= expected[2] then
    -- 	error(
    -- 		string.format(
    -- 			"Expected: `%s` but got: `%s` (expected substring: '%s', expanded substring: '%s')",
    -- 			table.concat(expected, ", "),
    -- 			table.concat(expanded, ", "),
    -- 			expectedSubstring,
    -- 			expandedSubstring
    -- 		),
    -- 		2
    -- 	)
    -- end
end

function assert_selection_2(start, length, text, expected)
    local expanded = expandSelectionRange(start, length, text)
    local expandedSubstring = text:sub(expanded[1] + 1, expanded[1] + expanded[2])
    local expectedSubstring = text:sub(expected[1] + 1, expected[1] + expected[2])

    lt.assert_equal(expected, expanded,
        string.format("Expected: `%s` but got: `%s` (expected substring: '%s', expanded substring: '%s')",
            table.concat(expected, ", "), table.concat(expanded, ", "), expectedSubstring, expandedSubstring))

    -- if expanded[1] ~= expected[1] or expanded[2] ~= expected[2] then
    -- 	error(
    -- 		string.format(
    -- 			"Expected: `%s` but got: `%s` (expected substring: '%s', expanded substring: '%s')",
    -- 			table.concat(expected, ", "),
    -- 			table.concat(expanded, ", "),
    -- 			expectedSubstring,
    -- 			expandedSubstring
    -- 		),
    -- 		2
    -- 	)
    -- end
end

-- function test_addition()
--   assertSelection(10, 0, "(this sentence.has spaces and punctuation)", { 6, 8 }) -- "sentence"
--   assertSelection(6, 8, "(this sentence.has spaces and punctuation)", { 6, 9 })  -- "sentence."
--   assertSelection(6, 9, "(this sentence.has spaces and punctuation)", { 6, 12 }) -- "sentence.has"
--   assertSelection(6, 12, "(this sentence.has spaces and punctuation)", { 1, 40 }) -- "this sentence.has spaces and punctuation"
--   assertSelection(1, 40, "(this sentence.has spaces and punctuation)", { 0, 42 }) -- "(this sentence.has spaces and punctuation)"
--   assertSelection(0, 42, "(this sentence.has spaces and punctuation)", { 0, 42 }) -- "(this sentence.has spaces and punctuation)"
-- end

local helpers = {}

function helpers.get_cursor(text)
    local idx = string.find(text, "|", 1, true)

    if (not idx) then
        return nil
    end

    return idx
end

function helpers.get_selection(text)
    local start_idx = string.find(text, "[", 1, true)
    local end_idx = string.find(text, "]", 1, true)
    if (not start_idx or not end_idx) then
        return nil
    end

    local len = end_idx - 1 - start_idx

    return {start_idx, len}
end

function string_insert(str1, str2, pos)
    return str1:sub(1, pos) .. str2 .. str1:sub(pos + 1)
end

function helpers.insert_selection(text, start_index, len)
    local out = text
    out = string_insert(out, "[", start_index - 1)
    out = string_insert(out, "]", start_index + len)
    return out
end

describe("test utils", function()
    it("get_cursor returns cursor index", function()
        assert.are.same(helpers.get_cursor("|"), 1)
        assert.are.same(helpers.get_cursor("some ot|her text"), 8)
        assert.are.same(helpers.get_cursor("some text"), nil)
    end)

    it("get_selection returns selection start and length", function()
        assert.are.same({1, 0}, helpers.get_selection("[]"))
        assert.are.same({6, 5}, helpers.get_selection("some [other] text"))
        assert.are.same({1, 15}, helpers.get_selection("[some other text]"))
        assert.are.same(nil, helpers.get_selection("some text"))
    end)

    it("insert_selection inserts at given indices", function()
        assert.are.same("[]", helpers.insert_selection("", table.unpack({1, 0})))

        assert.are.same("some [other] text", helpers.insert_selection("some other text", table.unpack({6, 5})))
        assert.are.same("[some other text]", helpers.insert_selection("some other text", table.unpack({1, 15})))
    end)
end)

describe("expand_selection_range", function()
    it("foo", function()
        local text_in = "this is so|me text"
        local text_out = "this is [some] text"
        -- @TODO: should cursor be the same as a 0-len selection? e.g. {n, n}
        local cursor = helpers.get_cursor(text_in)

        local expanded_range = expandSelectionRange(cursor, 1, text_in)

        local expected_sel = helpers.get_selection(text_out)
        print("exp", expected_sel[1], expected_sel[2])

        assert.are.same("foo", expanded_range)
    end)
end)
