#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.8.1
# from Racc grammar file "grammar.y".
#

require 'racc/parser.rb'

  require_relative 'nodes'
  require_relative 'lexer'


module Zaid
  class Parser < Racc::Parser
    include Nodes

module_eval(<<'...end grammar.y/module_eval...', 'grammar.y', 164)
  def initialize
    @lexer = Lexer.new
  end

  def parse(code, show_tokens: false)
    @tokens = @lexer.tokenize(code)

    puts @tokens.inspect if show_tokens

    do_parse
  end

  def next_token
    token = @tokens.shift

    return token unless token && token[0] == :COMMENT

    next_token
  end
...end grammar.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
    29,    32,    27,    78,    17,    23,    20,    25,    30,    79,
    52,    53,    28,    17,    24,    19,    50,    21,    49,    22,
    31,    29,    26,    27,    54,    57,    23,    20,    25,    30,
    18,    59,    34,    28,    17,    24,    19,    16,    21,    18,
    22,    31,    29,    26,    27,    80,    49,    23,    20,    25,
    30,    85,    34,    84,    28,    96,    24,    19,    16,    21,
    18,    22,    31,    98,    26,    34,    95,    45,    46,    29,
    34,    27,    86,    17,    23,    20,    25,    30,    89,    16,
    74,    28,    86,    24,    19,    86,    21,    86,    22,    31,
    29,    26,    27,    97,    86,    23,    20,    25,    30,    18,
   100,    86,    28,   nil,    24,    19,    16,    21,   nil,    22,
    31,    29,    26,    27,   nil,   nil,    23,    20,    25,    30,
   nil,   nil,   nil,    28,   nil,    24,    19,    16,    21,   nil,
    22,    31,    29,    26,    27,   nil,   nil,    23,    20,    25,
    30,   nil,   nil,   nil,    28,   nil,    24,    19,    16,    21,
   nil,    22,    31,    29,    26,    27,   nil,   nil,    23,    20,
    25,    30,   nil,   nil,   nil,    28,   nil,    24,    19,    16,
    21,   nil,    22,    31,    29,    26,    27,   nil,   nil,    23,
    20,    25,    30,   nil,   nil,   nil,    28,   nil,    24,    19,
    16,    21,   nil,    22,    31,    29,    26,    27,   nil,   nil,
    23,    20,    25,    30,   nil,   nil,   nil,    28,   nil,    24,
    19,    16,    21,   nil,    22,    31,    29,    26,    27,   nil,
   nil,    23,    20,    25,    30,   nil,   nil,   nil,    28,   nil,
    24,    19,    16,    21,   nil,    22,    31,    29,    26,    27,
   nil,   nil,    23,    20,    25,    30,   nil,   nil,   nil,    28,
   nil,    24,    19,    16,    21,   nil,    22,    31,    29,    26,
    27,   nil,   nil,    23,    20,    25,    30,   nil,   nil,   nil,
    28,   nil,    24,    19,    16,    21,   nil,    22,    31,    29,
    26,    27,   nil,   nil,    23,    20,    25,    30,   nil,   nil,
   nil,    28,   nil,    24,    19,    16,    21,   nil,    22,    31,
    29,    26,    27,   nil,   nil,    23,    20,    25,    30,   nil,
   nil,   nil,    28,   nil,    24,    19,    16,    21,   nil,    22,
    31,    29,    26,    27,   nil,   nil,    23,    20,    25,    30,
   nil,   nil,   nil,    28,   nil,    24,    19,    16,    21,   nil,
    22,    31,    29,    26,    27,   nil,   nil,    23,    20,    25,
    30,   nil,   nil,   nil,    28,   nil,    24,    19,    16,    21,
   nil,    22,    31,    29,    26,    27,   nil,   nil,    23,    20,
    25,    30,   nil,   nil,   nil,    28,   nil,    24,    19,    16,
    21,   nil,    22,    31,    29,    26,    27,   nil,   nil,    23,
    20,    25,    30,   nil,   nil,   nil,    28,   nil,    24,    19,
    16,    21,   nil,    22,    31,    29,    26,    27,   nil,   nil,
    23,    20,    25,    30,   nil,   nil,   nil,    28,   nil,    24,
    19,    16,    21,   nil,    22,    31,    29,    26,    27,   nil,
   nil,    23,    20,    25,    30,   nil,   nil,   nil,    28,   nil,
    24,    19,    16,    21,   nil,    22,    31,    29,    26,    27,
   nil,   nil,    23,    20,    25,    30,   nil,   nil,   nil,    28,
   nil,    24,    19,    16,    21,   nil,    22,    31,    29,    26,
    27,   nil,   nil,    23,    20,    25,    30,   nil,   nil,   nil,
    28,   nil,    24,    19,    16,    21,   nil,    22,    31,    34,
    26,    45,    46,    43,    44,    40,    42,    39,    41,    37,
    38,    36,    35,   nil,    81,    16,    72,    34,   nil,    45,
    46,    43,    44,    40,    42,    39,    41,    37,    38,    36,
    35,    82,   nil,   nil,    34,   nil,    45,    46,    43,    44,
    40,    42,    39,    41,    37,    38,    36,    35,    34,   nil,
    45,    46,    43,    44,    40,    42,    39,    41,    37,    38,
    36,    35,    34,   nil,    45,    46,    43,    44,    40,    42,
    39,    41,    37,    38,    36,    35,    34,   nil,    45,    46,
    43,    44,    40,    42,    39,    41,    37,    38,    36,    35,
    34,   nil,    45,    46,    43,    44,    40,    42,    39,    41,
    37,    38,    36,    35,    34,   nil,    45,    46,    43,    44,
    40,    42,    39,    41,    37,    38,    36,    35,    34,   nil,
    45,    46,    43,    44,    40,    42,    39,    41,    37,    38,
    36,    35,    34,   nil,    45,    46,    43,    44,    40,    42,
    39,    41,    37,    38,    36,    34,   nil,    45,    46,    43,
    44,    40,    42,    39,    41,    37,    38,    34,   nil,    45,
    46,    43,    44,    40,    42,    39,    41,    34,   nil,    45,
    46,    43,    44,    40,    42,    39,    41,    34,   nil,    45,
    46,    43,    44,    34,   nil,    45,    46,    43,    44,    34,
   nil,    45,    46,    43,    44,    34,   nil,    45,    46,    43,
    44,    34,   nil,    45,    46 ]

racc_action_check = [
     0,     1,     0,    53,     2,     0,     0,     0,     0,    53,
    27,    28,     0,     0,     0,     0,    25,     0,    25,     0,
     0,    86,     0,    86,    29,    32,    86,    86,    86,    86,
     2,    34,    51,    86,    86,    86,    86,     0,    86,     0,
    86,    86,    49,    86,    49,    54,    59,    49,    49,    49,
    49,    75,    70,    75,    49,    88,    49,    49,    86,    49,
    86,    49,    49,    94,    49,    68,    88,    68,    68,    16,
    71,    16,    78,    94,    16,    16,    16,    16,    79,    49,
    49,    16,    80,    16,    16,    81,    16,    82,    16,    16,
    26,    16,    26,    91,    95,    26,    26,    26,    26,    94,
    96,    97,    26,   nil,    26,    26,    16,    26,   nil,    26,
    26,    30,    26,    30,   nil,   nil,    30,    30,    30,    30,
   nil,   nil,   nil,    30,   nil,    30,    30,    26,    30,   nil,
    30,    30,    31,    30,    31,   nil,   nil,    31,    31,    31,
    31,   nil,   nil,   nil,    31,   nil,    31,    31,    30,    31,
   nil,    31,    31,    33,    31,    33,   nil,   nil,    33,    33,
    33,    33,   nil,   nil,   nil,    33,   nil,    33,    33,    31,
    33,   nil,    33,    33,    35,    33,    35,   nil,   nil,    35,
    35,    35,    35,   nil,   nil,   nil,    35,   nil,    35,    35,
    33,    35,   nil,    35,    35,    36,    35,    36,   nil,   nil,
    36,    36,    36,    36,   nil,   nil,   nil,    36,   nil,    36,
    36,    35,    36,   nil,    36,    36,    37,    36,    37,   nil,
   nil,    37,    37,    37,    37,   nil,   nil,   nil,    37,   nil,
    37,    37,    36,    37,   nil,    37,    37,    38,    37,    38,
   nil,   nil,    38,    38,    38,    38,   nil,   nil,   nil,    38,
   nil,    38,    38,    37,    38,   nil,    38,    38,    39,    38,
    39,   nil,   nil,    39,    39,    39,    39,   nil,   nil,   nil,
    39,   nil,    39,    39,    38,    39,   nil,    39,    39,    40,
    39,    40,   nil,   nil,    40,    40,    40,    40,   nil,   nil,
   nil,    40,   nil,    40,    40,    39,    40,   nil,    40,    40,
    41,    40,    41,   nil,   nil,    41,    41,    41,    41,   nil,
   nil,   nil,    41,   nil,    41,    41,    40,    41,   nil,    41,
    41,    42,    41,    42,   nil,   nil,    42,    42,    42,    42,
   nil,   nil,   nil,    42,   nil,    42,    42,    41,    42,   nil,
    42,    42,    43,    42,    43,   nil,   nil,    43,    43,    43,
    43,   nil,   nil,   nil,    43,   nil,    43,    43,    42,    43,
   nil,    43,    43,    44,    43,    44,   nil,   nil,    44,    44,
    44,    44,   nil,   nil,   nil,    44,   nil,    44,    44,    43,
    44,   nil,    44,    44,    45,    44,    45,   nil,   nil,    45,
    45,    45,    45,   nil,   nil,   nil,    45,   nil,    45,    45,
    44,    45,   nil,    45,    45,    46,    45,    46,   nil,   nil,
    46,    46,    46,    46,   nil,   nil,   nil,    46,   nil,    46,
    46,    45,    46,   nil,    46,    46,    50,    46,    50,   nil,
   nil,    50,    50,    50,    50,   nil,   nil,   nil,    50,   nil,
    50,    50,    46,    50,   nil,    50,    50,    52,    50,    52,
   nil,   nil,    52,    52,    52,    52,   nil,   nil,   nil,    52,
   nil,    52,    52,    50,    52,   nil,    52,    52,    85,    52,
    85,   nil,   nil,    85,    85,    85,    85,   nil,   nil,   nil,
    85,   nil,    85,    85,    52,    85,   nil,    85,    85,    47,
    85,    47,    47,    47,    47,    47,    47,    47,    47,    47,
    47,    47,    47,   nil,    55,    85,    47,    55,   nil,    55,
    55,    55,    55,    55,    55,    55,    55,    55,    55,    55,
    55,    56,   nil,   nil,    56,   nil,    56,    56,    56,    56,
    56,    56,    56,    56,    56,    56,    56,    56,     3,   nil,
     3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
     3,     3,    58,   nil,    58,    58,    58,    58,    58,    58,
    58,    58,    58,    58,    58,    58,    73,   nil,    73,    73,
    73,    73,    73,    73,    73,    73,    73,    73,    73,    73,
    76,   nil,    76,    76,    76,    76,    76,    76,    76,    76,
    76,    76,    76,    76,    77,   nil,    77,    77,    77,    77,
    77,    77,    77,    77,    77,    77,    77,    77,    93,   nil,
    93,    93,    93,    93,    93,    93,    93,    93,    93,    93,
    93,    93,    60,   nil,    60,    60,    60,    60,    60,    60,
    60,    60,    60,    60,    60,    61,   nil,    61,    61,    61,
    61,    61,    61,    61,    61,    61,    61,    62,   nil,    62,
    62,    62,    62,    62,    62,    62,    62,    63,   nil,    63,
    63,    63,    63,    63,    63,    63,    63,    64,   nil,    64,
    64,    64,    64,    65,   nil,    65,    65,    65,    65,    66,
   nil,    66,    66,    66,    66,    67,   nil,    67,    67,    67,
    67,    69,   nil,    69,    69 ]

racc_action_pointer = [
    -3,     1,   -12,   514,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,    66,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   -22,    87,   -28,     1,    19,
   108,   129,    25,   150,    21,   171,   192,   213,   234,   255,
   276,   297,   318,   339,   360,   381,   402,   465,   nil,    39,
   423,     8,   444,   -10,    33,   483,   500,   nil,   528,     6,
   598,   611,   623,   633,   643,   649,   655,   661,    41,   667,
    28,    46,   nil,   542,   nil,    12,   556,   570,    58,    68,
    68,    71,    73,   nil,   nil,   465,    18,   nil,    53,   nil,
   nil,    86,   nil,   584,    57,    80,    90,    87,   nil,   nil,
   nil,   nil ]

racc_action_default = [
    -1,   -61,    -2,    -3,    -6,    -7,    -8,    -9,   -10,   -11,
   -12,   -13,   -14,   -15,   -16,   -17,   -61,   -19,   -20,   -21,
   -22,   -23,   -24,   -25,   -26,   -49,   -61,   -47,   -61,   -61,
   -61,   -61,   -61,    -5,   -61,   -61,   -61,   -61,   -61,   -61,
   -61,   -61,   -61,   -61,   -61,   -61,   -61,   -61,   -27,   -61,
   -61,   -46,   -61,   -61,   -61,   -61,   -61,   102,    -4,   -29,
   -34,   -35,   -36,   -37,   -38,   -39,   -40,   -41,   -42,   -43,
   -44,   -45,   -18,   -32,   -30,   -61,   -50,   -48,   -61,   -54,
   -61,   -61,   -61,   -28,   -31,   -61,   -61,   -52,   -61,   -55,
   -57,   -58,   -60,   -33,   -61,   -61,   -61,   -61,   -51,   -53,
   -56,   -59 ]

racc_goto_table = [
    33,     2,    47,    48,     1,    75,    88,   nil,   nil,   nil,
   nil,   nil,    51,   nil,   nil,   nil,    55,    56,   nil,    58,
   nil,    60,    61,    62,    63,    64,    65,    66,    67,    68,
    69,    70,    71,   nil,   nil,    73,    76,    83,    77,    87,
   nil,    90,    91,    92,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,    99,   nil,   101,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    93,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,    94,   nil,   nil,
   nil,   nil,    33 ]

racc_goto_check = [
     4,     2,     3,    16,     1,    17,    19,   nil,   nil,   nil,
   nil,   nil,     3,   nil,   nil,   nil,     3,     3,   nil,     3,
   nil,     3,     3,     3,     3,     3,     3,     3,     3,     3,
     3,     3,     3,   nil,   nil,     3,     3,    16,     3,    18,
   nil,    18,    18,    18,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,    18,   nil,    18,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     3,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,     2,   nil,   nil,
   nil,   nil,     4 ]

racc_goto_pointer = [
   nil,     4,     1,   -14,    -2,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   -22,   -44,   -39,   -73 ]

racc_goto_default = [
   nil,   nil,   nil,     3,     4,     5,     6,     7,     8,     9,
    10,    11,    12,    13,    14,    15,   nil,   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 44, :_reduce_1,
  1, 44, :_reduce_2,
  1, 45, :_reduce_3,
  3, 45, :_reduce_4,
  2, 45, :_reduce_5,
  1, 45, :_reduce_6,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  3, 46, :_reduce_18,
  1, 47, :_reduce_none,
  1, 47, :_reduce_none,
  1, 48, :_reduce_21,
  1, 48, :_reduce_22,
  1, 48, :_reduce_23,
  1, 48, :_reduce_24,
  1, 48, :_reduce_25,
  1, 48, :_reduce_26,
  2, 49, :_reduce_27,
  4, 49, :_reduce_28,
  3, 49, :_reduce_29,
  2, 59, :_reduce_30,
  3, 59, :_reduce_31,
  1, 60, :_reduce_32,
  3, 60, :_reduce_33,
  3, 50, :_reduce_34,
  3, 50, :_reduce_35,
  3, 50, :_reduce_36,
  3, 50, :_reduce_37,
  3, 50, :_reduce_38,
  3, 50, :_reduce_39,
  3, 50, :_reduce_40,
  3, 50, :_reduce_41,
  3, 50, :_reduce_42,
  3, 50, :_reduce_43,
  3, 50, :_reduce_44,
  3, 50, :_reduce_45,
  2, 50, :_reduce_46,
  1, 51, :_reduce_47,
  3, 52, :_reduce_48,
  1, 53, :_reduce_49,
  3, 54, :_reduce_50,
  3, 61, :_reduce_51,
  4, 55, :_reduce_52,
  6, 55, :_reduce_53,
  0, 62, :_reduce_54,
  1, 62, :_reduce_55,
  3, 62, :_reduce_56,
  4, 56, :_reduce_57,
  4, 57, :_reduce_58,
  6, 57, :_reduce_59,
  4, 58, :_reduce_60 ]

racc_reduce_n = 61

racc_shift_n = 102

racc_token_table = {
  false => 0,
  :error => 1,
  :AND => 2,
  :CLASS => 3,
  :COMMENT => 4,
  :CONSTANT => 5,
  :DEDENT => 6,
  :ELSE => 7,
  :FALSE => 8,
  :FLOAT => 9,
  :IDENTIFIER => 10,
  :IF => 11,
  :IS => 12,
  :IT_IS => 13,
  :INDENT => 14,
  :METHOD => 15,
  :NEWLINE => 16,
  :NIL => 17,
  :NUMBER => 18,
  :RECEIVE => 19,
  :STRING => 20,
  :THEN => 21,
  :TRUE => 22,
  :WHILE => 23,
  "." => 24,
  "!" => 25,
  "*" => 26,
  "/" => 27,
  "+" => 28,
  "-" => 29,
  ">" => 30,
  ">=" => 31,
  "<" => 32,
  "<=" => 33,
  "==" => 34,
  "!=" => 35,
  "&&" => 36,
  "||" => 37,
  "=" => 38,
  "\xD8\x8C" => 39,
  "(" => 40,
  ")" => 41,
  ";" => 42 }

racc_nt_base = 43

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]
Ractor.make_shareable(Racc_arg) if defined?(Ractor)

Racc_token_to_s_table = [
  "$end",
  "error",
  "AND",
  "CLASS",
  "COMMENT",
  "CONSTANT",
  "DEDENT",
  "ELSE",
  "FALSE",
  "FLOAT",
  "IDENTIFIER",
  "IF",
  "IS",
  "IT_IS",
  "INDENT",
  "METHOD",
  "NEWLINE",
  "NIL",
  "NUMBER",
  "RECEIVE",
  "STRING",
  "THEN",
  "TRUE",
  "WHILE",
  "\".\"",
  "\"!\"",
  "\"*\"",
  "\"/\"",
  "\"+\"",
  "\"-\"",
  "\">\"",
  "\">=\"",
  "\"<\"",
  "\"<=\"",
  "\"==\"",
  "\"!=\"",
  "\"&&\"",
  "\"||\"",
  "\"=\"",
  "\"\\xD8\\x8C\"",
  "\"(\"",
  "\")\"",
  "\";\"",
  "$start",
  "Program",
  "Expressions",
  "Expression",
  "Terminator",
  "Literal",
  "Call",
  "Operator",
  "GetConstant",
  "SetConstant",
  "GetLocal",
  "SetLocal",
  "Method",
  "Class",
  "If",
  "While",
  "Arguments",
  "ArgList",
  "Block",
  "ParamList" ]
Ractor.make_shareable(Racc_token_to_s_table) if defined?(Ractor)

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'grammar.y', 39)
  def _reduce_1(val, _values, result)
     result = NodeList.new([])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 40)
  def _reduce_2(val, _values, result)
     result = val[0]
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 44)
  def _reduce_3(val, _values, result)
     result = NodeList.new(val)
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 45)
  def _reduce_4(val, _values, result)
     result = val[0] << val[2]
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 46)
  def _reduce_5(val, _values, result)
     result = val[0]
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 47)
  def _reduce_6(val, _values, result)
     result = NodeList.new([])
    result
  end
.,.,

# reduce 7 omitted

# reduce 8 omitted

# reduce 9 omitted

# reduce 10 omitted

# reduce 11 omitted

# reduce 12 omitted

# reduce 13 omitted

# reduce 14 omitted

# reduce 15 omitted

# reduce 16 omitted

# reduce 17 omitted

module_eval(<<'.,.,', 'grammar.y', 62)
  def _reduce_18(val, _values, result)
     result = val[1]
    result
  end
.,.,

# reduce 19 omitted

# reduce 20 omitted

module_eval(<<'.,.,', 'grammar.y', 71)
  def _reduce_21(val, _values, result)
     result = NumberNode.new(val[0])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 72)
  def _reduce_22(val, _values, result)
     result = FloatNode.new(val[0])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 73)
  def _reduce_23(val, _values, result)
     result = StringNode.new(val[0])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 74)
  def _reduce_24(val, _values, result)
     result = TrueNode.new
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 75)
  def _reduce_25(val, _values, result)
     result = FalseNode.new
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 76)
  def _reduce_26(val, _values, result)
     result = NilNode.new
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 80)
  def _reduce_27(val, _values, result)
     result = CallNode.new(nil, val[0], val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 81)
  def _reduce_28(val, _values, result)
     result = CallNode.new(val[0], val[2], val[3])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 82)
  def _reduce_29(val, _values, result)
     result = CallNode.new(val[0], val[2], [])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 86)
  def _reduce_30(val, _values, result)
     result = []
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 87)
  def _reduce_31(val, _values, result)
     result = val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 91)
  def _reduce_32(val, _values, result)
     result = val
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 92)
  def _reduce_33(val, _values, result)
     result = val[0] << val[2]
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 96)
  def _reduce_34(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 97)
  def _reduce_35(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 98)
  def _reduce_36(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 99)
  def _reduce_37(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 100)
  def _reduce_38(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 101)
  def _reduce_39(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 102)
  def _reduce_40(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 103)
  def _reduce_41(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 104)
  def _reduce_42(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 105)
  def _reduce_43(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 106)
  def _reduce_44(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 107)
  def _reduce_45(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 108)
  def _reduce_46(val, _values, result)
     result = CallNode.new(val[1], val[0], [])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 112)
  def _reduce_47(val, _values, result)
     result = GetConstantNode.new(val[0])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 116)
  def _reduce_48(val, _values, result)
     result = SetConstantNode.new(val[0], val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 120)
  def _reduce_49(val, _values, result)
     result = GetLocalNode.new(val[0])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 124)
  def _reduce_50(val, _values, result)
     result = SetLocalNode.new(val[0], val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 128)
  def _reduce_51(val, _values, result)
     result = val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 132)
  def _reduce_52(val, _values, result)
     result = MethodNode.new(val[1], [], val[3])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 133)
  def _reduce_53(val, _values, result)
     result = MethodNode.new(val[1], val[3], val[5])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 137)
  def _reduce_54(val, _values, result)
     result = []
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 138)
  def _reduce_55(val, _values, result)
     result = val
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 139)
  def _reduce_56(val, _values, result)
     result = val[0] << val[2]
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 143)
  def _reduce_57(val, _values, result)
     result = ClassNode.new(val[1], val[3])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 147)
  def _reduce_58(val, _values, result)
     result = IfNode.new(val[1], val[3], nil)
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 148)
  def _reduce_59(val, _values, result)
     result = IfNode.new(val[1], val[3], val[5])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 152)
  def _reduce_60(val, _values, result)
     result = WhileNode.new(val[1], val[3])
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class Parser

end