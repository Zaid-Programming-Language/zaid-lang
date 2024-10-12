<h1 dir="rtl">سجل التغييرات</h1>

<p dir="rtl">كل التغييرات الخاصة بهذا المشروع ستُكتب في هذا الملف. بنية الملف تتبع بنية <a href="https://keepachangelog.com/en/1.1.0">Keep a Changelog</a> وهذا المشروع يتبع معايير <a href="https://semver.org/spec/v2.0.0.html">Semantic Versioning</a>.</p>

<h2 dir="rtl">[غير منشور]</h2>

<h3 dir="rtl">أُضيف</h3>

<ul dir="rtl">
  <li>مميزات اللغة:
    <ul>
      <li>أنواع البيانات:
        <ul>
          <li>المصفوفات.</li>
        </ul>
      </li>
      <li>الجمل الشرطية:
        <ul>
          <li><code>وإذا كان</code>.</li>
        </ul>
      </li>
      <li>حلقات التكرار:
        <ul>
          <li><code>توقف</code>.</li>
          <li><code>التالي</code>.</li>
        </ul>
      </li>
    </ul>
  </li>
</ul>

<h2 dir="rtl"><a href="https://github.com/Zaid-Programming-Language/zaid-lang/releases/tag/0.0.1">0.0.1</a> - 2024-10-10</h2>

<h3 dir="rtl">أُضيف</h3>

<ul dir="rtl">
  <li>تركيبة جمل لغة زيد (<a href="syntax.zaid"><code dir="ltr">syntax.zaid</code></a>).</li>
  <li>الكلمات المفتاحية للغة زيد (<a href="lib/zaid/keywords.rb"><code dir="ltr">lib/zaid/keywords.rb</code></a>).</li>
  <li>مُعالِج جمل لغة زيد (<a href="lib/zaid/lexer.rb"><code dir="ltr">lib/zaid/lexer.rb</code></a>) في مُكوِّنين:
    <ul>
      <li>مُعالِج الرموز (<a href="lib/zaid/lexer_components/tokenizer.rb"><code dir="ltr">lib/zaid/lexer_components/tokenizer.rb</code></a>).</li>
      <li>ضاغط الرموز (<a href="lib/zaid/lexer_components/compressor.rb"><code dir="ltr">lib/zaid/lexer_components/compressor.rb</code></a>).</li>
    </ul>
  </li>
  <li>قواعد لغة زيد (<a href="lib/zaid/grammar.y"><code dir="ltr">lib/zaid/grammar.y</code></a>).</li>
  <li>مُعالِجات قواعد لغة زيد (<a href="lib/zaid/nodes/*"><code dir="ltr">lib/zaid/nodes/*</code></a>).</li>
  <li>محلل لغة زيد (<a href="lib/zaid/parser.rb"><code dir="ltr">lib/zaid/parser.rb</code></a>).</li>
  <li>بيئة تشغيل لغة زيد (<a href="lib/zaid/runtime/*"><code dir="ltr">lib/zaid/runtime/*</code></a>).</li>
  <li>مُفسِّر لغة زيد (<a href="lib/zaid/interpreter.rb"><code dir="ltr">lib/zaid/interpreter.rb</code></a>).</li>
  <li>حالات الاختبار (<a href="test/*"><code dir="ltr">test/*</code></a>).</li>
  <li>المكتبات المستخدمة في التطوير (<a href="Gemfile"><code dir="ltr">Gemfile</code></a>).</li>
  <li>مهام التطوير (<a href="Rakefile"><code dir="ltr">Rakefile</code></a>).</li>
  <li>مُفسِّر سطر الأوامر (<a href="bin/zaid"><code dir="ltr">bin/zaid</code></a>).</li>
  <li>خصائص مكتبة لغة زيد (<a href="zaid.gemspec"><code dir="ltr">zaid.gemspec</code></a>).</li>
  <li>إصدار مكتبة لغة زيد: <a href="https://rubygems.org/gems/zaid">https://rubygems.org/gems/zaid</a>.</li>
  <li>مميزات اللغة:
    <ul>
      <li>التعليقات:
        <ul>
          <li><code>#</code>.</li>
          <li><code>تعليق:</code>.</li>
          <li><code>ملاحظة:</code>.</li>
          <li><code>سؤال:</code>.</li>
        </ul>
      </li>
      <li>أنواع البيانات:
        <ul>
          <li>النصوص.</li>
          <li>الأعداد الصحيحة.</li>
          <li>الأعداد العشرية.</li>
          <li>القيم المنطقية:
            <ul>
              <li><code>صحيح</code>.</li>
              <li><code>خاطئ</code>.</li>
            </ul>
          </li>
          <li>القيم غير المعروفة:
            <ul>
              <li><code>مجهول</code>.</li>
            </ul>
          </li>
        </ul>
      </li>
      <li>العمليات المنطقية:
        <ul>
          <li><code>يساوي</code>: <code>==</code>.</li>
          <li><code>لا يساوي</code>: <code>!=</code>.</li>
          <li><code>أكبر من</code>: <code>></code>.</li>
          <li><code>أصغر من</code>: <code><</code>.</li>
          <li><code>أكبر من أو يساوي</code>: <code>>=</code>.</li>
          <li><code>أصغر من أو يساوي</code>: <code><=</code>.</li>
          <li><code>و</code>: <code>&&</code>.</li>
          <li><code>أو</code>: <code>||</code>.</li>
        </ul>
      </li>
      <li>العمليات الحسابية:
        <ul>
          <li><code>زائد</code>: <code>+</code>.</li>
          <li><code>ناقص</code>: <code>-</code>.</li>
          <li><code>ضرب</code>: <code>*</code>.</li>
          <li><code>تقسيم</code>: <code>/</code>.</li>
        </ul>
      </li>
      <li>الجُمل الشرطية:
        <ul>
          <li><code>إذا كان</code>.</li>
          <li><code>وإلا</code>.</li>
        </ul>
      </li>
      <li>حلقات التكرار:
        <ul>
          <li><code>طالما كان</code>.</li>
        </ul>
      </li>
      <li>الدوال.</li>
      <li>الأنواع.</li>
    </ul>
  </li>
</ul>
