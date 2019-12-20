holidays = {}

holidays.modname = minetest.get_current_modname()
holidays.modpath = minetest.get_modpath(holidays.modname)

function holidays.log(level, message, ...)
    return minetest.log(level, ("[%s] %s"):format(modname, message:format(...)))
end

--[[
    local time = os.time() -- a number
    os.date("*t", time) -- {year = 1998, month = 9, day = 16, yday = 259, wday = 4,
     hour = 23, min = 48, sec = 10, isdst = false}
]]--

local function date_lte(d1, d2)
    return d1.month < d2.month or (d1.month == d2.month and d1.day <= d2.day)
end


local function date_range_predicate(start, stop)
    if date_lte(start, stop) then
        return function(date)
            return date_lte(start, date) and date_lte(date, stop)
        end
    else
        return function(date)
            return date_lte(date, stop) or date_lte(start, date)
        end
    end
end

holidays.schedule = {
    christmas = date_range_predicate({month=12, day=24}, {month=12, day=26}),
    easter = date_range_predicate({month=4, day=11}, {month=4, day=13}),
    july4 = date_range_predicate({month=7, day=3}, {month=7, day=5}),
    winter = date_range_predicate({month=12, day=21}, {month=3, day=21})
}

function holidays.is_holiday_active(holiday_name)
    local time = os.time()
    local date = os.date("*t", time)
    local predicate = holidays.schedule[holiday_name]
    return predicate and predicate(date)
end

dofile(holidays.modpath .. "/christmas.lua")
dofile(holidays.modpath .. "/easter.lua")
dofile(holidays.modpath .. "/july4.lua")
dofile(holidays.modpath .. "/winter.lua")
