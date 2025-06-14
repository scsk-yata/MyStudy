def count_space(str)
    count = 0
    str.length.times do |i|
        if str[i] == ' '
            count += 1
        end
    end
    count
end

puts count_space("This is a pen.")