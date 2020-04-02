function ()
    local queue = WA_STARFALL
    if queue and queue.head + 0 <= queue.tail then
        local foo = queue.truck[queue.head + 0]
        return foo.duration, foo.expiration
    else
        return 0.0, 0.0
    end
end
