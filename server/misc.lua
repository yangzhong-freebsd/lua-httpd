local misc = misc or {}

function misc.splitString(str, char)
        local split_list = {}

        for match in str:gmatch("[^" .. char .. "]+") do
                table.insert(split_list, match)
        end
        return split_list
end

return misc
