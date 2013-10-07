# encoding: utf-8
module Pairtree
  class Identifier
    ENCODE_REGEX = Regexp.compile("[\"*+,<=>?\\\\^|]|[^\x21-\x7e]", nil)
    DECODE_REGEX = Regexp.compile("\\^(..)", nil)

    ##
    # Encode special characters within an identifier
    # @param [String] id The identifier
    def self.encode id
      id.gsub(ENCODE_REGEX) { |c| char2hex(c) }.tr('/:.', '=+,')
    end

    ##
    # Decode special characters within an identifier
    # @param [String] id The identifier
    def self.decode id
      input = id.tr('=+,', '/:.').bytes.to_a
      output = []
      while input.first
        if input.first == 94
          h = []
          input.shift
          h << input.shift
          h << input.shift
          output << h.pack('c*').hex
        else
          output << input.shift
        end
      end
      output.pack('c*').force_encoding('UTF-8')
    end

    ##
    # Convert a character to its pairtree hexidecimal representation
    # @param [Char] c The character to convert
    def self.char2hex c
      c.unpack('H*')[0].scan(/../).map { |x| "^#{x}"}.join('')
    end

    ##
    # Convert a pairtree hexidecimal string to its character representation
    # @param [String] h The hexidecimal string to convert
    def self.hex2char h
       '' << h.delete('^').hex
    end
  end
end
