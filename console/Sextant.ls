
  do ->

    { string-from-code-point, camel-case } = dependency 'native.String'
    { Num, Bool } = dependency 'primitive.Type'

    sextant-key-suffix = <[
      1 2 12 3 13 23 123
      4 14 24 124 34 134 234 1234
      5 15 25 125 35 235 1235 45 145 245 1245 345 1345 2345 12345
      6 16 26 126 36 136 236 1236 46 146 1246 346 1346 2346 12346 56 156 256 1256 356 1356 2356 12356 456 1456 2456 12456 3456 13456 23456
    ]>

    sextant-code = -> 0x1fb00 + Num it

    sextant-chars = { [ ("sextant-#key-suffix"), (string-from-code-point sextant-code index) ] for key-suffix, index in sextant-key-suffix }

    sextant-for-key = (key) ->

      switch key

        | 'sextant-' => ' '
        | 'sextant-123456' => string-from-code-point 0x2588

        else sextant-chars[ key ]

    new-sextant-char = ->

      bits = void

      clear = !-> bits := [ off for til 6 ]

      clear!

      #

      index = (x, y) -> y + x * 2

      bit-suffix = (bit, bit-index) -> if bit then "#{ bit-index + 1 }" else ""

      key-suffix = -> [ (bit-suffix bit, bit-index) for bit, bit-index in bits ] * ''

      #

      get: (x, y) -> Num x ; Num y ; bit-index = index x, y ; return void if bit-index > matrix.length ; bits[ bit-index ]
      set: (x, y, bit = on) !-> Num x ; Num y ; Bool bit ; return void if @get[ x, y ] is void ; bits[ (index x, y) ] := bit

      unset: (x, y) !-> @set x, y, off

      clear: -> clear!

      to-string: -> key = "sextant-#{ key-suffix! }" ; sextant-for-key key

    #

    sextant-char-from-string-list = (strings) ->

      char = new-sextant-char!

      for string, row in strings

        break if row >= 3

        for bit, column in string / ''

          continue if column >= 2

          if bit is '*'

            char.set row, column

      char

    {
      sextant-chars,
      new-sextant-char,
      sextant-char-from-string-list
    }
