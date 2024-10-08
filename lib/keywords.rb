# frozen_string_literal: true

module Zaid
  module Keywords
    # Compressable keywords:
    LESS    = 'أصغر'
    GREATER = 'أكبر'
    PLUS    = 'زائد'
    TIMES   = 'ضرب'
    DIVIDE  = 'قسمة'
    WAS     = 'كان'
    NOT     = 'لا'
    THAN    = 'من'
    MINUS   = 'ناقص'
    EQUALS  = 'يساوي'

    # Uncompressable keywords:
    OR      = 'أو'
    IF      = 'إذا'
    THEN    = 'إذن'
    RECEIVE = 'تستقبل'
    FALSE   = 'خاطئ'
    METHOD  = 'دالة'
    TRUE    = 'صحيح'
    WHILE   = 'طالما'
    NIL     = 'مجهول'
    CLASS   = 'نوع'
    IS      = 'هو'
    ELSE    = 'وإلا'
    IT_IS   = 'وهي'

    # Semi-compressable keywords:
    AND     = 'و'
  end
end
