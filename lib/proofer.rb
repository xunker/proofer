require "proofer/version"

class Proofer
  attr_reader :failure, :markdown
  attr_accessor :debug_mode

  def passed?
    process_markdown
    !failure
  end

  def failed?
    process_markdown
    !!failure
  end

  def debug_mode?
    !!debug_mode
  end

  def self.from_file(filename)
    self.new(File.open(filename, 'r').read)
  end

  def initialize(markdown)
    @markdown = markdown
    @tested = false
  end

  def self.from_string(markdown)
    self.new(markdown)
  end

protected

  def log(msg)
    return unless debug_mode?
    msg.split("\n").each do |line|
      puts "LOG: #{line}"
    end
  end

  def contains_ruby_block(string)
    string =~ /```ruby/
  end

  def contains_assertion(string)
    string =~ /^\s*\#\s*\=\>\s*.*$/ # "  # => xxx"
  end

  def process_markdown
    return if @tested

    if contains_ruby_block(@markdown )
      
      @markdown.scan(/```ruby(.+?)```/m).each do |code_block_arr|
        code_block = code_block_arr[0]

        sub_blocks = [[]]
        if contains_assertion(code_block)
          
          b = binding
          code_block.split("\n").each do |bl|

            bl.strip!
            next if bl.size < 1
            if bl =~ /^\s*\#\s*\=\>\s*.*$/
              sub_blocks.last << bl
              sub_blocks << []
            else
              sub_blocks.last << bl
            end

          end
          sub_blocks.each_with_index do |sub_block, index|
            next unless sub_block.last =~ /^\s*\#\s*\=\>\s*.*$/
            expected = sub_block.last.match(/^\s*\#\s*\=\>\s*(.*)$/)[1]
            bbb = "retval#{index} = (\n" + sub_block[0..sub_block.size].join("\n") + "\n)\n"

            bbb << "expected#{index} = (" + expected + ")\n"

            bbb << "assert(retval#{index}, expected#{index})"
            log bbb
            retval = eval(bbb, b)
            log "works? #{!!retval}"
            log '-'*40
            @failure = !retval
          end
        end

      end
    end
  end

  def assert(value, expected)
    log "ASSERT: #{value.inspect} == #{expected.inspect}: #{value == expected}"
    value == expected
  end

end
