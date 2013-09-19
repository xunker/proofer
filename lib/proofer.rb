require "proofer/version"

class Proofer
  attr_reader :failure, :markdown

  def passed?
    !failure
  end

  def failed?
    !!failure
  end

  def self.from_file(filename)
    self.new(File.open(filename, 'r').read)
  end

  def initialize(markdown)
    @markdown = markdown

    process_markdown
  end

  def self.from_string(markdown)
    self.new(markdown)
  end

protected

  def process_markdown
    if @markdown =~ /```ruby/
      
      @markdown.scan(/```ruby(.+?)```/m).each do |code_block_arr|
        code_block = code_block_arr[0]

        blocks = [[]]
        if code_block =~ /^\s*\#\s*\=\>\s*.*$/ # "  # => xxx"
          
          b = binding
          code_block.split("\n").each do |bl|

            bl.strip!
            next if bl.size < 1
            if bl =~ /^\s*\#\s*\=\>\s*.*$/
              blocks.last << bl
              blocks << []
            else
              blocks.last << bl
            end

          end
          blocks.each do |bb|
            rand = rand(1000)
            next unless bb.last =~ /^\s*\#\s*\=\>\s*.*$/
            expected = bb.last.match(/^\s*\#\s*\=\>\s*(.*)$/)[1]
            bbb = "retval#{rand} = (\n" + bb[0..-2].join("\n") + "\n)\n"

            bbb << "expected#{rand} = (" + expected + ")\n"

            bbb << "assert(retval#{rand}, expected#{rand})"
            puts bbb
            retval = eval(bbb, b)
            puts "works? #{!!retval}"
            puts '-'*80
            @failure = !retval
          end
        end

      end
    end
  end

  # def initialize(filename)
  #   file = File.open(filename, 'r')
  #   contents = file.read
  #   if contents =~ /```ruby/
  #     b = binding
  #     contents.scan(/```ruby(.+?)```/m).each do |code_block_arr|
  #       code_block = code_block_arr[0]

  #       blocks = [[]]
  #       if code_block =~ /^\s*\#\s*\=\>\s*.*$/ # "  # => xxx"
          
  #         code_block.split("\n").each do |bl|
  #           bl.strip!
  #           next if bl.size < 1
  #           if bl =~ /^\s*\#\s*\=\>\s*.*$/
  #             blocks.last << bl
  #             blocks << []
  #           else
  #             blocks.last << bl
  #           end

  #         end
  #         blocks.each do |bb|
  #           rand = rand(1000)
  #           next unless bb.last =~ /^\s*\#\s*\=\>\s*.*$/
  #           expected = bb.last.match(/^\s*\#\s*\=\>\s*(.*)$/)[1]
  #           bbb = "retval#{rand} = (\n" + bb[0..-2].join("\n") + "\n)\n"

  #           bbb << "expected#{rand} = (" + expected + ")\n"

  #           bbb << "assert(retval#{rand}, expected#{rand})"
  #           puts bbb
  #           retval = eval(bbb, b)
  #           puts "works? #{!!retval}"
  #           puts '-'*80
  #           @passes = !!retval
  #         end
  #       end

  #     end
  #   end
  # end

  def assert(value, expected)
    puts "ASSERT: #{value.inspect} == #{expected.inspect}: #{value == expected}"
    value == expected
  end

end
