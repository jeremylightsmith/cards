def find_tests(dir_name = '.')
    tests = []
    Dir.foreach(dir_name) {|file_name|
        if file_name[0..0] != '.' # ignore '.', '..', and hidden dirs
            full_name = "#{dir_name}/#{file_name}"
            if File.directory?(full_name)
                tests += find_tests(full_name)
            elsif file_name[-8..-1] == '_test.rb'
                tests << full_name
            end
        end
    }
    tests
end

find_tests.each {|test| require test}