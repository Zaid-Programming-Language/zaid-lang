# frozen_string_literal: true

require 'minitest/autorun'

require 'zaid/parser'

module Zaid
  class ParserTest < Minitest::Test
    include Nodes

    def setup
      @parser = Parser.new
    end

    def test_comments
      assert_equal NodeList.new([]), @parser.parse('# لغة زيد')
      assert_equal NodeList.new([]), @parser.parse('تعليق: لغة زيد')
      assert_equal NodeList.new([]), @parser.parse('ملاحظة: صنِعت هذه اللغة لأغراض تعليمية')
      assert_equal NodeList.new([]), @parser.parse('سؤال: هل هذه اللغة سهلة؟')
    end

    def test_number_node
      assert_equal NodeList.new([NumberNode.new(5)]), @parser.parse('٥')
    end

    def test_float_node
      assert_equal NodeList.new([FloatNode.new(3.14)]), @parser.parse('٣.١٤')
    end

    def test_string_node
      assert_equal NodeList.new([StringNode.new('زيد')]), @parser.parse('"زيد"')
    end

    def test_true_node
      assert_equal NodeList.new([TrueNode.new]), @parser.parse('صحيح')
    end

    def test_false_node
      assert_equal NodeList.new([FalseNode.new]), @parser.parse('خاطئ')
    end

    def test_nil_node
      assert_equal NodeList.new([NilNode.new]), @parser.parse('مجهول')
    end

    def test_get_local_node
      assert_equal NodeList.new([GetLocalNode.new('عدد')]), @parser.parse('عدد')
    end

    def test_set_local_node
      assert_equal NodeList.new([SetLocalNode.new('عدد', NumberNode.new(5))]), @parser.parse('عدد = ٥')
    end

    def test_call_node
      assert_equal NodeList.new([CallNode.new(nil, 'اطبع', [GetLocalNode.new('عدد')])]), @parser.parse('اطبع(عدد)')
    end

    def test_call_node_on_receiver
      assert_equal NodeList.new([CallNode.new(NumberNode.new(1), 'صفر؟', [])]), @parser.parse('١.صفر؟')
    end

    def test_call_node_with_arguments
      assert_equal NodeList.new([CallNode.new(nil, 'اجمع', [NumberNode.new(1), NumberNode.new(2)])]),
                   @parser.parse('اجمع(١، ٢)')
    end

    def test_method_node
      code = <<~CODE
        دالة صحيحة وهي
          صحيح
      CODE

      nodes = NodeList.new([MethodNode.new('صحيحة', [], NodeList.new([TrueNode.new]))])

      assert_equal nodes, @parser.parse(code)
    end

    def test_method_node_with_arguments
      code = <<~CODE
        دالة اجمع تستقبل العدد_الأول و العدد_الثاني وهي
          العدد_الأول + العدد_الثاني
      CODE

      nodes = NodeList.new(
        [
          MethodNode.new(
            'اجمع',
            %w[العدد_الأول العدد_الثاني],
            NodeList.new([CallNode.new(GetLocalNode.new('العدد_الأول'), '+', [GetLocalNode.new('العدد_الثاني')])])
          )
        ]
      )

      assert_equal nodes, @parser.parse(code)
    end

    def test_class_node
      code = <<~CODE
        نوع الحيوانات هو
          دالة المشي وهي
            اطبع("الحيوان يمشي")
      CODE

      nodes = NodeList.new(
        [
          ClassNode.new(
            'الحيوانات',
            NodeList.new(
              [
                MethodNode.new(
                  'المشي',
                  [],
                  NodeList.new([CallNode.new(nil, 'اطبع', [StringNode.new('الحيوان يمشي')])])
                )
              ]
            )
          )
        ]
      )

      assert_equal nodes, @parser.parse(code)
    end

    def test_if_node
      code = <<~CODE
        عدد = ٥

        إذا كان عدد أكبر من ٣ إذن
          اطبع("عدد أكبر من ٣")
      CODE

      nodes = NodeList.new(
        [
          SetLocalNode.new('عدد', NumberNode.new(5)),
          IfNode.new(
            CallNode.new(GetLocalNode.new('عدد'), '>', [NumberNode.new(3)]),
            NodeList.new([CallNode.new(nil, 'اطبع', [StringNode.new('عدد أكبر من ٣')])]),
            nil
          )
        ]
      )

      assert_equal nodes, @parser.parse(code)
    end

    def test_if_node_with_else
      code = <<~CODE
        عدد = ٥

        إذا كان عدد أكبر من ٣ إذن
          اطبع("عدد أكبر من ٣")
        وإلا
          اطبع("عدد أصغر من ٣")
      CODE

      nodes = NodeList.new(
        [
          SetLocalNode.new('عدد', NumberNode.new(5)),
          IfNode.new(
            CallNode.new(GetLocalNode.new('عدد'), '>', [NumberNode.new(3)]),
            NodeList.new([CallNode.new(nil, 'اطبع', [StringNode.new('عدد أكبر من ٣')])]),
            NodeList.new([CallNode.new(nil, 'اطبع', [StringNode.new('عدد أصغر من ٣')])])
          )
        ]
      )

      assert_equal nodes, @parser.parse(code)
    end

    def test_if_node_with_else_if
      code = <<~CODE
        عدد = ٥

        إذا كان عدد أكبر من ٣ إذن
          اطبع("عدد أكبر من ٣")
        وإذا كان عدد أصغر من ٣ إذن
          اطبع("عدد أصغر من ٣")
        وإلا
          اطبع("عدد يساوي ٣")
      CODE

      nodes = NodeList.new(
        [
          SetLocalNode.new('عدد', NumberNode.new(5)),
          IfNode.new(
            CallNode.new(GetLocalNode.new('عدد'), '>', [NumberNode.new(3)]),
            NodeList.new([CallNode.new(nil, 'اطبع', [StringNode.new('عدد أكبر من ٣')])]),
            IfNode.new(
              CallNode.new(GetLocalNode.new('عدد'), '<', [NumberNode.new(3)]),
              NodeList.new([CallNode.new(nil, 'اطبع', [StringNode.new('عدد أصغر من ٣')])]),
              NodeList.new([CallNode.new(nil, 'اطبع', [StringNode.new('عدد يساوي ٣')])])
            )
          )
        ]
      )

      assert_equal nodes, @parser.parse(code)
    end

    def test_while_node
      code = <<~CODE
        عدد = ٥

        طالما كان عدد أكبر من ٠ إذن
          اطبع(عدد)
          عدد = عدد - ١
          توقف
          التالي
      CODE

      nodes = NodeList.new(
        [
          SetLocalNode.new('عدد', NumberNode.new(5)),
          WhileNode.new(
            CallNode.new(GetLocalNode.new('عدد'), '>', [NumberNode.new(0)]),
            NodeList.new(
              [
                CallNode.new(nil, 'اطبع', [GetLocalNode.new('عدد')]),
                SetLocalNode.new('عدد', CallNode.new(GetLocalNode.new('عدد'), '-', [NumberNode.new(1)])),
                BreakNode.new,
                ContinueNode.new
              ]
            )
          )
        ]
      )

      assert_equal nodes, @parser.parse(code)
    end

    def test_precedence
      nodes = NodeList.new(
        [
          CallNode.new(
            NumberNode.new(1),
            '+',
            [CallNode.new(NumberNode.new(2), '*', [NumberNode.new(3)])]
          )
        ]
      )

      assert_equal nodes, @parser.parse('١ + ٢ * ٣')
      assert_equal nodes, @parser.parse('١ + (٢ * ٣)')
    end

    def test_binary_operator
      nodes = NodeList.new(
        [
          CallNode.new(
            CallNode.new(NumberNode.new(1), '+', [NumberNode.new(2)]),
            '||',
            [NumberNode.new(3)]
          )
        ]
      )

      assert_equal nodes, @parser.parse('١ + ٢ || ٣')
    end

    def test_array_node
      assert_equal NodeList.new([ArrayNode.new([NumberNode.new(1), NumberNode.new(2)])]), @parser.parse('[١، ٢]')
    end

    def test_array_access_node
      assert_equal NodeList.new([ArrayAccessNode.new(ArrayNode.new([NumberNode.new(1), NumberNode.new(2)]), NumberNode.new(0))]),
                   @parser.parse('[١، ٢][٠]')
    end

    def test_array_variable
      code = <<~CODE
        مصفوفة_الأعداد = [١، ٢]
        اطبع(مصفوفة_الأعداد[٠])
      CODE

      nodes = NodeList.new(
        [
          SetLocalNode.new('مصفوفة_الأعداد', ArrayNode.new([NumberNode.new(1), NumberNode.new(2)])),
          CallNode.new(nil, 'اطبع', [ArrayAccessNode.new(GetLocalNode.new('مصفوفة_الأعداد'), NumberNode.new(0))])
        ]
      )

      assert_equal nodes, @parser.parse(code)
    end

    def test_array_with_newlines
      code = <<~CODE
        مصفوفة_الأعداد = [
          ١،
          ٢
        ]

        اطبع(مصفوفة_الأعداد[٠])
      CODE

      nodes = NodeList.new(
        [
          SetLocalNode.new('مصفوفة_الأعداد', ArrayNode.new([NumberNode.new(1), NumberNode.new(2)])),
          CallNode.new(nil, 'اطبع', [ArrayAccessNode.new(GetLocalNode.new('مصفوفة_الأعداد'), NumberNode.new(0))])
        ]
      )

      assert_equal nodes, @parser.parse(code)
    end

    def test_nested_arrays
      code = <<~CODE
        مصفوفة_الأعداد = [
          ١،
          [٢، ٣]
        ]

        اطبع(مصفوفة_الأعداد[١][٠])
      CODE

      nodes = NodeList.new(
        [
          SetLocalNode.new('مصفوفة_الأعداد', ArrayNode.new([NumberNode.new(1), ArrayNode.new([NumberNode.new(2), NumberNode.new(3)])])),
          CallNode.new(nil, 'اطبع', [ArrayAccessNode.new(ArrayAccessNode.new(GetLocalNode.new('مصفوفة_الأعداد'), NumberNode.new(1)), NumberNode.new(0))])
        ]
      )

      assert_equal nodes, @parser.parse(code)
    end

    def test_array_assignment_node
      code = <<~CODE
        مصفوفة_الأعداد = [١]
        مصفوفة_الأعداد[٠] = ٢
        اطبع(مصفوفة_الأعداد[٠])
      CODE

      nodes = NodeList.new(
        [
          SetLocalNode.new('مصفوفة_الأعداد', ArrayNode.new([NumberNode.new(1)])),
          ArrayAssignmentNode.new(GetLocalNode.new('مصفوفة_الأعداد'), NumberNode.new(0), NumberNode.new(2)),
          CallNode.new(nil, 'اطبع', [ArrayAccessNode.new(GetLocalNode.new('مصفوفة_الأعداد'), NumberNode.new(0))])
        ]
      )

      assert_equal nodes, @parser.parse(code)
    end

    def test_zero_or_one
      assert_equal NodeList.new([NumberNode.new(0)]), @parser.parse('صفر')
      assert_equal NodeList.new([NumberNode.new(1)]), @parser.parse('واحد')
    end
  end
end
