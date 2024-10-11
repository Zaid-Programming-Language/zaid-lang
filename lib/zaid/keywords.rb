# frozen_string_literal: true

module Zaid
  module Keywords
    # Compressable keywords:
    DIVIDE  = 'تقسيم'
    EQUALS  = 'يساوي'
    GREATER = 'أكبر'
    LESS    = 'أصغر'
    MINUS   = 'ناقص'
    NOT     = 'لا'
    PLUS    = 'زائد'
    THAN    = 'من'
    TIMES   = 'ضرب'
    WAS     = 'كان'

    # Uncompressable keywords:
    CLASS   = 'نوع'
    ELSE    = 'وإلا'
    ELSE_IF = 'وإذا'
    FALSE   = 'خاطئ'
    IF      = 'إذا'
    IS      = 'هو'
    IT_IS   = 'وهي'
    METHOD  = 'دالة'
    NIL     = 'مجهول'
    OR      = 'أو'
    RECEIVE = 'تستقبل'
    THEN    = 'إذن'
    TRUE    = 'صحيح'
    WHILE   = 'طالما'

    # Semi-compressable keywords:
    AND     = 'و'
  end
end
