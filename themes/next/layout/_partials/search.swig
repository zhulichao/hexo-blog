{% if theme.swiftype_key %}
  {% include 'search/swiftype.swig' %}
{% elseif theme.tinysou_Key %}
  {% include 'search/tinysou.swig' %}
{% endif %}
{% if config.search.path %}
  {% include 'search/localsearch.swig' %}
{% endif %}